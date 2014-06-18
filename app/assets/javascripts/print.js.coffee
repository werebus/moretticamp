beforePrint = ->
  $('#calendar').fullCalendar('option', 'aspectRatio', 1.55)
afterPrint = ->
  $('#calendar').fullCalendar('option', 'aspectRatio', 1.35)

if window.matchMedia
  mediaQueryList = window.matchMedia('print')
  mediaQueryList.addListener (mql)->
    if mql.matches then beforePrint() else afterPrint()

window.onbeforeprint = beforePrint
window.onafterprint = afterPrint
