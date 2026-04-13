import { Controller } from "@hotwired/stimulus"

// Displays a shimmer placeholder until the image finishes loading,
// then fades the image in smoothly.
//
// Usage:
//   <div data-controller="lazy-image" class="lazy-image">
//     <img src="..." loading="lazy" data-lazy-image-target="img" data-action="load->lazy-image#reveal">
//   </div>

export default class extends Controller {
  static targets = ["img"]

  connect() {
    this.imgTargets.forEach((img) => {
      if (img.complete && img.naturalWidth > 0) {
        this.#show(img)
      }
    })
  }

  reveal(event) {
    this.#show(event.target)
  }

  #show(img) {
    img.classList.add("lazy-image--loaded")
    const wrapper = img.closest(".lazy-image")
    if (wrapper) wrapper.classList.add("lazy-image--ready")
  }
}
