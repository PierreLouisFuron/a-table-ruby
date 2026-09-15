import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
    connect () {
        this.select = new TomSelect(this.element, {
            persist: false,
            createOnBlur: false,
            create: true,
            onItemAdd: function () {
                // drop any text still in the input so a half-typed tag is
                // never left behind (and never saved) after a selection
                this.setTextboxValue('')
                this.refreshOptions(false)
            },
            onBlur: function () {
                this.setTextboxValue('')
                this.refreshOptions(false)
            }
        })
    }

    disconnect () {
        this.select?.destroy()
    }
}
