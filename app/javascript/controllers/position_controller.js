import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
    static values = {
        draggable: String,
        handle: String,
        field: String
    }

    connect () {
        const options = { animation: 150 }

        // Without these the add-button and every child become draggable too.
        if (this.hasDraggableValue) options.draggable = this.draggableValue
        if (this.hasHandleValue) options.handle = this.handleValue

        if (this.hasFieldValue) {
            options.onEnd = () => this.renumber()

            // The DOM order is the source of truth, so take it at submit time:
            // that covers rows cocoon appended and drags onEnd may have missed.
            // Turbo reads the form on a bubbling document listener, which runs
            // after this one, so it serialises the values written here.
            this.form = this.element.closest("form")
            if (this.form) this.form.addEventListener("submit", this.renumber)
        }

        this.sortable = Sortable.create(this.element, options)
    }

    disconnect () {
        if (this.form) this.form.removeEventListener("submit", this.renumber)
        if (this.sortable) this.sortable.destroy()
    }

    // Rows cocoon soft-deletes stay in the DOM but hidden; skipping them leaves
    // gaps, which the model closes when it compacts positions on save.
    renumber = () => {
        this.rows.forEach((row, index) => {
            const field = row.querySelector(this.fieldValue)
            if (field) field.value = index
        })
    }

    get rows () {
        const selector = this.hasDraggableValue ? this.draggableValue : ":scope > *"
        return Array.from(this.element.querySelectorAll(selector))
                    .filter((row) => row.offsetParent !== null)
    }
}
