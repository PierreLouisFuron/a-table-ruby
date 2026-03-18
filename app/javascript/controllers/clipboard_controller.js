import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {

  static targets = ["content", "button"]

  static values = {
    confirm: { type: String, default: 'Copied' },
    delayMs: { type: Number, default: 3000 }
  }

  copy() {
    const text = this.contentTarget.innerText
    const originalContent = this.buttonTarget.innerHTML
    const onSuccess = () => {
      this.buttonTarget.innerHTML = `<i class="fa fa-check"></i> ${this.confirmValue}`;
      setTimeout(() => {
        this.buttonTarget.innerHTML = originalContent;
      }, this.delayMsValue);
    }

    const fallbackCopy = () => {
      const textarea = document.createElement('textarea')
      textarea.value = text
      textarea.style.position = 'fixed'
      textarea.style.opacity = '0'
      this.element.appendChild(textarea)
      textarea.select()
      document.execCommand('copy')
      this.element.removeChild(textarea)
      onSuccess()
    }

    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(onSuccess).catch(() => {
        fallbackCopy()
      });
    } else {
      fallbackCopy()
    }
  }
}
