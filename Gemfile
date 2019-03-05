# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in active_admin_datetimepicker.gemspec
gemspec
group :test do
  default_rails_version = '5.2.1'
  default_activeadmin_version = '1.3.1'

  gem 'activeadmin', "~> #{ENV['AA'] || default_activeadmin_version}"
  gem 'rails', "~> #{ENV['RAILS'] || default_rails_version}"

  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'coveralls', require: false # Test coverage website. Go to https://coveralls.io
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'sass-rails'
  gem 'selenium-webdriver'
  gem 'sqlite3'
end
