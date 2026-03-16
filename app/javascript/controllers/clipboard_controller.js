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
    navigator.clipboard.writeText(text)
      .then(() => {
        this.buttonTarget.innerHTML = `<i class="fa fa-check"></i> ${this.confirmValue}`;
        setTimeout(() => {
          this.buttonTarget.innerHTML = originalContent;
        }, this.delayMsValue);
      })
      .catch((error) => {
        console.error('Failed to copy text to clipboard:', error);
      });
  }
}
