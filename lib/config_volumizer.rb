require 'config_volumizer/version'
require 'config_volumizer/parser'
require 'config_volumizer/generator'

module ConfigVolumizer
  class << self

    # Parses keys within the {source} hash matching {base_name}
    # returning a hash with all the matched data under a string key matching the {base_name}
    #
    # @see ConfigVolumizer::Parser.parse
    #
    # @param [Hash] source
    # @param [String] base_name
    # @return [Hash]
    def parse(source, mapping)
      Parser.parse(source, mapping)
    end

    # Generates a flattened config out of a data hash
    #
    # @see ConfigVolumizer::Generator.generate
    #
    # @param [Hash] data
    # @return [Hash]
    def generate(data)
      Generator.generate(data)
    end

  end
end
