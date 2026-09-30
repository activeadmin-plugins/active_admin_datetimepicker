require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  # process_timeout: Ferrum's default is 10s for Chrome to hand back a
  # websocket URL. GitHub runners miss that often enough to fail a leg
  # per run with Ferrum::ProcessTimeoutError; the browser is starting
  # fine, just slowly.
  Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1280, 800],
                                process_timeout: 30)
end
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 5
