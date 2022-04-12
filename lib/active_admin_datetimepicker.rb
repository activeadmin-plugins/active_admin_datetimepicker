require 'activeadmin'
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
