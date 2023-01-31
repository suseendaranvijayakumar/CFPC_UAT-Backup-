import { LightningElement,wire,track } from 'lwc';
import { CurrentPageReference } from "lightning/navigation";
import LightningAlert from "lightning/alert";
import cacValidation from "@salesforce/apex/RedirectionLinksHelper.cacValidation";
import aegValidation from "@salesforce/apex/RedirectionLinksHelper.aegValidation";
import fmValidation from "@salesforce/apex/RedirectionLinksHelper.fmValidation";
import emValidation from "@salesforce/apex/RedirectionLinksHelper.emValidation";
import exValidation from "@salesforce/apex/RedirectionLinksHelper.exValidation";
import openWaterNavURLs from "@salesforce/apex/RedirectionLinksHelper.openWaterNavURLs";
import FELLOWSHIP from '@salesforce/contentAssetUrl/Fellowship';
import CERTIFICATION from '@salesforce/contentAssetUrl/Certifications';
import EXAMINATION from '@salesforce/contentAssetUrl/Examination';
import COMPETENCE from '@salesforce/contentAssetUrl/Competence';
import EXAMINER from '@salesforce/contentAssetUrl/Examiner';
import OWFELLOWSHIP from '@salesforce/label/c.OW_Fellowship';
import FM from '@salesforce/label/c.OW_FM';
import EM from '@salesforce/label/c.OW_EM';
import CAC from '@salesforce/label/c.OW_CAC';
import ASEXAMINER from '@salesforce/label/c.OW_As_an_Examiner';



//import CreateDebug from "@salesforce/apex/RedirectionLinksHelper.CreateDebugLog";

export default class RedirectionLinks extends LightningElement {
messagestr = '';
Fellowship = FELLOWSHIP;
Certifications = CERTIFICATION;
Examination = EXAMINATION;
Competence = COMPETENCE;
Examiner=EXAMINER;
@track urlValueforAEG=false;
@track isLoaded = false;
OWURL = {
    CAC:'', FM:'', EM:'', AEG:'', Examiner:'', Fellowship:''
}

label = {
    OWFELLOWSHIP,
    FM,
    EM,
    CAC,
    ASEXAMINER
};

@wire(openWaterNavURLs)
    wiredContacts({ error, data }) {
        if (data) {
            if(data.CAC)
               this.OWURL.CAC = data.CAC;
            if(data.Examiner)
               this.OWURL.Examiner = data.Examiner;
            if(data.EM)
               this.OWURL.EM = data.EM;
            if(data.AEG)
               this.OWURL.AEG = data.AEG;
               if(this.urlValueforAEG)
                 this.redirectToAEG();
            if(data.FM)
               this.OWURL.FM = data.FM;
            if(data.Fellowship)
               this.OWURL.Fellowship = data.Fellowship;
        } else if (error) {
            console.log('error while fetching Open Water custom metadata');
        }
    }

@wire(CurrentPageReference)
getStateParameters(currentPageReference) {
 if (currentPageReference) {
   const urlValue = currentPageReference.state.AEGFlag;
   if (urlValue) {
     this.urlValueforAEG = urlValue;
     
   } else {
     this.urlValueforAEG = false;
   }
 }
}
    async redirectToCAC(event){
        this.isLoaded = true;
        this.messagestr = cacValidation();
        try {
            this.messagestr = await cacValidation();
            this.isLoaded = false;
                if ( this.messagestr !='SUCCESS' ){
                        const result = await LightningAlert.open ({
                        message:this.messagestr,
                    });
               // CreateDebug();
                }
        else {
            window.open( this.OWURL.CAC, '_blank').focus();
        }
          } catch(e) {}
    }
    async redirectToAEG(event){
        this.isLoaded = true;
        this.messagestr = aegValidation();
        try {
            this.messagestr = await aegValidation();
            this.isLoaded = false;
                if ( this.messagestr !='SUCCESS' ){
                        const result = await LightningAlert.open ({
                        message:this.messagestr,
                    });
                //CreateDebug();
                }
        else {
            window.open( this.OWURL.AEG, '_blank').focus();
        }
          } catch(e) {}
    }

    async redirectToFM(event){
        this.isLoaded = true;
        this.messagestr = fmValidation();
        try {
            this.messagestr = await fmValidation();
            this.isLoaded = false;
                if ( this.messagestr !='SUCCESS' ){
                        const result = await LightningAlert.open ({
                        message:this.messagestr,
                    });
                //CreateDebug();
                }
        else {
            window.open( this.OWURL.FM, '_blank').focus();
        }
          } catch(e) {}
    }

    async redirectToEM(event){
        this.isLoaded = true;
        this.messagestr = emValidation();
        try {
            this.messagestr = await emValidation();
            this.isLoaded = false;
                if ( this.messagestr !='SUCCESS' ){
                        const result = await LightningAlert.open ({
                        message:this.messagestr,
                    });
                //CreateDebug();
                }
        else {
            window.open( this.OWURL.EM, '_blank').focus();
        }
          } catch(e) {
            console.log('in the exception');
          }
    }

    async redirectToEX(event){
        this.isLoaded = true;
        this.messagestr = exValidation();
        try {
            this.messagestr = await exValidation();
            this.isLoaded = false;
                if ( this.messagestr !='SUCCESS' ){
                        const result = await LightningAlert.open ({
                        message:this.messagestr,
                    });
                //CreateDebug();
                }
        else {
            window.open( this.OWURL.Examiner, '_blank').focus();
        }
          } catch(e) {}
    }
    
    redirectToFellowship(){
        window.open(this.OWURL.Fellowship, '_blank').focus();
    }
   

}