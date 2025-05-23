import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import bootstrap5Plugin from '@fullcalendar/bootstrap5'
import { Tooltip } from './bootstrap'

window.addEventListener('turbo:load', () => {
  const calEl = document.getElementById('calendar')
  if (!calEl) {
    return
  }

  const updateTitleFormat = function (cal) {
    const bsMedium = window.getComputedStyle(document.documentElement).getPropertyValue('--bs-breakpoint-md')
    if (window.matchMedia('(min-width: ' + bsMedium + ')').matches) {
      cal.changeView('desktopDayGridMonth')
    } else {
      cal.changeView('dayGridMonth')
    }
  }

  const calendar = new Calendar(calEl, {
    plugins: [dayGridPlugin, bootstrap5Plugin],
    themeSystem: 'bootstrap5',
    buttonIcons: {
      prev: 'fa fa-solid fa-chevron-left',
      next: 'fa fa-solid fa-chevron-right'
    },
    eventSources: [
      {
        url: '/events.json',
        error (e) {
          if (e.status === 401) { window.location.reload(false) }
        }
      }, {
        url: '/seasons.json'
      }
    ],
    datesSet: function (dateInfo) {
      localStorage.setItem('eventCalendarCurrentDate', dateInfo.view.currentStart.toISOString())
    },
    initialDate: localStorage.getItem('eventCalendarCurrentDate') !== null
      ? localStorage.getItem('eventCalendarCurrentDate')
      : new Date(),
    validRange: {
      start: calEl.dataset.startDate,
      end: calEl.dataset.endDate
    },
    views: {
      dayGridMonth: {
        titleFormat: { month: 'numeric', year: '2-digit' }
      },
      desktopDayGridMonth: {
        type: 'dayGridMonth',
        titleFormat: { month: 'long', year: 'numeric' }
      }
    },
    eventDidMount: function (info) {
      const desc = info.event.extendedProps.description

      if (desc) {
        // eslint-disable-next-line no-new
        new Tooltip(info.el, { title: desc })
      }
    },

    windowResize: function () { updateTitleFormat(this) }
  })

  updateTitleFormat(calendar)
  calendar.render()
})
