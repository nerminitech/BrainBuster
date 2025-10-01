import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  toggle(event) {
    if (!event.target.checked) return

    this.checkboxTargets.forEach((checkbox) => {
      if (checkbox === event.target) return
      checkbox.checked = false
    })
  }
}
