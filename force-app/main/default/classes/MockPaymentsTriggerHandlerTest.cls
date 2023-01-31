@isTest
public class MockPaymentsTriggerHandlerTest {
    @isTest static void createmockpayment(){
        blng__BillingRule__c blr= new blng__BillingRule__c(Name='Test',blng__InitialBillingTrigger__c='Order Product Activation Date',blng__PartialPeriodTreatment__c='Separate',blng__PeriodTreatmentForBTDO__c='Exclude Billing Day of Month',blng__GenerateInvoices__c='Yes');
        insert blr;
        blng__RevenueRecognitionRule__c rev= new blng__RevenueRecognitionRule__c(Name='Test rev rec',blng__CreateRevenueSchedule__c='Yes',blng__Active__c=TRUE);
        insert rev;
        blng__TaxRule__c txc = new blng__TaxRule__c(Name='Test tax rule', blng__Active__c= TRUE, blng__TaxableYesNo__c='Yes');
        insert txc;
        Pricebook2 pbk = new Pricebook2(Name='Pricebook 2023-2024',IsActive = true);
        insert pbk;
        Product2 prd= new Product2(isactive=true, Name='Test1',Productcode='NF_SU',SBQQ__ChargeType__c='One-time',Family='Self Learning',blng__BillingRule__c=blr.Id,blng__RevenueRecognitionRule__c=rev.Id,blng__TaxRule__c=txc.Id);
        insert prd;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prd.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;
        PricebookEntry pbkent = new PricebookEntry(isactive=True,Pricebook2Id= pbk.Id, Product2Id= prd.Id,UnitPrice=80);
        insert pbkent;
        Account a = new Account(Name='TestAccount',CFPC_ID__c='642525');
        insert a;
        CFPC_Mock_Payment__c mockpayment = new CFPC_Mock_Payment__c();
        mockpayment.CFPC_Member_ID__c = '642525';
        mockpayment.CFPC_Product_Code__c = 'NF_SU'; 
        mockpayment.CFPC_Payment_Amount__c  = 500;
        mockpayment.CFPC_Source_System__c  = 'EXAM';
        mockpayment.CFPC_Status__c  = 'Billed';
        mockpayment.CFPC_Quantity_Ordered__c  = 1;
        mockpayment.CFPC_Order_Description__c  = 'Recognized Training Certification Outside CA Application Fee';
        mockpayment.CFPC_PO_NUM__c  = '5036';
        mockpayment.CFPC_Type__c  = 'VISA';
        mockpayment.CFPC_Transaction_Reference_ID__c  = '7036';
        mockpayment.CFPC_Transaction_Response_Code__c   = 'Transaction Reference ID';
        mockpayment.CFPC_OpenWater_ID__c   = '5036';
        mockpayment.CFPC_BT_ID__c   = '668196';
        mockpayment.CFPC_ST_ID__c   = '668196';
        mockpayment.CFPC_Billing_Type__c    = 'WEB';
        insert mockpayment;
        
        Test.StartTest();
       CFPC_Standlone_Order_creation_OW sch = new CFPC_Standlone_Order_creation_OW();

        String cronTrigger = '0 '+1+' * * * ?';
        System.schedule('OW_Standlone_order_scheduler_job',cronTrigger,sch);

		Test.stopTest();
        
    }
}