def add_author_resource(options = {}, &block)

  ActiveAdmin.register Author do
    config.filters = true

    filter :birthday, as: :date_time_range
    filter :created_at, as: :date_time_range
    filter :last_seen_at, as: :date_time_range

    form do |f|
      f.semantic_errors(*f.object.errors.attribute_names)

      f.inputs 'General' do
        f.input :name
        f.input :birthday, as: :date_time_picker, input_html: { placeholder: 'Formtastic placeholder' }
      end

      f.actions
    end
  end
  Rails.application.reload_routes!

end
