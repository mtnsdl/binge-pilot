import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-reveal"
export default class extends Controller {
  connect() {
  }
  showNext(event) {
    event.preventDefault()
    console.log("Click");
    const active = document.querySelector(".active")
    active.classList.remove("active")
    active.nextElementSibling.classList.add("active")
  }
}
