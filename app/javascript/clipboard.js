import { Tooltip } from './bootstrap'
import Clipboard from 'clipboard/src/clipboard'

window.addEventListener('turbo:load', () => {
  const clipboardButton = document.querySelector('button.clip')
  if (!clipboardButton) return

  const clipboard = new Clipboard(clipboardButton)

  clipboard.on('success', () => {
    const tip = new Tooltip(clipboardButton, { title: 'Copied!' })
    tip.show()
    setTimeout(() => { tip.dispose() }, 2000)
  })
})
