/** 
 * @date 2022-08-01
 * @author IndustriousCRM
 * @version 1.0
 * @description WebService to facilitate SF-WSL Integration
 */

@RestResource(urlMapping = '/CFPCWebServicesLegacy/api/LegacyMember/*')
global with sharing class CFPC_WSL_WebService {
    
    private static CFPC_WSL_DataRepository dataRepo = new CFPC_WSL_DataRepository();
    
    static final String LEGACY_MEM_STR = 'LegacyMember/';
  	static final String SFDC_INT_WSL1_GET_MEMBER_UPDATES = 'GetMemberUpdates';
  	static final String SFDC_INT_WSL2_POST_MEMBER_UPDATES = 'PostMemberUpdates';
    static final String SFDC_INT_WSL3_GET_MEMBER_COUNT = 'GetMemberCount';
    static final String SFDC_INT_WSL4_UPDATE_EM_FM_DATES = 'UpdateEmFmDates';
    static final String SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION = 'UpdateExamApplicantDesignation';
        
    @HttpGet
    global static void doGet(){
        RestRequest req = RestContext.request;
    	RestResponse res = RestContext.response;
        
        
    	if(req.requestURI.substringAfter(LEGACY_MEM_STR) == SFDC_INT_WSL1_GET_MEMBER_UPDATES){
            doGetMemberUpdates(res);
    	}
             
        if(req.requestURI.substringAfter(LEGACY_MEM_STR) == SFDC_INT_WSL3_GET_MEMBER_COUNT){
            doGetMemberCount(res);
    	}
        
        if(req.requestURI.contains('test/ResetData')){
            String memberIdForReset = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resetData(memberIdForReset,res);
    	}
    }
    
    @HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
    	RestResponse res = RestContext.response;
      	String inputJSON = req.requestBody.toString();
        
        if(req.requestURI.substringAfter(LEGACY_MEM_STR) == SFDC_INT_WSL2_POST_MEMBER_UPDATES){
            doPostMemberUpdates(inputJSON, res);
    	}
        
        if(req.requestURI.substringAfter(LEGACY_MEM_STR) == SFDC_INT_WSL4_UPDATE_EM_FM_DATES){
            doUpdateEmFmDates(inputJSON, res);
    	}
        
        if(req.requestURI.substringAfter(LEGACY_MEM_STR) == SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION){
            doUpdateExamApplicantDesignation(inputJSON, res);
    	}
        
        if(req.requestURI.contains('testapi/SetMemberPushFlagToTrue')){
            String memberIdForReset = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resetFlag(memberIdForReset,res);
        }
    }
    
    
    
    private static void doGetMemberCount(RestResponse res){
        try{
            String memberCountResponse = '0';
            JSONGenerator jsGen = JSON.createGenerator(true);
            memberCountResponse = String.valueOf([SELECT COUNT() FROM Contact WHERE CFPC_INT_Send_To_Legacy__c = TRUE AND CFPC_CFPC_ID__c != '' AND CFPC_Class__c != 'Prospect']);
            jsGen.writeStartObject();
                jsGen.writeStringField('count', memberCountResponse);
            jsGen.writeEndObject();
            String jsonData = jsGen.getAsString();
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonData);
            res.statusCode = 200;    
        }
        catch(exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(e.getMessage()); //to-do: run tests after updating this to 'Error in GetMemberCount';
        }
    }
	
    private static void doGetMemberUpdates(RestResponse res){
        try{
            String memberResponse = dataRepo.getMemberData();
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(memberResponse);
            res.statusCode = 200;
        }
        catch(exception e){
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);//Blob.valueOf(e.getMessage());
        }
    }
    
    
    private static void doPostMemberUpdates(String inputJSON, RestResponse res){
        try{
            String inputJSONArray = '{ "Flags" : '+inputJSON+'}';
            CFPC_WSL_FlagsParser flagParser = CFPC_WSL_FlagsParser.parse(inputJSONArray);
            //CFPC_WSLegacy_FlagsParser flagParser = CFPC_WSLegacy_FlagsParser.parse(inputJSON);
            CFPC_WSL_FlagsParser.cls_FlagData[] flagsList = flagParser.Flags;
            Map<String,String> flagsMap = new Map<String,String>();
            Map<Id,Contact> conMap = new Map<Id,Contact>();
            for(CFPC_WSL_FlagsParser.cls_FlagData fl : flagsList){
                flagsMap.put(fl.Key, fl.Value);
            }
            List<Contact> member = [SELECT ID, CFPC_CFPC_ID__c FROM Contact WHERE CFPC_CFPC_ID__c in :flagsMap.keySet()
                                    WITH SECURITY_ENFORCED];
            
            for(Contact con : member){
                String flvalue = flagsMap.get(con.CFPC_CFPC_ID__c);
                if(flvalue != null){
                    if(flvalue == '' || String.isEmpty(flvalue)){
                        con.CFPC_INT_Send_to_Legacy__c = false;
                        con.CFPC_INT_Send_to_Legacy_Response__c = 'Success';
                        con.CFPC_INT_Send_To_Legacy_Success_DT__c = System.Now();
                    }
                    
                    else{
                        con.CFPC_INT_Send_to_Legacy_Response__c = flvalue;
                        con.CFPC_INT_Send_To_Legacy_DT__c = System.Now();
                    }
                    
                    //update con;
                    conMap.put(con.Id,con);
                }
                
            }
            
            if(conMap.size() > 0){
                res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c);
            	res.statusCode = 200;
                update conMap.values();
            }
            else{
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);//Blob.valueOf(e.getMessage()); //Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);
            }
            
        }
        catch(exception e){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(e.getMessage()); //Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);
        }
    }
    
    private static void doUpdateEmFmDates(String inputJSON, RestResponse res){
        try{
            
            //String.containsIgnoreCase(searchStr);
            //String.equalsIgnoreCase(other);
            Set<String> booleans = new Set<String>();
            booleans.add('true');
            booleans.add('false');
            CFPC_WSL_EM_FM_Parser emfm = CFPC_WSL_EM_FM_Parser.parse(inputJSON);
            if(emfm.MemberId == null){
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(CFPC_Constants.MEM_NOT_SPEC);
                return;
            }
            Boolean compFlag = emfm.EmFmCompletionFlag != null ? emfm.EmFmCompletionFlag.equalsIgnoreCase('True') ? true : false : false;
            //Boolean compFlag = emfm.EmFmCompletionFlag != null ? booleans.contains(emfm.EmFmCompletionFlag.) == true ? true : false : false;
            Date compDate = emfm.EmFmCompletionDate != null ? Date.valueOf(emfm.EmFmCompletionDate) : null;
            
            //List<CFPC_Education__c> edu = [SELECT Id from CFPC_Education__c WHERE CFPC_Member_Id__r.CFPC_CFPC_Id__c = :emfm.MemberId
                                           //WITH SECURITY_ENFORCED];
            
            List<Contact> member = [SELECT ID, CFPC_CFPC_ID__c FROM Contact WHERE CFPC_CFPC_ID__c = :emfm.MemberId
                                    WITH SECURITY_ENFORCED];
            
            if(member.size() > 0 && emfm.Type != null && (emfm.Type == '1' || emfm.Type == '2') && booleans.contains(emfm.EmFmCompletionFlag.toLowerCase())){
                if(emfm.Type == '1'){
                    member[0].CFPC_EM_Completion_Date__c = compDate;
                    member[0].CFPC_EM_Completion_Flag_Checkbox__c = compFlag;
                }
                else if(emfm.Type == '2'){
                    member[0].CFPC_FM_Completion_Date__c = compDate;
                    member[0].CFPC_FM_Completion_Flag_Checkbox__c = compFlag;
                }
                update member[0];
                res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c);
            	res.statusCode = 200;
            }
            else{
                //to-do: Debug Log reason
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
            	res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);
            }

            
        }
        catch(exception e){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE); //Blob.valueOf(e.getMessage());
        }
    }
    
    private static void doUpdateExamApplicantDesignation(String inputJSON, RestResponse res){
        try{
            String msg;
        	Map<String,CFPC_Subcategory__mdt> validDsgns = new Map<String,CFPC_Subcategory__mdt>();
	        Map<String,CFPC_Subcategory__mdt> validRoutes = new Map<String,CFPC_Subcategory__mdt>();
        	String activeDsgn = 'Active';
            CFPC_WSL_Designation_Parser dsgnInfo = CFPC_WSL_Designation_Parser.parse(inputJSON);
            CFPC_Designation__c dsgn = mapExamDesignationFields(dsgnInfo);
            
            
            if(dsgnInfo.MemberId == null || dsgnInfo.DesignationCode == null || dsgnInfo.EffectiveDate == null){
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(CFPC_Constants.INCORRECT_PARAMETERS_RESPONSE);
                return;
            }
            
            
             
             if(!dsgnInfo.EffectiveDate.contains('T') || (dsgnInfo.ResidencyCompletionDate != null && !dsgnInfo.ResidencyCompletionDate.contains('T'))){
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);
                return;
            }
            
            List<Contact> member = [SELECT Id FROM Contact WHERE cfpc_cfpc_id__c = :dsgnInfo.MemberId limit 1];
        	if(member.size() > 0){
            	dsgn.CFPC_Member_Id__c = member[0].Id;
        	}
            List<CFPC_Designation__c> existingDsgn =   [SELECT Id FROM CFPC_Designation__c 
                                                  		WHERE CFPC_Member_Id__r.cfpc_cfpc_id__c = :dsgnInfo.MemberId
                                                  		AND CFPC_Designation__c = :dsgnInfo.DesignationCode
                                                  		AND CFPC_Designation_Status__c = :activeDsgn];
            Map<String,CFPC_Subcategory__mdt> validSCs = CFPC_Subcategory__mdt.getAll();
            for(CFPC_Subcategory__mdt sc : validSCs.values()){
                if(sc.Type__c == 'Designation'){
                    validDsgns.put(sc.DeveloperName, sc);
                }
                if(sc.Type__c == 'Route'){
                    validRoutes.put(sc.DeveloperName, sc);
                }
        	}

            if(existingDsgn.size() == 0 && validDsgns.containsKey(dsgnInfo.DesignationCode) && (validRoutes.containsKey(dsgnInfo.RouteCode) || dsgnInfo.RouteCode == null)){
            	insert dsgn;
                //List<CFPC_Education__c> edu = [SELECT Id from CFPC_Education__c WHERE CFPC_Member_Id__r.CFPC_CFPC_Id__c = :dsgnInfo.MemberId
                                               //WITH SECURITY_ENFORCED];
                //if(edu.size() > 0 && dsgnInfo.ResidencyCompletionDate != null){
                if(member.size() > 0 && dsgnInfo.ResidencyCompletionDate != null){
                    member[0].CFPC_FM_Completion_Date__c = Date.valueOf(dsgnInfo.ResidencyCompletionDate);
                    member[0].CFPC_FM_Completion_Flag_Checkbox__c = true;
                    																							//update edu[0];
                    update member[0];
                }
            	//msg = CFPC_Constants.SUCCESS_RESPONSE; //'Success';
            	res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c);
                res.statusCode = 200;
        	}
            else if(existingDsgn.size() > 0){
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(CFPC_Constants.DUP_RESPONSE);
            }
            
             else if(!validDsgns.containsKey(dsgnInfo.DesignationCode)){
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(CFPC_Constants.INCORRECT_DSGN_CODE_RESPONSE);
            }
            
            else if(!validRoutes.containsKey(dsgnInfo.RouteCode)){
                res.statusCode = 400;
            	res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(CFPC_Constants.INCORRECT_ROUTE_CODE_RESPONSE);
            }
                
                
        }
        catch(exception e){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE); //Blob.valueOf(e.getMessage()); 
        }
    }
 
    public static CFPC_Designation__c mapExamDesignationFields(CFPC_WSL_Designation_Parser dsgnInfo){
        CFPC_Designation__c dsgn = new CFPC_Designation__c();
        dsgn.CFPC_Designation_Status__c = Constants__mdt.getInstance('Active').Constant_Value__c;
        dsgn.CFPC_DesignationStartDate__c = Date.valueOf(dsgnInfo.EffectiveDate);
        dsgn.Name = dsgnInfo.DesignationCode;
        dsgn.CFPC_Designation__c = dsgnInfo.DesignationCode;
        dsgn.CFPC_DesignationRoute__c = dsgnInfo.RouteCode;
        
        return dsgn;
                                                            
    }
    
    public static void resetData(String memberIdForReset, RestResponse res){
        
        try{
            List<Contact> ctList = [SELECT ID from Contact where CFPC_CFPC_ID__c = :memberIdForReset];
            if(ctList.size() > 0){
                ctList[0].CFPC_INT_Send_To_Legacy__c = true;
                update ctList;
                
                String mcfp = 'MCFP';
                List<CFPC_Designation__c> desgnList = [SELECT ID from CFPC_Designation__c where CFPC_Designation__c != :mcfp
                                                       AND CFPC_Member_Id__r.CFPC_CFPC_Id__c = :memberIdForReset
                                                       AND CreatedDate = Today];
				if(desgnList.size() > 0){
    				delete desgnList;
				}
            }
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf('Flag Reset');
                res.statusCode = 200;
        }
        catch(exception e){
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(e.getMessage());
        }
    }
    
    public static void resetFlag(String memberIdForReset, RestResponse res){
        try{
            List<Contact> ctList = [SELECT ID from Contact where CFPC_CFPC_ID__c = :memberIdForReset];
            if(ctList.size() > 0){
                ctList[0].CFPC_INT_Send_To_Legacy__c = true;
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
}