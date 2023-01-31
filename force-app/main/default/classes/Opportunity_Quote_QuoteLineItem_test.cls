@isTest
public class Opportunity_Quote_QuoteLineItem_test {
    
    
   @testSetup static void setup()  {
       
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
       
        Account a = new Account(Name='TestAccount');
        insert a;
       
        Id accountRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CFPC Account').getRecordTypeId();        
        Account accountRecord = new Account();
        accountRecord.Name = 'Test Account1';
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
            CFPC_Preferred_Language__c = 'English',
            Self_Learning_Program_Marketing__c=True,
            CFPC_New_Class__c='Practicing',
            CFPC_Chapter__c='ON',
            CFPC_First_Year_Practicing__c='Yes',
            CFPC_Reduced_Fee__c='No'
            
        );
        insert newContactRecord; 
       
       Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
       Id recordTypeId_reins = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reinstatement').getRecordTypeId();
       Id recordTypeId_renewal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
       
        /*Opportunity oppoRecord = new Opportunity();
        oppoRecord.CloseDate = System.today();
        oppoRecord.Name = 'Test';
        oppoRecord.RecordTypeId = recordTypeId;
        oppoRecord.StageName = 'Prospecting';
        oppoRecord.CFPC_Gender__c = 'Male';
        oppoRecord.AccountId = accountRecord.Id;
        oppoRecord.CFPC_Submission_Date__c=System.today(); */
       
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
       
        Opportunity oppoRecord2 = new Opportunity();
        oppoRecord2.CloseDate = System.today();
        oppoRecord2.Name = 'Test_Reinstatement';
        oppoRecord2.RecordTypeId = recordTypeId_reins;
        oppoRecord2.StageName = 'Submitted';
        oppoRecord2.CFPC_Gender__c = 'Male';
        oppoRecord2.AccountId = accountRecord.Id;
        oppoRecord2.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord2.CFPC_Chapter_Province__c='SK';
        oppoRecord2.CFPC_New_Class__c='Learner';
        oppoRecord2.CFPC_Submission_Date__c=System.today();
       
       Opportunity oppoRecord3 = new Opportunity();
        oppoRecord3.CloseDate = System.today();
        oppoRecord3.Name = 'Test_Renewal';
        oppoRecord3.RecordTypeId = recordTypeId_renewal;
        oppoRecord3.StageName = 'Submitted';
        oppoRecord3.CFPC_Gender__c = 'Male';
        oppoRecord3.AccountId = accountRecord.Id;
        oppoRecord3.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord3.CFPC_Chapter_Province__c='SK';
        oppoRecord3.CFPC_New_Class__c='Learner';
        oppoRecord3.CFPC_Submission_Date__c=System.today();
       
        
        //insert oppoRecord;
        insert oppoRecord1;
        insert oppoRecord2;
        insert oppoRecord3;
       
       
        
    }
    
    
     @isTest static void Opportunitycreation() {
       
         Id recordTypeId_renewal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
         
        Account acc= [Select Name,Id from Account where Name='TestAccount'];
         Account acc2= [Select Name,Id from Account where Name='Test Account1'];
        System.debug('Fetch account'+acc);
       Opportunity opp4 = new Opportunity(Name='Test opportunity4',
                                       StageName='Submitted',
                                       CloseDate=System.today().addMonths(1),CFPC_Submission_Date__c=System.today(),CFPC_New_Class__c='Learner',CFPC_First_Year_Practicing_FYP__c=TRUE);
         
        Opportunity opp5 = new Opportunity(Name='Test opportunity5',
                                       StageName='Submitted',
                                       CloseDate=System.today().addMonths(1),CFPC_Submission_Date__c=System.today(),CFPC_Chapter_Province__c='Sk',CFPC_Reduced_Fee__c=TRUE,CFPC_Donation_Amount__c=100);
          
       /* Opportunity oppoRecord = [SELECT Id, Name, CloseDate, AccountId, CFPC_Gender__c, StageName,RecordType.Name
                                  FROM Opportunity 
                                  WHERE Name = 'Test' 
                                  LIMIT 1]; */
        Opportunity opprenewal = new Opportunity(Name='Test opportunity3',
                                       StageName='Submitted',RecordTypeId = recordTypeId_renewal,
                                       CloseDate=System.today().addMonths(1),CFPC_Submission_Date__c=System.today(),AccountId=acc2.Id);
          Test.startTest();
          
        
          
          insert opp4;
          insert opp5;
          insert opprenewal;
         
         // oppoRecord.StageName = 'Approved'; 
         // update oppoRecord;
          
          Test.stopTest();
        
    
    }
    
    
 
    @isTest static void Ordercreation() {
        Opportunity oppRec = [SELECT Id, Name, CloseDate, AccountId, CFPC_Gender__c, StageName
                                  FROM Opportunity 
                                  WHERE Name = 'Test121' 
                                  LIMIT 1];
        
        SBQQ__Quote__c qte = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppRec.Id];
        //System.debug('Quote update'+qte.SBQQ__StartDate__c);
        List <SBQQ__QuoteLine__c> qtline = [ Select Name, Id,SBQQ__Quote__c,SBQQ__Product__c,SBQQ__ProductName__c from SBQQ__QuoteLine__c where SBQQ__Quote__c=:qte.Id];
        //System.debug('Quote line update'+qtline);
        
        qte.SBQQ__ProrationDayOfMonth__c='1';
        qte.Proceed_To_Payment__c=TRUE;
      
        // System.debug('Quote update++'+qte);
        Test.StartTest();
       
        Update qte;
		ScheduleOrder_Creation sch = new ScheduleOrder_Creation();

        String cronTrigger = '0 '+1+' * * * ?';
        System.schedule('Apex job to update quote in every 1 minute to proceed to order',cronTrigger,sch);

		Test.stopTest();
       
      
        
       
        
    }
    
   
   
}