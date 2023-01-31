global with sharing class CFPC_Bulk_Invoice_Creation implements Database.Batchable<SObject>,Database.Stateful  {
    public Set<Id> result=new Set<Id>();
    
    public List<Order> ordupdate_inv1 = new List<Order>();
    
    global CFPC_Bulk_Invoice_Creation(List<Order> ordupdate){
        for(Order qt : ordupdate ){
                result.add(qt.Id);
            }
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
         String query = 'Select Name, Id,SBQQ__Contracted__c,SBQQ__Quote__c,blng__BillNow__c from Order where Id in:result';
        system.debug('check invoice creation  '+query);
        return Database.getQueryLocator(query);
       
    }
    
     global void execute(Database.BatchableContext bc, List<Order> scope){
         List<Order> ordupdate_inv = new List<Order>();
         for(Order ord :scope){
             ord.blng__BillNow__c=TRUE;
             ordupdate_inv.add(ord);
             ordupdate_inv1.add(ord);
         }
         
        // Database.update(ordupdate_inv,false);
         Update ordupdate_inv;
      
    }
    
     global void finish(Database.BatchableContext bc) {
         System.debug('invoice to Update'+ordupdate_inv1);
       Database.executeBatch(new CFPC_Update_BulkInvoice(ordupdate_inv1),1);
        
    }

}