import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = ["input", "template", "links"]
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
      render: {
        option: function(item, escape) {
          return `<div class="py-2 px-3">
            <div class="font-medium">${escape(item.email)}</div>
          </div>`
        }
      }
    })

    this.tomSelect.on('item_add', (value) => {
      this.templateTarget.content.querySelector('input').value = value
      const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
      this.linksTarget.insertAdjacentHTML('beforeend', content)
    })
  }

  disconnect() {
    if (this.tomSelect) {
      this.tomSelect.destroy()
    }
  }
}
