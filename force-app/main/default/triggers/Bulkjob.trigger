trigger Bulkjob on Bulk_Job__c (After insert) {
    
    /* Developed by: Suseendaran.v
     * After Insert trigger
     * Trigger to schedule a bulk job for "Bulk Renewal" , " Bulk discontinutaion"," Run batch to check record for Bulk Disconitutaion","Run batch to records for bulk Renewal"
     * 
     * This triggers call a apex class "CFPC_Creation_of_bulk_jobs"
     */
    
     if(trigger.isAfter && trigger.isInsert)
    {
     
      CFPC_Creation_of_bulk_jobs.afterInsert(Trigger.new);
    
    }
    
    
   
 

}