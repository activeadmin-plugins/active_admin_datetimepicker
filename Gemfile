source 'https://rubygems.org'

# Specify your gem's dependencies in active_admin_datetimepicker.gemspec
gemspec
group :test do
  default_rails_version = '4.2.7'
  gem 'sprockets-rails', '2.3.3'
  gem 'rails', "#{ENV['RAILS'] || default_rails_version}"
  gem 'rspec-rails'
  gem 'activeadmin', github: 'activeadmin', ref: '06aa8b2af692e46fc360832473ca63e23a70b3d4'
  gem 'coveralls', require: false # Test coverage website. Go to https://coveralls.io
  gem 'sass-rails'
  gem 'sqlite3'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
end
