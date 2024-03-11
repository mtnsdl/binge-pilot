// app/javascript/controllers/swipe_controller.js
import { Controller } from "@hotwired/stimulus"
import Hammer from "hammerjs"

export default class extends Controller {
  connect() {
    this.hammer = new Hammer(this.element);
    this.hammer.on("swipeleft", () => this.swipeLeft());
    this.hammer.on("swiperight", () => this.swipeRight());
  }

  swipeLeft() {
    // Logic for swipe left - setting liked to false
    this.submitForm(false);
  }

  swipeRight() {
    // Logic for swipe right - setting liked to true
    this.submitForm(true);
  }

  submitForm(liked) {
    // You can adjust the selector based on your actual form structure
    // Here, we assume there's a specific form or hidden input to update
    const form = liked ?
      document.querySelector("form[data-like='true']") :
      document.querySelector("form[data-like='false']");

    if (form) {
      // Update any necessary hidden fields if needed
      form.querySelector("input[name='liked']").value = liked;
      form.requestSubmit(); // This submits the form
    } else {
      console.error("Form not found");
    }
  }

  disconnect() {
    if (this.hammer) {
      this.hammer.destroy();
    }
  }
}
