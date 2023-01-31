public without sharing class getAllContentDocs {
    
    @AuraEnabled(cacheable=true)
    public static List<uIWrapper> getContentDocuments() {
        List<uIWrapper> uiList= new List<uIWrapper>();
        ID LibraryId = [SELECT Id FROM ContentWorkspace WHERE Name = 'CFPC_Members_Docs' LIMIT 1].Id;
        for(MembershipDocPages__mdt md: [select sortOrder__c,MasterLabel,SitePageURL__c from MembershipDocPages__mdt order by sortOrder__c asc ]){
            uIWrapper u = new uIWrapper();
            u.Title = md.MasterLabel;
            u.DocUrl = URL.getSalesforceBaseUrl().toExternalForm()+md.SitePageURL__c;
            uiList.add(u);
        }
        for(ContentDocument cv:[SELECT Id,Description,Title from ContentDocument where parentId =: LibraryId order by Title desc]){
            uIWrapper ul = new uIWrapper();
            ul.Title = cv.Title;
            ul.DocUrl= URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/document/download/'+ cv.Id;
            uiList.add(ul); 
        }
        ID chapterLibraryId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Chapter Documents' LIMIT 1].Id;
        User us = [select id,contactId,Contact.CFPC_Chapter__c from user where Id =: UserInfo.getUserId() LIMIT 1];
        uIWrapper uw = new uIWrapper();
        for(ContentDocument cd:[SELECT Id,Description,Title from ContentDocument where parentId =: chapterLibraryId]){
            if(us.contactId != null && us.Contact.CFPC_Chapter__c != null && us.Contact.CFPC_Chapter__c == cd.Title.substringBefore('-')){                
                if( cd.Description.toLowerCase() == (UserInfo.getLanguage().substringBefore('_'))){
                    uw.chapTitle = cd.Title;
                    uw.chapDesc= cd.Description;
                    uw.chapDocUrl= URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/document/download/'+ cd.Id;
                    uiList.add(uw);
                    break;
                }else if(cd.Description.toLowerCase() == (UserInfo.getLanguage().substringBefore('_'))){
                    uw.chapTitle = cd.Title;
                    uw.chapDesc= cd.Description;
                    uw.chapDocUrl= URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/document/download/'+ cd.Id;
                    uiList.add(uw);
                    break;
                }
                
            }
        }
        return uiList;
    }
    public class uIWrapper {
        @AuraEnabled public string DocUrl;
        @AuraEnabled public string Title;
        @AuraEnabled public string chapTitle;
        @AuraEnabled public string chapDocUrl;
        @AuraEnabled public string chapDesc;
    }
}