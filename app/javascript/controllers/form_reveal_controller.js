import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-reveal"
export default class extends Controller {
  static targets = ["input", "submit", "back", "next"]


  connect() {
    this.activeIndex = 0
  }
  showNext(event) {
    event.preventDefault()
    const active = this.inputTargets[this.activeIndex]


    active?.classList?.remove("active")
    this.activeIndex += 1
    const inactive = this.inputTargets[this.activeIndex]
    inactive?.classList?.add("active")
    console.log(this.activeIndex, this.inputTargets.length)

    if (this.activeIndex + 1 >= this.inputTargets.length) {
      this.submitTarget.classList.remove("d-none")
      this.nextTarget.classList.add("d-none")
    } else {
      this.submitTarget.classList.add("d-none")
      this.backTarget.classList.remove("d-none")
      console.log("sausage");
    }
  }

  showPrevious(event) {
    event.preventDefault()
    const active = this.inputTargets[this.activeIndex]

    active?.classList?.remove("active")
    this.activeIndex -= 1
    const inactive = this.inputTargets[this.activeIndex]
    inactive?.classList?.add("active")
    console.log(this.activeIndex, this.inputTargets.length)

    if (this.activeIndex + 1 > this.inputTargets.length) {
      this.submitTarget.classList.remove("d-none")
    } else if (this.activeIndex == 0) {
      this.backTarget.classList.add("d-none")
    } else {
      this.submitTarget.classList.add("d-none")
      this.nextTarget.classList.remove("d-none")
    }
  }
}
