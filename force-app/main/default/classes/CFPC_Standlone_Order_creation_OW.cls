public class CFPC_Standlone_Order_creation_OW implements Schedulable {
    
      /* Developr name: Suseendaran.v
     * This schedular class is to run a batch class which creats standlone order once a record is created in Mock payment object (CFPC_Mock_Payment__c) by OW intgration user
     * Batch class run with batch size one 
     */
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new CFPC_Stadlone_order_creation_OWBatch(),1);
        System.abortjob(ctx.getTriggerId());
    }
}