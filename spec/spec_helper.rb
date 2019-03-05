# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path('support', __dir__)

ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', __dir__)
require 'bundler'
Bundler.setup

ENV['RAILS_ENV'] = 'test'
# Ensure the Active Admin load path is happy
require 'rails'
ENV['RAILS'] = Rails.version
ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{ENV['RAILS']}", __FILE__)
# Create the test app if it doesn't exists
system 'rake setup' unless File.exist?(ENV['RAILS_ROOT'])

require 'active_model'
# require ActiveRecord to ensure that Ransack loads correctly
require 'active_record'
require 'active_admin'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + '/app/admin']
require ENV['RAILS_ROOT'] + '/config/environment.rb'
# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

require 'support/admin'
require 'support/capybara'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
