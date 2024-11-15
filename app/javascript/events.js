import { Calendar, formatDate } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import $ from 'jquery';

$(document).ready(function() {
  const caldate = function() {
    const date = Number(window.location.hash.slice(1)) ||
      $('#calendar').data('date') * 1000;
    return new Date(date);
  };
  const updateTitleFormat = function(cal) {
    if (Foundation.MediaQuery.is('medium')) {
      cal.changeView('desktopDayGridMonth');
    } else {
      cal.changeView('dayGridMonth');
    }
  };


  const calEl = document.getElementById('calendar')
  if(calEl) {
    const calendar = new Calendar(calEl, {
      plugins: [ dayGridPlugin ],
      eventSources: [
        {
          url: '/events.json',
          className: 'event-event',
          error(e){
            if (e.status === 401) { window.location.reload(false); }
          }
        },{
          url: '/seasons.json',
          className: 'season-event'
        }
      ],
      initialDate: caldate(),
      validRange: {
        start: new Date( $('#calendar').data('start-date') * 1000),
        end: new Date( $('#calendar').data('end-date') * 1000)
      },
      buttonIcons: false,
      buttonText: { today: 'Today', prev: null, next: null },
      views: {
        dayGridMonth: {
          titleFormat: { month: 'numeric', year: '2-digit' }
        },
        desktopDayGridMonth: {
          type: 'dayGridMonth',
          titleFormat: { month: 'long', year: 'numeric' }
        }
      },

      eventDidMount: function(info) {
        const desc = info.event.extendedProps.description

        if (desc) {
          var tip = new Foundation.Tooltip($(info.el), { tipText: desc });
        }
      },

      windowResize: function() { updateTitleFormat(this) }
    });

    updateTitleFormat(calendar);
    calendar.render();
  }
});
