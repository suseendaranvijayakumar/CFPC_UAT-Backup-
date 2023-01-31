@isTest
public class CFPC_Bulk_Renewal_test {

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
        
        
        
                
       insert oppoRecord1;
       
          
     
          SBQQ__Quote__c qte = [ Select Name, Id, SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
          qte.SBQQ__ProrationDayOfMonth__c='1';
          
          qte.SBQQ__Ordered__c=TRUE;
          Update qte;
         
      }
    @isTest static void Bulk_Renewal_job_test() {
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
                    Selected_for_Bulk_Renewal__c='No',
                    
                    Status = 'Draft'
                    
                );
        
        Insert testContract;
        
         
        System.debug('Order item'+orditem);
        for(OrderItem otm: orditem){
            SBQQ__Subscription__c sbt= new SBQQ__Subscription__c(SBQQ__Account__c=ord.AccountId,SBQQ__Contract__c=testContract.ID,SBQQ__Product__c=otm.Product2Id,SBQQ__Quantity__c=1,SBQQ__ChargeType__c=otm.SBQQ__ChargeType__c,SBQQ__BillingType__c=otm.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=otm.SBQQ__BillingFrequency__c);
            subtm.add(sbt);
        }
       Insert subtm;
        
        
        System.debug(' before first jobContract'+testContract);
         Id Renewal_recordTypeId = Schema.SObjectType.Bulk_Job__c.getRecordTypeInfosByDeveloperName().get('Renewal').getRecordTypeId();
        
          Bulk_Job__c blkjob2= new Bulk_Job__c();
        blkjob2.Name='Bulk Renewal identifictaion';
        blkjob2.Job_Type__c='Identify Bulk Renewal records';
        blkjob2.Job_Run_Date__c=Datetime.newInstance(2024,02, 2, 12, 30, 2);
        blkjob2.Record_To_Process__c='All';
        blkjob2.RecordTypeId=Renewal_recordTypeId;
        
         System.debug('after first job Contract'+testContract);
         testContract.Selected_for_Bulk_Renewal__c= 'Yes';
         Update testContract;
        
        
          Bulk_Job__c blkjob5= new Bulk_Job__c();
        blkjob5.Name='Bulk Renewal Quote generation';
        blkjob5.Job_Type__c='Bulk Renewal Quote Generation';
        blkjob5.Job_Run_Date__c=Datetime.newInstance(2024,02, 3, 12, 40, 2);
        blkjob5.Record_To_Process__c='All';
        blkjob5.RecordTypeId=Renewal_recordTypeId;
    
       
        
        Test.StartTest();
        
        Insert blkjob2;
        
        
        Insert blkjob5;
        //Insert blkjob6;
        Test.stopTest();
      
    }
    
    @isTest static void Opportunitycreation() {
        Id Renewal_recordTypeId = Schema.SObjectType.Bulk_Job__c.getRecordTypeInfosByDeveloperName().get('Renewal').getRecordTypeId();
        
        Id recordTypeId_Opprenewal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Account acc= [Select Name,Id from Account where Name='Test Account'];
        
        Opportunity oppoRecord1 = new Opportunity();
        oppoRecord1.CloseDate = System.today();
        oppoRecord1.Name = 'Test121';
        //oppoRecord1.RecordTypeId = recordTypeId_Opprenewal;
        oppoRecord1.StageName = 'Submitted';
        oppoRecord1.CFPC_Gender__c = 'Male';
        oppoRecord1.AccountId = acc.Id;
        oppoRecord1.CFPC_Self_Learning_Program__c=TRUE;
        oppoRecord1.CFPC_Chapter_Province__c='SK';
        oppoRecord1.CFPC_New_Class__c='Learner';
        oppoRecord1.CFPC_Submission_Date__c=System.today();
        
        insert oppoRecord1;
        
        SBQQ__Quote__c qte = [ Select Name, Id ,Quote_From_BulkRenewal__c,SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c,SBQQ__Type__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
       
        qte.SBQQ__ProrationDayOfMonth__c='1';
        qte.Quote_From_BulkRenewal__c=TRUE;
        Update qte;
        
         Bulk_Job__c blkjob6= new Bulk_Job__c();
        blkjob6.Name='Bulk Renewal Order generation';
        blkjob6.Job_Type__c='Bulk Renewal Order Generation';
        blkjob6.Job_Run_Date__c=Datetime.newInstance(2024,02, 3, 12, 50, 2);
        blkjob6.Record_To_Process__c='All';
        blkjob6.RecordTypeId=Renewal_recordTypeId;
        
        Test.StartTest();
        Insert blkjob6;
        Test.stopTest();
    }

      

}