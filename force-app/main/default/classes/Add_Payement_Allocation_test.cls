@isTest
public class Add_Payement_Allocation_test {
    
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
        oppoRecord1.CFPC_Submission_Date__c=System.today();
        
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
        oppoRecord2.CFPC_Submission_Date__c=System.today();
        
        
       insert oppoRecord1;
       insert oppoRecord2;
          
     
          SBQQ__Quote__c qte = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord1.Id];
          qte.SBQQ__ProrationDayOfMonth__c='1';
          
          qte.SBQQ__Ordered__c=TRUE;
          
         // SBQQ__Quote__c qte1 = [ Select Name, Id , SBQQ__Ordered__c,SBQQ__StartDate__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=: oppoRecord2.Id];
         // qte1.SBQQ__ProrationDayOfMonth__c='1';
          
         // qte1.SBQQ__Ordered__c=TRUE;
          
          Update qte;
          //Update qte1;
          

       
        
    }
 
     @isTest static void Paymentcreation() {
         
         Order ord =[Select Name, Id,Status,blng__BillNow__c from Order where Opportunity.Name='Test121'];
         
         
         ord.blng__BillNow__c=true;
         
         // Order ord1 =[Select Name, Id,Status,blng__BillNow__c from Order where Opportunity.Name='Testlowamount'];
         // ord1.blng__BillNow__c=true;
         
         Update ord;
        // Update ord1;
         blng__Invoice__c inv =[Select Name,blng__Account__c, Id  from blng__Invoice__c where blng__Order__c=:ord.Id];
         //blng__Invoice__c inv2 =[Select Name,blng__Account__c, Id  from blng__Invoice__c where blng__Order__c=:ord1.Id];
        
         
         blng__Payment__c pymnt= new blng__Payment__c();
         pymnt.blng__Account__c=inv.blng__Account__c;
         pymnt.blng__Amount__c=100;
         pymnt.blng__Invoice__c=inv.Id;
         pymnt.blng__PaymentDate__c=System.Today();
         
         blng__Payment__c pymnt1= new blng__Payment__c();
         pymnt1.blng__Account__c=inv.blng__Account__c;
         pymnt1.blng__Amount__c=1;
         pymnt1.blng__Invoice__c=inv.Id;
         pymnt1.blng__PaymentDate__c=System.Today();
         
         blng__Payment__c pymnt2= new blng__Payment__c();
         pymnt2.blng__Account__c=inv.blng__Account__c;
         pymnt2.blng__Amount__c=2;
         pymnt2.blng__Invoice__c=inv.Id;
         pymnt2.blng__PaymentDate__c=System.Today();
         
         
         
         Test.StartTest();
         Insert pymnt1;
         Insert pymnt2;
         Insert pymnt;
         
       

		 Test.stopTest();
}
}