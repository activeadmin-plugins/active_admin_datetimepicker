# frozen_string_literal: true

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

        def gt_input_name
          "#{method}_gteq"
        end

        def lt_input_name
          "#{method}_lteq"
        end
      end
    end
  end
end
