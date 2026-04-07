require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1280, 800])
end
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 5
