import { LightningElement,api } from 'lwc';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
} from 'lightning/flowSupport';

export default class CfpcPaymentPage extends LightningElement {

    value = 'MasterCard';
    cdcNumber;
    @api totalamount;
    @api availableActions = [];
    cardAddressflag=true;
    cardAddress='2630 Skymark Ave Mississauga, ON L4W 5A4 CANADA';

    get options() {
        return [
            { label: 'MasterCard', value: 'MasterCard' },
            { label: 'AMEX', value: 'AMEX' },
            { label: 'VISA', value: 'VISA' },
        ];
    }
    checkCDC(event){

      let cdcVal = event.target.value;
      if(cdcVal){
      this.cdcNumber = cdcVal[0]+cdcVal[1]+'/'+cdcVal[2]+cdcVal[3];
      console.log('this.cdcNumber'+this.cdcNumber);
    }
    }
    handleNextClick(){
        if (this.availableActions.find((action) => action === 'NEXT')) {
          const navigateNextEvent = new FlowNavigationNextEvent();
          this.dispatchEvent(navigateNextEvent);
        }
    }
    handlechangeAddress(event){
        this.cardAddressflag = false;
    }
    handleCCInput(event){
        let re;
        let data=event.target.value;
        console.log('value'+data);
        /*const digit = String.fromCharCode(event.which);
        console.log('digit'+digit);
        if (!/^\d+$/.test(digit)) {
            console.log('entered to exit');
            return;
        }
        const { target } = event;
        const value = QJ.val(target);
        const { length } = value.replace(/\D/g, "") + digit;*/
        var specials=/^([a-zA-Z _-]+)$/;
        if (specials.test(data)){
           
            return;
        }else{
        re = /(\d{4}(?!\s))$/;
        let i;
            
        if (re.test(data)) {
          event.preventDefault();
          let input = this.template.querySelectorAll('[data-id="cardnumber"]')
            console.log('checkboxes'+input);
            for(i=0; i<input.length; i++) {
                console.log('checkboxes'+input[i].value);
                input[i].value += ' ';
                console.log('checkboxes'+input[i].value);
            }
        }
    
    }

    }
}