import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "switch"]

  connect() {
    this.applyTheme()
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.mediaQuery.addEventListener("change", this.handleSystemChange)
  }

  disconnect() {
    this.mediaQuery.removeEventListener("change", this.handleSystemChange)
  }

  handleSystemChange = () => {
    if (!localStorage.getItem("theme")) {
      this.applyTheme()
    }
  }

  toggle() {
    const next = this.hasSwitchTarget && this.switchTarget.checked ? "dark" : "light"
    localStorage.setItem("theme", next)
    this.setTheme(next)
  }

  applyTheme() {
    const stored = localStorage.getItem("theme")
    if (stored) {
      this.setTheme(stored)
    } else {
      const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      this.setTheme(prefersDark ? "dark" : "light")
    }
  }

  setTheme(theme) {
    document.documentElement.setAttribute("data-bs-theme", theme)
    // this.updateSwitch(theme)
  }

  switchTargetConnected(element) {
    const theme = document.documentElement.getAttribute("data-bs-theme") || "light"
    element.checked = theme === "dark"
  }

  // updateSwitch(theme) {
  //   if (this.hasSwitchTarget) {
  //     this.switchTarget.checked = theme === "dark"
  //   }
  // }
}
