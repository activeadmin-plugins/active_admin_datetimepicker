Ransack.configure do |config|
  config.add_predicate 'gteq_datetime_picker',
    arel_predicate: 'gteq'

  config.add_predicate 'lteq_datetime_picker',
    arel_predicate: 'lt'
end
