require 'capybara/cuprite'

Capybara.server = :webrick
Capybara.register_driver :cuprite do |app|
  # Chrome sometimes never hands back a websocket URL on GitHub runners
  # and the leg dies with Ferrum::ProcessTimeoutError. --no-sandbox is
  # the fix: ubuntu-latest is now 24.04, which ships
  # kernel.apparmor_restrict_unprivileged_userns=1, and that blocks the
  # user-namespace sandbox for binaries without an AppArmor profile --
  # Chrome then hangs instead of starting. These runners are
  # single-tenant VMs rendering only this suite's own dummy app, so
  # dropping the sandbox costs nothing here.
  #
  # Ferrum already passes --disable-dev-shm-usage by default
  # (Ferrum::Browser::Options::Chrome::DEFAULT_OPTIONS), so /dev/shm was
  # never the problem and adding the flag again changed nothing.
  #
  # process_timeout is kept at 30s to cover a genuinely slow start; it
  # was not enough on its own.
  Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1280, 800],
                                process_timeout: 30,
                                browser_options: { 'no-sandbox': nil })
end
Capybara.javascript_driver = :cuprite
Capybara.default_max_wait_time = 5
