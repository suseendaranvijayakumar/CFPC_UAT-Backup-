public class CFPC_Subscription_Handler {
    
    public static void updateConstituent(list<SBQQ__Subscription__c> subRec){
        
        Set<Id> accId = new Set<Id>();
        Map<Id,Id> conAcIds = new Map<Id,Id>();
        for(SBQQ__Subscription__c ac:subRec){
            accId.add(ac.SBQQ__Account__c);
        }
        List<AccountContactRelation> acc = [select Id,ContactId,AccountId from AccountContactRelation where AccountId =:accId];
        for(AccountContactRelation accn:acc){
            conAcIds.put(accn.AccountId,accn.ContactId);
        }
        contact cn = new contact();
        for(SBQQ__Subscription__c sb:subRec){
            if(CFPC_Subscription_Constants.chapters.containskey(sb.SBQQ__ProductName__c) && sb.SBQQ__Quantity__c >0){
                cn.CFPC_Chapter__c = CFPC_Subscription_Constants.chapters.get(sb.SBQQ__ProductName__c);                
            }
            if(CFPC_Subscription_Constants.newClass.containskey(sb.SBQQ__ProductName__c) && sb.SBQQ__Quantity__c >0 ){
                cn.CFPC_New_Class__c  = CFPC_Subscription_Constants.newClass.get(sb.SBQQ__ProductName__c);
            }
            if(CFPC_Subscription_Constants.selfLrnPrgm.contains(sb.SBQQ__ProductName__c)){
                if(sb.SBQQ__Quantity__c >0){
                    cn.Join_Self_Learning_Program__c   = 'Yes';
                }else cn.Join_Self_Learning_Program__c   = 'No';
            }
            cn.Id = conAcIds.containskey(sb.SBQQ__Account__c) ? conAcIds.get(sb.SBQQ__Account__c):'';            
        }
        if(cn != null && (cn.CFPC_Chapter__c != ''||cn.CFPC_New_Class__c != '' || cn.Join_Self_Learning_Program__c !='')){
            update cn;
        }
    }
}