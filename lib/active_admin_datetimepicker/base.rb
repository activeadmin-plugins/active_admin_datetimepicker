module ActiveAdminDatetimepicker
  module Base
    mattr_accessor :default_datetime_picker_options
    @@default_datetime_picker_options = {}
    mattr_accessor :format
    @@format = '%Y-%m-%d %H:%M'

    # Value formats the browser accepts for native inputs (HTML spec), used on ActiveAdmin 4.
    NATIVE_FORMATS = {
      'datetime-local' => '%Y-%m-%dT%H:%M',
      'date' => '%Y-%m-%d'
    }.freeze

    def html_class
      'date-time-picker'
    end

    def input_html_data
      {}
    end

    def input_html_options(input_name = nil, placeholder = nil)
      super().tap do |options|
        options[:class] = [self.options[:class], html_class].compact.join(' ')
        options[:data] ||= input_html_data
        if ActiveAdminDatetimepicker.aa_v4?
          native_input_html_options(options, input_name)
        else
          options[:data].merge!(datepicker_options: datetime_picker_options)
          options[:value] = input_value(input_name)
          options[:maxlength] = 19
        end
        options[:data].merge!(datetimepicker_input: true)
        options[:placeholder] = placeholder unless placeholder.nil?
      end
    end

    def input_value(input_name = nil)
      val = object.public_send(input_name || method)
      val.is_a?(Date) ? val : parse_datetime(val)
    end

    def parse_datetime(val)
      DateTime.parse(val.to_s).strftime(format)
    rescue ArgumentError
      nil
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

    # A date column gets a date-only control; datetime columns and
    # ransackers without a column get a date and time control.
    def native_input_type
      column && column.type == :date ? 'date' : 'datetime-local'
    end

    def native_input_value(input_name = nil)
      format_native(object.public_send(input_name || method))
    end

    protected

    def native_input_html_options(options, input_name)
      options[:type] = native_input_type
      options[:value] = native_input_value(input_name)
      options.delete(:maxlength)
      options.delete(:size)
      native_picker_attributes.each { |name, value| options[name] = value unless options.key?(name) }
    end

    # Only the xdsoft options with a native equivalent are mapped; the rest
    # configure the jQuery widget, which ActiveAdmin 4 pages do not load.
    def native_picker_attributes
      picker_options = datetime_picker_options.transform_keys { |k| k.to_s.camelcase(:lower) }
      attributes = {}
      min = format_native(picker_options['minDateTime']) || format_native(picker_options['minDate'])
      max = format_native(picker_options['maxDateTime']) || native_max_date(picker_options['maxDate'])
      attributes[:min] = min if min
      attributes[:max] = max if max
      step = picker_options['step'].to_i
      # xdsoft counts the step in minutes, the HTML attribute in seconds.
      attributes[:step] = step * 60 if step > 0 && native_input_type == 'datetime-local'
      attributes
    end

    # xdsoft's maxDate allows the whole last day, so a datetime-local max ends at 23:59.
    def native_max_date(value)
      max = format_native(value)
      max && native_input_type == 'datetime-local' ? "#{max[0, 10]}T23:59" : max
    end

    def format_native(value)
      value = value.call if value.respond_to?(:call)
      return nil if value.blank?
      unless value.respond_to?(:strftime)
        # Relative xdsoft values such as "+3D" have no native equivalent.
        return nil unless value.to_s.match?(%r{\A\d{4}[-/]\d{1,2}[-/]\d{1,2}})
        value = DateTime.parse(value.to_s)
      end
      # A Time option is shown in the app's zone, like the record values.
      value = value.in_time_zone if value.is_a?(Time)
      value.strftime(NATIVE_FORMATS.fetch(native_input_type))
    rescue ArgumentError
      nil
    end

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
