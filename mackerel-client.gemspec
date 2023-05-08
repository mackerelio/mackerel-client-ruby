# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "mackerel-client"
  spec.version       = File.read("VERSION").strip
  spec.authors       = ["Mackerel developer team"]
  spec.email         = ["developers@mackerel.io"]
  spec.summary       = 'Mackerel client implemented by Ruby.'
  spec.description   = 'Mackerel client is a library to access Mackerel (https://mackerel.io/).'
  spec.homepage      = "https://mackerel.io/"
  spec.license       = "Apache 2"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '>= 1', '< 3'

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
end
