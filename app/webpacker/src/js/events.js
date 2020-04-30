var moment = require('moment');

$(document).ready(function() {
  const caldate = function() {
    const date = Number(window.location.hash.slice(1)) ||
      $('#calendar').data('date');
    return moment( date );
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

    eventRender(event, element){
      if (event.description) {
        var tip = new Foundation.Tooltip(element, {
          tipText: event.description
        });
      }
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
