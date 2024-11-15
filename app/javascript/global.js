import { Tooltip } from 'bootstrap';
import $ from 'jquery';

const ClipboardJS = require('clipboard');

$(document).ready(function() {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new Tooltip(tooltipTriggerEl));

  const clipboard_selector = 'button.clip';
  const clipboard_button = document.querySelector(clipboard_selector);
  const clipboard = new ClipboardJS(clipboard_selector);

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
