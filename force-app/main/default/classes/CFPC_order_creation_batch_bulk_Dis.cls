global with sharing  class CFPC_order_creation_batch_bulk_Dis implements Database.Batchable<SObject>, Database.AllowsCallouts,Database.Stateful {
    public Set<Id> result=new Set<Id>();
    List<SBQQ__Quote__c> quotetocontract= new List<SBQQ__Quote__c> ();
    
    global CFPC_order_creation_batch_bulk_Dis(List<SBQQ__Quote__c> quotetoupdate){
        for(SBQQ__Quote__c qt : quotetoupdate ){
                result.add(qt.Id);
            }
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'Select Name, Id,Bulk_Discontinuation_Order__c,SBQQ__Ordered__c from SBQQ__Quote__c where Id in:result';
        //system.debug('check contract'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SBQQ__Quote__c> scope){
        
        List<SBQQ__Quote__c> qteupdate= new List<SBQQ__Quote__c>() ; 
        List<SBQQ__QuoteLine__c> quotelineUpdate=  new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> quoteline = [Select Name, Id from SBQQ__QuoteLine__c where SBQQ__Quote__c in:result];
        System.debug('List of quote line to update'+result);
        System.debug('List of quote line to update'+quoteline);
        for(SBQQ__QuoteLine__c qtline: quoteline){
                qtline.SBQQ__Quantity__c=0;
                quotelineUpdate.add(qtline);

            }
            
        
        SBQQ.TriggerControl.disable();
            Database.update(quotelineUpdate,false);
        SBQQ.TriggerControl.enable();
         for(SBQQ__Quote__c quote: scope){
            quote.Bulk_Discontinuation_Order__c=true;
             qteupdate.add(quote);
            quotetocontract.add(quote);
        }
            Database.update(qteupdate,false);
        
    }
    global void finish(Database.BatchableContext bc) {
        Database.executeBatch(new CFPC_Bulk_Ordering(quotetocontract),1);
       
    }

}