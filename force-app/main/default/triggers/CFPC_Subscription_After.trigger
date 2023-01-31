trigger CFPC_Subscription_After on SBQQ__Subscription__c (after insert) {
 if(trigger.isAfter && trigger.isInsert)
    {
        CFPC_Subscription_Handler.updateConstituent(Trigger.new);
    }

}