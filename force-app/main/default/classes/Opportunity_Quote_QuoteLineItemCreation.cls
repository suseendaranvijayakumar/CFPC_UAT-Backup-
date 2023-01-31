public class Opportunity_Quote_QuoteLineItemCreation {
    
     /*
     * Developed by Suseendaran.v
     * This Class run after the insert of memebr application (opportunity) which creates quotes and add products to the quote line item based on the two field on memeber application ( Neww class and Chapter province)
     * This class is called from Opportunity trigger ( after insert and after update)
     */
     public static void afterInsert(List<Opportunity> newOppList, Map<Id,Opportunity> oldOpportunityMap){
         
         /* This method run after the insert of opportunity record
          * 
          * below we are declaring some variables
          * recordTypeId_new_application = Record type id of new application
          * recordTypeId_Renewal = Record type id of Renewal application
          * recordTypeId_Reinstatement= Record type id of Reinstatement application
          */
         Id recordTypeId_new_application;
         Id recordTypeId_Renewal;
         Id recordTypeId_Reinstatement;
         String quoteId='';
         List<Opportunity> OppList= newOppList;
         List<Pricebook2> priceBook = new List<Pricebook2>();
         Map<Id,PriceBookEntry> mapPriceBookToProducts = new Map<Id,PriceBookEntry>();
         
         
         if(!Test.isRunningTest()){
             /* This Condition doesnot run for test class
              * This gets the current  Pricebook Id from the custom label
              * Pricebook Id is mandantory to be update in custom label
             */
          String s2 = System.Label.Current_PriceBook_Id;
             
             // Get the Price book for the pricebook id entered in custom label
          priceBook = [SELECT Id, IsDeleted, Name, IsActive, IsArchived, Description, IsStandard, ValidFrom, ValidTo FROM Pricebook2 where IsActive=true and Id=:s2];
           
         }
         if(Test.isRunningTest()){
             /* This Condition run only for test class
             */
         priceBook = [SELECT Id, IsDeleted, Name, IsActive, IsArchived, Description, IsStandard, ValidFrom, ValidTo FROM Pricebook2 where IsActive=true and Name='Pricebook 2022-2023'];
           
         }
        
         /* Getting a list of all the price book entry and storing it in a map*/
        List<PriceBookEntry> priceBookList = [SELECT Id,Pricebook2Id,UnitPrice , isactive,Product2Id, Product2.Id, Product2.Name,Product2.Productcode FROM PriceBookEntry WHERE Pricebook2Id=:priceBook[0].id];
        for(PriceBookEntry ids:priceBookList){
            mapPriceBookToProducts.put(ids.Product2Id,ids);
        }
         
         /* Getting the opportunity record type and storing it in Id field */
         recordTypeId_new_application = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
         recordTypeId_Reinstatement = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reinstatement').getRecordTypeId();
         Integer SubscriptionTerm;
         
          /* Varaible declared to calculate the start and end date of the quote */
         date endate;
         date startDate;
         String NewClass='';
         String OldClass='';
         date submissiondate;
         
         // Iterating the list of opportunity which got created from the opportunity trigger
        for(Opportunity opp :newOppList){
            
            // Storing the old class and new class values in a varaiable
            NewClass=opp.CFPC_New_Class__c;
            OldClass=opp.CFPC_Class__c;
            
            // Checking the recordtype of the oppotunity 
         if(opp.RecordTypeId==recordTypeId_new_application || opp.RecordTypeId==recordTypeId_Reinstatement){
             
             // Entry condition to the loop only if opportunity record type is Member application or Reinstatment
             
             if(opp.RecordTypeId==recordTypeId_new_application){
                 // Entry condition to the loop only if opportunity record type Member application 
                 // submission date ( quote start date) variable is opportunity submission date
                 submissiondate = opp.CFPC_Submission_Date__c;
             }
             else if (opp.RecordTypeId==recordTypeId_Reinstatement){
                 // Entry condition to the loop only if opportunity record type Reinstatement 
                 // Submission date ( quote start date) variable is set july 1st of current fab year
                 // If the reinstatment is for of the reason other than non payment 'Reinstatement bill start override date' this field should be filled manually by MCC for any discontinuation reason other than non-payment at the time of manual discontinuation
                 
                 for(AccountContactRelation ac:[select Id,ContactId,AccountId from AccountContactRelation where AccountId =:opp.AccountId]){
                     for(Contact contc :[Select Id,Reinstatement_bill_start_override_date__c,Name from Contact where Id=:ac.ContactId]){
                         if(contc.Reinstatement_bill_start_override_date__c==null){
                             // If the contact doesnot have 'Reinstatement bill start override date' tghen quote start date is current fab start date i.e july 1st of current fab start date
                              if(opp.CFPC_Submission_Date__c.month()<=6){
                    // fab year check based on current submission month 
                    // submission date set to starting of the fab year
                   submissiondate = date.newinstance(opp.CFPC_Submission_Date__c.year()-1,07,01);
                                  //System.debug('Submission date not from contact1'+submissiondate);
                    }
                 
                 if(opp.CFPC_Submission_Date__c.month()>=7){
                     // fab year check based on current submission month 
                    // submission date set to starting of the fab year
                  submissiondate = date.newinstance(opp.CFPC_Submission_Date__c.year(),07,01);
                     //System.debug('Submission date not from contact2'+submissiondate);
            
                         }
                         } else{
                             // If the contact does have 'Reinstatement bill start override date' then quote start date is 'Reinstatement bill start override date'
                              //System.debug('Submission date from contact'+contc.Reinstatement_bill_start_override_date__c);
                             submissiondate=contc.Reinstatement_bill_start_override_date__c;
                         }
                         
                     }
                 
                 }
                
             }
             System.debug('Submission date'+submissiondate);
         
             // Variable declaration to calculate the quote start date and end date
             // 
         Integer currentYear = submissiondate.year();
         Integer cuurentday= submissiondate.day();
         Date currentdate = submissiondate;
         Date myDate = Date.newInstance(currentYear,06,30);
         
        if(currentdate>myDate){
            //Setting the the end date to next year june 30th based on current application submission date
             myDate=myDate.addYears(1);
             
         }
           
         if(cuurentday>15){
            // Calculation of start date based on submission date
            // if application submission date is less than 15 the start date is set to 1st of that month
            if(opp.RecordTypeId==recordTypeId_new_application){
             startDate=Date.newInstance(currentYear,currentdate.month()+1,01);
            }
             else{
                 startDate=submissiondate;
             }
             
         }
         else{
             // if application submission date greater than 15 the start date is set to 1st of next month
             if(opp.RecordTypeId==recordTypeId_new_application){
            startDate=Date.newInstance(currentYear,currentdate.month(),01);
             }
             else{
                 startDate=submissiondate;
             }
         }
             // subscription is difference between startdate and endate
             SubscriptionTerm=startDate.monthsBetween(myDate);
             if (myDate.day() > startDate.day()){
                SubscriptionTerm++; 
             } 
         
              /*
               * Creating of quote and mapping of quote fields to memeber application field
               * 
               */
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
            quote.SBQQ__Opportunity2__c = opp.Id;
            quote.SBQQ__Status__c = 'Draft';
            quote.SBQQ__StartDate__c = startDate;
            quote.SBQQ__SubscriptionTerm__c=SubscriptionTerm;
            quote.SBQQ__EndDate__c = myDate;
            quote.SBQQ__PriceBook__c = priceBook[0].Id;
            quote.SBQQ__Account__c=opp.AccountId;
             if(NewClass== null || NewClass==''){
               quote.CFPC_Class__c= OldClass;  
             }
             else{
                 quote.CFPC_Class__c=NewClass;
             }
            
             
            quote.CFPC_Chapter_Province__c=opp.CFPC_Chapter_Province__c;
            quote.CFPC_Self_Learning_Program__c=opp.CFPC_Self_Learning_Program__c;
            quote.SBQQ__PricebookId__c = priceBook[0].Id;
            quote.CFPC_First_Year_Practicing_FYP__c=opp.CFPC_First_Year_Practicing_FYP__c;
            quote.CFPC_Reduced_Fee__c=opp.CFPC_Reduced_Fee__c;
           
             /*
              * CPQ trigger disable
              */
            SBQQ.TriggerControl.disable();
             // Quote insertion
            insert quote; 
             
             /*
              * CPQ trigger enable 
              */
            SBQQ.TriggerControl.enable();
             
            quoteId= quote.Id;
             
            // Passing the quote id to next method to add products to the quoteline
            qutoelineItem_Insert(quoteId,mapPriceBookToProducts,OppList);
        }
        
        
              
        
        
    }
     }
    
    
    public static void qutoelineItem_Insert(String quoteId,Map<Id,PriceBookEntry> mapPriceBookToProducts, List<Opportunity> OppList){
        /*
         * Method to add products to the quoteline item based on the class and chapter province
         * This method contains parameters like quote id, pricebook , and opportunities
         * 
         */
        
        // Varaible declaration
        String code='';
        String classname='';
        String province='';
        Set<Id> result=new Set<Id>();
        List<Product2> productsList4= new List<Product2>();
        List<Product2> productsList5= new List<Product2>();
        List<Product2> Admin_prod= new List<Product2>();
        Id recordTypeId_Reinstatement;
        // Getting Reinstatement record type Id
        recordTypeId_Reinstatement = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reinstatement').getRecordTypeId();
        // list variable which will contains quote line to insert for the quote
        List<SBQQ__QuoteLine__c> listofQuote_LineItem = new List<SBQQ__QuoteLine__c>();
        // Getting the quote 
        SBQQ__Quote__c quote1 = [Select Id,CFPC_First_Year_Practicing_FYP__c,CFPC_Reduced_Fee__c,CFPC_Class__c,SBQQ__Primary__c,CFPC_Chapter_Province__c from SBQQ__Quote__c where id=:quoteId] ;
        
        for(Opportunity opp :OppList){
            //Iterate the list of opportunity created
            //Checking for class and chapter province value on opportunity
            if(quote1.CFPC_Class__c!=null && quote1.CFPC_Chapter_Province__c!=null ){
            //Enters if both are null
            // Combines the class and province into a single string and searches the products with product filter which is in this combination
            // Product filter is a multi select picklist field in product which is used to select product
               classname = quote1.CFPC_Class__c+';'+quote1.CFPC_Chapter_Province__c; 
              
                 List<Product2> productsList3 = [Select id,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c from Product2 where isactive=true and SR_ProductFilter__c INCLUDES(:classname) and Family!='Self Learning' and Family !='Other'];
                 
                 for(Product2 prd : productsList3 ){
                 result.add(prd.Id);
            }
            } else if(quote1.CFPC_Class__c==null && quote1.CFPC_Chapter_Province__c!=null){
                //Enter if  class is null and province is not null
                //Serches for products with chapter province in product filter field in product
                classname = quote1.CFPC_Chapter_Province__c; 
                
                
                 List<Product2> productsList3 = [Select id,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c from Product2 where isactive=true and SR_ProductFilter__c INCLUDES(:classname) and Family='Chapter Fee'];
                 
                 for(Product2 prd : productsList3 ){
                 result.add(prd.Id);
            }
            }else if(quote1.CFPC_Class__c!=null && quote1.CFPC_Chapter_Province__c==null){
                //Enter if  class is not null and province is null
                //Serches for products with class in product filter field  in product
                classname = quote1.CFPC_Class__c; 
                // System.debug('new class  not null'+classname);
                 List<Product2> productsList3 = [Select id,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c from Product2 where isactive=true and SR_ProductFilter__c INCLUDES(:classname) and Family='National Fee'];
                // System.debug('Product List3 '+productsList3);
                 for(Product2 prd : productsList3 ){
                 result.add(prd.Id);
            }
            }else if(quote1.CFPC_Class__c==null && quote1.CFPC_Chapter_Province__c==null){
                // if both atre null return no products
                classname = null; 
                System.debug('new class and provice  null'+classname);
            }
            // Getting Admin product to
            Admin_prod=[Select id,SBQQ__SortOrder__c,Family,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,ProductCode,SBQQ__ChargeType__c,isactive from Product2 where ProductCode='NF_AD' and Family='Administrative' and isactive=true];
            if(classname==null){
                // if both atre null return no products
               List<Product2> productsList3 = [Select id,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c from Product2 where isactive=true and SR_ProductFilter__c INCLUDES(:classname) and Family!='Self Learning' and Family !='Other'];
           // System.debug('Product List3 '+productsList3);
                 for(Product2 prd : productsList3 ){
                result.add(prd.Id);
            }
             
            }
            if(opp.RecordTypeId==recordTypeId_Reinstatement){
                
                //Adding the natinaol Admi fee products to reinstatment application
                if(Admin_prod.size()>0){
                     for(Product2 prd121 : Admin_prod ){
                     result.add(prd121.Id);
                    }
                    
                    
                }
                
            }
            
            
           
            if(opp.CFPC_Self_Learning_Program__c==TRUE){
                // if self learning is checked  selecting the self learning product
                   productsList4 = [Select id,SBQQ__SortOrder__c,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c  from Product2 where isactive=true and Family='Self Learning'and SR_ProductFilter__c INCLUDES(:classname) LIMIT 1];
              }
            if(opp.CFPC_Donation_Amount__c > 0){
                // if any donation amonut is there in application then adding donation product
                   productsList5 = [Select id,SBQQ__SortOrder__c,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c  from Product2 where isactive=true and Productcode='FAFM' LIMIT 1];
              }
            
            
           
            
            
            
           
            List<Product2> productsList6 =[Select id,Family,Reducing_Fee_Discount__c,First_Year_Practicing_Discount__c,ProductCode,SBQQ__SortOrder__c,SBQQ__BillingFrequency__c,SBQQ__BillingType__c,SBQQ__ChargeType__c from Product2 where Id in: result ORDER BY SBQQ__SortOrder__c ASC ];
            
            // Creation of Qyote line item list which needs to be inserted
             if(productsList6.size()>0){
                for(Product2 prods:productsList6){
                    //System.debug('Pricebook map1 ++'+mapPriceBookToProducts.get(prods.Id).ID);
                    if(quote1.CFPC_First_Year_Practicing_FYP__c || quote1.CFPC_Reduced_Fee__c){
                        //If first year practicing is checked or if reduced fee is checked appliying discount based on the discount fileds in prdoucts
                        if(quote1.CFPC_First_Year_Practicing_FYP__c){
                                listofQuote_LineItem.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId,SBQQ__Discount__c=prods.First_Year_Practicing_Discount__c,SBQQ__Number__c=prods.SBQQ__SortOrder__c,SBQQ__Product__c =prods.Id,SBQQ__ChargeType__c=prods.SBQQ__ChargeType__c,SBQQ__BillingType__c=prods.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=prods.SBQQ__BillingFrequency__c,SBQQ__PricebookEntryId__c=mapPriceBookToProducts.get(prods.Id).ID,SBQQ__Quantity__c =1));
                    
                        }
                         if(quote1.CFPC_Reduced_Fee__c){
                                listofQuote_LineItem.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId,SBQQ__Discount__c=prods.Reducing_Fee_Discount__c,SBQQ__Number__c=prods.SBQQ__SortOrder__c,SBQQ__Product__c =prods.Id,SBQQ__ChargeType__c=prods.SBQQ__ChargeType__c,SBQQ__BillingType__c=prods.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=prods.SBQQ__BillingFrequency__c,SBQQ__PricebookEntryId__c=mapPriceBookToProducts.get(prods.Id).ID,SBQQ__Quantity__c =1));
                    }
                   }
                    else{ 
                        listofQuote_LineItem.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId,SBQQ__Number__c=prods.SBQQ__SortOrder__c,SBQQ__Product__c =prods.Id,SBQQ__ChargeType__c=prods.SBQQ__ChargeType__c,SBQQ__BillingType__c=prods.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=prods.SBQQ__BillingFrequency__c,SBQQ__PricebookEntryId__c=mapPriceBookToProducts.get(prods.Id).ID,SBQQ__Quantity__c =1));
                   // System.debug('List of Quote LineItem+++ '+listofQuote_LineItem);
                    }
                    
                    // System.debug('List of Quote LineItem '+listofQuote_LineItem);
                }
                                             }
            if(productsList4.size()>0){
             for(Product2 prd1 : productsList4 ){
                         listofQuote_LineItem.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId,SBQQ__Number__c=prd1.SBQQ__SortOrder__c,SBQQ__Product__c =prd1.Id,SBQQ__ChargeType__c=prd1.SBQQ__ChargeType__c,SBQQ__BillingType__c=prd1.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=prd1.SBQQ__BillingFrequency__c,SBQQ__PricebookEntryId__c=mapPriceBookToProducts.get(prd1.Id).ID,SBQQ__Quantity__c =1));
                    
                        }
            }
            if(productsList5.size()>0){
                for(Product2 prods:productsList5){
                    
                    listofQuote_LineItem.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId,SBQQ__ChargeType__c=prods.SBQQ__ChargeType__c,SBQQ__BillingType__c=prods.SBQQ__BillingType__c,SBQQ__BillingFrequency__c=prods.SBQQ__BillingFrequency__c,SBQQ__Number__c=prods.SBQQ__SortOrder__c,SBQQ__Product__c =prods.Id,SBQQ__PricebookEntryId__c=mapPriceBookToProducts.get(prods.Id).ID,SBQQ__Quantity__c =1,SBQQ__ListPrice__c=opp.CFPC_Donation_Amount__c));
                    // System.debug('List of Quote LineItem1  '+listofQuote_LineItem);
                }
            }
      
            
            
       
        }
        
        //SBQQ.TriggerControl.disable();
        insert listofQuote_LineItem;
       //SBQQ.TriggerControl.enable();
        
        //One line iten are inserted quote is made primary
        quote1.SBQQ__Primary__c= TRUE;
        
        Update quote1;
        
       
      
    }

   
    
