global with sharing class CFPC_Check_Bulk_Renewal implements Database.Batchable<SObject>,Database.Stateful {
    
     /* Developr name: Suseendaran.v
     * This Batch class is to get get all the contract and makeSelected for Bulk renewal field on contract to 'Yes' which means the Contract which will be renewed as a part of bulk renewal process
     * 
     * Once a record is created with this job type a scheduler class ‘CFPC_bulk_renewal_iden_job’ is scheduled with the time mentioned , which call a batch class called ‘CFPC_Check_Bulk_Renewal’ this batch is to identify the contract ( contract which are present for current fab year and which has renewal quoted to false) associated with the constituent which needs to be renewed which also updates the “Queued for Renewal “to true on constituent and on contract the field ‘Selected for Bulk Renewal’ is made to yes
     * 
     * Varaible declaration 
     * FPstartDate = financial period start date
     * FPendate = financial period end date
     * Current date to get the current date
     * 
     */
    
    date FPstartDate;
    date FPendate;
    date Currentdate= System.today();
    integer Currentyear=Currentdate.year();
    public String Recordtoget;
    public String Alias ='agrac';
    List<Contract> Cnrt_to_update = new List<Contract> ();
    
    
    
    /* Constructor : To Caluate the current financial period 
     * eg: 1) today date= Nov 1st 2022
     * As nov(11) > 7 the FPStartedate will be set to 01/07/2022
     * FPEndate = 30/06/2023
     * 
     * 2) today date= Feb 1st 2023
     * As Feb(02) < 6 the FPStartedate will be set to 01/07/2022
     * FPEndate = 30/06/2023
     * 
     * 3) today date= june 20 2023
     * As june=(06) <= 6 the FPStartedate will be set to 01/07/2022
     * FPEndate = 30/06/2023
     * 
     * 4) today date= July 20 2023
     * As July(07) >= 7 the FPStartedate will be set to 01/07/2023
     * FPEndate = 30/06/2024
     */
    global CFPC_Check_Bulk_Renewal(String RecordLimit){
          if(Currentdate.month()<=6){
            FPstartDate = date.newinstance(Currentyear-1,07,01);
            FPendate = date.newinstance(Currentyear,06,30);
        }
        if(Currentdate.month()>=7){
            FPstartDate = date.newinstance(Currentyear,07,01);
            FPendate = date.newinstance(Currentyear+1,06,30);
        }
        
        Recordtoget=RecordLimit;
    }
    
     /* Database query Locator get all the Contract which is for current financial year 
      * this means startdate and endate is between financial period 
    */
     global Database.QueryLocator start(Database.BatchableContext bc){
         if(Recordtoget=='10'){
             String query = 'SELECT Id,Selected_for_Bulk_Renewal__c,AccountId,OwnerId,Owner.IsActive,Owner.Alias,CreatedDate FROM Contract WHERE SBQQ__RenewalQuoted__c =false And Owner.IsActive=true AND SBQQ__RenewalForecast__c =true and Disconitnued__c!=true And startDate >=: FPstartDate And endDate <=:FPendate ORDER BY CreatedDate DESC NULLS FIRST  LIMIT 10';
             return Database.getQueryLocator(query);
         }
         else{
             String query = 'SELECT Id,Selected_for_Bulk_Renewal__c,AccountId FROM Contract WHERE SBQQ__RenewalQuoted__c =false And SBQQ__RenewalForecast__c =true and Disconitnued__c!=true And startDate >=: FPstartDate And endDate <=:FPendate';
             return Database.getQueryLocator(query);
         }
        
        
    }
    
    /* Process all the contract fetched from query locator
     * We have field on contract record which is to identify whther this contract will be processed from bulk renewal job
     * if 'Selected for Bulk Renewal' is yes then this contract will be included for bulk renewal job
     * 
     * In the exceute method we are making the 'Selected for Bulk Renewal' to yes to identify which contract will be included to bulk renewal jobs
     */
    global void execute(Database.BatchableContext bc, List<Contract> scope){
        System.debug('List of contract to renew '+scope);
        System.debug('List of contract to renew size '+scope.size());

        
        Set<Id> acctId =new Set<Id>();
        Map<Id,Contact> Con_to_update = new Map<Id,Contact> ();
        Set<Id> contId = new Set<Id>();
        Map<Id,Contact> Map_Account_Contact = new Map<Id,Contact>();
        
         for(Contract conrtRec1 : scope){
            acctId.add(conrtRec1.AccountId);
         }
        
         List<AccountContactRelation> acct = [ Select Id,ContactId,AccountId from AccountContactRelation where AccountId IN: acctId];
        for(AccountContactRelation act :acct){
            contId.add(act.ContactId);
        }
        List<Contact> cnt = [Select Id, Name,AccountId,Queued_for_Renewal__c from Contact where Id in:contId];
        
        for( Contact cont :cnt){
            Map_Account_Contact.put(cont.AccountId,cont);
        }
        
        
        for(Contract conrtRec : scope){
            
            conrtRec.Selected_for_Bulk_Renewal__c='Yes';
            Cnrt_to_update.add(conrtRec);
          
            Contact ct=Map_Account_Contact.get(conrtRec.AccountId);
            if(ct!=null){
                  ct.Queued_for_Renewal__c=TRUE;
                  Con_to_update.put(ct.Id,ct);
            
                
            }
          
            
            
    
    }
       
        
          List<Database.SaveResult> results = Database.update(Cnrt_to_update,false);
        for (Database.SaveResult result : results) {
          if (!result.isSuccess()){
            for (Database.Error err : result.getErrors()){
               System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
    }
  }
}
        List<Database.SaveResult> results1 = Database.update(Con_to_update.values(),false);
        for (Database.SaveResult result : results1) {
          if (!result.isSuccess()){
            for (Database.Error err : result.getErrors()){
               System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
    }
  }
}
        
        
    }
    
    global void finish(Database.BatchableContext bc) {
       
    }

}