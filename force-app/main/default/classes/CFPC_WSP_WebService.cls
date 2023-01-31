@RestResource(urlMapping='/CFPCWebServicesPremier/api/CeCity/*')
global with sharing class CFPC_WSP_WebService {
    
  private static CFPC_WSP_DataRepository dataRepo = new CFPC_WSP_DataRepository();
  static final String SFDC_INT_WS1_GET_CPD_UPDATED_MEMBERS = 'GetMembersForDesignationStatusUpdate'; //RS - GetMembersForDesignationStatusUpdate //PV - 'GetCpdUpdatedMembers'
  static final String SFDC_INT_WS2_UPDATE_DESIGNATION_BY_CPD_CYCLE = 'UpdateDesignationByCpdCycle';
  static final String SFDC_INT_WS3_GET_MEMBER_PRACTICING_FLAG_CHANGE_DATE = 'GetMemberPracticingFlagChangeDate';
  static final String SFDC_INT_WS4_GET_MEMBER_EFFECTIVE_DATE = 'GetMemberEffectiveDate';
  static final String SFDC_INT_WS5_GET_MEMBER_OTHER_LICENCE_PROVINCE = 'GetMemberOtherLicenceProvince';
  static final String SFDC_INT_WS6_GET_ALL_MEMBER_DATES = 'GetAllMemberDates';
  static final String SFDC_INT_WS7_UPDATE_CE_CITY_IMIS_FLAG = 'UpdateCeCityFlag'; //'UpdateCeCityImisFlag'; //RS - UpdateCeCityFlag //PV - 'UpdateCeCityMemberPushFlags'
  static final String SFDC_INT_WS8_GET_MEMBER_COUNT = 'GetMemberCount';
  static final String SFDC_INT_WS9_UPDATE_CE_CITY = 'GetMembers';//'UpdateCeCity';
  static final String SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE = 'TriggerCpdCycleUpdate';
  static final String ERR_NO_ROUTE_FOUND = 'ERROR NO ROUTE FOUND!';
    

  private static String getEntityIdParamaterFromRequestURIAsTrailingValue(
    RestRequest req
  ) {
    String entityId = req.requestURI.substring(
      req.requestURI.lastIndexOf('/') + 1
    );
    return entityId;
  }

  // the definition of isURIMatch can be changed to be more liberal, using for example case-insensitive comparison and other measures
  // contains used to in order to ensure route is caught given that it may not be the last token behind the '/'
  // Unclear if this is best / standard approach
  private static boolean isURIMatch(RestRequest req, String endpointSelector) {
    boolean isMatch = false;
    return req.requestURI.substringAfter('CeCity/').contains(endpointSelector);
  }

  private static void doReturnNoRoute(RestRequest req, RestResponse res) {
    System.debug('doReturnNoRoute matched');
    res.statusCode = 400;
  }

  @HttpGet
  global static void doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;



    // SFDC_INT_WS8_GetMemberCount
    if (isURIMatch(req, SFDC_INT_WS8_GET_MEMBER_COUNT)) {
      System.debug('GemMemberCount matched');
      doGetMemberCount(req, res);
    }

    // SFDC_INT_WS9_UpdateCeCity
    if (isURIMatch(req, SFDC_INT_WS9_UPDATE_CE_CITY)) {
      doUpdateCeCity(req, res);
    }



    //SFDC_INT_05_1_TriggerCpdCycleUpdate
    if (isURIMatch(req, SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE)) {
      doTriggerCpdCycleUpdate(req, res);
    }
    //SFDC_INT_WS1_GetCpdUpdatedMembers
    if (isURIMatch(req, SFDC_INT_WS1_GET_CPD_UPDATED_MEMBERS)) {
      doGetCpdUpdateMembers(req, res);
    }



    //SFDC_INT_WS3_GetMemberEffectiveDate
    if (isURIMatch(req, SFDC_INT_WS3_GET_MEMBER_PRACTICING_FLAG_CHANGE_DATE)) {
      doGetMemberPracticingFlagChangeDate(req, res);
    }

    //SFDC_INT_WS4_GetMemberEffectiveDate
    if (isURIMatch(req, SFDC_INT_WS4_GET_MEMBER_EFFECTIVE_DATE)) {
      doGetMemberEffectiveDate(req, res);
    }

    //SFDC_INT_WS5_GetMemberOtherLicenceProvince
    if (isURIMatch(req, SFDC_INT_WS5_GET_MEMBER_OTHER_LICENCE_PROVINCE)) {
      doGetMemberOtherLicenceProvince(req, res);
    } 

    //SFDC_INT_WS6_GetMemberOtherLicenceProvince
    if (isURIMatch(req, SFDC_INT_WS6_GET_ALL_MEMBER_DATES)) {
      doGetAllMemberDates(req, res);
    } 
  }



  private static void doGetMemberCount(RestRequest req, RestResponse res) {
    String memberCountResponse = dataRepo.getMemberCountData();
    res.addHeader('Content-Type', 'application/json');
    res.responseBody = Blob.valueOf(memberCountResponse);
    res.statusCode = 200;
  }

  private static void doUpdateCeCity(RestRequest req, RestResponse res) {
    System.debug('doUpdateCeCity called');
      try{
          String memberResponse = dataRepo.getMemberData();
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(memberResponse);
            res.statusCode = 200;
      }
      catch(exception ex){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(ex.getMessage());//Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);//Blob.valueOf(ex.getMessage());
        }
    
  }



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

  	private static void doGetCpdUpdateMembers(RestRequest req, RestResponse res) {
  		List<CFPC_CPD_Cycle_Update_Member__c> cpdUpdateMembers = [SELECT ID, Name FROM CFPC_CPD_Cycle_Update_Member__c 
        
                                                                  WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC LIMIT 500];
        try{
            String jsonData;
            if(cpdUpdateMembers.size() > 0){
                jsonData = dataRepo.getCpdUpdateMembers(cpdUpdateMembers);
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonData);
                res.statusCode = 200;
            }
            else{
                JSONGenerator gen = JSON.createGenerator(true);
    			gen.writeStartArray();
                gen.writeEndArray();
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(gen.getAsString());
                res.statusCode = 200;
            }
    		
        }
        catch(exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(e.getMessage());
        }
  	}

	private static void doGetMemberPracticingFlagChangeDate(RestRequest req, RestResponse res) {
        try{
            String jsonData;
            Boolean isPracticingMember = Boolean.valueOf(getEntityIdParamaterFromRequestURIAsTrailingValue(req));
        	String memberId = req.requestURI.substringBetween('GetMemberPracticingFlagChangeDate/', '/');
            
            jsonData = dataRepo.getPracticingChangeDates(memberId, isPracticingMember);
            res.addHeader('Content-Type', 'application/json');
    		res.responseBody = Blob.valueOf(jsonData);
    		res.statusCode = 200;
        }
        catch(exception e){
            res.statusCode = 400;
          	res.responseBody = Blob.valueOf('Error in GetMemberPracticingFlagChangeDate');
        }
	}

  	private static void doGetMemberEffectiveDate(RestRequest req,RestResponse res) {
    	String memberid = getEntityIdParamaterFromRequestURIAsTrailingValue(req);
    	String responseBody = 'No member found!';
    	res.addHeader('Content-Type', 'application/json');
    	String effectiveDate = dataRepo.getMemberEffectiveDateForMember(memberId);
    	if (null != effectiveDate) {
      		res.statusCode = 200;
      		responseBody = effectiveDate;
    	} 
        else {
      		res.statusCode = 400;
            res.responseBody = Blob.valueOf('Error in GetMemberEffectiveDate');
    	}
    	res.responseBody = Blob.valueOf(responseBody);
  	}

  private static void doGetMemberOtherLicenceProvince(RestRequest req, RestResponse res) {
    String memberid = getEntityIdParamaterFromRequestURIAsTrailingValue(req);
    String responseBody = '';
      try{
          String otherLicensingProvinces = dataRepo.getMemberOtherLicenceProvince(memberId);
          if (null != otherLicensingProvinces && otherLicensingProvinces != '') {
      		//res.addHeader('Content-Type', 'application/json');
      		responseBody = otherLicensingProvinces;
            res.responseBody = Blob.valueOf(responseBody);   
      		res.statusCode = 200;
    	}
          
      }
      catch(exception e){
          res.statusCode = 400;
          res.responseBody = Blob.valueOf('Error in GetMemberOtherLicenceProvince');
      }
    
  }

    private static void doGetAllMemberDates(RestRequest req, RestResponse res) {
        String memberid = getEntityIdParamaterFromRequestURIAsTrailingValue(req);
        String responseBody = '';
        try{
            String allMemberDates = dataRepo.getAllMemberDates(memberId);
            res.addHeader('Content-Type', 'application/json');
            responseBody = allMemberDates;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(responseBody);
        }
        catch(exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Error in GetAllMemberDates');//Blob.valueOf(e.getMessage());//Blob.valueOf('Error in GetAllMemberDates');
        }     
	}

  	@HttpPost
  	global static void doPost() {
    	RestRequest req = RestContext.request;
    	RestResponse res = RestContext.response;
      	String inputJSON = req.requestBody.toString();
    	



    if (isURIMatch(req, SFDC_INT_WS7_UPDATE_CE_CITY_IMIS_FLAG)) {
        doUpdateCeCityImisFlag(inputJSON,res);
    }



    if (isURIMatch(req, SFDC_INT_WS2_UPDATE_DESIGNATION_BY_CPD_CYCLE)) {
        //String msg;
      //Query Member object to find Member using ID provided in payload
      doUpdateDesignationByCpdCycle(inputJSON,res);
      //createDebugEntry(req,res);
    }
        if(req.requestURI.contains('testapi/SetMemberPushFlagToTrue')){
            String memberIdForReset = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resetFlag(memberIdForReset,res);
        }
        
  }
    private static void doUpdateDesignationByCpdCycle(String inputJSON, RestResponse res){
        CFPC_WSP_CycleParser cycleInfo = CFPC_WSP_CycleParser.parse(inputJSON);
        Boolean hasCcfpDsgns = false;
        List<CFPC_Designation__c> dsgnsToUpdate = new List<CFPC_Designation__c>();
        Map<Id,CFPC_Designation__c> dsgnsMap = new Map<Id,CFPC_Designation__c>();
        String responseMsg;
        Set<String> cycleTypesPending = new Set<String>();
        cycleTypesPending.add('Remedial');
        cycleTypesPending.add('Leave Reinstatement');
        cycleTypesPending.add('Remedial Reinstatement');
        
        Set<String> cycleTypesActive = new Set<String>();
        cycleTypesActive.add('Default');
        cycleTypesActive.add('Voluntary');
        cycleTypesActive.add('Resident');
        
        try{
            List<CFPC_Designation__c> dsgnList = [SELECT Id, CFPC_Designation_Status__c,  CFPC_Designation__c
                                              FROM CFPC_Designation__c
                                              WHERE CFPC_Member_Id__r.CFPC_CFPC_ID__c =  :cycleInfo.ID
                                                  AND CFPC_Member_Id__r.CFPC_Status__c = 'Active'
                                                  AND CFPC_Member_Id__r.CFPC_Class_Type__c = 'FULL'
                                              WITH SECURITY_ENFORCED FOR UPDATE];
            
            for(CFPC_Designation__c dsgn : dsgnList){
                if(dsgn.CFPC_Designation__c == 'CCFP'){
                    hasCcfpDsgns = true;
                }
            }
            
            for(CFPC_Designation__c dsgn : dsgnList){
                if(cycleTypesPending.contains(cycleInfo.CycleType) && 
                   (dsgn.CFPC_Designation_Status__c == 'Active' || (dsgn.CFPC_Designation_Status__c == 'Inactive' && dsgn.CFPC_Designation__c != 'MCFP'))){
                    dsgn.CFPC_Designation_Status__c = 'Pending';
                    dsgn.CFPC_DesignationEndDate__c = System.today();
                    dsgnsToUpdate.add(dsgn);
                       dsgnsMap.put(dsgn.Id,dsgn);
                }
                
                if(cycleTypesActive.contains(cycleInfo.CycleType)){
                    if(dsgn.CFPC_Designation_Status__c != 'Active' && dsgn.CFPC_Designation__c != 'MCFP'){
                        dsgn.CFPC_Designation_Status__c = 'Active';
                        dsgn.CFPC_DesignationEndDate__c = null;
                        dsgnsToUpdate.add(dsgn);
                        	dsgnsMap.put(dsgn.Id,dsgn);
                    }
                    
                    if(dsgn.CFPC_Designation_Status__c != 'Active' && dsgn.CFPC_Designation__c == 'MCFP' && hasCcfpDsgns == false){
                        dsgn.CFPC_Designation_Status__c = 'Active';
                        dsgn.CFPC_DesignationEndDate__c = null;
                        dsgnsToUpdate.add(dsgn);
                        	dsgnsMap.put(dsgn.Id,dsgn);
                    }
                }
                //dsgnsToUpdate.add(dsgn);
                dsgnsMap.put(dsgn.Id,dsgn);
            }
            
            
            List<CFPC_CPD_Cycle_Update_Member__c> cpdUpdateMembers = [SELECT ID, Name FROM CFPC_CPD_Cycle_Update_Member__c 
                                                                      WHERE Name = :cycleInfo.ID
                                                                      WITH SECURITY_ENFORCED];
            
            //if(dsgnsMap.size() > 0 && (cycleTypesActive.contains(cycleInfo.CycleType) || cycleTypesPending.contains(cycleInfo.CycleType))){ 
                
                update dsgnsMap.values();
                res.statusCode = 200;
            	res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c);
                delete cpdUpdateMembers;
            //}
            
            
    	}
        
        catch(exception ex){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(ex.getMessage());
        }
    }
    
    private static void doUpdateCeCityImisFlag(String inputJSON, RestResponse res){
        try{
            CFPC_WSP_FlagParser flagParser = CFPC_WSP_FlagParser.parse(inputJSON);
            List<Contact> member = [SELECT ID, CFPC_INT_Send_To_CeCity_Failure_Count__c FROM Contact WHERE CFPC_CFPC_ID__c = :flagParser.Key 
                                    WITH SECURITY_ENFORCED LIMIT 1];
            List<Contact> conList = new List<Contact>();
            
            for(Contact con : member){
                
                if(flagParser.Value == 'Success'){
                    con.Send_to_CECity__c = false;
                    con.CFPC_INT_Send_to_CeCity_Response__c = 'Success';
                    con.CFPC_INT_Send_To_CeCity_DT__c = System.Now();
                    con.CFPC_INT_CeCity_Non_Eligible__c = false;
                    con.CFPC_INT_Send_To_CeCity_Failure_Count__c = '0';
                }
                
                else if(flagParser.Value == 'NotUpdate'){
                    con.Send_to_CECity__c = false;
                    con.CFPC_INT_Send_To_CeCity_Failure_Count__c = '0';
                    con.CFPC_INT_CeCity_Non_Eligible__c = false;
                }
                
                else if(flagParser.Value == 'NonEligable'){
                    con.Send_to_CECity__c = false;
                    con.CFPC_INT_Send_To_CeCity_Failure_Count__c = '0';
                    con.CFPC_INT_CeCity_Non_Eligible__c = true;
                }
                
                else{
                    con.CFPC_INT_Send_to_CeCity_Response__c = flagParser.Value;
                    con.CFPC_INT_Send_To_CeCity_DT__c = System.Now();
                    con.CFPC_INT_CeCity_Non_Eligible__c = false;
                    //String failString = con.CFPC_INT_Send_To_CeCity_Failure_Count__c;
                    Integer failCount = con.CFPC_INT_Send_To_CeCity_Failure_Count__c == '' || con.CFPC_INT_Send_To_CeCity_Failure_Count__c == null ? 1 : Integer.valueOf(con.CFPC_INT_Send_To_CeCity_Failure_Count__c) + 1;
                    con.CFPC_INT_Send_To_CeCity_Failure_Count__c = String.valueOf(failCount);
                }
                conList.add(con);
                //update con;
                

            }
            if(conList.size() > 0){
                update conList;
                res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c);
            	res.statusCode = 200;
            }
            else{
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(Constants__mdt.getInstance('FAILED_RESPONSE').Constant_Value__c);
            }

        }
        
        catch(exception ex){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(Constants__mdt.getInstance('FAILED_RESPONSE').Constant_Value__c);
        }
        
        
    }
    
    public static void resetFlag(String memberIdForReset, RestResponse res){
        try{
            List<Contact> ctList = [SELECT ID from Contact where CFPC_CFPC_ID__c = :memberIdForReset];
            if(ctList.size() > 0){
                ctList[0].Send_To_CeCity__c = true;
                update ctList;
                
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf('Member Push Flag Set');
                res.statusCode = 200;
            }
        }
        catch(exception e){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(e.getMessage());
        }
    }
    //private static void createDebugEntry(RestRequest request, RestResponse response){
        //CFPC_Integration_Log__c intLog = new CFPC_Integration_Log__c();
        //intLog.Http_Method__c = String.valueOf(request.httpMethod);   //.getMethod();
        //intLog.Endpoint__c = String.valueOf(request.requestURI);
        //intLog.System__c = 'WinService-Premier';
        
        //intLog.Response_Code__c = String.valueOf(response.StatusCode);
        //intLog.Response_Body__c = String.valueOf(response.responseBody);
        //intLog.Request_JSON__c = request.requestBody.toString();
        
        //insert intLog;
    //}
    
      
}