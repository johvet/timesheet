class @EntryTicker
  constructor: (@entry_id, @active) ->
    @span$ = $(".ticker[data-id=#{@entry_id}]")
    if @span$.length
      if @active then @start_ticking() else @stop_ticking()

  start_ticking: () ->
    @seconds = @span$.data('current')
    setInterval =>
      @nextTick()
    , 1000

  nextTick: () ->
    @seconds += 1
    if @span$.hasClass('ticking')
      @span$.text("#{@to_time(@seconds)}")
    else
      clearInterval @current_timer

  stop_ticking: () ->
    clearInterval @current_timer

  to_time: () ->
    secs = @seconds % 60
    minutes = Math.floor(@seconds / 60) % 60
    hours = Math.floor(@seconds / 3600) % 24
    days = Math.floor(@seconds / 3600) / 24
    "#{@zero_pad(hours)}:#{@zero_pad(minutes)}:#{@zero_pad(secs)}"

  zero_pad: (val, digits = 2) ->
    result = val.toString()
    while result.length < digits
      result = '0' + result
    result

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

$('.ticker[data-id]').each ->
  new EntryTicker($(this).data('id'), $(this).hasClass('ticking'))