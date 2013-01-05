# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if gon.controller == 'reports'
    form$ = $('form#filter')
    if form$.length
      $('.filter').bind 'change', (event) ->
        res$ = $('#search-results').empty()
        new Spinner().spin(res$[0])
        form$.submit()

    $('#filter_period').val('last_week')
    form$.submit()

    $('a.pdf-download', form$).on 'click', (event) =>
      event.preventDefault()

      # $('#download-form').remove()
      # add = "<form id='download-form' action='#{form$.attr('action')}.pdf' method='get' target='_blank'>"
      # $('body').append(add)
      $('#download-form fieldset').empty()
      for node in $('.filter')
        name = $(node).attr('name')
        value = $(node).val()
        $('#download-form fieldset').append("<input type='hidden' name='#{name}' value='#{value}'>") if value.length

      $('#download-form').submit()
      console.log "Done!"
