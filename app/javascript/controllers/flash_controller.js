import { Controller } from "@hotwired/stimulus"

// Handles animated toast-like appearance for flash messages.
export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.show()
    this.timeout = setTimeout(() => this.dismiss(), 6000)
  }

  disconnect() {
    this.clearTimeout()
  }

  close(event) {
    event?.preventDefault()
    this.dismiss()
  }

  show() {
    requestAnimationFrame(() => {
      this.containerTarget.classList.remove("translate-x-6", "opacity-0")
      this.containerTarget.classList.add("translate-x-0", "opacity-100")
    })
  }

  dismiss() {
    this.clearTimeout()
    this.containerTarget.classList.add("translate-x-6", "opacity-0")
    this.containerTarget.classList.remove("translate-x-0", "opacity-100")
    setTimeout(() => this.element.remove(), 300)
  }

  clearTimeout() {
    if (this.timeout) {
      window.clearTimeout(this.timeout)
      this.timeout = null
    }
  }
}
