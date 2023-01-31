import { LightningElement,api } from 'lwc';
import getFeeDetails from '@salesforce/apex/FeeStructureController.getFeeDetails';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
    FlowNavigationPauseEvent
} from 'lightning/flowSupport';

export default class CfpcFeeStructure extends LightningElement {
@api availableActions = [];
billBegin;
billEnd;
monthsBilled;
data=[];
data1=[];
data2=[];
tabledata=[];
quoteData=[];
totalIncome = 0;
totalAmount=0;
donation;
quoteId='';
displayAmount=false;
@api subtotal;
@api recordId;
showPage=false;

get columns() {
    return [
        {label: 'Item', fieldName: 'Name', type: 'text'},
        {label: 'Amount', fieldName: 'SBQQ__NetTotal__c', type: 'decimal'}
    ];
}
connectedCallback(){
    let today = new Date();
    let date = today.getDate();
    let month = today.getMonth()+1;
    let year = today.getFullYear();
    let year1 = today.getFullYear()+1;
    var month1 = today.getMonth()+2;
    let result,result2,diff1,diff2,yearfinal,yearcheck;
    if(date<15){
        result = month +'/'+1+'/'+year;
        diff1=month;
        yearfinal=year;
    }else{
        if(month==12){
            result = 1 +'/'+1+'/'+year1;
            diff1=1;
            yearfinal=year1;
        }else{
            result = month1 +'/'+1+'/'+year;
            diff1=month1;
            yearfinal=year;
        }
        
    }
    if(diff1<7){
        result2 = 6 +'/'+30+'/'+yearfinal;
        yearcheck=yearfinal;
    }else{
        result2 = 6 +'/'+30+'/'+(yearfinal+1);
        yearcheck=(yearfinal+1);
    }
    this.billBegin = result;
    this.billEnd=result2;
    this.monthsBilled = (6 - diff1 + (12 * (yearcheck - yearfinal)));
    this.getFeeDetail();
}
getFeeDetail(){
    getFeeDetails({ opprecordId: this.recordId })
        .then((result) => {
            let table=[];
            let table1=[];
            let table2=[];
            this.tabledata=result;
            console.log('result'+JSON.stringify(this.tabledata));
            if(this.tabledata){
                for(let row in this.tabledata) {
                    if(this.tabledata[row].SBQQ__Product__r.Product_Type__c){
                        if(this.tabledata[row].SBQQ__Product__r.Product_Type__c =='Other'){
                            table.push(this.tabledata[row]);
                        }else{
                            if(this.tabledata[row].SBQQ__Product__r.Product_Type__c=='Learning'){
                                table1.push(this.tabledata[row]);
                            }
                            if(this.tabledata[row].SBQQ__Product__r.Product_Type__c=='Donation'){
                                table2.push(this.tabledata[row]);
                            }
                            
                        }
                        if (this.tabledata[row].SBQQ__Product__r.Product_Type__c=='Donation')
                        { 
                            this.donation = this.tabledata[row].SBQQ__NetTotal__c;
                        }
                    }
                    if (this.tabledata[row].SBQQ__Quote__r.SBQQ__NetAmount__c)
                    { 
                        this.subtotal = this.tabledata[row].SBQQ__Quote__r.SBQQ__NetAmount__c;
                    }
                    
                    this.data= table;
                    this.data1=table1;
                    this.data2=table2;
                    this.displayAmount=true;
                }
            }   
        })
        .catch((error) => {
            this.error = error;
        });
    }

    

    handleGoNext(event) {
        this.showPage = true;
    }

    handleNextClick(){
        if (this.availableActions.find((action) => action === 'NEXT')) {
          const navigateNextEvent = new FlowNavigationNextEvent();
          this.dispatchEvent(navigateNextEvent);
        }
    }
    handlePauseClick(){
        if (this.availableActions.find((action) => action === 'PAUSE')) {
          const navigatePauseEvent = new FlowNavigationPauseEvent();
          this.dispatchEvent(navigatePauseEvent);
        }
    }
}