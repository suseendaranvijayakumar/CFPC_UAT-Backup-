public class CFPC_Bulk_Renewal_Contract_Schedule implements Schedulable {
    /*  Developed By : Suseendaran.v
     *  it will schedule a job which will go and fetch the renewal quote which were created from ‘Bulk Renewal Quote Generation’ job and create the order from them one by one.
     */
    Public String RecordLimit;
    Public CFPC_Bulk_Renewal_Contract_Schedule(String reclimit){
        RecordLimit= reclimit;
    }
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new CFPC_Bulk_Renewal_Contract_Batch(RecordLimit),1);
  
    }
}