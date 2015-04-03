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
        data.inject({}) do |result, (key, value)|
          process_item(result, key, value)
          result
        end
      end

      def process_item(result, prefix, value)
        case value
        when Array
          value.each_with_index do |item, index|
            process_item(result, "#{prefix}[#{index}]", item)
          end
        when Hash
          value.each do |key, item|
            process_item(result, "#{prefix}.#{key}", item)
          end
        else
          result[prefix] = value
        end
      end

    end
  end
end
