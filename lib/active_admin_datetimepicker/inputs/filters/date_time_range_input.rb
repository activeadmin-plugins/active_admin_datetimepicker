module ActiveAdmin
  module Inputs
    module Filters
      class DateTimeRangeInput < DateRangeInput
        include Base

        def html_class
          "date-time-picker"
        end

        def format
          "%Y-%m-%d %H:%M"
        end

        def input_html_options(input_name = gt_input_name)
          current_value = @object.public_send input_name
          { size: 12,
            class: html_class,
            max: 10,
            value: current_value.respond_to?(:strftime) ? current_value.strftime(format) : "" }
        end
      end
    end
  end
end