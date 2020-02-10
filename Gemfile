source 'https://rubygems.org'

# Specify your gem's dependencies in active_admin_datetimepicker.gemspec
gemspec

group :test do
  default_rails_version = '6.0.0'
  default_activeadmin_version = '2.6.0'

  gem 'rails', "~> #{ENV['RAILS'] || default_rails_version}"
  gem 'activeadmin', "~> #{ENV['AA'] || default_activeadmin_version}"

  gem 'sprockets-rails', '3.0.4'
  gem 'rspec-rails'
  gem 'coveralls', require: false # Test coverage website. Go to https://coveralls.io
  gem 'sass-rails'
  gem 'sqlite3', '~> 1.4.0'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'webdrivers'
  gem 'byebug'
end
