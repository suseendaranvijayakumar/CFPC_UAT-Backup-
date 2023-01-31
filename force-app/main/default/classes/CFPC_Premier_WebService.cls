/*******************************************************************************************
* @Description   Webservice to facilitate Salesforce-Premier Integration 
*				
*******************************************************************************************/
@RestResource(urlMapping='/CFPCPremierWebServices/api/CeCity/*')
global with sharing class CFPC_Premier_WebService {
    
    static final String SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE = 'TriggerCpdCycleUpdate';
    
    
    //Check if endpoint matches expected URI
    
    private static boolean isURIMatch(RestRequest req, String endpointSelector) {
    boolean isMatch = false;
    return req.requestURI.substringAfter('CeCity/').contains(endpointSelector);
  	}
    
    //Find entity Id at the end of the URI
    
    private static String getEntityIdParamaterFromRequestURIAsTrailingValue(RestRequest req){
    	String entityId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
    	return entityId;
  	}
    
    /**************************************************************************************
    * @Description  HTTP GET() method of the WebService
    * @Param		
    * @Return        
    **************************************************************************************/
	@HttpGet
  	global static void doGet() {
    	RestRequest req = RestContext.request;
    	RestResponse res = RestContext.response;
        
        if (isURIMatch(req, SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE)) {
      		doTriggerCpdCycleUpdate(req, res);
    	}
  	}
    
    /**************************************************************************************
    * @Description  Creates a record for a member in the CPD Member Table 
    * @Param		RestRequest, RestResponse
    * @Return        
    **************************************************************************************/
	    
    private static void doTriggerCpdCycleUpdate(RestRequest req, RestResponse res) {
        String memberid = getEntityIdParamaterFromRequestURIAsTrailingValue(req);
        String responseValue = 'Success';
        String notFoundValue = 'Member not found';
        String responseData;
        List<Contact> existingMembers = new List<Contact>();
        
        //Check if Member exists in CFPC_CPD_CYCLE_UPDATE Table
        List<CFPC_CPD_Cycle_Update_Member__c> memberInQueue = [SELECT ID from CFPC_CPD_Cycle_Update_Member__c WHERE Name = :memberId
                                                              WITH SECURITY_ENFORCED];
        try{
            if(memberInQueue.size() > 0){
                res.statusCode = 200;
                res.responseBody = Blob.valueOf(responseValue);
        	}
        
            else{
                 existingMembers = [SELECT Id, CFPC_CFPC_ID__c from Contact WHERE CFPC_CFPC_ID__c = :memberId
                                   WITH SECURITY_ENFORCED];
                
                //If Member does not exist in CFPC_CPD_CYCLE_UPDATE but exists in Member (Constituent) table  
                if(existingMembers.size() > 0){
                    CFPC_CPD_Cycle_Update_Member__c cylUpdateMember = new CFPC_CPD_Cycle_Update_Member__c();
                    cylUpdateMember.Name = memberId;
                    if(Schema.sObjectType.CFPC_CPD_Cycle_Update_Member__c.isCreateable()){
                        insert cylUpdateMember;
                    }
                    
                    res.statusCode = 200;
                    res.responseBody = Blob.valueOf(responseValue);
                }
            
            //If Member exists neither  in CFPC_CPD_CYCLE_UPDATE nor in Member (Constituent) table
                else{
                    res.statusCode = 404;
                    res.responseBody = Blob.valueOf(notFoundValue);
                }
        	}            
        }
        catch(Exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Fail');
        }
  	}
}