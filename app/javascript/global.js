import $ from 'jquery';

const ClipboardJS = require('clipboard');

$(document).ready(function() {
  flatpickr('.date-pick', {});

  const clipboard_selector = '.button.clip';
  const clipboard_button = $(clipboard_selector);
  const clipboard = new ClipboardJS(clipboard_selector);
  clipboard.on('success', function() {
    $(clipboard_selector).attr('title', 'Copied!');
    const tip = new Foundation.Tooltip(clipboard_button);
    tip.show();
    setTimeout(function() {
      tip._destroy();
      $(clipboard_selector).attr('title', null);
    }
    , 2000);
  });
});
