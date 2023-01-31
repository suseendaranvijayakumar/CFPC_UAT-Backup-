@isTest 
public class FeeStructureControllerTest {
    @testSetup static void setup()  {
        
        blng__BillingRule__c blr= new blng__BillingRule__c(Name='Test',blng__InitialBillingTrigger__c='Order Product Activation Date',blng__PartialPeriodTreatment__c='Separate',blng__PeriodTreatmentForBTDO__c='Exclude Billing Day of Month',blng__GenerateInvoices__c='Yes');
        insert blr;
        
        blng__RevenueRecognitionRule__c rev= new blng__RevenueRecognitionRule__c(Name='Test rev rec',blng__CreateRevenueSchedule__c='Yes',blng__Active__c=TRUE);
        insert rev;
        
        blng__TaxRule__c txc = new blng__TaxRule__c(Name='Test tax rule', blng__Active__c= TRUE, blng__TaxableYesNo__c='Yes');
        insert txc;
        
        Product2 prd= new Product2(isactive=true, Name='Test1',Productcode='SEC SLP',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=5,Family='Self Learning');
        Product2 prd2= new Product2(isactive=true, Name='Test2',Productcode='FAFM',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=6,Family='Donation',Product_Type__c='Donation');
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
            CFPC_Class__c = 'IMG',
            CFPC_Status__c = 'Active',
            CFPC_MINC_Number__c = '123',
            CFPC_Preferred_Language__c = 'English'
        );
        insert newContactRecord; 
        
        
        Account acc= [Select Name,Id from Account where Name='TestAccount'];
        System.debug('Fetch account'+acc);
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
        Id recordTypeId_reins = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reinstatement').getRecordTypeId();
        
        
        
        Opportunity oppoRecord1 = new Opportunity();
        oppoRecord1.CloseDate = System.today();
        oppoRecord1.Name = 'Test121';
        oppoRecord1.RecordTypeId = recordTypeId;
        oppoRecord1.StageName = 'Submitted';
        oppoRecord1.CFPC_Gender__c = 'Male';
        oppoRecord1.AccountId = acc.Id;
        oppoRecord1.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord1.CFPC_Chapter_Province__c='SK';
        oppoRecord1.CFPC_New_Class__c='Learner';
        oppoRecord1.CFPC_Submission_Date__c=System.today();
        
        
        
        
        insert oppoRecord1;
        SBQQ__Quote__c qte = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
        System.debug('quote '+qte);
    }
    public static testMethod  void testgetData(){
        
        
        
        
        Opportunity oppoRecord1 = [ Select Name, Id  from Opportunity];
        String opp = oppoRecord1.id+'' ;
        String amt= '100';
        List<SBQQ__QuoteLine__c> quotelines = new List <SBQQ__QuoteLine__c>();
        
        
        SBQQ__Quote__c qte = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id]; //where SBQQ__Opportunity2__c=: oppoRecord1.Id
        quotelines = [SELECT Id, SBQQ__Quote__c from SBQQ__QuoteLine__c ];
        FeeStructureController.getFeeDetails(opp);
        FeeStructureController.updateDonation(opp,amt);
        FeeStructureController.getUpdatedQuoteAmount(qte.Id);
        FeeStructureController.getRelatedQuote(qte.Id);
        FeeStructureController.deleteSelfLearning(quotelines[0].id);
        FeeStructureController.orderQuote(opp);
        FeeStructureController.createPayment(opp);
        FeeStructureController.payNow(qte.Id);
    }
    
}