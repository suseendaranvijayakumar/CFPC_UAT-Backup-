import { LightningElement,api } from 'lwc';
import getFeeDetails from '@salesforce/apex/FeeStructureController.getFeeDetails';
import updateDonation from '@salesforce/apex/FeeStructureController.updateDonation';
import getUpdatedQuoteAmount from '@salesforce/apex/FeeStructureController.getUpdatedQuoteAmount';
import payNow from '@salesforce/apex/FeeStructureController.payNow';
import deleteSelfLearning from '@salesforce/apex/FeeStructureController.deleteSelfLearning';
import orderQuote from '@salesforce/apex/FeeStructureController.orderQuote';
import createPayment from '@salesforce/apex/FeeStructureController.createPayment';
import LightningConfirm from "lightning/confirm";
import { deleteRecord } from 'lightning/uiRecordApi';

import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
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
latesttable=[];
latesttable1=[];
totalIncome = 0;
checkboxVal = true;
totalAmount=0;
donation;
amount=0;
proceedwithPayment= 'Proceed with Payment';
quoteId='';
quoteID1='';
displayAmount=false;
displayAmount1=false;
displayAmount2=false;
showTr1=true;
@api subtotal;
@api recordId;
showPage=false;
check=false;
quotelineid='';
payUrl='';

