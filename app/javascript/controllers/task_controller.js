import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleSubTaskForm(event) {
    event.preventDefault()
    const form = document.getElementById("new_sub_task_form")
    form.classList.toggle("hidden")
  }
}
