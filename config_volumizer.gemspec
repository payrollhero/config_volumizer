# -*- encoding: utf-8 -*-

require File.expand_path('../lib/config_volumizer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "config_volumizer"
  gem.version       = ConfigVolumizer::VERSION
  gem.summary       = "Adds volume to an otherwise flat config"
  gem.description   = "Allows turning dot notation config from ENV to rich Hash/Array structures"
  gem.license       = "MIT"
  gem.authors       = ["Piotr Banasik"]
  gem.email         = "piotr.banasik@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/config_volumizer"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
