global class CFPC_Bulk_Renewal_Contract_Batch implements Database.Batchable<SObject>,Database.Stateful,Database.AllowsCallouts {
  
     /*  Developed By : Suseendaran.v
     *  Once record is created with job type ‘Bulk Renewal Order Generation’ a apex class is scheduled ‘CFPC_Bulk_Renewal_Contract_Schedule’ which calls a batch class ‘CFPC_Bulk_Renewal_Contract_Batch’ 
     *  this batch class gets the renewal quote based on the field record to process and send the renewal quote records
     *  to the batch class “CFPC_Bulk_Ordering” this class order the quote one by one ( it make the ordered check box on quote to true), 
     *  once all quote are ordered next batch class called ‘CFPC_Bulk_Contract_Creation’ is called which create contract one by one
     *  ( it make the contracted check box on order to true which trigger the CPQ Contract creation process),
     *  once all contract are created Invoices are created from batch class “CFPC_Bulk_Invoice_Creation” for those order by making bill now checkbox to true. 
     * Once that is done all a batch class called ‘CFPC_Update_BulkInvoice’ is called which updates the status of the Invoice to post
     *  which triggers the Billing’s revenue schedule and revenue transaction process.
     */
    
    
    public List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
    public String Recordtoget;
    
  
    
    global CFPC_Bulk_Renewal_Contract_Batch(String RecordLimit){
        Recordtoget=RecordLimit;
     
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
       
       if(Recordtoget=='10'){
           String query = 'Select Id, Quote_From_BulkRenewal__c from SBQQ__Quote__c where createdDate=LAST_90_DAYS And Quote_From_BulkRenewal__c= True And SBQQ__Ordered__c =False LIMIT 10';
       return Database.getQueryLocator(query);
       }
        else{
            String query = 'Select Id, Quote_From_BulkRenewal__c from SBQQ__Quote__c where createdDate=LAST_90_DAYS And Quote_From_BulkRenewal__c= True And SBQQ__Ordered__c =False';
            return Database.getQueryLocator(query);
        }
       
    }
    global void execute(Database.BatchableContext bc, SBQQ__Quote__c[] scope){
      
        for( SBQQ__Quote__c qte: scope){
            quoteList.add(qte);
        }

        
         
    }
    
    global void finish(Database.BatchableContext bc) {     
       
        
        if(quoteList.size()>0){
               
                Database.executeBatch(new CFPC_Bulk_Ordering(quoteList),1);
            }
    }

}