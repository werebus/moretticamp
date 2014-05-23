$(document).ready ->
  $('.date-pick').fdatepicker
    format: "yyyy-mm-dd"
  $('.label-note').each (index,note)->
    $('label[for=' + note.getAttribute('data-for') + "]").append(note)
  $('label .label-note').removeClass('hide')
