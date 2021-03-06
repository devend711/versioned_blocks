# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versioned_blocks'

Gem::Specification.new do |spec|
  spec.name          = "versioned_blocks"
  spec.version       = VersionedBlocks::VERSION
  spec.authors       = ["devend711@gmail.com"]
  spec.email         = ["devend711@gmail.com"]
  spec.summary       = "Easily loop through versioned API URIs"
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/devend711/versioned_blocks"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
