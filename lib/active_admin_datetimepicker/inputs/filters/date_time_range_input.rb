module ActiveAdmin
  module Inputs
    module Filters
      class DateTimeRangeInput < DateRangeInput
        include Base
        include ActiveAdminDatetimepicker::Base

        # ActiveAdmin 4's DateRangeInput renders date_field pairs, which drop
        # the time; this keeps its markup but emits native datetime fields.
        def to_html
          return super unless ActiveAdminDatetimepicker.aa_v4?

          input_wrapping do
            [ label_html,
              '<div class="filters-form-input-group">',
              builder.text_field(gt_input_name, input_html_options_for(gt_input_name, gt_input_placeholder)),
              builder.text_field(lt_input_name, input_html_options_for(lt_input_name, lt_input_placeholder)),
              '</div>'
            ].join("\n").html_safe
          end
        end

        def wrapper_html_options
          super.tap do |options|
            # ActiveAdmin 4 dropped the filter_<as> class that active_admin_date_range_preset looks for.
            options[:class] = "#{options[:class]} filter_date_time_range" if ActiveAdminDatetimepicker.aa_v4?
            options[:data] = (options[:data] || {}).merge(datetimepicker_range: true)
          end
        end

        def input_html_options(input_name = gt_input_name, placeholder = gt_input_placeholder)
          super.tap do |options|
            options[:class] = html_class
          end
        end

        # This method is for compatibility for ActiveAdmin 2.6
        def input_html_options_for(input_name, placeholder)
          options = super
          value = ActiveAdminDatetimepicker.aa_v4? ? native_input_value(input_name) : input_value(input_name)
          bound = input_name == gt_input_name ? 'from' : 'to'
          options.merge placeholder: placeholder,
                        value: value,
                        data: (options[:data] || {}).merge(datetimepicker_range_input: bound)
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
