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

    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(onSuccess).catch((error) => {
        console.error('Failed to copy text to clipboard:', error);
      });
    } else {
      // fallback method for when the app is used in a non https or localhost environment
      const textarea = document.createElement('textarea')
      textarea.value = text
      textarea.style.position = 'fixed'
      textarea.style.opacity = '0'
      document.body.appendChild(textarea)
      textarea.select()
      document.execCommand('copy')
      document.body.removeChild(textarea)
      onSuccess()
    }
  }
}
