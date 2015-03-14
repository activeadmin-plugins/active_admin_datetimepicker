# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_admin_datetimepicker/version'

Gem::Specification.new do |spec|
  spec.name          = "active_admin_datetimepicker"
  spec.version       = ActiveAdminDatetimepicker::VERSION
  spec.authors       = ["Igor Fedoronchuk"]
  spec.email         = ["fedoronchuk@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{datetimepicker extension for ActiveAdmin}
  spec.description   = %q{Integrate xdan datetimepicker jQuery plugin to ActiveAdmin}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "xdan-datetimepicker-rails"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

end
