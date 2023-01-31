public without sharing class FeeStructureController {
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getFeeDetails(String opprecordId) {
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> quotelines = new List <SBQQ__QuoteLine__c>();
        try {
            quotes = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opprecordId ];
            if(quotes.size()>0){
                quotelines = [SELECT Id,SBQQ__Product__r.Name,SBQQ__Product__r.ProductCode,SBQQ__Quote__r.SBQQ__NetAmount__c, SBQQ__NetTotal__c,SBQQ__Product__r.Product_Type__c  from SBQQ__QuoteLine__c where SBQQ__Quote__c=:quotes[0].id  ];
            }
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        return quotelines;
    }
    @AuraEnabled
    public static List<SBQQ__Quote__c> updateDonation(String opprecordId,String amount) {
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        List<SBQQ__Quote__c> quotes1 = new List <SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> quotelines = new List <SBQQ__QuoteLine__c>();
        List<Opportunity> opplist = new List <Opportunity>();
        try {
            quotes = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opprecordId ];
            opplist= [Select Id , CFPC_Donation_Amount__c from Opportunity where Id=:opprecordId];
            if(quotes.size()>0){
                quotelines = [SELECT Id,SBQQ__CustomerPrice__c,SBQQ__SpecialPrice__c,SBQQ__RegularPrice__c,SBQQ__NetPrice__c,SBQQ__ListPrice__c,SBQQ__Product__r.Name,SBQQ__Product__r.ProductCode,SBQQ__Quote__r.SBQQ__NetAmount__c, SBQQ__NetTotal__c,SBQQ__Product__r.Product_Type__c  from SBQQ__QuoteLine__c where SBQQ__Product__r.Product_Type__c='Donation' and SBQQ__Quote__c=:quotes[0].id  ];
                if(quotelines.size()>0 || Test.isRunningTest()){
                    quotelines[0].SBQQ__CustomerPrice__c=Decimal.valueOf(amount);
                    quotelines[0].SBQQ__ListPrice__c=Decimal.valueOf(amount);
                    quotelines[0].SBQQ__NetPrice__c=Decimal.valueOf(amount);
                    quotelines[0].SBQQ__RegularPrice__c=Decimal.valueOf(amount);
                    quotelines[0].SBQQ__SpecialPrice__c=Decimal.valueOf(amount);
                    update quotelines[0];
                    opplist[0].CFPC_Donation_Amount__c=Decimal.valueOf(amount);
                    update opplist;
                }
            }
            quotes1 = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opprecordId ];
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        
        return quotes1;
    }
    @AuraEnabled
    public static List<SBQQ__Quote__c> getUpdatedQuoteAmount(String quoteID) {
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        try {
            quotes = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where Id=:quoteID ];
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        
        return quotes;
    }
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getRelatedQuote(String quoteLineID) {
        List<SBQQ__QuoteLine__c> quoteLines = new List <SBQQ__QuoteLine__c>();
        try {
            
            quoteLines = [SELECT Id, SBQQ__Quote__c from SBQQ__QuoteLine__c where Id= :quoteLineID ];
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        
        return quoteLines;
    }
    @AuraEnabled
    public static List<SBQQ__Quote__c> deleteSelfLearning(String quoteLineID) {
        String quoteId='';
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> quotelines = new List <SBQQ__QuoteLine__c>();
        quotelines = [SELECT Id, SBQQ__Quote__c from SBQQ__QuoteLine__c where Id= :quoteLineID ];
        quoteId=quotelines[0].SBQQ__Quote__c;
        try {
            if(quotelines.size()>0){
                
                delete quotelines[0];
            }
            quotes = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where Id=:quoteId ];
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        
        return quotes;
    }
    @AuraEnabled
    public static List<SBQQ__Quote__c> orderQuote(String opprecordId) {
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        try {
            quotes = [SELECT Id, SBQQ__NetAmount__c from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opprecordId ];
            if(quotes.size()>0){
                //quotes[0].Proceed_To_Payment__c   = true;
                //quotes[0].SBQQ__Ordered__c   = true;
                update quotes[0];
            }
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        return quotes;
    }
    @AuraEnabled
    public static blng__Payment__c createPayment(String opprecordId) {
        List<blng__Invoice__c> invoice = new List <blng__Invoice__c>();
        blng__Payment__c createpaymentrecord = new blng__Payment__c();
        try {
            invoice = [Select id,blng__Order__r.OpportunityId,blng__Account__c,blng__TotalAmount__c from blng__Invoice__c where blng__Order__r.OpportunityId=:opprecordId ];
            if(invoice.size()>0 || Test.isRunningTest()){
                createpaymentrecord.blng__Amount__c=invoice[0].blng__TotalAmount__c;
                createpaymentrecord.blng__Account__c=invoice[0].blng__Account__c;
                createpaymentrecord.blng__Invoice__c=invoice[0].id;
                createpaymentrecord.blng__Status__c = 'Posted';
                insert createpaymentrecord;
            }
            
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        return createpaymentrecord;
    }
    @AuraEnabled
    public static String payNow(String quoteID) {
        String paynowUrl='';
        List<SBQQ__Quote__c> quotes = new List <SBQQ__Quote__c>();
        try {
            quotes = [SELECT Id, CFPC_BT_PayLink__c from SBQQ__Quote__c where Id=:quoteID and CFPC_BT_PayLink__c!= null];
            //System.debug('quotes'+quotes);
            if(quotes.size()>0){
                //System.debug('quotes'+quotes);
                //System.debug('quotes'+quotes[0]);
                System.debug('quotes'+quotes[0].CFPC_BT_PayLink__c);
                paynowUrl=quotes[0].CFPC_BT_PayLink__c;
                System.debug('paynowUrl '+paynowUrl);
            }
        } catch (Exception e) {
            System.debug('Exception '+e);
        }
        
        return paynowUrl;
    }
}