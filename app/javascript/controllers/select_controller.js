import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
    connect () {
        this.sortable = new TomSelect(this.element,{
            persist: true,
            createOnBlur: true,
            duplicates: true,
            create: true,
        });
    }
}
