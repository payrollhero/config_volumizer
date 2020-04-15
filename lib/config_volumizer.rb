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
    # @param [Hash] mapping
    # @return [Hash]
    def parse(source, mapping)
      Parser.parse(source, mapping)
    end

    # Fetches the data described by the mapping from the source
    # works similar to #parse, but has a default value mechanism
    # and skips the root key
    #
    # @param [Hash] source
    # @param [String] mapping_key
    # @param [Object] mapping_info
    # @param [Object] default - default value if key not found
    # @param [proc] block - default value proc (is passed key as parameter)
    # @return [Object]
    def fetch(source, mapping_key, mapping_info, default=nil, &block)
      value = Parser.parse(source, mapping_key => mapping_info)
      value.fetch(mapping_key.to_s, *[default].compact, &block)
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
