require 'strscan'
require 'yaml'

module ConfigVolumizer
  module Parser

    class << self

      # Parses keys within the {source} hash matching {base_name}
      # returning a hash with all the matched data under a string key matching the {base_name}
      #
      # See Readme for an example
      #
      # @param [Hash] source
      # @param [String] base_name
      # @return [Hash]
      def parse(source, base_name)
        result = {}
        source.each do |key, value|
          if matches_name(base_name, key)
            fragments = key.gsub(/^#{base_name}/, '')
            handle_item(result, base_name, fragments, value)
          end
        end
        result
      end

      private

      def matches_name(base_name, key)
        key == base_name || key =~ /^#{base_name}([.\[])/
      end

      def format_value(value)
        YAML.load(value)
      end

      def initialize_array(result, key)
        validate_result_key_kind(result, key, Array)
        result[key] ||= []
      end

      def initialize_hash(result, key)
        validate_result_key_kind(result, key, Hash)
        result[key] ||= {}
      end

      def validate_result_key_kind(result, key, kind)
        if result[key] && !result[key].kind_of?(kind)
          raise ArgumentError, "referencing #{kind} key #{name} when its already a #{result[key].class}"
        end
      end

      def handle_item(result, base_name, name, value)
        dst, key = result, base_name
        scanner = StringScanner.new(name)

        until scanner.eos?
          dst, key = case next_fragment(scanner)
                     when /^\.(.+)/
                       handle_hash($~, dst, key)
                     when /\[(\d+)\]/
                       handle_array($~, dst, key)
                     end
        end

        dst[key] = format_value(value)
      end

      def handle_array(match, dst, key)
        index = match[1].to_i
        initialize_array(dst, key)
        return dst[key], index
      end

      def handle_hash(match, dst, key)
        hash_key = match[1]
        initialize_hash(dst, key)
        return dst[key], hash_key
      end

      def next_fragment(scanner)
        fragment = scanner.scan /\.[^.\[]+|\[\d+\]/
        raise "failed: rest: #{scanner.rest} inside #{scanner.string}" unless fragment
        fragment
      end

    end
  end
end
