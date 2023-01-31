@isTest 
public class OpportunityTriggerTest { 
    @testSetup
    static void createData(){
        
           blng__BillingRule__c blr= new blng__BillingRule__c(Name='Test',blng__InitialBillingTrigger__c='Order Product Activation Date',blng__PartialPeriodTreatment__c='Separate',blng__PeriodTreatmentForBTDO__c='Exclude Billing Day of Month',blng__GenerateInvoices__c='Yes');
        insert blr;
       
       blng__RevenueRecognitionRule__c rev= new blng__RevenueRecognitionRule__c(Name='Test rev rec',blng__CreateRevenueSchedule__c='Yes',blng__Active__c=TRUE);
       insert rev;
       
       blng__TaxRule__c txc = new blng__TaxRule__c(Name='Test tax rule', blng__Active__c= TRUE, blng__TaxableYesNo__c='Yes');
       insert txc;
       
        Product2 prd= new Product2(isactive=true, Name='Test1',Productcode='SEC SLP',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=5,Family='Self Learning');
        Product2 prd2= new Product2(isactive=true, Name='Test2',Productcode='FAFM',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=6,Family='Other');
        Product2 prd3= new Product2(isactive=true, Name='Test3',Productcode='SEC SK',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=7,Family='Chapter Fee');
        Product2 prd4= new Product2(isactive=true, Name='Test4',Productcode='SEC SL',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=7,Family='National Fee');
        Product2 prd5= new Product2(isactive=true, Name='Test5',Productcode='NF_AD',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=7,Family='Administrative');
        
        insert prd;
        insert prd2;
        insert prd3;
        insert prd4;
        insert prd5;
       
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        
        Pricebook2 pbk = new Pricebook2(Name='Pricebook 2022-2023',IsActive = true);
        insert pbk;
        Id pricebookId = Test.getStandardPricebookId();
        //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
       PricebookEntry standardPBE2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd2.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE2;
       PricebookEntry standardPBE3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd3.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE3;
       PricebookEntry standardPBE4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd4.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE4;
       
       PricebookEntry standardPBE5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd5.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE5;

        PricebookEntry pbkent = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd.Id,UnitPrice=80);
        insert pbkent;
       
       PricebookEntry pbkent2 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd2.Id,UnitPrice=90);
        insert pbkent2;
       
       PricebookEntry pbkent3 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd3.Id,UnitPrice=50);
        insert pbkent3;
       
       PricebookEntry pbkent4 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd4.Id,UnitPrice=40);
        insert pbkent4;
       
       PricebookEntry pbkent5 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd5.Id,UnitPrice=50);
        insert pbkent5;
        
        
        
        //Create Account
        Id accountRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CFPC Account').getRecordTypeId();        
        Account accountRecord = new Account();
        accountRecord.Name = 'Test Account';
        accountRecord.RecordTypeId = accountRecordId;
        insert accountRecord;
        
        //Create Contact
        Contact newContactRecord = new Contact(
            //FirstName = 'Test',
            LastName = 'Test Code1',
            AccountId = accountRecord.Id,
            Email = 'test@test.com',
            RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Group_B_Member').getRecordTypeId(),
            CFPC_Gender__c = 'Male',
            CFPC_Class__c = 'IMG',
            CFPC_Status__c = 'Active',
            CFPC_MINC_Number__c = '123',
            CFPC_Preferred_Language__c = 'English'
        );
        insert newContactRecord; 
        
        //Create Opportunity
        Opportunity oppoRecord = new Opportunity();
        oppoRecord.CloseDate = System.today();
        oppoRecord.Name = 'Test';
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
        oppoRecord.RecordTypeId = recordTypeId;
        oppoRecord.StageName = 'Prospecting';
        oppoRecord.CFPC_Gender__c = 'Male';
        oppoRecord.AccountId = accountRecord.Id;
        oppoRecord.CFPC_Chapter_Province__c='SK';
        oppoRecord.CFPC_New_Class__c='Learner';
        oppoRecord.CFPC_Submission_Date__c=date.newinstance(2022,07,01);
        insert oppoRecord;
        
        //Create User
        Profile profileRec  = [SELECT Id FROM Profile WHERE Name = 'CFPC Member' limit 1];
        User userRecord = new user(
            // UserRoleId = r.Id,
            LastName = 'Test Code1',
            Email = 'test@test.com',
            Alias = 'Tcode',
            Username = 'test1234444@tes1t.com',
            ContactId = newContactRecord.id,
            ProfileId = profileRec.Id,
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true
        );
        //INSERT userRecord;
    }
    
    @isTest
    static void createTestData() {
        Opportunity oppoRecord = [SELECT Id, Name, CloseDate, AccountId, CFPC_Gender__c, StageName
                                  FROM Opportunity 
                                  WHERE Name = 'Test' 
                                  LIMIT 1]; 
        
        /*User userRecord = [SELECT Id, LastName, Email, Alias, Username, ContactId, ProfileId, TimeZoneSidKey, EmailEncodingKey, 
                           LanguageLocaleKey, LocaleSidKey 
                           FROM User
                           WHERE LastName = 'Test Code1'];*/

            Test.startTest();
            oppoRecord.StageName = 'Approved'; 
            update oppoRecord;
            Test.stopTest();
    }
}