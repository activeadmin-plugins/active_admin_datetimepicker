# frozen_string_literal: true

module ActiveAdminDatetimepicker
  module Base
    mattr_accessor :default_datetime_picker_options
    @@default_datetime_picker_options = {}
    mattr_accessor :format
    @@format = '%Y/%m/%d %H:%M'
    mattr_accessor :format_date
    @@format_date = '%Y/%m/%d'
    # mattr_accessor :format_time
    # @@format_time = '%H:%M'

    def html_class
      'date-time-picker'
    end

    def input_html_data
      {}
    end

    def input_html_options(input_name = nil, _placeholder = nil)
      options = {}
      options[:class] = [self.options[:class], html_class].compact.join(' ')
      options[:data] ||= input_html_data
      options[:data][:datepicker_options] = datetime_picker_options
      options[:value] ||= input_value(input_name)
      options[:maxlength] = 19
      options
    end

    def input_value(input_name = nil)
      val = object.public_send(input_name || method)
      case val
      when Time
        return DateTime.new(val.year, val.month, val.day, val.hour, val.min,
                            val.sec).strftime(format)
      when Date
        return Date.new(val.year, val.month, val.day).strftime(format_date)
      else
        val.to_s
      end
    end

    def datetime_picker_options
      @datetime_picker_options ||= begin
        # backport support both :datepicker_options AND :datetime_picker_options
        options = self.options.fetch(:datepicker_options, {})
        options = self.options.fetch(:datetime_picker_options, options)
        options = Hash[options.map { |k, v| [k.to_s.camelcase(:lower), v] }]
        _default_datetime_picker_options.merge(options)
      end
    end

    protected

    def _default_datetime_picker_options
      res = default_datetime_picker_options.map do |k, v|
        if v.respond_to?(:call) || v.is_a?(Proc)
          [k, v.call]
        else
          [k, v]
        end
      end
      Hash[res]
    end
  end
end
