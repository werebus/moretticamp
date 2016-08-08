# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#calendar').fullCalendar
    theme: true,
    eventSources: [{
      url: '/events.json'
      color: '#061'
      error: (e)->
        if e.status == 401 then window.location.reload(false)
      },{
      url: '/seasons.json'
      color: '#666'
    }]
    defaultDate: moment( $('#calendar').data('date') ),
    buttonIcons: false,
    buttonText:
      today: 'Today'
      prev: '<'
      next: '>'
    header:
      left: 'title'
      center: ''
      right: if $('#calendar').data('today') then 'today prev,next' else 'prev,next'

    eventMouseover: (event, jsEvent, view)->
      unless (event.description == '' || event.description == null || event.description == undefined)
        $(this).append(
          '<div class="event-hover" id="eh-' + event.id + '">' + event.description + '</div>')
        $('#eh-' + event.id).fadeIn('fast').css
          top: $(this).height() + 15
          'max-width': $('td.fc-day').width() * 3
        if $(this).position().left < $('#calendar').width() / 2
          $('#eh-' + event.id).css('left', 15)
        else
          $('#eh-' + event.id).css('right', 15)
    eventMouseout: (event, jsEvent, view)->
      $('#eh-' + event.id).fadeOut('fast', ->
        $(this).remove())

    viewRender: (view, element)->
      start_date = moment( $('#calendar').data('start-date') )
      end_date = moment( $('#calendar').data('end-date') )

      current_date_string = view.intervalStart.format('YYYY-MM')
      start_date_string = start_date.format('YYYY-MM')
      end_date_string = end_date.format('YYYY-MM')

      $('.fc-prev-button').toggleClass('ui-state-disabled', (current_date_string == start_date_string))
      $('.fc-next-button').toggleClass('ui-state-disabled', (current_date_string == end_date_string))

      if $('.fc-toolbar .fc-left h3').length == 0
        $('.fc-toolbar .fc-left').append('<h3></h3>')
      $('.fc-toolbar .fc-left h3').text( view.intervalStart.format('M/YY') )
