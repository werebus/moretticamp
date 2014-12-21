$(document).ready ->
  $('#token-button').click (event)->
    event.preventDefault()
    $('#user_calendar_access_token').val('')
