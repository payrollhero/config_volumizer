require 'config_volumizer/version'
require 'config_volumizer/parser'

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
    def parse(source, base_name)
      Parser.parse(source, base_name)
    end

  end
end
