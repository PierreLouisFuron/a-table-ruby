import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
    connect () {
        this.sortable = new TomSelect(this.element,{
            persist: false,
            createOnBlur: true,
            // create: true
            create: function(input){
                return {value:input,text:input}
            }
        });
    }
}
