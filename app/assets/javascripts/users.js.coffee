$(document).ready ->
  $('#token-button').click (event)->
    event.preventDefault()
    digits = "0123456789abcdef"
    s = ""
    for n in [1..32]
      rnum = Math.floor(Math.random() * digits.length)
      s += digits.substring(rnum, rnum+1)
    $('#user_calendar_access_token').val(s)
