import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "backdrop"]

  connect() {
    this.backdropTarget.addEventListener("click", () => this.close());
  }

  open() {
    this.backdropTarget.classList.remove("hidden");
    this.panelTarget.classList.remove("hidden");

    this.panelTarget.offsetHeight;

    requestAnimationFrame(() =>
      this.panelTarget.classList.add("open")
    );

    this.backdropTarget.classList.add("show");
  }

  close() {
    this.panelTarget.classList.remove("open");
    this.backdropTarget.classList.remove("show");

    setTimeout(() => {
      this.panelTarget.classList.add("hidden");
      this.backdropTarget.classList.add("hidden");
    }, 250);
  }
}