public static void afterUpdate(List<Opportunity> newOppList){
    /*
     * After Update exceution which run to update the account on quote 
     * If the account on quote is null , account from opportunity will be copied to quote
     */
    Set<Id> setid= new Set<Id>();
    Id recordTypeId_new_application;
    Id recordTypeId_Reinstatement;
    
    recordTypeId_new_application = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
     recordTypeId_Reinstatement = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reinstatement').getRecordTypeId();
    for (Opportunity opp : newOpplist){
        setid.add(opp.Id);
    }
    List<SBQQ__Quote__c> quote = [ Select Id, Name,SBQQ__Account__c,SBQQ__Opportunity2__c from SBQQ__Quote__c where SBQQ__Opportunity2__c in :setid ];
    List<SBQQ__Quote__c> accupdatequote = new List<SBQQ__Quote__c>();
 Map<Id,SBQQ__Quote__c> SBQuote= new Map<Id,SBQQ__Quote__c>();
    for(SBQQ__Quote__c qte : quote){
        SBQuote.put(qte.SBQQ__Opportunity2__c,qte);
    }
    System.debug('Opportunity List upasted'+newOppList);
    for (Opportunity opp1 : newOpplist){
        if(opp1.RecordTypeId==recordTypeId_new_application || opp1.RecordTypeId==recordTypeId_Reinstatement){
        
        SBQQ__Quote__c quote1 = SBQuote.get(opp1.id);
        if(quote1.SBQQ__Account__c==null){
            quote1.SBQQ__Account__c = opp1.AccountId;
            accupdatequote.add(quote1);
        }
        
        
        
        }
    }
    update accupdatequote;

}
 


}