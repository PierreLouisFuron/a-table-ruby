import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

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
    const current = document.documentElement.getAttribute("data-bs-theme") || "light"
    const next = current === "dark" ? "light" : "dark"
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
    this.updateIcon(theme)
  }

  updateIcon(theme) {
    if (this.hasIconTarget) {
      this.iconTarget.className = theme === "dark" ? "fa fa-sun" : "fa fa-moon"
    }
  }
}
