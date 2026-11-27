# Page objects for the plugin's inputs, built on the active_admin_page_objects
# gem (2.x, which needs ActiveAdmin 4). Test code only: load it from a spec
# helper with
#   require 'active_admin_datetimepicker/page_objects'
# The plugin itself never requires this file, and the gemspec does not depend
# on active_admin_page_objects.
require 'active_admin_page_objects'

ActiveAdminPageObjects.check_version!('>= 2.0.0.a', '< 3.0.0.a', plugin: 'active_admin_datetimepicker')

# The inputs of the range filter carry data-datetimepicker-range-input. The
# gem's own filter_range_from and filter_range_to look for names that end in
# _gteq] and _lteq], which the _datetime_picker predicates do not.
ActiveAdminPageObjects.register_selectors(
  datetimepicker_range_from: "input[data-datetimepicker-range-input='from']",
  datetimepicker_range_to: "input[data-datetimepicker-range-input='to']"
)

module ActiveAdminDatetimepicker
  module PageObjects
  end
end

require 'active_admin_datetimepicker/page_objects/date_time_range_filter'

# Formtastic puts the input's name, here date_time_range, on its wrapper.
ActiveAdminPageObjects.register_filter_class('date_time_range', ActiveAdminDatetimepicker::PageObjects::DateTimeRangeFilter)
