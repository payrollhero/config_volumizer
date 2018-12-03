require 'strscan'
require 'yaml'
require 'csv'

module ConfigVolumizer
  module Parser

    class << self

      # Parses keys within the {source} hash matching {base_name}
      # returning a hash with all the matched data under a string key matching the {base_name}
      #
      # See Readme for an example
      #
      # @param [Hash] source
      # @param [Hash] mapping
      # @return [Hash]
      def parse(source, mapping)
        result = {}
        mapping.each do |mapping_key, mapping_info|
          source.keys.sort.each do |key|
            value = source[key]
            if matches_name(mapping_key, key)
              handle_item(result, key, value, mapping_key, mapping_info)
            end
          end
        end
        result
      end

      private

      def matches_name(base_name, key)
        key == base_name || key =~ /^#{base_name}_/
      end

      def format_value(value)
        YAML.load(value)
      end

      def format_array_value(value)
        CSV.parse_line(value).map { |inner_value| format_value(inner_value) }
      end

      def handle_item(result, name, value, mapping_key, mapping_info)
        case mapping_info
        when Array
          handle_array_item(mapping_info, mapping_key, name, result, value)
        when Hash
          handle_hash_item(mapping_info, mapping_key, name, result, value)
        when :value
          result[mapping_key] = format_value(value)
        when :hash
          new_name = name.gsub(/^#{mapping_key}_/, '')
          result[mapping_key] ||= {}
          result[mapping_key][new_name] = format_value(value)
        when :varied
          new_name = name.gsub(/^#{mapping_key}_/, '')
          if new_name == "" || name == mapping_key
            result[mapping_key] = format_value(value)
          else
            result[mapping_key] ||= {}
            result[mapping_key][new_name] = format_value(value)
            end
        else
          raise ArgumentError, "don't know how to deal with #{mapping_info.inspect}"
        end

      end

      def handle_hash_item(mapping_info, mapping_key, name, result, value)
        mapping_key = mapping_key.to_s if mapping_key.kind_of?(Symbol)
        result[mapping_key] ||= {}
        new_name = name.gsub(/^#{mapping_key}_/, '')
        mapping_info.each do |inner_mapping_key, inner_mapping_info|
          inner_mapping_key = inner_mapping_key.to_s if inner_mapping_key.kind_of?(Symbol)
          if matches_name(inner_mapping_key, new_name)
            handle_item(result[mapping_key], new_name, value, inner_mapping_key, inner_mapping_info)
          end
        end
      end

      def handle_array_item(mapping_info, mapping_key, name, result, value)
        result[mapping_key] ||= []
        mapping_info.each do |inner_mapping_info|
          case inner_mapping_info
          when :value
            result[mapping_key] += format_array_value(value)
          when :hash, Hash
            handle_array_hash_item(inner_mapping_info, mapping_key, name, result, value)
          when :varied
            new_name = name.gsub(/^#{mapping_key}_(\d+)(?:_)?/, '')
            if new_name == ""
              result[mapping_key] += format_array_value(value) # value mode
            else
              handle_array_hash_item(inner_mapping_info, mapping_key, name, result, value) # hash mode
            end
          else
            raise "don't know how to handle: #{inner_mapping_info.inspect}"
          end
        end
      end

      def handle_array_hash_item(inner_mapping_info, mapping_key, name, result, value)
        new_name = name.gsub(/^#{mapping_key}_(\d+)(?:_)?/, '')
        index = $~[1].to_i
        handle_item(result[mapping_key], new_name, value, index, inner_mapping_info)
      end

    end
  end
end
