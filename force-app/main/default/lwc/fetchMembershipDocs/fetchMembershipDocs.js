import { LightningElement,wire } from 'lwc';
import getContentDocuments from '@salesforce/apex/getAllContentDocs.getContentDocuments';
import welcomeText1 from '@salesforce/label/c.MembershipdocsPage';
import welcomeText2 from '@salesforce/label/c.MembershipdocsPage2';
import chapterdocuments from '@salesforce/label/c.Chapterdocuments';

export default class FetchMembershipDocs extends LightningElement {
    recordUrl=[];
    error;
    welcomeText;
    chapterdocs =[];
    recordData=[];
    label = {
        welcomeText1,
        welcomeText2,
        chapterdocuments
    };
    @wire(getContentDocuments)
    wiredAccount({ error, data }) {
        if (data) {
            this.recordData=data;
            this.seperateChapterDocs(data);
            this.error = undefined;
        } else if (error) {
            console.log('failure'+JSON.stringify(error));
            this.error = error;
        }  
    }
    seperateChapterDocs(data){
        data.forEach(doc => {
            if(doc.chapDesc &&(doc.chapDesc === 'en' || doc.chapDesc === 'FR')){
                this.chapterdocs.push(doc);
    
        }
        this.recordUrl = data.filter(m => {
            return (!m.chapDesc && (m.chapDesc != 'en' || m.chapDesc != 'FR'));
          });
        });
    }
}