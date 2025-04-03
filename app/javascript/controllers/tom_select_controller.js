import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = ["input"]
  static values = {
    url: String,
    placeholder: String
  }

  connect() {
    console.log("tom-select connected")

    this.tomSelect = new TomSelect(this.inputTarget, {
      valueField: 'id',
      labelField: 'email',
      searchField: 'email',
      load: (query, callback) => {
        const url = `${this.urlValue}?q=${encodeURIComponent(query)}`
        fetch(url)
          .then(response => response.json())
          .then(json => {
            callback(json)
          }).catch(() => {
            callback()
          })
      },
      placeholder: this.placeholderValue || "Search for users...",
      maxItems: null,
      create: false,
      render: {
        option: function(item, escape) {
          return `<div class="py-2 px-3">
            <div class="font-medium">${escape(item.email)}</div>
          </div>`
        }
      }
    })
  }

  disconnect() {
    if (this.tomSelect) {
      this.tomSelect.destroy()
    }
  }
}
