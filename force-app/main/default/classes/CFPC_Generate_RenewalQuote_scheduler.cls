public class CFPC_Generate_RenewalQuote_scheduler implements Schedulable  {
    
    /*  Developed By : Suseendaran.v
     *  The Identified contract will be sent one by one to the renewal contract API of salesforce to create the renewal quote along with the quote line.
     */
        Public String RecordLimit;
    Public CFPC_Generate_RenewalQuote_scheduler(String reclimit){
        RecordLimit= reclimit;
    }
 public void execute(SchedulableContext ctx) {
        Database.executeBatch(new CFPC_Generate_RenewalQuote_Batch(RecordLimit),1);
  
    }
}