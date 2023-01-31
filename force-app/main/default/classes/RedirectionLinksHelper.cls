public without sharing class RedirectionLinksHelper {
    
    static final string TRANSACTION_SUCCESS = 'SUCCESS';
    static final string TRANSACTION_FAIL = 'FAILED';
    public static string accessToken='';
    static final string FMAPPCHECK= 'fmappliedcheck?memberid=';
    static final string FMAPPCHECKWITHRESULT= 'fmappliedcheckwithresults?memberid=';
    static final string EMAPPCHECK= 'emappliedcheck?memberid=';
    static final string EMAPPCHECKWITHRESULT= 'emappliedcheckwithresults?memberid=';
    static final string EXAMINER='OpenExams'; 
    
    @AuraEnabled(cacheable=true)
    public static string cacValidation (){
        string result = TRANSACTION_FAIL;   
        User us = CFPC_CommunityUserContactInfo.getCurrentuser();
        set<string> cacClasses = new Set<String>{'MBR', 'RES', 'SEN', 'LIFE', 'Affiliate'};
            set<string> cacDesignations = new Set<String>{'CCFP', 'RES', 'SEN', 'LIFE', 'Affiliate'};
                set<string> cacDesignationStatus = new Set<String>{'Active'};
                    if (exceptionListCheck(us,'CAC')){
                        result = TRANSACTION_SUCCESS;
                    }else{
                        if (balanceCheck(us)){
                            if(statusCheck(us) && classCheck(us,cacClasses)){
                                result = TRANSACTION_SUCCESS;
                            }else{ 
                                result = System.Label.CAC_MemberStatusandClass;
                            }
                        }else{ result = System.Label.CAC_MemberOutstandingDues;
                        }
                    }     
        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static string emValidation (){
        string result = TRANSACTION_FAIL;   
        User us = CFPC_CommunityUserContactInfo.getCurrentuser();
        set<string> emClasses = new Set<String>{'MBR', 'RES', 'SEN', 'LIFE', 'Affiliate'};
            set<string> emDesignations1 = new Set<String>{'CCFP'};
                //set<string> emDesignations2 = new Set<String>{'CCFP (EM)'};
                 set<string> emDesignations2 = new Set<String>{'EM'};
                    set<string> emDesignationStatus1 = new Set<String>{'Forfeit','Pending'};
                        set<string> emDesignationStatus2 = new Set<String>{'Active'};
                            if (exceptionListCheck(us,'EM')){
                                result = TRANSACTION_SUCCESS;
                            }else{
                                if (balanceCheck(us)){
                                    if(statusCheck(us) && classCheck(us,emClasses)){
                                        if(!designationCheck(us,emDesignations1,emDesignationStatus1)){
                                            if(!designationCheck(us,emDesignations2,emDesignationStatus2)){
                                                string token = getAuthToken();
                                                boolean statusChk=false;
                                                statusChk = emExam_CheckAllowExam(us,EMAPPCHECK,token);
                                                if(statusChk){
                                                    statusChk = emExam_CheckAllowExam(us,EMAPPCHECKWITHRESULT,token);
                                                    if(statusChk){
                                                        result = TRANSACTION_SUCCESS;
                                                    }else result = System.Label.FM_MemberAwaitingResults;
                                                }else { result = System.Label.EM_MemberExam3months;
                                                }
                                            }else{ //result = System.Label.EM_MemberforfeitCCFP;
                                                result = System.Label.EM_MemberActiveCCFP;
                                            }
                                        }else{ //result = System.Label.EM_MemberActiveCCFP;
                                            result = System.Label.EM_MemberforfeitCCFP;
                                        }
                                        
                                    }else{ result = System.Label.EM_MemberStatusandClass;
                                    }
                                }else{ result = System.Label.EM_MemberOutstandingDues;
                                }
                            }     
        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static string aegValidation (){
        string result = TRANSACTION_FAIL;   
        User us = CFPC_CommunityUserContactInfo.getCurrentuser();
        set<string> aegClasses = new Set<String>{'MBR', 'RES', 'SEN'};
            set<string> aegDesignations = new Set<String>{'CCFP', 'FCFP'};
                set<string> aegDesignationStatus = new Set<String>{'Active'};
                    if (exceptionListCheck(us,'AEG')){
                        result = TRANSACTION_SUCCESS;
                    }else{
                        if (balanceCheck(us)){
                            if(statusCheck(us) && classCheck(us,aegClasses)){
                                if(!designationCheck(us,aegDesignations,aegDesignationStatus)){
                                    result = TRANSACTION_SUCCESS;
                                }else{ result = System.Label.AEG_Memberdesignation;
                                }
                            }else{ result = System.Label.AEG_MemberStatusandClass;
                            }
                        }else{ result = System.Label.AEG_MemberOutstandingDues  ;
                        }
                    }     
        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static string fmValidation (){
        string result = TRANSACTION_FAIL;   
        User us = CFPC_CommunityUserContactInfo.getCurrentuser();
        set<string> fmClasses = new Set<String>{'MBR', 'RES', 'SEN', 'LIFE'};
            set<string> fmDesignations = new Set<String>{'CCFP'};
                set<string> fmDesignationStatus = new Set<String>{'Active'};
                    set<string> fmDesignationStatus2 = new Set<String>{'Forfeit','Pending'};
                        if (exceptionListCheck(us,'FM')){
                            result = TRANSACTION_SUCCESS;
                        }else{
                            if (balanceCheck(us)){
                                if(statusCheck(us) && classCheck(us,fmClasses)){
                                    if(!designationCheck(us,fmDesignations,fmDesignationStatus)){
                                        if(!designationCheck(us,fmDesignations,fmDesignationStatus2)){
                                            string token = getAuthToken();
                                            boolean statusChk=false;
                                            statusChk = emExam_CheckAllowExam(us,FMAPPCHECK,token);
                                            if(statusChk){
                                                statusChk = emExam_CheckAllowExam(us,FMAPPCHECKWITHRESULT,token);
                                                if(statusChk){
                                                    result = TRANSACTION_SUCCESS;
                                                }else result = System.Label.FM_MemberAwaitingResults;
                                            }else { result = System.Label.FM_MemberExam3months;
                                            }
                                        }else{ result = System.Label.FM_MemberforfeitCCFP;
                                        }
                                    }else{ result = System.Label.FM_MemberActiveCCFP;
                                    }
                                }else{ result = System.Label.FM_MemberStatusandClass;
                                }
                            }else{ result = System.Label.FM_MemberOutstandingDues;
                            }
                        }     
        
        return result;
    }
    
    @AuraEnabled
    public static string exValidation (){
        string result = TRANSACTION_FAIL;   
        User us = CFPC_CommunityUserContactInfo.getCurrentuser();
            set<string> exDesignations = new Set<String>{'CCFP'};
                set<string> exDesignationStatus = new Set<String>{'Active'};
                    set<string> exDesignationStatus2 = new Set<String>{'Forfeit','Pending'};
                        /*if (exceptionListCheck(us,'EXM')){
                            result = TRANSACTION_SUCCESS;
                        }else{}*/
                                if(statusCheck(us)){
                                    boolean statusChk=false;
                                    if(us.Contact.CFPC_Class__c!= '' && us.Contact.CFPC_Class__c == 'RET'){
                                        Integer dateChk= getRetirementDate(us); 
                                        if(dateChk != null && dateChk<= 1827 ){
                                             string token = getAuthToken();
                                             statusChk = emExam_CheckAllowExam(us,EXAMINER,token);
                                             if(statusChk){
                                                result = TRANSACTION_SUCCESS;
                                             }else{ result = System.Label.FM_MemberStatusandClass;
                                             }
                                        }else result = System.Label.FM_MemberStatusandClass;
                                    }else {
                                        string token = getAuthToken();
                                        statusChk = emExam_CheckAllowExam(us,EXAMINER,token);
                                        if(statusChk){
                                            result = TRANSACTION_SUCCESS;
                                         }else{ 
                                             result = System.Label.FM_MemberStatusandClass;
                                         }
                                    }                     
                                }else{  result = System.Label.FM_MemberStatusandClass;
                                }
        return result;
    }
        
    public static Boolean exceptionListCheck(User us,string component){
        Boolean result = false;
        for(Exemption_List__mdt md: [select MemberId__c,MasterLabel,Component__c from Exemption_List__mdt where Component__c=:component]){
            
            if(us.contactId != null && us.Contact.CFPC_CFPC_ID__c != null){
                if(us.Contact.CFPC_CFPC_ID__c == md.MemberId__c){
                    result = true;
                }
            } 
        }
        return result;
    }
    
    public static Boolean balanceCheck(User us){
        Boolean [] balCheck = new List<Boolean>();
        boolean result = true;
        List<blng__Invoice__c> balDue = [SELECT id,blng__Balance__c,blng__Account__c from blng__Invoice__c where blng__Account__c  =:us.contact.AccountId];
        if(balDue.size()>0){
        for(blng__Invoice__c bl:balDue){
            if(bl.blng__Balance__c != null && bl.blng__Balance__c != 0)
            balCheck.add(false);
        }
        
        if (balCheck.contains(false))
            return result = false;
        }
        return result;
        
    }
    
    public static Boolean statusCheck(User us){
        Boolean result = false;
        
        if (us.contact.CFPC_Status__c == 'Active' ){
            result = true;
        }else{
            result = false;
        }
        return result;
    }
    
    public static Boolean designationCheck(User us, set<string> designations, set<string> designationStatus ){
        Boolean result = false;
        for(CFPC_Designation__c des: [ select CFPC_Designation__c from CFPC_Designation__c WHERE CFPC_Member_Id__c =: us.contactId AND CFPC_Designation_Status__c IN :designationStatus  ]){
            if (des.CFPC_Designation__c != null){
                List<String> selections = des.CFPC_Designation__c.split(';');
                for (String desig: designations ){
                    if(selections.contains(desig)){
                        result = true;
                    }
                }
            }
        }
        return result;
    }
    
    public static Boolean classCheck(User us, set<string> classes ){
        Boolean result = false;
        for(string st:classes){
            if(st.containsIgnoreCase(us.Contact.CFPC_Class__c)){
                result = true;
            }
        }
        return result;
    }
    
    public RedirectionLinksHelper() {
        
    }
    public static boolean emExam_CheckAllowExam(user us, string flowType,string accessToken){
        HttpRequest req = new HttpRequest();
        HttpResponse authresp = new HttpResponse();
        set<string> desg = new set<String>();
        set<string> designationStatus = new Set<String>{'Active'};
        ExamAuthUrl__mdt mcs = ExamAuthUrl__mdt.getInstance('BaseUrl');        
        String authorizationHeader = 'Bearer '+accessToken;
        if(flowType == 'OpenExams')
        req.setEndpoint(mcs.endPointURL__c+flowType);
        else
        req.setEndpoint(mcs.endPointURL__c+flowType+us.Contact.CFPC_CFPC_ID__c);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('rescallout'+res.getBody());
        if(flowType == 'OpenExams' && res.getstatusCode() == 200){
            ExaminerOutputWrapper exresp = ExaminerOutputWrapper.parse(res.getBody());
            if(exresp.responseStatus == true){
                for(ExaminerOutputWrapper.cls_openExams ex:exresp.openExams){
                    desg.add(ex.requiredDesignationFrench);
                    desg.add(ex.requiredDesignationEnglish);
                }
                return designationCheck(us,desg,designationStatus);
            }
            else return false;
        }
        else {
            if(res.getstatusCode() == 200){
                redirectionLinkwrpperOutput resp = new redirectionLinkwrpperOutput();
                resp = redirectionLinkwrpperOutput.parse(res.getBody());
                return resp.responseStatus;
            }
        }
        return false;
        
    }
    
    public static string getAuthToken() {
        ExamAuthUrl__mdt mcs = ExamAuthUrl__mdt.getInstance('ExamAuthUrl');
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        String body;
        try {
            if (mcs!=null) {
                request.setEndpoint(mcs.endPointURL__c);
                request.setMethod(mcs.Method__c);
                request.setHeader('Content-Type','application/json');
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject(); 
                gen.writeStringField('UserName', mcs.UserName__c);
                gen.writeStringField('Password', mcs.Password__c);
                gen.writeEndObject();
                body = gen.getAsString();
            }else{
                System.debug('No End point details found in metadata ExamAuthUrl__mdt');
            }
            request.setBody(body);
            response = http.send(request);
            if(response.getstatusCode() == 200 && response.getbody() != null){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                accessToken = (String)results.get('token');
            }
            return accessToken;
        } catch (Exception ex) {
            system.debug('exception'+ex);
            return accessToken;
        } 

    }
    @AuraEnabled(cacheable=true)
    public static Map<string, string> openWaterNavURLs() {
        Map<string, string> owURLs = new Map<string, string>();
        for(OpenWaterURL_s__mdt mcs:OpenWaterURL_s__mdt.getAll().values()){
            owURLs.put(mcs.NameofFlow__c,mcs.URL__c);
        }
        return owURLs;
    }
    public static Integer getRetirementDate(user us){
        if(us.ContactId != null){
            CFPC_Class_Change_History__c[] cch = [SELECT Id,CFPC_Member_Id__r.Id,CFPC_Status__c,CFPC_Start_Date__c,CFPC_Member_Id__r.CFPC_Class__c 
                                                  from CFPC_Class_Change_History__c 
                                                  where CFPC_Member_Id__r.Id =: us.ContactId AND CFPC_Member_Id__r.CFPC_Class__c ='RET' Order by CFPC_Start_Date__c desc LIMIT 1];
 
            If(cch.size()>0){
                if(cch[0].CFPC_Start_Date__c != null)
                {
                    Integer startDate = system.today().daysBetween(cch[0].CFPC_Start_Date__c);
                    string val = String.valueOf(startDate);
                    If(val.contains('-'))
                      startDate = Integer.valueOf(val.substringAfter('-'));
                    else startDate = Integer.valueOf(val);
                    return startDate;
                }
                
            } 
        }
        return null;
    }
}