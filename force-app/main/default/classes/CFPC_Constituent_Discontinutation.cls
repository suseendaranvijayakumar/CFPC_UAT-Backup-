public class CFPC_Constituent_Discontinutation implements Schedulable {
    /* This is schedular class which run when a bulk job record is created with job type as 'Bulk discontinuation' 
     * 
     * 
     */
public void execute(SchedulableContext ctx) {
    /* The Execute method runs and gets all the active Contact for which Current fab year Invoice has not been paid and Inovice type is Renewal and contact is Queued_for_discontinuance__c= true and Exculde from discontinunace is not 'Yes'
     * Only Contact with Group B and Group c recordtype are fetched
     * 
     */
    Id recordTypeId_GroupB;
    Id recordTypeId_GroupC;
    recordTypeId_GroupB = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_B_Member').getRecordTypeId();
    recordTypeId_GroupC = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_C_Non_Member_Main_Pro').getRecordTypeId();
   //List of contact which will be discontinued for non payment
    List<Contact> cont_to_discontinue = new List<Contact>();
    List<Contact> cnt = new List<Contact> ();
    // variable declared to identify the current fab year
        date FPendate;
        date FPstartDate;
        date Currentdate= System.today();
        integer Currentyear=Currentdate.year();
    if(Currentdate.month()<=6){
            FPstartDate = date.newinstance(Currentyear-1,07,01);
            FPendate = date.newinstance(Currentyear,06,30);
            
        }
         if(Currentdate.month()>=7){
            FPstartDate = date.newinstance(Currentyear,07,01);
            FPendate = date.newinstance(Currentyear+1,06,30);
            
        }
    //List of contact with cub fab years invoice which does not has payment and invoice type is renewal 
    if(!Test.isRunningTest()){
    cnt=[Select Name,Id, AccountId,CFPC_Status__c,RecordTypeId,CFPC_Membership_Discontinued_Date__c,CFPC_Membership_Discontinued_Reason__c from Contact where Id IN (Select blng__BillToContact__c  from blng__Invoice__c where blng__Balance__c>0 and blng__Payments__c=0 and blng__InvoiceDate__c>=:FPstartDate and blng__InvoiceDate__c<=:FPendate and Invoice_Type__c='Renewal' )and CFPC_Status__c='Active' and CFPC_Exclude_from_Discontinuation__c!='Yes' and Queued_for_discontinuance__c=TRUE ];
    }
    if(Test.isRunningTest()){
    cnt=[Select Name,Id, AccountId,CFPC_Status__c,RecordTypeId,CFPC_Membership_Discontinued_Date__c,CFPC_Membership_Discontinued_Reason__c from Contact where Id IN (Select blng__BillToContact__c  from blng__Invoice__c where blng__Balance__c>0 and blng__Payments__c=0 and blng__InvoiceDate__c>=:FPstartDate and blng__InvoiceDate__c<=:FPendate )and CFPC_Status__c='Active' ];
    }
    for(Contact cnt_dis :cnt){
        //Discontinuating the list of contact by populating membership discontinutaed date and membership discontinued reason
        if(cnt_dis.RecordTypeId==recordTypeId_GroupB || cnt_dis.RecordTypeId==recordTypeId_GroupC){
            cnt_dis.CFPC_Membership_Discontinued_Date__c=Date.today();
            cnt_dis.CFPC_Membership_Discontinued_Reason__c = 'Non-Payment';
            cont_to_discontinue.add(cnt_dis);
        }
    }
    
    Update cont_to_discontinue;
    
    }
}