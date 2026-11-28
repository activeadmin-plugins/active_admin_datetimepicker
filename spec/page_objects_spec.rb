require 'spec_helper'

# The page objects need active_admin_page_objects 2.x, which needs ActiveAdmin 4.
if ActiveAdminDatetimepicker.aa_v4?
  require 'active_admin_datetimepicker/page_objects'

  describe 'page objects for the range filter', type: :feature, aa: 4 do
    let(:authors_page) do
      Class.new(ActiveAdminPageObjects::Page) do
        set_url '/admin/authors'
        section :filters, ActiveAdminPageObjects::Filters
      end.new
    end
    let(:filters) { authors_page.filters }
    let(:filter_class) { ActiveAdminDatetimepicker::PageObjects::DateTimeRangeFilter }

    before do
      add_author_resource
      Author.create!(name: 'Ren', last_name: 'before', created_at: Time.zone.parse('2024-01-20 09:00'), updated_at: Time.zone.parse('2024-01-20 09:00'))
      Author.create!(name: 'Rey', last_name: 'inside', created_at: Time.zone.parse('2024-01-20 11:00'), updated_at: Time.zone.parse('2024-01-20 11:00'))
      Author.create!(name: 'Ron', last_name: 'after', created_at: Time.zone.parse('2024-01-20 13:00'), updated_at: Time.zone.parse('2024-01-20 13:00'))
      authors_page.load
    end

    it 'returns the filter class for a datetime column, a date column and an untyped ransacker' do
      expect(filters.filter(:created_at)).to be_a(filter_class)
      expect(filters.filter(:birthday)).to be_a(filter_class)
      expect(filters.filter(:last_seen_at)).to be_a(filter_class)
    end

    it 'leaves the base gem selectors alone' do
      expect(ActiveAdminPageObjects.selector(:filter_range_from)).to eq 'input[name$="_gteq]"]'
      expect(ActiveAdminPageObjects.selector(:filter_range_to)).to eq 'input[name$="_lteq]"]'
    end

    it 'fills the range from a Time and a String and filters by it' do
      filters.filter(:created_at).fill_in_range(from: Time.zone.parse('2024-01-20 10:00'), to: '2024-01-20 12:00')
      filters.submit

      expect(page).to have_text('inside')
      expect(page).not_to have_text('before')
      expect(page).not_to have_text('after')
      expect(find('#q_created_at_gteq_datetime_picker').value).to eq '2024-01-20T10:00'
      expect(find('#q_created_at_lteq_datetime_picker').value).to eq '2024-01-20T12:00'
    end

    it 'reads the ends as Times in the app zone' do
      filter = filters.filter(:last_seen_at)
      filter.fill_in_range(from: '2024-01-20T10:00', to: Time.utc(2024, 1, 20, 12, 30).in_time_zone)

      expect(filter.from).to eq Time.zone.parse('2024-01-20 10:00')
      expect(filter.to).to eq Time.zone.parse('2024-01-20 12:30')
      expect(filter.range).to eq [filter.from, filter.to]
      expect(filter).to have_range('2024-01-20 10:00', Time.zone.parse('2024-01-20 12:30'))
      expect(filter).to have_no_range('2024-01-20 10:00', '2024-01-20 12:00', wait: 0)
    end

    it 'writes a Date as midnight, and a date column as a date' do
      created = filters.filter(:created_at)
      created.fill_in_range(from: Date.new(2024, 1, 20), to: Date.new(2024, 1, 21))
      expect(find('#q_created_at_gteq_datetime_picker').value).to eq '2024-01-20T00:00'
      expect(created.to).to eq Time.zone.parse('2024-01-21 00:00')

      birthday = filters.filter(:birthday)
      birthday.fill_in_range(from: Time.zone.parse('1990-05-17 15:30'), to: '1990-06-01')
      expect(find('input[name="q[birthday_gteq]"]').value).to eq '1990-05-17'
      expect(find('input[name="q[birthday_lteq]"]').value).to eq '1990-06-01'
      expect(birthday.from).to eq Time.zone.parse('1990-05-17 00:00')
    end

    it 'clears an end with nil' do
      filter = filters.filter(:created_at)
      filter.fill_in_range(from: '2024-01-20 10:00', to: '2024-01-20 12:00')
      filter.fill_in_range(from: nil, to: '2024-01-20 12:00')

      expect(filter.from).to be_nil
      expect(filter.to).to eq Time.zone.parse('2024-01-20 12:00')
    end

    it 'rejects a String without a date' do
      expect { filters.filter(:created_at).fill_in_range(from: 'soon', to: nil) }.to raise_error(ArgumentError)
    end

    it 'fills the inputs of a browser', js: true do
      filter = filters.filter(:created_at)
      filter.fill_in_range(from: Time.zone.parse('2024-01-20 10:00'), to: '2024-01-20 12:00')

      expect(filter.range).to eq [Time.zone.parse('2024-01-20 10:00'), Time.zone.parse('2024-01-20 12:00')]
      filters.submit
      expect(page).to have_text('inside')
      expect(page).not_to have_text('after')
    end

    # The plugin writes whole-minute steps; an app's input_html can set a finer one.
    %w[1 any].each do |step|
      it "keeps seconds when the input's step is #{step}", js: true do
        page.execute_script("document.querySelectorAll('[data-datetimepicker-range-input]').forEach(input => { input.step = '#{step}' })")
        filter = filters.filter(:created_at)
        filter.fill_in_range(from: Time.zone.parse('2024-01-20 10:00:15'), to: '2024-01-20 12:00:00')

        expect(find('#q_created_at_gteq_datetime_picker').value).to eq '2024-01-20T10:00:15'
        expect(find('#q_created_at_lteq_datetime_picker').value).to start_with '2024-01-20T12:00'
        expect(filter.from).to eq Time.zone.parse('2024-01-20 10:00:15')
        expect(filter.to).to eq Time.zone.parse('2024-01-20 12:00')
        expect(filter).to have_range('2024-01-20 10:00:15', '2024-01-20 12:00')
        expect(filter).to have_no_range('2024-01-20 10:00', '2024-01-20 12:00', wait: 0)
      end
    end
  end
end
