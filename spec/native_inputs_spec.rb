require 'spec_helper'

describe 'native inputs on ActiveAdmin 4', type: :feature, aa: 4 do
  def register_author_with_datetime_form(created_at_options = {})
    ActiveAdmin.register Author do
      permit_params :name, :last_name, :birthday, :created_at

      filter :birthday, as: :date_time_range
      filter :created_at, as: :date_time_range
      filter :last_seen_at, as: :date_time_range

      form do |f|
        f.inputs do
          f.input :name
          f.input :last_name
          f.input :birthday, as: :date_time_picker
          f.input :created_at, { as: :date_time_picker }.merge(created_at_options)
        end
        f.actions
      end
    end
    Rails.application.reload_routes!
  end

  context 'form input' do
    before { register_author_with_datetime_form }

    it 'renders datetime-local for a datetime column and date for a date column' do
      visit '/admin/authors/new'

      expect(page).to have_css('input#author_created_at[type="datetime-local"][data-datetimepicker-input]')
      expect(page).to have_css('input#author_birthday[type="date"][data-datetimepicker-input]')
      expect(page).not_to have_css('[data-datepicker-options]')
    end

    it 'saves the ISO value and shows it back' do
      visit '/admin/authors/new'
      fill_in 'author_name', with: 'Ren'
      fill_in 'author_last_name', with: 'Iso'
      fill_in 'author_birthday', with: '1990-05-17'
      fill_in 'author_created_at', with: '2024-01-31T10:45'
      find('input[type=submit]').click

      author = Author.find_by!(last_name: 'Iso')
      expect(author.birthday).to eq Date.new(1990, 5, 17)
      expect(author.created_at.strftime('%Y-%m-%d %H:%M')).to eq '2024-01-31 10:45'

      visit "/admin/authors/#{author.id}/edit"
      expect(find('#author_created_at').value).to eq '2024-01-31T10:45'
      expect(find('#author_birthday').value).to eq '1990-05-17'
    end
  end

  context 'form input with datepicker_options' do
    before do
      register_author_with_datetime_form(
        datepicker_options: { min_date: '2024-01-01', max_date: Date.new(2024, 12, 31), step: 15, format: 'd/m/Y H:i' }
      )
    end

    it 'maps min, max and step to native attributes' do
      visit '/admin/authors/new'

      input = find('#author_created_at')
      expect(input[:min]).to eq '2024-01-01T00:00'
      expect(input[:max]).to eq '2024-12-31T00:00'
      expect(input[:step]).to eq '900'
    end
  end

  context 'form input with relative xdsoft limits' do
    before { register_author_with_datetime_form(datepicker_options: { min_date: '+3D' }) }

    it 'leaves min out' do
      visit '/admin/authors/new'
      expect(find('#author_created_at')[:min]).to be_nil
    end
  end

  context 'filters' do
    before do
      register_author_with_datetime_form
      Author.create!(name: 'Ren', last_name: 'before', created_at: Time.zone.parse('2024-01-20 09:00'), updated_at: Time.zone.parse('2024-01-20 09:00'))
      Author.create!(name: 'Rey', last_name: 'inside', created_at: Time.zone.parse('2024-01-20 11:00'), updated_at: Time.zone.parse('2024-01-20 11:00'))
      Author.create!(name: 'Ron', last_name: 'after', created_at: Time.zone.parse('2024-01-20 13:00'), updated_at: Time.zone.parse('2024-01-20 13:00'))
      visit '/admin/authors'
    end

    it 'renders the pair inside the ActiveAdmin 4 filter markup' do
      wrapper = find('#q_created_at_input')
      expect(wrapper[:class].split).to include('filters-form-field', 'filter_date_time_range')
      expect(wrapper['data-datetimepicker-range']).to eq 'true'
      expect(wrapper).to have_css('.filters-form-input-group input[type="datetime-local"][name="q[created_at_gteq_datetime_picker]"][data-datetimepicker-range-input="from"]')
      expect(wrapper).to have_css('.filters-form-input-group input[type="datetime-local"][name="q[created_at_lteq_datetime_picker]"][data-datetimepicker-range-input="to"]')
      expect(page).to have_css('#q_birthday_input input[type="date"][name="q[birthday_gteq]"]')
    end

    it 'filters a datetime column with ISO values and keeps them in the inputs' do
      fill_in 'q_created_at_gteq_datetime_picker', with: '2024-01-20T10:00'
      fill_in 'q_created_at_lteq_datetime_picker', with: '2024-01-20T12:00'
      find('.filters-form-submit').click

      expect(page).to have_text('inside')
      expect(page).not_to have_text('before')
      expect(page).not_to have_text('after')
      expect(find('#q_created_at_gteq_datetime_picker').value).to eq '2024-01-20T10:00'
      expect(find('#q_created_at_lteq_datetime_picker').value).to eq '2024-01-20T12:00'
    end

    it 'filters an untyped ransacker with ISO values' do
      fill_in 'q_last_seen_at_gteq_datetime_picker', with: '2024-01-20T10:00'
      fill_in 'q_last_seen_at_lteq_datetime_picker', with: '2024-01-20T12:00'
      find('.filters-form-submit').click

      expect(page).to have_text('inside')
      expect(page).not_to have_text('before')
      expect(page).not_to have_text('after')
      expect(find('#q_last_seen_at_gteq_datetime_picker').value).to eq '2024-01-20T10:00'
    end
  end

  context 'in a browser', js: true do
    before do
      register_author_with_datetime_form
      visit '/admin/authors?q[created_at_gteq_datetime_picker]=2024-01-20T10:00'
    end

    it 'accepts the rendered value as a valid datetime-local value' do
      # Browsers blank a datetime-local whose value does not match the spec format.
      expect(page.evaluate_script("document.getElementById('q_created_at_gteq_datetime_picker').value")).to eq '2024-01-20T10:00'
    end
  end
end
