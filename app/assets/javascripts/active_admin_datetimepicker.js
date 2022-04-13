//= require vendor/jquery.datetimepicker.full

function setupDateTimePicker(container) {
  const defaults = {
    formatDate: 'y-m-d',
    format: 'Y-m-d H:i',
    allowBlank: true,
    defaultSelect: false,
    validateOnBlur: false
  }

  $(container).find('input.date-time-picker').each(function(index, entry) {
    $(entry).datetimepicker($.extend(defaults, $(entry).data('datepicker-options')));
  });
}

function initXdanDateTimePickerPlugin() {
  setupDateTimePicker($('body'));
  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    setupDateTimePicker(fieldset);
  });
}

$(document).ready(initXdanDateTimePickerPlugin);
$(document).on('turbolinks:load', initXdanDateTimePickerPlugin());
