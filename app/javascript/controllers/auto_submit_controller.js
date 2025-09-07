import { Controller } from "@hotwired/stimulus"

// Auto-submits a form when any input/select/checkbox changes, debounced
// Usage: data-controller="auto-submit" data-auto-submit-delay-value="500"
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 200 }
  }

  connect() {
    // Only attach if element is a FORM
    this.form = this.element.tagName === 'FORM' ? this.element : this.element.closest('form')
    if (!this.form) return

    this.boundTrigger = this.trigger.bind(this)
    // Listen to input and change events for responsiveness across input types
    this.form.addEventListener('input', this.boundTrigger)
    this.form.addEventListener('change', this.boundTrigger)

    this.timeout = null
    this.inFlightController = null
  }

  disconnect() {
    if (!this.form) return
    this.form.removeEventListener('input', this.boundTrigger)
    this.form.removeEventListener('change', this.boundTrigger)
    if (this.timeout) clearTimeout(this.timeout)
    if (this.inFlightController) this.inFlightController.abort()
  }

  trigger(event) {
    // Ignore submit button clicks; we'll handle auto-submission
    if (event && event.target && event.target.type === 'submit') return

    if (this.timeout) clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.submit(), this.delayValue)
  }

  submit() {
    if (!this.form) return

    // If it is a GET form (filters), prefer Turbo to visit with query string, preserving history
    const method = (this.form.getAttribute('method') || 'get').toLowerCase()

    // Build FormData -> query string
    const fd = new FormData(this.form)
    const params = new URLSearchParams()
    for (const [key, value] of fd.entries()) {
      // include empty string values as present to allow clearing
      params.append(key, value)
    }

    const action = this.form.getAttribute('action') || window.location.pathname
    const url = method === 'get' ? `${action}?${params.toString()}` : action

    if (method === 'get') {
      // Use Turbo if available; falls back to location
      if (window.Turbo && Turbo.visit) {
        Turbo.visit(url, { action: 'advance' })
      } else {
        window.location.assign(url)
      }
    } else {
      // For non-GET, submit via fetch with Turbo-Drive semantics
      if (this.inFlightController) this.inFlightController.abort()
      this.inFlightController = new AbortController()
      fetch(action, {
        method: this.form.method || 'POST',
        body: fd,
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        signal: this.inFlightController.signal
      }).finally(() => {
        this.inFlightController = null
      })
    }
  }
}
