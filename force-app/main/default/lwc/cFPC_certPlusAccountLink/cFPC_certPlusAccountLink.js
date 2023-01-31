import { LightningElement } from 'lwc';
import getCurrentContact from "@salesforce/apex/CFPC_CommunityUserContactInfo.getCurrentuser";	
import CERTACC from '@salesforce/label/c.certAccount';
import CERTACCURL from '@salesforce/label/c.CERTAccURL';


export default class CFPC_certPlusAccountLink extends LightningElement {

certFlag= false;

label = {
    CERTACC,
    CERTACCURL
};
connectedCallback(){
    this.getContact();
}
redirectToCERT(){
        window.open(CERTACCURL, '_blank');
    }
getContact() {
    getCurrentContact().then(result => {
        //this.currentUser = result;
        if ( result != ''){
            if(result.Contact.CFPC_CERTAccountFlag__c == true){
               this.certFlag=true;
            }
       }
    })
    .catch(error => {
        console.log('Exception'+error);
    });
 }
}