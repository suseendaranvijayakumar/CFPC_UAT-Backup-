trigger CFPC_Contact_trigger on Contact (After Update) {
CFPC_Amend_Contract_Discontinouation.afterUpdate(Trigger.new,Trigger.oldMap);


}