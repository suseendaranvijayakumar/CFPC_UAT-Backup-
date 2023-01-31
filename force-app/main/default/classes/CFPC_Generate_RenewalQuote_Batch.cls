global with sharing class CFPC_Generate_RenewalQuote_Batch implements Database.Batchable<SObject>,Database.Stateful,Database.AllowsCallouts{
    /*  Developed By : Suseendaran.v
     *  Once a record is created with this job type a scheduler class ‘CFPC_Generate_RenewalQuote_scheduler’ is scheduled with the time mentioned , 
     *  which calls a batch class called ‘CFPC_Generate_RenewalQuote_Batch’ . 
     *  this batch class fetches the contract which were identified in the ‘Identification job’, 
     *  that is fetch the contract in the current fab year which has renewed quote as false and Selected for bulk renewal as true (which means this was identified from first job).
     */
    public date FPendate;
    public date FPstartDate;
    public set<Id> quoteIds = new set<Id>();
    public Set<Id> result=new Set<Id>();
    public string chek_bulk_renewal='Yes';
    public List<Contact> cnt = new List<Contact>();
    public static Boolean renewalRunCheck=false;
    public Map<Id,Contact> Map_Account_Contact = new Map<Id,Contact>();
    public String Recordtoget;
    public Integer Recordcount=0;
    
    global CFPC_Generate_RenewalQuote_Batch(String RecordLimit){
        date Currentdate= System.today();
        integer Currentyear=Currentdate.year();
        if(Currentdate.month()<=6){
            FPstartDate = date.newinstance(Currentyear-1,07,01);
            FPendate = date.newinstance(Currentyear,06,30);
        }
        if(Currentdate.month()>=7){
            FPstartDate = date.newinstance(Currentyear,07,01);
            FPendate = date.newinstance(Currentyear+1,06,30);
        }
        
       
        Recordtoget=RecordLimit;
        
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       //String query;
        //if(!Test.isRunningTest()){
         String query = 'SELECT Id,AccountId FROM Contract WHERE SBQQ__RenewalQuoted__c =false And SBQQ__RenewalForecast__c =true And startDate >=: FPstartDate And endDate <=:FPendate and Selected_for_Bulk_Renewal__c=:chek_bulk_renewal LIMIT 1';
          
       // }
        //if(Test.isRunningTest()){
         // query = 'SELECT Id,AccountId FROM Contract WHERE startDate >=: FPstartDate And endDate <=:FPendate LIMIT 1';
       // }
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, Contract[] scope){
         
         Set<Id> acctId =new Set<Id>();
        for(Contract conrtRec1 : scope){
            acctId.add(conrtRec1.AccountId);
         }
        cnt = [Select Id, Name,AccountId,Queued_for_Renewal__c from Contact where AccountId IN: acctId];
        
        for( Contact cont :cnt){
            Map_Account_Contact.put(cont.AccountId,cont);
        }
        for( Contract con: scope){
              if(Map_Account_Contact.get(con.AccountId).Queued_for_Renewal__c==TRUE){
                CreateRenewalContext context = new CreateRenewalContext();
                context.renewedContracts = scope;
                renewalRunCheck = true;
                String jsonContext = JSON.serialize(context);
                CFPC_ContractRenewer renewer = new CFPC_ContractRenewer();
                QuoteModel[] quotes = renewer.load(null, jsonContext);
                for(QuoteModel sb:quotes){
                    quoteIds.add(sb.record.Id);
                }
              }
                
            
        }
    }
    
    global void finish(Database.BatchableContext bc) {    
        if(quoteIds.size()>0){
            Recordcount=Recordcount+1;
            List<SBQQ__Quote__c> sbq =[select Id, Quote_From_BulkRenewal__c from SBQQ__Quote__c where Id=:quoteIds];
            for(SBQQ__Quote__c sb: sbq){
                sb.Quote_From_BulkRenewal__c = true;
            }
            update sbq;
            if(Recordcount==10 && Recordtoget=='10'){
                renewalRunCheck = false;
            }
            else{
               Database.executeBatch(new CFPC_Generate_RenewalQuote_Batch(Recordtoget),1); 
            }
           
        } else{
            List<SBQQ__Quote__c> quoteList =[select Id, Quote_From_BulkRenewal__c from SBQQ__Quote__c where  createdDate=LAST_90_DAYS And Quote_From_BulkRenewal__c= True And SBQQ__Ordered__c =False];
            if(quoteList.size()>0){
                renewalRunCheck = false;
           }
        }
    
    }
    
    public class CreateRenewalContext {
        public Id masterContractId;
        public Contract[] renewedContracts;
        public Boolean returnOnlyQuoteId;
    }

}