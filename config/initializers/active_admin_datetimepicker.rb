# ActiveAdmin 4 submits native datetime-local values ("2024-01-31T10:00").
# Typed columns cast them to times; for an untyped ransacker the value stays a
# string, so the "T" is swapped for the space the database compares against.
iso_to_db = lambda do |value|
  value.is_a?(String) ? value.sub(/\A(\d{4}-\d{2}-\d{2})T(?=\d{2}:\d{2})/, '\1 ') : value
end

Ransack.configure do |config|
  config.add_predicate 'gteq_datetime_picker',
    arel_predicate: 'gteq',
    formatter: iso_to_db

  config.add_predicate 'lteq_datetime_picker',
    arel_predicate: 'lt',
    formatter: iso_to_db
end
