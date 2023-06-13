# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nimble/version'

Gem::Specification.new do |spec|

  spec.name             = "nimble-api"
  spec.version          = NimbleApi::VERSION
  spec.homepage         = "https://github.com/aptos/NimbleApi"
  spec.platform         = Gem::Platform::RUBY
  spec.license          = 'Apache'

  spec.summary          = "Nimble CRM Api Wrapper"
  spec.description      = "Ruby wrapper for the Nimble CRM Api."

  spec.authors          = ["Brian Wilkerson"]
  spec.email            = "brian@taskit.io"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday", "~> 0.8"
  spec.add_dependency "chronic", "~> 0.10"
  spec.add_dependency "json", "~> 2.6.3"

end
