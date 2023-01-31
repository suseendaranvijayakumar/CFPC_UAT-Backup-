/*******************************************************************************************
* @Description   Webservice to facilitate Salesforce-FMF Integration 
*				
*******************************************************************************************/
@RestResource(urlMapping='/CFPCWebServicesFMF/api/FMF/*')
global with sharing class CFPC_FMF_WebService {
	
    static final String DATETIME_FORMAT = 'YYYY-MM-dd\'T\'HH:mm:ss';
    static final String TIME_STRING = 'T00:00:00';
    static final String EST_TIMEZONE = 'America/New_York';
    static final String DISCONTINUED = 'Discontinued';
    
    //Find entity Id at the end of the URI
    
    private static String getEntityIdParamaterFromRequestURIAsTrailingValue(RestRequest req){
    	String entityId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
    	return entityId;
  }
    
    //Check if endpoint matches expected URI
    
    private static boolean isURIMatch(RestRequest req, String endpointSelector){
    	boolean isMatch = false;
    	return req.requestURI.substringAfter(CFPC_Constants.FMF_STR).contains(endpointSelector);
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
        
        if(isURIMatch(req, CFPC_Constants.SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE)){
      		doGetMemberFYPStartDate(req, res);
    	}
  	}
    
    /**************************************************************************************
    * @Description  Provides First Year Practicing Start Date in response body
    * @Param		RestRequest, RestResponse
    * @Return        
    **************************************************************************************/
    private static void doGetMemberFYPStartDate(RestRequest req, RestResponse res) {
        try{
            String memberId = getEntityIdParamaterFromRequestURIAsTrailingValue(req);
            List<CFPC_Change_Log__c> memberChangeLogs =   [SELECT Id, CFPC_INT_Change_Date__c, CFPC_INT_Current_Value__c
                                                			FROM CFPC_Change_Log__c 
                                                           	WHERE ((CFPC_INT_Property__c LIKE :CFPC_Constants.FIRST_YEAR_STR
                                                            		AND CFPC_INT_Current_Value__c LIKE :CFPC_Constants.STR_1) OR 
                                                           			(CFPC_INT_Property__c LIKE :CFPC_Constants.MEM_SUBCAT_STR
                                                           			AND CFPC_INT_Current_Value__c LIKE :CFPC_Constants.F_STR))
                                                           		AND CFPC_INT_Member_ID__c = :memberId 
                                                           		WITH SECURITY_ENFORCED LIMIT 1];

            Contact con = new Contact(); 
            con = getCfpcMember(memberId);
			
            List<First_Year_Practice__c> fyp = [SELECT ID, First_Year_Practice__c from First_Year_Practice__c
                                                WHERE Member_Id__c = :memberId WITH SECURITY_ENFORCED LIMIT 1];
            Integer fypYear = 0; 
            String fypDateTime;
            if(fyp.size() > 0 && fyp[0].First_Year_Practice__c != null){
               fypYear = fyp[0].First_Year_Practice__c.year();
               fypDateTime = fyp[0].First_Year_Practice__c.format(DATETIME_FORMAT,EST_TIMEZONE);
            }                                               
            if(memberChangeLogs.size() > 0 && con != null && fyp.size() > 0){
                if(con.CFPC_R6_practicing_physicians__c != 'Yes' && con.CFPC_Class__c != 'MBR'){
                    res.statusCode = 200;
                    return;
                }
                
                List<CFPC_Class_Change_History__c> memberClasses = [SELECT CFPC_Start_Date__c, CFPC_Class__c, CFPC_Member_Id__c
                                                         FROM CFPC_Class_Change_History__c 
                                                         WHERE CFPC_Member_Id__r.CFPC_CFPC_ID__c = :memberId 
                                                                    AND CFPC_Member_Id__r.CFPC_Status__c != :DISCONTINUED
                                                         			AND CFPC_Start_Date__c != NULL 
                                                                    AND CALENDAR_YEAR(CFPC_Start_Date__c) = :fypYear 
                                                         WITH SECURITY_ENFORCED ORDER BY CFPC_Start_Date__c DESC LIMIT 1];
                                                         
                if(memberClasses.size() > 0){ 
                    res.statusCode = 200;
            		res.addHeader('Content-Type', 'application/json');
          			res.responseBody = Blob.valueOf('"' + String.valueOf(memberClasses[0].CFPC_Start_Date__c) + TIME_STRING + '"');
                    
                }
                else{
                    if(fypDateTime != null){
                        res.statusCode = 200;
            			res.addHeader('Content-Type', 'application/json');
          				res.responseBody = Blob.valueOf('"' + fypDateTime + '"');
                    }
                } 
            } 
        }
        catch(exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Error in GetMemberFYPStartDate: ' +e.getMessage());
        }
    }
    
    public static Contact getCfpcMember(String memberID){
        Set<String> mc = new Set<String>();
        mc.add('MBR');
        mc.add('RES');
        mc.add('EXAM'); //TRJ
        List<Contact> cfpcMember = new List<Contact>();
        cfpcMember = [SELECT CFPC_R6_practicing_physicians__c, CFPC_Class__c 
                      FROM Contact 
                      WHERE cfpc_cfpc_id__c = :memberID AND CFPC_Class__c in :mc WITH SECURITY_ENFORCED limit 1];
        if(cfpcMember.size() > 0){
            return cfpcMember[0];
        }
        else {
            return null;
        }
    }

}