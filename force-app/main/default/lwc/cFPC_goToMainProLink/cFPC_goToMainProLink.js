import { LightningElement } from 'lwc';
import getCurrentContact from "@salesforce/apex/CFPC_CommunityUserContactInfo.getCurrentuser";
import GOTOMAINPRO from '@salesforce/label/c.goToMainPro';
import GOTOMAINPROURL from '@salesforce/label/c.goToMainProURL';


export default class CFPC_goToMainProLink extends LightningElement {
    mainProFlag='';
   connectedCallback(){
      this.getContact();
    }
    label = {
        GOTOMAINPRO,
        GOTOMAINPROURL
    };
    redirectToMainPro(){
        window.open(GOTOMAINPROURL, '_blank');
    }

    getContact() {
        getCurrentContact().then(result => {
            //this.currentUser = result;
            if ( result != ''){
                if(result.Contact.CFPC_MainProFlag__c == true){
                   this.mainProFlag=true;
                }
           }
        })
        .catch(error => {
            console.log('Exception'+error);
        });
     }    
}