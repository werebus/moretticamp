# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  d = new Date( $('#calendar').data('date') )
  $('#calendar').fullCalendar
    theme: true,
    eventSources: [{
      url: '/events.json'
      color: '#061'},{
      url: '/seasons.json'
      color: '#666'
    }]
    year: d.getFullYear(),
    month: d.getMonth(),
    date: d.getDate(),
    buttonIcons: false,
    buttonText:
      today: 'Today'
    header:
      left: 'title'
      center: ''
      right: if $('#calendar').data('today') then 'today prev,next' else 'prev,next'
    viewRender: (view, element)->
      start_date = new Date( $('#calendar').data('start-date') )
      end_date = new Date( $('#calendar').data('end-date') )

      current_date_string = view.start.getMonth() + '/' + view.start.getYear()
      start_date_string = start_date.getMonth() + '/' + start_date.getYear()
      end_date_string = end_date.getMonth() + '/' + end_date.getYear()

      $('.fc-button-prev').toggleClass('ui-state-disabled', (current_date_string == start_date_string))
      $('.fc-button-next').toggleClass('ui-state-disabled', (current_date_string == end_date_string))

      if $('.fc-header-title h3').length == 0
        $('.fc-header-title').append('<h3></h3>')
      $('.fc-header-title h3').text( (view.start.getMonth()+1) + '/' + (view.start.getFullYear() + '').substring(2) )
