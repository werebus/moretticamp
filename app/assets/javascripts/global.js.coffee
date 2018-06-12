$(document).ready ->
  $('.date-pick').fdatepicker
    format: "yyyy-mm-dd"

  clipboard_selector = '.button.clip'
  clipboard_button = $(clipboard_selector)
  clipboard = new ClipboardJS(clipboard_selector)
  clipboard.on 'success', ->
    $(clipboard_selector).attr('title', 'Copied!')
    tip = new Foundation.Tooltip(clipboard_button)
    tip.show()
    setTimeout ->
      tip._destroy()
      $(clipboard_selector).attr('title', null)
    , 2000

  $('.label-note').each (index,note)->
    $('label[for=' + note.getAttribute('data-for') + "]").append(note)
  $('label .label-note').removeClass('hide')
