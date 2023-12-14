# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_admin_datetimepicker/version'

Gem::Specification.new do |spec|
  spec.name          = "active_admin_datetimepicker"
  spec.version       = ActiveAdminDatetimepicker::VERSION
  spec.authors       = ["Igor Fedoronchuk"]
  spec.email         = ["fedoronchuk@gmail.com"]

  spec.summary       = %q{datetimepicker extension for ActiveAdmin}
  spec.description   = %q{Integrate jQuery xdan datetimepicker plugin to ActiveAdmin}
  spec.homepage      = "https://github.com/activeadmin-plugins/activeadmin_datetimepicker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activeadmin", ">= 2.14.0", "< 4.0"
end
