trigger CFPC_Payment_Trigger on blng__Payment__c (after insert,before insert) {
    if(trigger.isAfter && trigger.isInsert)
    {
        Add_Payement_Allocation.afterInsert(Trigger.new);
    }
    
    if(trigger.isBefore && trigger.isInsert)
    {
        Add_Payement_Allocation.updateConstituent(trigger.new);
    }
}