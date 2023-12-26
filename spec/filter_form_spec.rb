require 'spec_helper'

describe 'authors index', type: :feature, js: true do
  before do
    add_author_resource
  end

  context 'index filters' do
    before do
      visit '/admin/authors'
    end

    context 'filter by Date column' do
      before do
        page.find('input#q_birthday_gteq').click

        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_calendar td.xdsoft_date[data-date="1"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click

        page.find('input#q_birthday_lteq').click

        page.find('.xdsoft_datetimepicker', visible: true)
          .find('.xdsoft_calendar td.xdsoft_date[data-date="20"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click
      end

      it 'can set date from/to' do
        date_from = Date.today.beginning_of_month.strftime("%Y-%m-%d")
        date_to = (Date.today.beginning_of_month + 19.days).strftime("%Y-%m-%d")

        expect(page.find('input#q_birthday_gteq').value).to start_with(date_from)
        expect(page.find('input#q_birthday_lteq').value).to start_with(date_to)

        expect(page).to have_css('input#q_birthday_gteq[placeholder="From"]')
        expect(page).to have_css('input#q_birthday_lteq[placeholder="To"]')

        page.find('#sidebar input[type=submit]').click
        page.has_css?('h4', text: 'Current filters:')

        # birthday(Date type) is a Date column, should not contain H:M
        expect(page.find('#q_birthday_gteq').value).to match(/\A\d{4}-\d{2}-\d{2}\z/)
      end
    end

    context 'filter by DateTime/Timestamp column' do
      before do
        Author.create!(name: "Ren",
                       last_name: "from-20-day-of-month",
                       created_at: (Time.now.change(day: 20) - 1.hour).to_formatted_s(:db))

        Author.create!(name: "Rey",
                       last_name: "from-the-future",
                       created_at: (Time.now.change(day: 20) + 2.hours).to_formatted_s(:db))

        # chose 01 and 20 day of the current month

        page.find('input#q_created_at_gteq_datetime_picker').click

        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_calendar td.xdsoft_date[data-date="1"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click

        page.find('input#q_created_at_lteq_datetime_picker').click

        page.find('.xdsoft_datetimepicker', visible: true)
          .find('.xdsoft_calendar td.xdsoft_date[data-date="20"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click

        @value_from = page.find('#q_created_at_gteq_datetime_picker').value
        @value_to = page.find('#q_created_at_lteq_datetime_picker').value

        page.find('#sidebar input[type=submit]').click
        page.has_css?('h4', text: 'Current filters:')
      end

      it 'q_created_at_lteq_datetime send correct value to SQL' do
        expect(page).to have_text('from-20-day-of-month')
        expect(page).not_to have_text('from-the-future')
      end

      it 'input#value and placeholder is the same as before form submit' do
        # created_at(Timestamp type) should contain Hours:Minutes, as selected before submit
        expect(page.find('#q_created_at_gteq_datetime_picker').value).to match(@value_from)
        expect(page.find('#q_created_at_lteq_datetime_picker').value).to match(@value_to)

        expect(page).to have_css('#q_created_at_gteq_datetime_picker[placeholder=From]')
        expect(page).to have_css('#q_created_at_lteq_datetime_picker[placeholder=To]')
      end
    end

    context 'filter by virtual attribute last_seen_at - without column&type properties (search by updated_at)' do
      before do
        @first_author = Author.create!(name: 'Ren', last_name: 'current', updated_at: Time.now.to_formatted_s(:db))
        @second_author = Author.create!(name: 'Rey', last_name: 'future', updated_at: 22.days.from_now.to_formatted_s(:db))

        # chose 01 and 20 day of the current month
        page.find('input#q_last_seen_at_gteq_datetime_picker').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_calendar td.xdsoft_date[data-date="1"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click

        page.find('input#q_last_seen_at_lteq_datetime_picker').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_calendar td.xdsoft_date[data-date="20"]').click
        page.find('.xdsoft_datetimepicker', visible: true)
            .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click

        @value_from = page.find('#q_last_seen_at_gteq_datetime_picker').value
        @value_to = page.find('#q_last_seen_at_lteq_datetime_picker').value

        page.find('#sidebar input[type=submit]').click
        page.has_css?('h4', text: 'Current filters:')
      end

      it 'should filter records properly' do
        expect(page).to have_text(@first_author.name)
        expect(page).not_to have_text(@second_author.name)
      end

      it 'input#value and placeholder is the same as before form submit' do
        # last_seen_at (without typecasting just a string) should contain Hours:Minutes, as selected before submit
        expect(page.find('#q_last_seen_at_gteq_datetime_picker').value).to match(@value_from)
        expect(page.find('#q_last_seen_at_lteq_datetime_picker').value).to match(@value_to)

        expect(page).to have_css('#q_last_seen_at_gteq_datetime_picker[placeholder=From]')
        expect(page).to have_css('#q_last_seen_at_lteq_datetime_picker[placeholder=To]')
      end
    end
  end
end
