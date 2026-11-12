desc "Creates a test rails app for the specs to run against"
task :setup do
  require 'rails/version'

  rails_new_opts = %w(
    --skip-turbolinks
    --skip-spring
    --skip-bootsnap
    --skip-javascript
    -m
    spec/support/rails_template.rb
  )
  # Same path spec_helper.rb uses, so the suite finds the app.
  activeadmin_major = Gem.loaded_specs['activeadmin'].version.segments.first
  app_path = ENV['RAILS_ROOT'] || "spec/rails/rails-#{Rails::VERSION::STRING}-aa#{activeadmin_major}"
  system 'bundle', 'exec', 'rails', 'new', app_path, *rails_new_opts
end
