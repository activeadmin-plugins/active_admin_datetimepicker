require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  # Chrome hangs at startup on GitHub runners and never hands back a
  # websocket URL, failing a leg per run with
  # Ferrum::ProcessTimeoutError. Raising :process_timeout alone did not
  # fix it -- 30s timed out too, so the browser is stuck rather than
  # slow. --disable-dev-shm-usage is the cause: containers give /dev/shm
  # 64 MB and Chrome deadlocks when it runs out. --no-sandbox is needed
  # because the runner already runs as an unprivileged user.
  Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1280, 800],
                                process_timeout: 30,
                                browser_options: {
                                  'no-sandbox': nil,
                                  'disable-dev-shm-usage': nil,
                                  'disable-gpu': nil
                                })
end
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 5
