# frozen_string_literal: true

def add_author_resource(_options = {})
  ActiveAdmin.register Author do
    config.filters = true

    filter :birthday, as: :date_time_range

    form do |f|
      f.semantic_errors *f.object.errors.keys

      f.inputs 'General' do
        f.input :name
        f.input :birthday, as: :date_time_picker
      end

      f.actions
    end
  end
  Rails.application.reload_routes!
end
