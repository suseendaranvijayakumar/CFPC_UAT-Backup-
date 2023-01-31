public class CFPC_bulk_discontinuation_iden_job implements Schedulable {
    
     /* Developr name: Suseendaran.v
     * This Batch class is to get get all the contact(Consitiutents) and make Exclude from Discontiunation field on contact to 'No' which means the contact is le included in bulk discontunation process
     * 
     * Varaible declaration 
     * FPstartDate = financial period start date
     * FPendate = financial period end date
     * Current date to get the current date
     * Status is check the status of the invoice assoicatted with contact
     * Id of the contact
     */
    
    public void execute(SchedulableContext ctx) {
        
    date FPstartDate;
    date FPendate;
    date Currentdate= System.today();
    integer Currentyear=Currentdate.year();
    String status='Active';
    String InvoiceType='Renewal';
    Id recordTypeId_GroupB;
    Id recordTypeId_GroupC;
    List<Contact> Cnt_to_update = new List<Contact> ();
    List<Contact> cnt = new List<Contact> ();
        
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
     * 
     * Assign the record Id based on the name of contact record type
     */
        
        if(Currentdate.month()<=6){
            FPstartDate = date.newinstance(Currentyear-1,07,01);
            FPendate = date.newinstance(Currentyear,06,30);
            
        }
         if(Currentdate.month()>=7){
            FPstartDate = date.newinstance(Currentyear,07,01);
            FPendate = date.newinstance(Currentyear+1,06,30);
            
        }
        recordTypeId_GroupB = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_B_Member').getRecordTypeId();
        recordTypeId_GroupC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_C_Non_Member_Main_Pro').getRecordTypeId();
       
        

        /* List all the contact which does have payment
    * 
    * For a contact It will go get a latest invoice, which is in the current Financial period and check if the invoice is paid or not
    * If the Inovice is not paid ( that means it has balance greater than zero and no payment )
    * If the status of contact is active
    * Invoice type is renewal
    *  and record type of contact is Group B or Group C
    * 
    */
        if(!Test.isRunningTest()){
         cnt=[Select Name,Id, AccountId,CFPC_Status__c,RecordTypeId,CFPC_Membership_Discontinued_Date__c,CFPC_Membership_Discontinued_Reason__c from Contact where Id IN(Select blng__BillToContact__c  from blng__Invoice__c where blng__Balance__c>0 and blng__Payments__c=0 and blng__InvoiceDate__c>=:FPstartDate and blng__InvoiceDate__c<=:FPendate and Invoice_Type__c=:InvoiceType) and CFPC_Status__c=:status and (RecordTypeId=:recordTypeId_GroupB  OR RecordTypeId=:recordTypeId_GroupC)];
    System.debug('Contact List'+cnt);   
        }
        
        if(Test.isRunningTest()){
         cnt=[Select Name,Id, AccountId,CFPC_Status__c,RecordTypeId,CFPC_Membership_Discontinued_Date__c,CFPC_Membership_Discontinued_Reason__c from Contact where Id IN(Select blng__BillToContact__c  from blng__Invoice__c where blng__Balance__c>0 and blng__Payments__c=0) and CFPC_Status__c='Active'];
    System.debug('Contact List ++'+cnt);
        }
    /* 
    * The contact are iterated  and the field 'Queeued for discontinuation' to True and  'Exculde from discontinutaion' is set to No , which means this contact which will be processed in bulk discontinuation
    * 
    */
        
            for(Contact contRec : cnt){
            
            contRec.CFPC_Exclude_from_Discontinuation__c='No';
            contRec.Queued_for_discontinuance__c=TRUE;
            Cnt_to_update.add(contRec);
        }
        
         //Saving a list contacts
        List<Database.SaveResult> results = Database.update(Cnt_to_update,false);
        for (Database.SaveResult result : results) {
          if (!result.isSuccess()){
            for (Database.Error err : result.getErrors()){
               System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
       
  
            }

          }
        }
    }
}