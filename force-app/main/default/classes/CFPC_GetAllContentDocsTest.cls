@isTest
public class CFPC_GetAllContentDocsTest {
    @testSetup
    private static void createTestData() {
        Id accountRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CFPC Account').getRecordTypeId();        
        Account accountRecord = new Account();
        accountRecord.Name = 'Test Account';
        accountRecord.RecordTypeId = accountRecordId;
        insert accountRecord;
        Contact newContactRecord = new Contact(
            FirstName = 'Test',
            LastName = 'Test Code1',
            AccountId = accountRecord.Id,
            Email = 'test@test.com',
            RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_B_Member').getRecordTypeId(),
            CFPC_Gender__c = 'Male',
            CFPC_Class__c = 'LIFE',
            CFPC_Status__c = 'Active',
            CFPC_MINC_Number__c = '123',
            CFPC_Preferred_Language__c = 'English',
            CFPC_Chapter__c = 'AB'
        );
        insert newContactRecord; 
        //Insert User   
        Profile p = [SELECT Id FROM Profile WHERE Name = 'CFPC Member' LIMIT 1];
        user u = New User(
            UserName = 'test_' + math.random() + '@test.com',
            FirstName = 'Test-First',
            LastName = 'Test-Last',
            Alias = 'test',
            email = 'test' + math.random() + '@test.com',
            CommunityNickName = string.valueOf(math.random()).substring(0,6),
            ProfileID = p.id,
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            ContactID = newContactRecord.Id
        );
        insert u; 
        ID memberDocs = [Select Id from ContentWorkspace where Name = 'CFPC_Members_Docs'].Id;
        ID chapterLibraryId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Chapter Documents' LIMIT 1].Id;
        List<ContentDocument> cd = new List<ContentDocument>();
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        ContentVersion cv = new ContentVersion();
        cv.title = 'AB-Chapter-Letter_ENG_2022';        
        cv.VersionData = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'test content123'+'.'+'pdf';
        cv.Description ='en';
        contentVersions.add(cv);
        ContentVersion cv1 = new ContentVersion();
        cv1.title = 'AB-Chapter-Letter_ENG_2022';        
        cv1.VersionData = Blob.valueOf('Unit Test Attachment Body');
        cv1.PathOnClient = 'test content'+'.'+'pdf';
        cv1.Description ='en';
        contentVersions.add(cv1);
        insert contentVersions;
        
        List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
        contentVersions = [Select Id, ContentDocumentId from ContentVersion];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentVersions[0].ContentDocumentId;
        cdl.LinkedEntityId = memberDocs;   
        cdl.Sharetype = 'I';
        documentLinks.add(cdl);
        
        ContentDocumentLink cdd = new ContentDocumentLink();
        cdd.ContentDocumentId = contentVersions[1].ContentDocumentId;
        cdd.LinkedEntityId = chapterLibraryId;   
        cdd.Sharetype = 'I';
        documentLinks.add(cdd);
        insert documentLinks;
    }
    @isTest 
    static void getContentDocumentstest(){
        user u = [select Id from user where FirstName = 'Test-First' LIMIT 1];
        System.runAs(u) {
            getallContentDocs.getContentDocuments();
        }    
    }
    
}