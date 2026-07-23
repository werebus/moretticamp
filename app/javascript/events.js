import { Calendar } from 'fullcalendar'
import dayGridPlugin from 'fullcalendar/daygrid'
import themePlugin from '@fullcalendar/bootstrap5'
import { Tooltip } from './bootstrap'
import 'long-press-event'

window.addEventListener('turbo:load', () => {
  const calEl = document.getElementById('calendar')
  if (!calEl) {
    return
  }

  const calendar = new Calendar(calEl, {
    plugins: [themePlugin, dayGridPlugin],
    headerToolbar: {
      start: 'title',
      end: 'today prev,next'
    },
    eventSources: [
      '/events.json',
      '/seasons.json'
    ],
    eventSourceFailure (e) {
      if (e.response.status === 401) { window.location.reload(false) }
    },
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
        const tip = new Tooltip(info.el, { title: desc, container: calEl })
        window.addEventListener('turbo:before-cache', () => {
          if (tip.tip) { tip.dispose() }
        })

        info.el.addEventListener('long-press', function (e) {
          e.target.focus()
        })
      }
    }
  })

  const resizeObserver = new ResizeObserver((entries) => {
    for (const entry of entries) {
      if (entry.borderBoxSize) {
        const bsSmall = window.getComputedStyle(document.documentElement).getPropertyValue('--bs-breakpoint-sm')
        const borderBoxSize = entry.contentBoxSize[0]
        if (borderBoxSize.inlineSize < parseInt(bsSmall)) {
          calendar.changeView('dayGridMonth')
        } else {
          calendar.changeView('desktopDayGridMonth')
        }
      }
    }
  })
  resizeObserver.observe(calEl)

  calendar.render()
})
