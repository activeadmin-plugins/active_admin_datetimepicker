module ActiveAdminDatetimepicker
  module Base
    def html_class
      'date-time-picker'
    end

    def format
      '%Y-%m-%d %H:%M'
    end

    def input_html_data
      {}
    end

    def input_html_options(input_name = nil)
      options = {}
      options[:class] = [self.options[:class], html_class].compact.join(' ')
      options[:data] ||= input_html_data
      options[:data].merge!(datepicker_options: datetime_picker_options)
      options[:value] ||= input_value(input_name)
      options[:maxlength] = 19
      options
    end

    def input_value(input_name = nil)
      val = object.public_send(input_name || method)
      return DateTime.new(val.year, val.month, val.day, val.hour, val.min).strftime(format) if val.is_a?(Time)
      val.to_s
    end

    def datetime_picker_options
      @datetime_picker_options ||= begin
        # backport support both :datepicker_options AND :datetime_picker_options
        options = self.options.fetch(:datepicker_options, {})
        options = self.options.fetch(:datetime_picker_options, options)
        Hash[options.map { |k, v| [k.to_s.camelcase(:lower), v] }]
      end
    end
  end
end
