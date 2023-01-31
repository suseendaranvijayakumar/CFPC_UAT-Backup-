global with sharing class CFPC_Bulk_Ordering implements Database.Batchable<SObject>,Database.Stateful {

    public Set<Id> result=new Set<Id>();
    List<SBQQ__Quote__c> quotetocontract1= new List<SBQQ__Quote__c> ();
    
    global CFPC_Bulk_Ordering(List<SBQQ__Quote__c> quotetocontract){
        for(SBQQ__Quote__c qt : quotetocontract ){
                result.add(qt.Id);
            }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select Name, Id,Bulk_Discontinuation_Order__c,SBQQ__Ordered__c from SBQQ__Quote__c where Id in:result';
        //system.debug('check contract'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SBQQ__Quote__c> scope){
        List<SBQQ__Quote__c> qteupdate1= new List<SBQQ__Quote__c>() ; 
         for(SBQQ__Quote__c quote: scope){
            
            quote.SBQQ__Ordered__c=true;
            qteupdate1.add(quote);
            quotetocontract1.add(quote);
        }
            
            System.debug('Quote'+qteupdate1);
            
            Update qteupdate1;
    }
    
    global void finish(Database.BatchableContext bc) {
      
        Database.executeBatch(new CFPC_Bulk_Contract_Creation(quotetocontract1),1);
        
        
    }
}