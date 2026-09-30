require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  # Chrome hangs at startup on GitHub runners and never hands back a
  # websocket URL, failing a leg per run with
  # Ferrum::ProcessTimeoutError. Raising :process_timeout alone did not
  # fix it -- 30s timed out too, so the browser is stuck rather than
  # slow. The cause is /dev/shm: containers mount it at 64 MB and Chrome
  # deadlocks once it fills, so --disable-dev-shm-usage moves that
  # scratch space to /tmp. --no-sandbox is needed because the runner
  # already runs as an unprivileged user, and --disable-gpu drops a
  # subsystem with nothing to do in headless.
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
