# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class EntryDateChanger
  constructor: ->
    @callback = $('#datepicker').data('url')
    @picker$ = $('#datepicker').datepicker
      dateFormat: 'yy-m-d'
      defaultDate: $('#datepicker').data('current')
      showWeek: true
      showButtonPanel: true
      onSelect: =>
        window.location.href = "#{@callback}?date=#{@picker$.val()}"

    $('#new-entry').bind 'click', (event) =>
      href = $(event.target).attr('href')
      $(event.target).attr('href', "#{href}?when=#{@picker$.val()}")

if gon.controller == 'entries'
  new EntryDateChanger()