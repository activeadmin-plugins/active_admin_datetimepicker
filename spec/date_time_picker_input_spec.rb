# frozen_string_literal: true

require 'spec_helper'

describe ActiveAdmin::Inputs::DateTimePickerInput do
  it 'included from ActiveAdminDatetimepicker::Base' do
    input = ActiveAdmin::Inputs::DateTimePickerInput.new(
      # all dummy args for now
      Object.new, Object.new, Object.new, Object.new, Object.new, {})
    expect(input.html_class).to eq 'date-time-picker'
    expect(input.format).to eq '%Y-%m-%d %H:%M'
  end
end
