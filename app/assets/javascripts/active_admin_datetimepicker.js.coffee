#= require jquery.xdan.datetimepicker.full

@setupDateTimePicker = (container) ->
  defaults = {
    formatDate: 'y-m-d',
    format: 'Y-m-d H:i',
    allowBlank: true,
    defaultSelect: false,
    validateOnBlur: false
  }

  entries = $(container).find('input.date-time-picker')
  entries.each (index, entry) ->
    options = $(entry).data 'datepicker-options'
    $(entry).datetimepicker $.extend(defaults, options)

@initXdanDateTimePickerPlugin = () ->
  setupDateTimePicker $('body')
  $(document).on 'has_many_add:after', '.has_many_container', (e, fieldset) ->
    setupDateTimePicker fieldset

$(document).ready ->
  initXdanDateTimePickerPlugin()

$(document).on 'turbolinks:load', ->
  initXdanDateTimePickerPlugin()
