import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    remaining: Number,
    deadline: Number,
    serverTime: Number
  }

  static targets = ["display", "form"]

  connect() {
    this.submitted = false
    this.offset = this.hasServerTimeValue ? this.serverTimeValue - Date.now() : 0
    this.remaining = 0
    this.syncRemainingFromDeadline()

    if (this.remaining <= 0) {
      this.expire()
    } else {
      this.startTimer()
    }
  }

  disconnect() {
    this.stopTimer()
  }

  tick() {
    this.syncRemainingFromDeadline()
    if (this.remaining <= 0) {
      this.expire()
    }
  }

  updateDisplay() {
    if (this.hasDisplayTarget) {
      const seconds = Number.isFinite(this.remaining) ? Math.max(0, Math.floor(this.remaining)) : 0
      this.displayTarget.textContent = `${seconds}s`
    }
  }

  expire() {
    if (this.submitted) return
    this.submitted = true
    this.stopTimer()
    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    }
  }

  startTimer() {
    this.stopTimer()
    this.timerId = setInterval(() => this.tick(), 250)
  }

  stopTimer() {
    if (this.timerId) {
      clearInterval(this.timerId)
      this.timerId = null
    }
  }

  syncRemainingFromDeadline() {
    const nowMs = Date.now() + this.offset

    if (this.hasDeadlineValue && this.deadlineValue > 0) {
      const diffMs = this.deadlineValue - nowMs
      this.remaining = Math.max(0, Math.ceil(diffMs / 1000))
    } else if (this.hasRemainingValue) {
      this.remaining = Math.max(0, Math.floor(this.remainingValue))
    } else {
      this.remaining = 0
    }

    this.updateDisplay()
  }
}
