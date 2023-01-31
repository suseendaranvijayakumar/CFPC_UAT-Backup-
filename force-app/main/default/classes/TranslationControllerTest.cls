@isTest 
public class TranslationControllerTest {
    @isTest 
    public static void CreateTestData(){
        Id accountRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CFPC Account').getRecordTypeId();       
        Account accRec = new Account();
        accRec.Name = 'Test Account';
        accRec.RecordTypeId = accountRecordId;
        INSERT accRec;
        
        Contact conRec1 = new Contact();
        Id contactRecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_B_Member').getRecordTypeId();
        conRec1.AccountId = accRec.Id;
        conRec1.LastName = 'Test Code1';
        //conRec1.CFPC_ID_Auto_Num__c = 123;
        conRec1.CFPC_Bill_End_Date__c = Date.newInstance(2022, 08, 24);
        conRec1.CFPC_Preferred_Language__c = 'English';
        conRec1.Email = 'test@test.com';
        conRec1.CFPC_Gender__c = 'Male';
        conRec1.CFPC_Class__c = 'IMG';
        conRec1.CFPC_Status__c = 'Active';
        conRec1.CFPC_MINC_Number__c = '123';
        conRec1.RecordTypeId = contactRecordtypeId;
        
        INSERT conRec1;
        
        /*ntact conRec2 = new Contact();
conRec2.AccountId = accRec.Id;
conRec2.LastName = 'Test Code1';
conRec2.CFPC_Bill_End_Date__c = Date.newInstance(2022, 08, 24);
conRec2.CFPC_Preferred_Language__c = 'French;
conRec2.Email = 'test@test.com';
conRec2.CFPC_Gender__c = 'M';
conRec2.CFPC_Class__c = 'IMG';
conRec2.CFPC_Status__c = 'Active';
conRec2.CFPC_MINC_Number__c = '123';
conRec2.RecordTypeId = contactRecordtypeId;

INSERT conRec2;*/
        
        Profile profileRec  = [SELECT Id FROM Profile WHERE Name = 'CFPC Member' limit 1];
        User userRecord = new User();
        userRecord.LastName = 'Test Code1';
        userRecord.Email = 'test@test.com';
        userRecord.Alias = 'Tcode';
        userRecord.Username = 'test1234444@tes1t.com';
        userRecord.ContactId = conRec1.Id;
        userRecord.ProfileId = profileRec.Id;
        userRecord.TimeZoneSidKey = 'America/New_York';
        userRecord.EmailEncodingKey = 'UTF-8';
        userRecord.LanguageLocaleKey = 'en_US';
        userRecord.LocaleSidKey = 'en_US';
        userRecord.IsActive = true;
        
        INSERT userRecord;
        
        Id OpprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'Test Opportunity';
        oppRec.CFPC_Submission_Date__c = Date.today().addDays(10);
        oppRec.AccountId = conRec1.AccountId;
        oppRec.RecordTypeId = OpprecordTypeId;
        oppRec.CloseDate = Date.today().addDays(10);
        oppRec.StageName = 'Prospecting';
        oppRec.CFPC_Gender__c = 'Male';
        
        INSERT oppRec;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id',conRec1.Id);
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(oppRec);
        TranslationController translationObj = new TranslationController(stdcontroller);
        TranslationController.PdfDataWrapper pdfWrapperObj = new TranslationController.PdfDataWrapper();
        pdfWrapperObj.formattedDate(oppRec.CFPC_Submission_Date__c, 'dd MMMM yyyy');
        pdfWrapperObj.setOpportunityDetails(oppRec);
        pdfWrapperObj.setContactDetails(conRec1);
        
        Test.stopTest();
    }
}