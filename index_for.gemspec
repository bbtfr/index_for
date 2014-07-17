# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'index_for/version'

Gem::Specification.new do |spec|
  spec.name          = "index_for"
  spec.version       = IndexFor::VERSION
  spec.authors       = ["Theo"]
  spec.email         = ["bbtfrr@gmail.com"]
  spec.summary       = "Wrap your objects with a helper to easily list them"
  spec.description   = "Wrap your objects with a helper to easily list them"
  spec.homepage      = "https://github.com/bbtfr/index_for"
  spec.license       = "MIT"


  spec.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel', '>= 3.2', '< 5'
  spec.add_dependency 'actionpack', '>= 3.2', '< 5'
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'railties', '>= 3.2', '< 5'
end
