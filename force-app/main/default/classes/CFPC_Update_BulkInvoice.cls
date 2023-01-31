global with sharing class CFPC_Update_BulkInvoice implements Database.Batchable<SObject>,Database.Stateful  {
     public Set<Id> result=new Set<Id>();
    public List<blng__Invoice__c> invc_update = new List<blng__Invoice__c>();
    
    global CFPC_Update_BulkInvoice(List<Order> ordupdate){
        for(Order qt : ordupdate ){
                result.add(qt.Id);
            }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         String query = 'Select Name, Id,blng__InvoiceStatus__c from blng__Invoice__c where blng__Order__c in:result';
        //system.debug('check contract'+query);
        return Database.getQueryLocator(query);
       
    }
    
     global void execute(Database.BatchableContext bc, List<blng__Invoice__c> scope){
         for(blng__Invoice__c invc :scope){
             invc.blng__InvoiceStatus__c='Posted';
             invc_update.add(invc);
         }
         
         Database.update(invc_update,false);
      
    }
    
     global void finish(Database.BatchableContext bc) {
        
        
    }

}