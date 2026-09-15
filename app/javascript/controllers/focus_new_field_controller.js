import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect () {
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType !== Node.ELEMENT_NODE) return

          const field = node.querySelector('input[type="text"], textarea, select')
          if (field) field.focus()
        })
      })
    })

    this.observer.observe(this.element, { childList: true })
  }

  disconnect () {
    this.observer.disconnect()
  }
}
