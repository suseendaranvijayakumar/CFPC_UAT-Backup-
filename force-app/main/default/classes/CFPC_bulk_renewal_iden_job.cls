Public class CFPC_bulk_renewal_iden_job implements Schedulable {
     /*  Developed By : Suseendaran.v
     *  Scheduler class to call a batch class which to identify the record for renewal
     *  This class run after the insertion of bulk job record ( Bulk job is a custom object created for scheduling bulk job)
     */
    
    Public String RecordLimit;
    Public CFPC_bulk_renewal_iden_job(String reclimit){
        RecordLimit= reclimit;
    }
     public void execute(SchedulableContext ctx) {
        Database.executeBatch(new CFPC_Check_Bulk_Renewal(RecordLimit));
  
    }

}