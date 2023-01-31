global with sharing class CFPC_Bulk_Contract_Creation implements Database.Batchable<SObject>,Database.Stateful {
    public Set<Id> result=new Set<Id>();
    public List<Order> ordupdate = new List<Order>();
    
    global CFPC_Bulk_Contract_Creation(List<SBQQ__Quote__c> quotetocontract){
        for(SBQQ__Quote__c qt : quotetocontract ){
                result.add(qt.Id);
            }
    }
     global Database.QueryLocator start(Database.BatchableContext BC){
         String query = 'Select Name, Id,SBQQ__Contracted__c,SBQQ__Quote__c from Order where SBQQ__Quote__c in:result';
        system.debug('check contract query'+query);
        return Database.getQueryLocator(query);
       
    }
    
     global void execute(Database.BatchableContext bc, List<Order> scope){
         List<Order> ordupdate1 = new List<Order>();
         for(Order ord :scope){
             ord.SBQQ__Contracted__c=TRUE;
             ordupdate.add(ord);
             ordupdate1.add(ord);
         }
         
         //Database.update(ordupdate,false);
      Update ordupdate1;
    }
    
     global void finish(Database.BatchableContext bc) {
         System.debug('invoice to create'+ordupdate);
        Database.executeBatch(new CFPC_Bulk_Invoice_Creation(ordupdate),1);
        
    }

}