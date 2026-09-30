require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  # Chrome intermittently fails to hand back a websocket URL on GitHub
  # runners and the leg dies with Ferrum::ProcessTimeoutError. The cause
  # is not established. Two theories were tried and both are ruled out:
  #
  #   * /dev/shm exhaustion -- Ferrum already passes
  #     --disable-dev-shm-usage by default
  #     (Ferrum::Browser::Options::Chrome::DEFAULT_OPTIONS), so the runs
  #     that failed were already using it.
  #   * the ubuntu-24.04 AppArmor restriction on unprivileged user
  #     namespaces -- the sibling repo capybara_active_admin passes
  #     --no-sandbox and --disable-setuid-sandbox already, and flakes
  #     the same way.
  #
  # So: --no-sandbox is kept because it is harmless on a single-tenant
  # CI VM serving only this suite's dummy app and may still help, and
  # process_timeout is raised from Ferrum's 10s default because a slow
  # start is at least a failure mode a budget can cover. Neither is
  # demonstrated to fix it. A rerun is currently the answer when it
  # happens.
  Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1280, 800],
                                process_timeout: 30,
                                browser_options: { 'no-sandbox': nil })
end
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 5
