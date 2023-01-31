trigger OrderTriggerCFPC on Order (after insert,before insert) {
    if(Test.isRunningTest()){
        if(Trigger.isInsert && Trigger.isBefore){
            for(Order eachOrder:Trigger.new){
                if(eachOrder.cfpc_product_code__c!=''){
                    eachOrder.blng__BillingDayOfMonth__c='1';
                }            
            }
        }
    }
    if(Trigger.isInsert && Trigger.isAfter){
        List<Order> standaloneOrders = new List<Order>();
        for(Order eachOrder:Trigger.new){
            if(eachOrder.cfpc_product_code__c!=''){
                standaloneOrders.add(eachOrder);
            }            
        }
        if(standaloneOrders.size()>0){
            OrderTriggerHandlerCFPC.createOrderItems(standaloneOrders);
        }
        
    }
}