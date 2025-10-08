import { Controller } from "@hotwired/stimulus"

// Steuert den Victory-Screen: wartet auf andere Spieler und blendet bei Abschluss das Ergebnis ein.
export default class extends Controller {
  static targets = ["waiting", "victory", "defeat", "progress", "winnerName"]
  static values = {
    url: String,
    user: Number,
    pollInterval: { type: Number, default: 5000 },
    initialState: String
  }

  connect() {
    if (!this.hasUrlValue) return

    if (this.initialStateValue === "completed") {
      this.fetchStatus()
      return
    }

    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    if (this.timer) return
    this.timer = setInterval(() => this.fetchStatus(), this.pollIntervalValue)
  }

  stopPolling() {
    if (!this.timer) return
    clearInterval(this.timer)
    this.timer = null
  }

  fetchStatus() {
    fetch(this.urlValue, { headers: { Accept: "application/json" } })
      .then((response) => (response.ok ? response.json() : Promise.reject()))
      .then((data) => this.handleStatus(data))
      .catch(() => {})
  }

  handleStatus(data) {
    if (this.hasProgressTarget) {
      this.progressTarget.textContent = `${data.finished_participations}/${data.total_participations}`
    }

    if (!data.completed) return

    this.stopPolling()
    this.waitingTargets.forEach((element) => element.classList.add("hidden"))

    const isWinner = this.hasUserValue && data.winner_id === this.userValue

    if (isWinner && this.hasVictoryTarget) {
      this.victoryTargets.forEach((element) => element.classList.remove("hidden"))
      return
    }

    if (this.hasDefeatTarget) {
      this.defeatTargets.forEach((element) => element.classList.remove("hidden"))
      if (this.hasWinnerNameTarget && data.winner_name) {
        this.winnerNameTargets.forEach((element) => {
          element.textContent = data.winner_name
        })
      }
    }
  }
}
