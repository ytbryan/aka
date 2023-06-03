# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aka/version'
require 'aka/post_message'

Gem::Specification.new do |spec|
  spec.name          = "aka3"
  spec.version       = Aka::VERSION
  spec.authors       = ["Bryan Lim"]
  spec.email         = ["ytbryan@gmail.com"]
  spec.summary       = %q{The Missing Terminal Shortcut Manager}
  spec.description   = %q{ A delightful way to manage and grow your aliases in your daily project. }
  spec.homepage      = "https://github.com/ytbryan/aka"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["aka"]
  spec.require_paths = ["lib"]
  spec.post_install_message = Log::MESSAGE
  spec.required_ruby_version = ">= 2.0.0"
  spec.add_dependency 'thor' , '~> 0.19.4'
  spec.add_dependency 'file-utils' , '~> 0.1.0'
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "bundler", "~> 2.3.6"
  spec.add_development_dependency "rake", "~> 13.0.6"
end
