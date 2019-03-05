# frozen_string_literal: true

require 'spec_helper'

describe ActiveAdminDatetimepicker::Base do
  class Dummy
    include ActiveAdminDatetimepicker::Base
  end

  let(:dummy) { Dummy.new }

  it 'html_class' do
    expect(dummy.html_class).to eq 'date-time-picker'
  end

  it 'format' do
    expect(dummy.format).to eq '%Y-%m-%d %H:%M'
    expect(ActiveAdminDatetimepicker::Base.format).to eq '%Y-%m-%d %H:%M'
  end
end
