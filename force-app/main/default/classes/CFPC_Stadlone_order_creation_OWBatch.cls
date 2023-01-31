global with sharing class CFPC_Stadlone_order_creation_OWBatch  implements Database.Batchable<SObject>,Database.Stateful{
    /* Developr name: Suseendaran.v
     * This batch class which creats standlone order once a record is created in Mock payment object (CFPC_Mock_Payment__c) by OW intgration user
     * It fetches the records from CFPC_Mock_Payment__c obejcts and creates a standlone order for these records 
     * It only fetches the record for which standlone order was not created previously
     * Once a standlone order is created for the record we have a field called Standlone_Ordered which is made true inorder to identify whether the record was previously ordered
     * 
     */
    public static Id getAccountId(String memberID){
        // Method to return the account map
        List<Account> accList = new List<Account>();
        if(MemberID!=null){
            accList = [Select Id,CFPC_ID__c from Account where CFPC_ID__c=:memberID Limit 1];
        }
        System.debug('acc'+accList);
        Id accountIdtomap=null;
        if(accList.size()>0){
            accountIdtomap = accList[0].Id;
        }
        return accountIdtomap;
    }
    
    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        // getting all the records in Mock payment object which were not yet ordered ( for which standlone order were not created which can identified by the checkbox Standlone__c=FALSe)
             String query = 'SELECT CFPC_Billing_Type__c,CFPC_Bill_Creation_Date__c,CreatedDate,Standlone__c,CFPC_BT_ID__c,CFPC_Credit_Card_Type__c,CFPC_Member_ID__c,CFPC_Member__c,CFPC_OpenWater_ID__c,CFPC_Order_Date__c,CFPC_Order_Description__c,CFPC_Payment_Amount__c,CFPC_PO_NUM__c,CFPC_Product_Code__c,CFPC_Quantity_Ordered__c,CFPC_Source_System__c,CFPC_Status__c,CFPC_ST_ID__c,CFPC_Transaction_Reference_ID__c,CFPC_Transaction_Response_Code__c,CFPC_Type__c,Id,Name,Test_Data__c FROM CFPC_Mock_Payment__c where Standlone__c=FALSE';
             return Database.getQueryLocator(query);
     }
    
    global void execute(Database.BatchableContext bc, List<CFPC_Mock_Payment__c> scope){
        // Once we get the record order is created with the required fields
        System.debug('Record to create'+scope);
        
        List<CFPC_Mock_Payment__c> pytupdate = new List<CFPC_Mock_Payment__c>();
     Map<String,String> mapMemberIdtoProductCode = new Map<String,String>();
        List<Order> ordersList = new List<Order>();
        List<Pricebook2> priceBook = [SELECT Id, IsDeleted, Name, IsActive, IsArchived, Description, IsStandard, ValidFrom, ValidTo FROM Pricebook2 where IsActive=true and name='Pricebook 2023-2024' LIMIT 1];
        for(CFPC_Mock_Payment__c paymentsRecord : scope ){
            System.debug('Record to create transcation'+paymentsRecord.CFPC_Transaction_Reference_ID__c);
            mapMemberIdtoProductCode.put(paymentsRecord.CFPC_Member__c,paymentsRecord.CFPC_Product_Code__c);
            Order orders = new Order();
            orders.AccountId =getAccountId(paymentsRecord.CFPC_Member_ID__c);
            orders.EffectiveDate =paymentsRecord.CreatedDate.date();
            orders.Pricebook2Id = priceBook[0].id;
            orders.cfpc_product_code__c =paymentsRecord.CFPC_Product_Code__c;
            orders.CFPC_Standalone_Order_Amount__c=paymentsRecord.CFPC_Payment_Amount__c ;
            orders.CFPC_Open_Water_Id__c=paymentsRecord.CFPC_OpenWater_ID__c  ;
            orders.CFPC_Payment_Transaction_Ref_Id__c=paymentsRecord.CFPC_Transaction_Reference_ID__c ;
            orders.CFPC_Credit_Card_Type__c=paymentsRecord.CFPC_Credit_Card_Type__c  ;
            orders.CFPC_Source_System__c=paymentsRecord.CFPC_Source_System__c  ;
            //orders.Pricebook2Id =getPricebookId(paymentsRecord.CFPC_Product_Code__c);
            orders.Status ='Draft';
            ordersList.add(orders);
        }
        if(ordersList.size()>0){
            
            //Inserting the order record
            List<Database.SaveResult> results = Database.Insert(ordersList,false);
        for (Database.SaveResult result : results) {
            
            if (result.isSuccess()){
                // Once order is succesfully created we update the mock payment record and make standlone_ordered check box to true , which means this record will not be choosen next time
                System.debug('Record to create success');
                for(CFPC_Mock_Payment__c pyt:scope){
                    pyt.Standlone__c=TRUE;
                    pytupdate.add(pyt);
                }
            }
          if (!result.isSuccess()){
            for (Database.Error err : result.getErrors()){
               System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
    }
  }
}
            
            if(pytupdate.size()>0){
                System.debug('Record to create success to update'+pytupdate);
                Update pytupdate ;
            }
        }
        
    }
    
     global void finish(Database.BatchableContext bc) {
         // the below logic is written to exceute the scheduled job for every 5 mins
         // After the excution of all the logic in the btach class , the excute method creates a another job in next 5 mins and abort the pervious job
         Datetime dt = system.now().addMinutes(5);
       String sDay=String.valueof(dt.day());        
       String sMonth=String.valueof(dt.month());
       String sMinute= String.valueOf(dt.minute());       
       String sHour=string.valueOf(dt.hour()); 
       String sSeconds= '00';
       String sYear=String.valueof(system.now().year());     
         String SJobName = 'OW_Standlone_order_scheduler_job -'+sDay+'-'+sMonth+'-'+sYear+' '+sHour+':'+sMinute+':'+sSeconds;
       String CRON_EXP = '00 '+sMinute+' '+sHour+' '+sDay+' '+sMonth+' ? '+sYear; 
         System.schedule(SJobName, CRON_EXP, new CFPC_Standlone_Order_creation_OW());
    }
}