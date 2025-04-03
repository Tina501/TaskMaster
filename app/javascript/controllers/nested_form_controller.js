import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "links"]

  connect() {
    console.log("Nested form controller connected")
  }

  add(event) {
    event.preventDefault()
    console.log("Adding new subtask")
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.linksTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()
    console.log("Removing subtask")
    const wrapper = event.target.closest('.nested-fields')

    if (wrapper.dataset.newRecord === "true") {
      wrapper.remove()
    } else {
      wrapper.style.display = 'none'
      const destroyField = wrapper.querySelector("input[name*='_destroy']")
      if (destroyField) {
        destroyField.value = '1'
      }
    }
  }
}
