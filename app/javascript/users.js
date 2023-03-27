import $ from 'jquery';

$(document).ready(() =>
  $('#token-button').click(function(event){
    event.preventDefault();
    $('#user_calendar_access_token').val('');
  })
);
