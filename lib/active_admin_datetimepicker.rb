require 'activeadmin'

module ActiveAdminDatetimepicker
  # ActiveAdmin 4 drops jQuery and Sprockets, so the plugin renders native
  # date/time inputs there instead of the xdsoft picker.
  def self.aa_v4?
    Gem::Version.new(ActiveAdmin::VERSION) >= Gem::Version.new('4.0.0.beta1')
  end
end

require 'active_admin_datetimepicker/version'
require 'active_admin_datetimepicker/base'
require 'active_admin_datetimepicker/inputs/date_time_picker_input'
require 'active_admin_datetimepicker/inputs/filters/date_time_range_input'

module ActiveAdminDatetimepicker
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end
