module ActiveAdmin
  module Inputs
    module Filters
      class DateTimeRangeInput < DateRangeInput
        include Base
        include ActiveAdminDatetimepicker::Base

        def input_html_options(input_name = gt_input_name, placeholder = gt_input_placeholder)
          super.tap do |options|
            options[:class] = html_class
          end
        end

        # This method is for compatibility for ActiveAdmin 2.6
        def input_html_options_for(input_name, placeholder)
          super.merge placeholder: placeholder,
                      value: input_value(input_name)
        end

        def gt_input_name
          column && column.type == :date ? super : "#{method}_gteq_datetime_picker"
        end

        def lt_input_name
          column && column.type == :date ? super : "#{method}_lteq_datetime_picker"
        end

      end
    end
  end
end
