require 'config_volumizer/version'
require 'config_volumizer/parser'

module ConfigVolumizer
  class << self

    def parse(source, base_name)
      Parser.parse(source, base_name)
    end

  end
end
