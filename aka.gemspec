# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aka/version'

Gem::Specification.new do |spec|
  spec.name          = "aka2"
  spec.version       = Aka::VERSION
  spec.authors       = ["Bryan Lim","Ryan Goh"]
  spec.email         = ["ytbryan@gmail.com","gohengkeat89@gmail.com"]
  spec.summary       = %q{The Missing Alias Manager}
  spec.description   = %q{aka generates/edits/destroys/finds/shares permanent aliases with a single command. }
  spec.homepage      = "https://github.com/ytbryan/aka"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["aka"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"
  spec.add_runtime_dependency 'thor' , '~> 0.19.1'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
end
