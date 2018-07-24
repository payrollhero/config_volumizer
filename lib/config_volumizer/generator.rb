require 'ostruct'
module ConfigVolumizer

  # Converts a {Hash} into a flattened {Hash} as a template for volumizing your configs
  module Generator
    class << self

      # Generates a flattened config out of a data hash
      #
      # See Readme for an example
      #
      # @param [Hash] data
      # @return [Hash]
      def generate(data)
        OpenStruct.new(
          env_hash: generate_env(data),
          mapping_hash: generate_mapping(data),
        )
      end

      private

      def generate_env(data)
        data.inject({}) do |result, (key, value)|
          process_env_item(result, key, value)
          result
        end
      end

      def generate_mapping(data)
        data.inject({}) do |result, (key, value)|
          result[key] = process_mapping_item(value)
          result
        end
      end

      def process_mapping_item(value)
        case value
        when Array
          result = []
          value.each_with_index do |item, index|
            result[index] = process_mapping_item(item)
          end
          result.uniq!
          result = [:varied] if result.length > 1
          result
        when Hash
          result = {}
          value.each do |key, item|
            result[key] = process_mapping_item(item)
          end
          result
        else
          :value
        end
      end

      def process_env_item(result, prefix, value)
        case value
        when Array
          value.each_with_index do |item, index|
            process_env_item(result, "#{prefix}_#{index}", item)
          end
        when Hash
          value.each do |key, item|
            process_env_item(result, "#{prefix}_#{key}", item)
          end
        else
          result[prefix] = value
        end
      end

    end
  end
end
