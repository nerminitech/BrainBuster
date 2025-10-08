import { Controller } from "@hotwired/stimulus"

// Ermoeglicht per Klick das Kopieren eines Textes in die Zwischenablage.
export default class extends Controller {
  static targets = ["feedback"]
  static values = {
    text: String,
    noticeDuration: { type: Number, default: 2000 }
  }

  copy(event) {
    event.preventDefault()
    const textToCopy = this.textValue || event.currentTarget?.dataset?.clipboardText
    if (!textToCopy) return

    navigator.clipboard
      .writeText(textToCopy)
      .then(() => this.showFeedback("Code kopiert!"))
      .catch(() => this.showFeedback("Konnte nicht kopiert werden", true))
  }

  showFeedback(message, isError = false) {
    if (!this.hasFeedbackTarget) return

    this.feedbackTarget.textContent = message
    this.feedbackTarget.classList.remove("hidden")
    if (isError) {
      this.feedbackTarget.classList.add("text-rose-300")
    } else {
      this.feedbackTarget.classList.remove("text-rose-300")
    }

    clearTimeout(this.hideTimer)
    this.hideTimer = setTimeout(() => {
      this.feedbackTarget.classList.add("hidden")
    }, this.noticeDurationValue)
  }
}
