source 'https://rubygems.org'

# Specify your gem's dependencies in active_admin_datetimepicker.gemspec
gemspec

group :test do
  default_rails_version = '7.1.0'
  default_activeadmin_version = '3.1.0'

  gem 'rails', "~> #{ENV['RAILS'] || default_rails_version}"
  gem 'activeadmin', "~> #{ENV['AA'] || default_activeadmin_version}"

  gem 'sprockets-rails'
  gem 'rspec-rails'
  gem 'coveralls_reborn', require: false
  gem 'sass-rails'
  gem 'sqlite3', '~> 1.4.0'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'webdrivers'
  gem 'byebug'
  gem 'webrick', require: false
end
