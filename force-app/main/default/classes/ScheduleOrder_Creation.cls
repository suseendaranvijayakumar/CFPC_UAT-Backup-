public class ScheduleOrder_Creation implements Schedulable {
public void execute(SchedulableContext ctx) {
    List<SBQQ__Quote__c> qteupdate= new List<SBQQ__Quote__c> ();
    List<SBQQ__Quote__c> quote = [SELECT Id, Name, OwnerId, SBQQ__Ordered__c,Proceed_To_Payment__c FROM SBQQ__Quote__c WHERE Proceed_To_Payment__c= TRUE and SBQQ__Ordered__c=FALSE];
    for(SBQQ__Quote__c qte : quote){
        
            qte.SBQQ__Ordered__c=TRUE;
            qteupdate.add(qte); 
       
            
        
    }
    Update qteupdate;
    }
}