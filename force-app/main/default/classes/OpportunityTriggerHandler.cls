public class OpportunityTriggerHandler{
    public static void afterUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldOpportunityMap){
         Id recordTypeId;
        /* Set<Id> acctId=new Set<Id>();
        System.debug('Inside Opportunity trigger');
        for(Opportunity opp :newOppList){
            acctId.add(opp.accountId);
        }
         
        Map<Id, Account> contactsByAccount = new Map<Id, Account>([SELECT (SELECT FirstName, LastName,CFPC_Preferred_Language__c FROM Contacts) FROM Account WHERE Id in :acctId]);
*/
        Map<Id,Opportunity> idToOpportunityMap = new Map<Id,Opportunity>();

        for(Opportunity opp :newOppList){
           /* if(opp.StageName == 'Approved' && opp.StageName != oldOpportunityMap.get(opp.Id).StageName){
             Contact[] accountContacts = contactsByAccount.get(opp.accountId).Contacts;
            
            if(accountContacts[0].CFPC_Preferred_Language__c=='French'){
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Nouvelle application').getRecordTypeId();  
        }
        else if (accountContacts[0].CFPC_Preferred_Language__c=='English'){
           recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
         
        }   
            }
            
            */
            if(opp.StageName == 'Approved'){
              recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
             System.debug('outside if 1st loop new stage name'+opp.StageName);
            System.debug('outside if 1st  loop old stage name'+oldOpportunityMap.get(opp.Id).StageName);
            System.debug('outside if 1st loop record type name'+opp.RecordType.name);   
            }
             
            
            if(opp.StageName == 'Approved' && opp.StageName != oldOpportunityMap.get(opp.Id).StageName && opp.RecordTypeId == recordTypeId){
                 System.debug('Inside if 1st loop'+opp);
                idToOpportunityMap.put(opp.Id,opp);
            } 
            else if(opp.StageName == 'Approved' && opp.StageName != oldOpportunityMap.get(opp.Id).StageName && opp.RecordType.name == 'Nouvelle application'){
                 System.debug('Inside if 2nd loop'+opp);
                idToOpportunityMap.put(opp.Id,opp);
            }
        }
        System.debug('Size of map'+idToOpportunityMap);
        if(idToOpportunityMap.size()>0){
            // Calling batch class.
             System.debug('Calling batch class');
            Database.executeBatch(new GeneratePdfOnApprovalBatch(idToOpportunityMap)); 
        }
        
        
        
        
    }
    
    
    
}