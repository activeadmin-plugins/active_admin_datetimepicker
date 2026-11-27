module ActiveAdminDatetimepicker
  module PageObjects
    # The `as: :date_time_range` filter: a pair of native `datetime-local`
    # inputs (`date` for a date column) on ActiveAdmin 4. Values are written in
    # the format the input takes, in the app's time zone, which is the zone the
    # plugin shows them in. `filters.filter(:created_at)` returns it without a
    # declaration; declare it to type a filter:
    #
    #   section :filters, ActiveAdminPageObjects::Filters do
    #     filter :created_at, 'Created At', ActiveAdminDatetimepicker::PageObjects::DateTimeRangeFilter
    #   end
    #
    #   filter = filters.filter(:created_at)
    #   filter.fill_in_range(from: Time.zone.parse('2024-01-20 10:00'), to: '2024-01-20 12:00')
    #   filters.submit
    #   filter.from # => Sat, 20 Jan 2024 10:00:00 UTC +00:00
    class DateTimeRangeFilter < ActiveAdminPageObjects::DateRangeFilter
      LOCAL_FORMAT = '%Y-%m-%dT%H:%M'.freeze
      DATE_FORMAT = '%Y-%m-%d'.freeze

      # Sets both ends. +from+ and +to+ are a Time, a Date or a String that
      # Time.zone parses; a Date is midnight. nil or "" clears that end.
      # @raise [ArgumentError] for a String that holds no date
      def fill_in_range(from:, to:)
        write(from_input, from)
        write(to_input, to)
        self
      end

      # See #fill_in_range.
      def set(from, to = nil)
        fill_in_range(from: from, to: to)
      end

      # The "from" end as a Time in the app's zone, or nil when it is empty.
      # An input without a time, such as a date column's, gives midnight.
      # @return [Time, nil]
      def from
        read(from_input)
      end

      # The "to" end, as #from gives it.
      # @return [Time, nil]
      def to
        read(to_input)
      end

      # @return [Array<Time, nil>] #from and #to
      def range
        [from, to]
      end

      private

      def from_input
        find(:active_admin, :datetimepicker_range_from)
      end

      def to_input
        find(:active_admin, :datetimepicker_range_to)
      end

      def zone
        Time.zone || Time.find_zone!('UTC')
      end

      def parse(text)
        zone.parse(text) || raise(ArgumentError, "no date in #{text.inspect}")
      end

      def to_time(value)
        value.is_a?(String) ? parse(value) : value.in_time_zone(zone)
      end

      def blank_end?(value)
        value.nil? || value == ''
      end

      # The step is in seconds: a sub-minute one makes the input take seconds.
      def seconds?(input)
        step = input[:step]
        step == 'any' || (!step.to_s.empty? && step.to_f % 60 != 0)
      end

      def format_of(input)
        case input[:type]
        when 'datetime-local' then seconds?(input) ? "#{LOCAL_FORMAT}:%S" : LOCAL_FORMAT
        when 'date' then DATE_FORMAT
        else defined?(ActiveAdminDatetimepicker::Base) ? ActiveAdminDatetimepicker::Base.format : '%Y-%m-%d %H:%M'
        end
      end

      def written(input, value)
        to_time(value).strftime(format_of(input))
      end

      def write(input, value)
        input.set(blank_end?(value) ? '' : written(input, value))
      end

      def read(input)
        text = input.value.to_s
        text.empty? ? nil : parse(text)
      end

      # Compares the Times the inputs hold, as the browser may drop zero seconds.
      def range_matches?(from, to)
        [[from_input, from], [to_input, to]].all? do |input, value|
          expected = blank_end?(value) ? nil : parse(written(input, value))
          read(input) == expected
        end
      end
    end
  end
end
