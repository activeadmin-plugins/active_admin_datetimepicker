module ActiveAdmin
  module Inputs
    class DateTimePickerInput < ::Formtastic::Inputs::StringInput
      include ActiveAdminDatetimepicker::Base
    end
  end
end
