@isTest
public class CFPC_Bulk_Job_test {
    
    @testSetup static void setup()  {
    
         blng__BillingRule__c blr= new blng__BillingRule__c(Name='Test',blng__InitialBillingTrigger__c='Order Product Activation Date',blng__PartialPeriodTreatment__c='Separate',blng__PeriodTreatmentForBTDO__c='Exclude Billing Day of Month',blng__GenerateInvoices__c='Yes');
        insert blr;
       
       blng__RevenueRecognitionRule__c rev= new blng__RevenueRecognitionRule__c(Name='Test rev rec',blng__CreateRevenueSchedule__c='Yes',blng__Active__c=TRUE);
       insert rev;
       
       blng__TaxRule__c txc = new blng__TaxRule__c(Name='Test tax rule', blng__Active__c= TRUE, blng__TaxableYesNo__c='Yes');
       insert txc;
       
        Product2 prd= new Product2(isactive=true, Name='Test1',Productcode='SEC SLP',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=12,Family='Self Learning',SBQQ__SubscriptionPricing__c='Fixed Price',SBQQ__SubscriptionType__c='Renewable',SBQQ__SubscriptionBase__c='List');
        Product2 prd2= new Product2(isactive=true, Name='Test2',Productcode='FAFM',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',Family='Other',SBQQ__SubscriptionBase__c='List',SBQQ__SubscriptionType__c='One-time');
        Product2 prd3= new Product2(isactive=true, Name='Test3',Productcode='SEC SK',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=12,Family='Chapter Fee',SBQQ__SubscriptionPricing__c='Fixed Price',SBQQ__SubscriptionType__c='Renewable',SBQQ__SubscriptionBase__c='List');
        Product2 prd4= new Product2(isactive=true, Name='Test4',Productcode='SEC SL',SR_ProductFilter__c='Learner;SK',SBQQ__ChargeType__c='Recurring',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id,SBQQ__BillingType__c='Advance',SBQQ__BillingFrequency__c='Monthly',SBQQ__SubscriptionTerm__c=12,Family='National Fee',SBQQ__SubscriptionPricing__c='Fixed Price',SBQQ__SubscriptionType__c='Renewable',SBQQ__SubscriptionBase__c='List');
        
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
        
       
        Id accountRecordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CFPC Account').getRecordTypeId();        
        Account accountRecord = new Account();
        accountRecord.Name = 'Test Account';
        accountRecord.SBQQ__RenewalModel__c='Contract Based';
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
        oppoRecord1.CFPC_Submission_Date__c=date.newinstance(2022,07,01);
        
        Opportunity oppoRecord2 = new Opportunity();
        oppoRecord2.CloseDate = System.today();
        oppoRecord2.Name = 'Testlowamount';
        oppoRecord2.RecordTypeId = recordTypeId;
        oppoRecord2.StageName = 'Submitted';
        oppoRecord2.CFPC_Gender__c = 'Male';
        oppoRecord2.AccountId = accountRecord.Id;
        oppoRecord2.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord2.CFPC_Chapter_Province__c='SK';
        oppoRecord2.CFPC_New_Class__c='Learner';
        oppoRecord2.CFPC_Submission_Date__c=date.newinstance(2022,08,01);
        
      
        
       insert oppoRecord1;
       insert oppoRecord2;

          
     
          SBQQ__Quote__c qte = [ Select Name, Id, SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
          qte.SBQQ__ProrationDayOfMonth__c='1';
          
          qte.SBQQ__Ordered__c=TRUE;
          Update qte;
         
         
      

    
    }
    @isTest static void Amendment_job_test() {
        List<SBQQ__Subscription__c> subtm = new List<SBQQ__Subscription__c>();
      
        
        Order ord =[Select Name,TotalAmount,AccountId,OpportunityId,Pricebook2Id, Id,EffectiveDate,EndDate,Status,blng__BillNow__c,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__EndDate__c,SBQQ__Quote__r.SBQQ__SubscriptionTerm__c,SBQQ__Contracted__c from Order where Opportunity.Name='Test121'];
        List<OrderItem> orditem =[Select SBQQ__QuoteLine__c,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c,Product2Id,SBQQ__QuoteLine__r.Name,Product2.Name,Id,SBQQ__Subscription__c,SBQQ__SubscriptionPricing__c,SBQQ__SubscriptionTerm__c,SBQQ__SubscriptionType__c,SBQQ__Status__c from OrderItem where OrderId=:ord.Id];
         
       
        ord.blng__BillNow__c=true;
        
        
        Update ord;
        
        
         Contract testContract = new Contract( 
                    AccountId = ord.AccountId,
                    Name = ord.Name,
                    SBQQ__Opportunity__c=ord.OpportunityId,
                    StartDate = date.newinstance(2022,07,01),
                    ContractTerm=Integer.valueOf(ord.SBQQ__Quote__r.SBQQ__SubscriptionTerm__c),
                    SBQQ__RenewalPricebookId__c=ord.Pricebook2Id,
                    SBQQ__Quote__c=ord.SBQQ__Quote__c,
                    SBQQ__AmendmentPricebookId__c=ord.Pricebook2Id,
                    SBQQ__AmendmentStartDate__c=ord.EffectiveDate,
                    SBQQ__Order__c=ord.Id,
                    Status = 'Draft'
                    
                );
        
        Insert testContract;
        
         
        
        for(OrderItem otm: orditem){
            SBQQ__Subscription__c sbt= new SBQQ__Subscription__c(SBQQ__Account__c=ord.AccountId,SBQQ__Contract__c=testContract.ID,SBQQ__Product__c=otm.Product2Id,SBQQ__Quantity__c=1,SBQQ__ChargeType__c=otm.SBQQ__ChargeType__c,SBQQ__BillingType__c=otm.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=otm.SBQQ__BillingFrequency__c);
            subtm.add(sbt);
        }
       Insert subtm;
        
       
        
        Contact cnt=[Select name,AccountId,CFPC_Status__c,Id from Contact where name='Test Code1'];
       
        cnt.CFPC_Membership_Discontinued_Date__c=Date.today();
        cnt.CFPC_Membership_Discontinued_Reason__c = 'Non-Payment';
        cnt.CFPC_Status__c='Discontinued';
        
        Test.StartTest();
        Update cnt;
        Test.stopTest();
        
  }
 
    
    

}