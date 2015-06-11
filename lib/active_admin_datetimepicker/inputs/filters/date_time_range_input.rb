module ActiveAdmin
  module Inputs
    module Filters
      class DateTimeRangeInput < DateRangeInput
        include Base
        include ActiveAdminDatetimepicker::Base

        def input_html_options(input_name = gt_input_name)
          super.tap do |options|
            options[:class] = html_class
          end
        end
      end
    end
  end
end
