require 'spec_helper'

describe 'authors index', type: :feature, js: true do
  before do
    add_author_resource
  end

  context 'edit form' do
    before do
      visit '/admin/authors/new'
    end

    before do
      page.find('#author_birthday').click

      page.find('.xdsoft_datetimepicker', visible: true)
          .find('.xdsoft_calendar td.xdsoft_date[data-date="1"]').click
      page.find('.xdsoft_datetimepicker', visible: true)
          .find('.xdsoft_timepicker.active .xdsoft_time.xdsoft_current').click
    end

    it 'can set birthday'  do
      date_birthday = Date.today.beginning_of_month.strftime("%Y-%m-%d")
      expect(page.find('#author_birthday').value).to start_with(date_birthday)
      expect(page).to have_css('#author_birthday[placeholder="Formtastic placeholder"]')
    end
  end
end
