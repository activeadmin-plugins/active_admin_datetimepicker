require 'spec_helper'

describe 'data-* hooks', type: :feature do
  before { add_author_resource }

  it 'marks the filter range wrapper and its from/to inputs' do
    visit '/admin/authors'

    within('#q_created_at_input[data-datetimepicker-range]') do
      expect(page).to have_css('input#q_created_at_gteq_datetime_picker[data-datetimepicker-input][data-datetimepicker-range-input="from"]')
      expect(page).to have_css('input#q_created_at_lteq_datetime_picker[data-datetimepicker-input][data-datetimepicker-range-input="to"]')
    end
  end

  it 'marks the form input' do
    visit '/admin/authors/new'

    expect(page).to have_css('input#author_birthday[data-datetimepicker-input]')
  end
end
