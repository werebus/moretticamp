import { Tooltip } from 'bootstrap';
import Clipboard from 'clipboard/src/clipboard';
import $ from 'jquery';

$(function() {
  const clipboard_selector = 'button.clip';
  const clipboard_button = document.querySelector(clipboard_selector);
  const clipboard = new Clipboard(clipboard_selector);

  clipboard.on('success', function() {
    $(clipboard_selector).attr('title', 'Copied!');
    const tip = new Tooltip(clipboard_button);
    tip.show();
    setTimeout(function() {
      tip.dispose();
      $(clipboard_selector).attr('title', null);
    }
    , 2000);
  });
});
