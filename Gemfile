source 'https://rubygems.org'
gemspec

default_rails_version = '8.0.0'
default_activeadmin_version = '3.2.0'

gem 'rails', "~> #{ENV['RAILS'] || default_rails_version}"
activeadmin_version = ENV['AA'] || default_activeadmin_version

gem 'activeadmin', "~> #{activeadmin_version}"
if Gem::Version.new(activeadmin_version) >= Gem::Version.new('4.0.0.beta1')
  gem 'propshaft'
  gem 'importmap-rails'
else
  gem 'sprockets-rails'
  gem 'sass-rails'
end

group :test do
  gem 'simplecov', require: false
  gem 'rspec-rails'
  gem 'sqlite3', '~> 2.0'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'cuprite'
  gem 'webrick', require: false
end
