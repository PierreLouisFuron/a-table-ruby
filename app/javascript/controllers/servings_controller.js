import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="servings"
export default class extends Controller {
  static targets = ["count", "ingredient"]

  static values = {
    base: Number,
    current: Number
  }

  connect() {
    this.currentValue = this.baseValue
    this.updateDisplay()
  }

  increment() {
    this.currentValue++
    this.updateDisplay()
  }

  decrement() {
    if (this.currentValue > 1) {
      this.currentValue--
      this.updateDisplay()
    }
  }

  reset() {
    this.currentValue = this.baseValue
    this.updateDisplay()
  }

  updateDisplay() {
    if (this.hasCountTarget) {
      this.countTarget.textContent = this.currentValue
    }

    this.ingredientTargets.forEach((el) => {
      const baseQuantity = parseFloat(el.dataset.quantity)
      const unit = el.dataset.unit || ""
      const name = el.dataset.name
      const optional = el.dataset.optional === "true"

      let text
      if (isNaN(baseQuantity)) {
        text = unit ? `${name} : ${unit}` : name
      } else {
        const scaled = baseQuantity * (this.currentValue / this.baseValue)
        const display = Number.isInteger(scaled) ? scaled : parseFloat(scaled.toFixed(2))
        text = unit ? `${name} : ${display} ${unit}` : `${name} : ${display}`
      }

      el.textContent = optional ? `( ${text} )` : text
    })
  }
}
