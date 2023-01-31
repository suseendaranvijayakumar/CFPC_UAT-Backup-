trigger OpportunityTrigger on Opportunity (after update,after insert,before insert){
    
     if(trigger.isAfter && trigger.isInsert)
    {
     
      Opportunity_Quote_QuoteLineItemCreation.afterInsert(Trigger.new, Trigger.oldMap);
    
    }
    if( trigger.isBefore && trigger.isInsert){
        CFPC_Renewal_Opportunity.beforeInsert(Trigger.new);
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
    
       OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
       Opportunity_Quote_QuoteLineItemCreation.afterUpdate(Trigger.new);
       
    
    }
    
   
}