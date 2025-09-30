import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    remaining: Number
  }

  static targets = ["display", "form"]

  connect() {
    this.submitted = false
    this.remaining = Math.max(0, Math.floor(this.remainingValue || 0))
    this.updateDisplay()

    if (this.remaining <= 0) {
      this.expire()
    } else {
      this.timerId = setInterval(() => this.tick(), 1000)
    }
  }

  disconnect() {
    if (this.timerId) {
      clearInterval(this.timerId)
    }
  }

  tick() {
    this.remaining -= 1
    if (this.remaining <= 0) {
      this.remaining = 0
      this.updateDisplay()
      this.expire()
    } else {
      this.updateDisplay()
    }
  }

  updateDisplay() {
    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = `${this.remaining}s`
    }
  }

  expire() {
    if (this.submitted) return
    this.submitted = true
    if (this.timerId) clearInterval(this.timerId)
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    }
  }
}
