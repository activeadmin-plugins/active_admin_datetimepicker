# ActiveAdminDatetimepicker

Adds ability to use XDSoft's DateTime picker as the date_time_picker input for forms, and date_time_range for filters


![ActiveAdminDatetimepicker](https://raw.githubusercontent.com/ActiveAdminPlugins/activeadmin_datetimepicker/master/screen/screen.png "ActiveAdminDatetimepicker")

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_admin_datetimepicker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_admin_datetimepicker

## Usage

Plugin  offers the `date_time_picker` input and `date_time_range` filter , which use the [XDSoft DateTime Picker gem](https://github.com/shekibobo/xdan-datetimepicker-rails).
The `date_time_picker` input accepts many of the options available to the standard jQueryUI Datepicker. For example:

 JS asset
 ```//= require active_admin_datetimepicker```

 CSS
 ```@import "active_admin_datetimepicker";```


```ruby
form do |f|
  f.input :starts_at, as: :date_time_picker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }
  f.input :ends_at,   as: :date_time_picker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
end
```

```ruby
    filter :created_at, as: :date_time_range
```


## Override behaviour in initializer
```ruby
# This if for front-end javascript side
ActiveAdminDatetimepicker::Base.default_datetime_picker_options = {
    defaultDate: proc { Time.current.strftime("%Y-%m-%d 00:00") }
}
# This if for backend(Ruby)
ActiveAdminDatetimepicker::Base.format = "%Y-%m-%d %H:%M:%S"
```


See [the datetimepicker documentation for more details](http://xdsoft.net/jqplugins/datetimepicker/).


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/activeadmin-plugins/activeadmin_datetimepicker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
