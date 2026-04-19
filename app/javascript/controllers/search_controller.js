import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.search = this.debounce(this.search.bind(this), 300)
  }

  search() { this.element.requestSubmit() }
  submit() { this.element.requestSubmit() }

  debounce(fn, wait) {
    let t
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), wait) }
  }
}
