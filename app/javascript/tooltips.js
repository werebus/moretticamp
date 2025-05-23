import { Tooltip } from './bootstrap'

window.addEventListener('turbo:load', () => {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  tooltipTriggerList.forEach(tooltipTriggerEl => new Tooltip(tooltipTriggerEl))
})
