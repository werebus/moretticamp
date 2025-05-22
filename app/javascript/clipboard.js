import { Tooltip } from './bootstrap'
import Clipboard from 'clipboard/src/clipboard'

window.addEventListener('turbo:load', () => {
  const clipboard_button = document.querySelector('button.clip')
  if (!clipboard_button) return

  const clipboard = new Clipboard(clipboard_button)

  clipboard.on('success', () => {
    const tip = new Tooltip(clipboard_button, { title: 'Copied!' })
    tip.show()
    setTimeout(() => { tip.dispose() }, 2000)
  })
})
