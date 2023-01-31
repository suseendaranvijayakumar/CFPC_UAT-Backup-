public without sharing class CFPC_CommunityUserContactInfo {
    @AuraEnabled
    public static user getCurrentuser(){
        return [SELECT id, LanguageLocaleKey, contactId, Contact.CFPC_CFPC_ID__c, Contact.CFPC_Class__c, contact.CFPC_Status__c,
                   contact.AccountId,contact.CFPC_Membership_Discontinued_Date__c, contact.CFPC_CERTAccountFlag__c,contact.CFPC_MainProFlag__c 
                   from user WHERE Id =: UserInfo.getUserId() LIMIT 1];
    }
}