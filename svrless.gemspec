# frozen_string_literal: true

require_relative "lib/svrless/version"

Gem::Specification.new do |spec|
  spec.name          = "svrless"
  spec.version       = Svrless::VERSION
  spec.authors       = ["zrthko"]
  spec.email         = ["zrthko@svrless.org"]
  spec.summary       = "Serverless framework for Rails developers."
  spec.description   = "Bridging the gap between monolithic style development with a serverless backend."
  spec.homepage      = "https://github.com/svrless/svrless"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new("~> 2.7.0")
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/svrless/svrless"
  spec.metadata["changelog_uri"] = "https://github.com/svrless/svrless/blob/main/CHANGELOG.md"
  spec.executables << "svrless"
  spec.require_paths = ["lib"]
  spec.add_dependency "activesupport", "~> 5.0.0.0"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
end