get columns() {
    return [
        {label: 'Item', fieldName: 'Name', type: 'text'},
        {label: 'Amount', fieldName: 'SBQQ__NetTotal__c', type: 'decimal'}
    ];
}
connectedCallback(){
    console.log('recordID'+this.recordId);
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
    this.monthsBilled = (7 - diff1 + (12 * (yearcheck - yearfinal)));
    
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
                        this.quoteId=this.tabledata[row].SBQQ__Quote__r.Id;
                        this.subtotal = this.tabledata[row].SBQQ__Quote__r.SBQQ__NetAmount__c;
                    }
                    if (this.tabledata[row].SBQQ__Quote__r.SBQQ__NetAmount__c == 0)
                    {
                        this.proceedwithPayment = 'Next';
                    }
                    
                    this.data= table;
                    this.data1=table1;
                    this.data2=table2;
                    this.displayAmount=true;
                    console.log('this.quoteId '+this.quoteId);
                    if(this.quoteId){
                        console.log('entered '+this.quoteId);
                        payNow({ quoteID:this.quoteId })
                        .then((result2) => {
                                console.log('success '+result2);
                                this.payUrl=result2;
                                console.log('payURL' +this.payUrl);
                                //window.open(result2);
                                //window.open(payUrl, '_blank');
                            })
                        .catch((error) => {
                            this.error = error;
                        });
                    }
                }
            }   
        })
        .catch((error) => {
            this.error = error;
        });
    }

    

    handleGoNext(event) {
        this.showPage = true;
        if(this.recordId){
            orderQuote({ opprecordId:this.recordId })
            .then((result2) => {
                    console.log('success');
                })
            .catch((error) => {
                this.error = error;
            });
        }
    }

    handlePauseClick(){
        console.log('Pause clicked');
        if (this.availableActions.find((action) => action === 'PAUSE')) {
          const navigatePauseEvent = new FlowNavigationPauseEvent();
          this.dispatchEvent(navigatePauseEvent);
          console.log('success');
        }
    }

    handleNextClick(){
        if(this.recordId){
            createPayment({ opprecordId:this.recordId })
            .then((result2) => {
                    console.log('success'+result2);
                })
            .catch((error) => {
                this.error = error;
            });
        }
        if (this.availableActions.find((action) => action === 'NEXT')) {
          const navigateNextEvent = new FlowNavigationNextEvent();
          this.dispatchEvent(navigateNextEvent);
        }
    }
    onchange(event){
        this.donation=event.target.value;
        updateDonation({ opprecordId: this.recordId ,amount: this.donation})
        .then((result) => {
            
            this.tabledata=result;
            console.log('result'+JSON.stringify(this.tabledata));
            this.quoteId=this.tabledata[0].Id ;
            //this.check=true;
            //test();
            if(this.tabledata){
                for(let row in this.tabledata) {
                    if (this.tabledata[row].SBQQ__NetAmount__c)
                    { 
                        this.subtotal = this.tabledata[row].SBQQ__NetAmount__c;
                    }
                    console.log(this.tabledata[row]);
                    this.displayAmount=false;
                    this.displayAmount1=true;
                    this.displayAmount2=false;
                }
            } 
        })
        .catch((error) => {
            this.error = error;
        });
    }
    async deleteQuoteLineOnChange(event){
        let quoteID2='';
        this.quotelineid=event.target.name;
        console.log(event.target.name);
        console.log(event.target.checked);
        const result = await LightningConfirm.open ({
            message:" Warning! This process cannot be undone. Are you sure you would like to Opt out of Self- Learning Program?",
            theme: "shade",
            variant: "headerless", 
            label:"Confirmation"
        });
        console.log('result'+result);
        if (result){
            console.log("result on OK" , result);
            deleteSelfLearning({ quoteLineID:this.quotelineid })
            .then((result2) => {
                this.latesttable1=result2;
                console.log(this.latesttable1[0]);
                if (this.latesttable1[0].SBQQ__NetAmount__c){
                     
                    this.subtotal = this.latesttable1[0].SBQQ__NetAmount__c;
                       
                        
                    
                }
                console.log(this.latesttable1[0]);
                this.displayAmount=false;
                this.displayAmount1=false;
                this.displayAmount2=true;
                        /*getUpdatedQuoteAmount({ quoteID : quoteID2 })
                        .then((result1) => {
                            this.latesttable=result1;
                            console.log(this.latesttable);
                            if (this.latesttable[0].SBQQ__NetAmount__c){
                                { 
                                    this.subtotal = this.latesttable[0].SBQQ__NetAmount__c;
                                }
                                console.log(this.latesttable[0]);
                                this.displayAmount=false;
                                this.displayAmount1=false;
                                this.displayAmount2=true;
                                this.check=false;
                            }
                        })
                        .catch((error) => {
                            this.error = error;
                        });*/
            })
            .catch((error) => {
                this.error = error;
            });
            console.log(quoteID2);
            console.log(this.quoteID1);
            
            //deleteRecord(this.quotelineid);
            this.showTr1 = false;
            
        }
        
         else if (result == false){

            let i;
            let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]')
            console.log('checkboxes'+checkboxes);
            for(i=0; i<checkboxes.length; i++) {
                console.log('checkboxes'+checkboxes[i].checked);
                checkboxes[i].checked = true;
                console.log('checkboxes'+checkboxes[i].checked);
            }
            
            
        }
    }

    test() {
        if(this.check){
            if(this.quoteId ){
        getUpdatedQuoteAmount({ quoteID:this.quoteId })
            .then((result1) => {
                this.latesttable=result1;
                console.log(this.latesttable[0]);
                if (this.latesttable[0].SBQQ__NetAmount__c){
                    { 
                        this.subtotal = this.latesttable[0].SBQQ__NetAmount__c;
                    }
                    console.log(this.latesttable[0]);
                    this.displayAmount=false;
                    this.displayAmount1=true;
                    this.check=false;
                }
            })
            .catch((error) => {
                this.error = error;
            });
        }}
     } 
     handleNextClick1(event){
        console.log('entered');
        console.log('entered '+this.quoteId);
        if(this.quoteId){
            console.log('entered '+this.quoteId);
            payNow({ quoteID:this.quoteId })
            .then((result2) => {
                    console.log('success '+result2);
                    this.payUrl=result2;
                    console.log('payURL' +this.payUrl);
                    //window.open(result2);
                    window.open(payUrl, '_blank');
                })
            .catch((error) => {
                this.error = error;
            });
        }
     }
}