# frozen_string_literal: true

require 'spec_helper'

describe 'authors index', type: :feature, js: true do
  before do
    Author.create!(name: 'John', last_name: 'Doe')
    Author.create!(name: 'Jane', last_name: 'Roe')
  end

  before do
    add_author_resource
  end

  context 'index filters' do
    before do
      visit '/admin/authors'
    end

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
      date_from = Date.today.beginning_of_month.strftime('%Y-%m-%d')
      date_to = (Date.today.beginning_of_month + 19.days).strftime('%Y-%m-%d')

      expect(page.find('input#q_birthday_gteq').value).to start_with(date_from)
      expect(page.find('input#q_birthday_lteq').value).to start_with(date_to)
    end
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

    it 'can set birthday' do
      date_birthday = Date.today.beginning_of_month.strftime('%Y-%m-%d')
      expect(page.find('#author_birthday').value).to start_with(date_birthday)
    end
  end
end
