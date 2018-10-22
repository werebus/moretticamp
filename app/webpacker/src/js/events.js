var moment = require('moment');

$(document).ready(function() {
  const caldate = function() {
    const date = Number(window.location.hash.slice(1)) ||
      $('#calendar').data('date');
    return moment( date ).add(1, 'day');
  };

  $('#calendar').fullCalendar({
    height: 'auto',
    theme: true,
    eventSources: [{
      url: '/events.json',
      className: 'event-event',
      error(e){
        if (e.status === 401) { window.location.reload(false); }
      }
      },{
      url: '/seasons.json',
      className: 'season-event'
    }],
    defaultDate: caldate(),
    validRange: {
      start: moment( $('#calendar').data('start-date')),
      end: moment( $('#calendar').data('end-date'))
    },
    buttonIcons: false,
    buttonText: {
      today: 'Today'
    },

    eventMouseover(event, jsEvent, view){
      if (event.description) {
        $(this).append(
          `<div class="event-hover" id="eh-${event.id}">${event.description}</div>`);
        $(`#eh-${event.id}`).fadeIn('fast').css({
          top: $(this).height() + 15,
          'max-width': $('td.fc-day').width() * 3
        });
        if ($(this).position().left < ($('#calendar').width() / 2)) {
          $(`#eh-${event.id}`).css('left', 15);
        } else {
          $(`#eh-${event.id}`).css('right', 15);
        }
      }
    },
    eventMouseout(event, jsEvent, view){
      $(`#eh-${event.id}`).fadeOut('fast', function() {
        $(this).remove();
    });
    },

    viewRender(view, element){
      const current_date = view.intervalStart;
      const start_date = moment( $('#calendar').data('start-date') );
      const end_date = moment( $('#calendar').data('end-date') );

      if ($('.fc-toolbar .fc-left h3').length === 0) {
        $('.fc-toolbar .fc-left').append('<h3></h3>');
      }
      $('.fc-toolbar .fc-left h3').text( current_date.format('M/YY') );
    },

    viewDestroy(view, element){
      const current_date = view.intervalStart;
      history.replaceState({date: current_date},
        `Events, ${current_date.format('MMMM YYYY')}`,
        `#${current_date}`);
    }
  });

  window.onpopstate = function(event){
    if (event.state.date) {
      $('#calendar').fullCalendar('gotoDate', event.state.date);
    }
  };
});
