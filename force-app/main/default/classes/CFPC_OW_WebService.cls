/**
* @date     
* @author   
* @version 1.5
* @description Added POST Designations
*/
@RestResource(urlMapping='/CFPC_OW_WebService/api/*')
global class CFPC_OW_WebService {
    

    @HttpPost
    global static void postPayment() {

        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String inputJSON = req.requestBody.toString();
            Integer i = 0;
            String msg;
            
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(inputJSON);//
              
            for(object fld : results.values()){
                if(fld == null || fld == ''){
                    i++;
                }    
            }
            if(i == 0){
                switch on RestContext.request.requestURI.substringAfter('api/'){
                    when 'Certification/CreatePayment' 	{msg = CFPC_OW_WebServiceHelper.processCreatePaymentInfo(inputJSON);}
                    when 'cac/UpdateCacPayment' 		{msg = CFPC_OW_WebServiceHelper.processCACPaymentInfo(inputJSON);}
                    when 'aeg/UpdatePayment' 			{msg = CFPC_OW_WebServiceHelper.processAEGPaymentInfo(inputJSON);}
                    when 'aeg/UpdateDesignation' 		{msg = CFPC_OW_WebServiceHelper.processDesignationAEG(inputJSON);}
                    when 'cac/UpdateApprovalOfCac' 		{msg = CFPC_OW_WebServiceHelper.processDesignationCAC(inputJSON);}
                    when 'cac/UpdateCacApplicant'		{msg = CFPC_OW_WebServiceHelper.processCACApplicant(inputJSON);}
                    //when 'test/ResetData'				{msg = CFPC_OW_WebServiceHelper.resetData();}
                    when else							{msg = 'Invalid URL';}
                }
                    
                res.addHeader('Content-Type', 'application/json');
                if(msg == CFPC_Constants.SUCCESS_RESPONSE){
                   res.statusCode = 200;
                   res.responseBody = Blob.valueOf(CFPC_Constants.SUCCESS_RESPONSE);//

                }
                else if(msg == CFPC_Constants.DUP_RESPONSE){
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf(CFPC_Constants.DUP_RESPONSE);//

            		
                }
                else if(msg == CFPC_Constants.MEM_NOT_FOUND){
                    res.statusCode = 404;
                    res.responseBody = Blob.valueOf(CFPC_Constants.NOT_FOUND_RESPONSE);

                }
                else{
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf(msg); 
                }
            }
            else{
                res.addHeader('Content-Type', 'application/json');
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(CFPC_Constants.INCORRECT_PARAMETERS_RESPONSE);
            }   
        }
        catch(Exception ex){
            String errorMessage = ex+'';
			RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(CFPC_Constants.FAILED_RESPONSE);
        }

    }
    

    
    
    @HttpGet
    global static void getUniversities() {
        Map<String,Integer> getResult = new Map<String,Integer>();
        String resStr;
        String memberId;
        String schoolId;
        Integer statCode;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if (req.requestURI.substringAfter('api/') == 'exam/GetUniversities/'){
            resStr = CFPC_OW_DataGenerator.generateUnivJSONFormatDataWithArray();
        }
        else if(req.requestURI.contains('cac/GetCacApplicantDetails/')){
            memberId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resStr = CFPC_OW_DataGenerator.generateCACApplicantJSON(memberId);
            if(resStr.contains('Applicant data not found or data incomplete.')){
                res.statusCode = 404;
            }
                
            System.debug('CACApp: ' +res.responseBody);
        }
        else if(req.requestURI.contains('exam/GetExamApplicationDetails/')){
            memberId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resStr = CFPC_OW_DataGenerator.generateExamApplicantJSON(memberId);
            if(resStr.contains('Applicant data not found or data incomplete.')){
                res.statusCode = 404;
            }
                
        }
        else if(req.requestURI.contains('exam/GetDegreesBySchoolCode/')){
            schoolId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            resStr = CFPC_OW_DataGenerator.generateDegreeJSON(schoolId);
            if(resStr.contains('University Not Found')){
                res.statusCode = 404;
            }
                
        }
        else if(req.requestURI.contains('query/GetData/GetMemberByUserName')){
            memberId = req.params.get('Parameter');
            resStr = CFPC_OW_DataGenerator.generateMemberJSON(memberId);
            if(resStr.contains('Member Not Found')){
                res.statusCode = 404;
            }
                
        }
        else if(req.requestURI.contains('Membership/IsMember/')){
            memberId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Boolean rslt = CFPC_OW_DataGenerator.isEligibleForDiscount(memberId);
            res.responseBody = Blob.valueOf(String.valueOf(rslt));
            
        }
        
        else if(req.requestURI.contains('test/ResetData')){
            resStr = CFPC_OW_WebServiceHelper.resetData();
        }
        
        if(resStr != null){
            res.addHeader('Content-Type', 'application/json');
        	res.responseBody = Blob.valueOf(resStr);
                   
        }
           
    }
     
}