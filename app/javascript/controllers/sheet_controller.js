import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "backdrop"]
  static values = { dismissible: Boolean };

  connect() {
    this.backdropTarget.addEventListener("click", () => this.dismissibleValue ? this.close() : true);
    this.element.sheetController = this;
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

    this.dismissibleValue = true;
  }
}
