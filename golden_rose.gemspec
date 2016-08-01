# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'golden_rose/version'

Gem::Specification.new do |spec|
  spec.name          = "golden_rose"
  spec.version       = GoldenRose::VERSION
  spec.authors       = ["Róża Szylar (PGS Software)"]
  spec.email         = ["rszylar@pgs-soft.com"]

  spec.summary       = %q{A tool for generating reports from Xcode results bundle.}
  spec.description   = %q{A tool for generating reports from Xcode results bundle.
  Analyze results bundle directory created by Xcode during building, testing, running and generates HTML report with results.}
  spec.homepage      = "https://github.com/PGSSoft/golden_rose"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ["golden_rose"]
  spec.require_paths = ["lib"]

  spec.add_dependency "haml"
  spec.add_dependency "plist"
  spec.add_dependency "rubyzip"
  spec.add_dependency "thor"
  spec.add_dependency "tilt"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
