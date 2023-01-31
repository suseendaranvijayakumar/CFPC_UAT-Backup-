@isTest
public class CFPC_RedirectionLinksHelper_Test {
    
    @testSetup static void setup()  {
        
        blng__BillingRule__c blr= new blng__BillingRule__c(Name='Test',blng__InitialBillingTrigger__c='Order Product Activation Date',blng__PartialPeriodTreatment__c='Separate',blng__PeriodTreatmentForBTDO__c='Exclude Billing Day of Month',blng__GenerateInvoices__c='Yes');
        insert blr;
        blng__RevenueRecognitionRule__c rev= new blng__RevenueRecognitionRule__c(Name='Test rev rec',blng__CreateRevenueSchedule__c='Yes',blng__Active__c=TRUE);
        insert rev;
        blng__TaxRule__c txc = new blng__TaxRule__c(Name='Test tax rule', blng__Active__c= TRUE, blng__TaxableYesNo__c='Yes');
        insert txc;
        
        Product2 prd= new Product2(isactive=true, Name='Test1',Productcode='SEC SLP',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=5,Family='Self Learning');
        Product2 prd2= new Product2(isactive=true, Name='Test2',Productcode='FAFM',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=6,Family='Other');
        Product2 prd3= new Product2(isactive=true, Name='Test3',Productcode='SEC SK',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=7,Family='Chapter Fee');
        Product2 prd4= new Product2(isactive=true, Name='Test4',Productcode='SEC SL',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=7,Family='National Fee');
        
        insert prd;
        insert prd2;
        insert prd3;
        insert prd4;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        
        Pricebook2 pbk = new Pricebook2(Name='Pricebook 2022-2023',IsActive = true);
        insert pbk;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        
        PricebookEntry standardPBE2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd2.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE2;
        PricebookEntry standardPBE3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd3.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE3;
        PricebookEntry standardPBE4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd4.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE4;
        
        PricebookEntry pbkent = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd.Id,UnitPrice=80);
        insert pbkent;
        
        PricebookEntry pbkent2 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd2.Id,UnitPrice=90);
        insert pbkent2;
        
        PricebookEntry pbkent3 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd3.Id,UnitPrice=50);
        insert pbkent3;
        
        PricebookEntry pbkent4 = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd4.Id,UnitPrice=40);
        insert pbkent4;
        Account a = new Account(Name='TestAccount');
        insert a;
        
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
            CFPC_Class__c = 'LIFE',
            CFPC_Status__c = 'Active',
            CFPC_MINC_Number__c = '123',
            CFPC_Preferred_Language__c = 'English',
            CFPC_Chapter__c = ''
            
        );
        insert newContactRecord; 
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
        
        Opportunity oppoRecord1 = new Opportunity();
        oppoRecord1.CloseDate = System.today();
        oppoRecord1.Name = 'Test121';
        oppoRecord1.RecordTypeId = recordTypeId;
        oppoRecord1.StageName = 'Submitted';
        oppoRecord1.CFPC_Gender__c = 'Male';
        oppoRecord1.AccountId = accountRecord.Id;
        oppoRecord1.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord1.CFPC_Chapter_Province__c='SK';
        oppoRecord1.CFPC_New_Class__c='Learner';
        oppoRecord1.CFPC_Submission_Date__c=System.today();
        insert oppoRecord1;
        
        
        SBQQ__Quote__c qte = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
        qte.SBQQ__ProrationDayOfMonth__c='1';
        qte.SBQQ__Ordered__c=TRUE;
        Update qte;
        Order ord =[Select Name, Id,Status,blng__BillNow__c from Order where Opportunity.Name='Test121'];         
        ord.blng__BillNow__c=true;
        Update ord;
        blng__Invoice__c inv =[Select Name,blng__Account__c, Id  from blng__Invoice__c where blng__Order__c=:ord.Id];
        system.debug('inv ---'+inv);
        CFPC_Designation__c  desg = new CFPC_Designation__c ();
        desg.CFPC_Designation__c  = 'ESS';
        desg.CFPC_Member_Id__c= newContactRecord.Id;
        desg.CFPC_Designation_Status__c = 'Forfeit';
        insert desg;
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
    }
    @IsTest
    public static void cacValidationTest() {
        
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_CFPC_ID__c = '615890';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.cacValidation();
        }
    }
    @IsTest
    public static void cacValidationfirstElseTest() {
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where FirstName = 'Test-First' LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.cacValidation();
        }
    }
    @IsTest
    public static void emValidationTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_CFPC_ID__c = '653516 ';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.emValidation();
        }
    }
    @IsTest
    public static void emValidationElseTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_Class__c = 'LIFE';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c,contact.CFPC_Class__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseOpenWater());
            test.stopTest();
            RedirectionLinksHelper.emValidation();
        }
    } 
    
    @IsTest
    public static void fmValidationTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_CFPC_ID__c = '321322';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.fmValidation();
        }
    }
    @IsTest
    public static void FmValidationElseTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_Class__c = 'LIFE';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c,contact.CFPC_Class__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseOpenWater());
            test.stopTest();
            RedirectionLinksHelper.fmValidation();
        }
    } 
    @IsTest
    public static void aegValidationTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_CFPC_ID__c = '660004';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.aegValidation();
        }
    }
    @IsTest
    public static void aegValidationElseTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_Class__c = 'MBR';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            RedirectionLinksHelper.aegValidation();
        }
    }
    @IsTest
    public static void exValidationTest() {
        contact cn = [select Id,CFPC_CFPC_ID__c from contact where lastname ='Test Code1' LIMIT 1];
        cn.CFPC_CFPC_ID__c = '660004';
        update cn;
        user u = [select Id,contact.CFPC_CFPC_ID__c from user where ContactId =:cn.Id LIMIT 1];
        System.runAs(u) {
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseOpenWater());
            test.stopTest();
            RedirectionLinksHelper.exValidation();
        }
    }
    @IsTest
    public static void openWaterNavURLsTest(){
        RedirectionLinksHelper.openWaterNavURLs();
    }
    
}