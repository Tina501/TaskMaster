import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove(event) {
    event.preventDefault()

    const inputs = document.querySelectorAll("[data-tom-select-target='links'] input")

    inputs.forEach(input => {
      if (input.value === event.currentTarget.dataset.userId) {
        input.nextElementSibling.value = true
      }
    })

    event.currentTarget.parentElement.remove()
  }
}
