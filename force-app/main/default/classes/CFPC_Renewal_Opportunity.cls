public class CFPC_Renewal_Opportunity {
public static void beforeInsert(List<Opportunity> RenewOppList){
     Id recordTypeId_Renewal;
    recordTypeId_Renewal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    Set<Id> result=new Set<Id>();
    List<Opportunity> oppupdate = new List<Opportunity>();
    system.debug('Renewal opportunity'+RenewOppList);
    for(Opportunity oop:RenewOppList){
        result.add(oop.AccountId);
        
    }
    Map<Id,Contact> mapContact = new Map<Id,Contact>();
    List<Contact> cont =[Select CFPC_New_Class__c,Self_Learning_Program_Marketing__c,Join_Self_Learning_Program__c,CFPC_Class__c,CFPC_First_Year_Practicing__c,CFPC_Reduced_Fee__c,Name,AccountId, Id,CFPC_Chapter__c from Contact where AccountId in:result ];
    for(Contact ct:cont){
            mapContact.put(ct.AccountId,ct);
        }
    
    for(Opportunity opp:RenewOppList){
        if(opp.RecordTypeId==recordTypeId_Renewal ){
            //opp.CFPC_Self_Learning_Program__c=mapContact.get(opp.AccountId).Self_Learning_Program_Marketing__c;
            opp.CFPC_New_Class__c= mapContact.get(opp.AccountId).CFPC_New_Class__c;
            opp.CFPC_Chapter_Province__c=mapContact.get(opp.AccountId).CFPC_Chapter__c ;
            opp.CFPC_Class__c=mapContact.get(opp.AccountId).CFPC_Class__c ;
            
            if(mapContact.get(opp.AccountId).Join_Self_Learning_Program__c=='Yes'){
                opp.CFPC_Self_Learning_Program__c=TRUE;
            }else if(mapContact.get(opp.AccountId).Join_Self_Learning_Program__c=='No'){
                opp.CFPC_Self_Learning_Program__c=FALSE;
           }
            
            
            if(mapContact.get(opp.AccountId).CFPC_First_Year_Practicing__c=='Yes'){
                opp.CFPC_First_Year_Practicing_FYP__c=TRUE;
            }
            else if(mapContact.get(opp.AccountId).CFPC_First_Year_Practicing__c=='No'){
                opp.CFPC_First_Year_Practicing_FYP__c=FALSE;
            }
            if(mapContact.get(opp.AccountId).CFPC_Reduced_Fee__c=='Yes'){
                opp.CFPC_Reduced_Fee__c=TRUE;
            }
            else if(mapContact.get(opp.AccountId).CFPC_Reduced_Fee__c=='No'){
                opp.CFPC_Reduced_Fee__c=FALSE;
            }
            
            
        }
        
    }
    
    

}
    
}