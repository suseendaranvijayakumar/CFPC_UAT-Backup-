/** 
 * @date 2022-08-01
 * @author IndustriousCRM
 * @version 1.0
 * @description Data Generator for SF-OpenWater Integration
 */
public with sharing class CFPC_OW_DataGenerator {
    

	public static Contact getMember(String memberID){
        List<Contact> conList = new List<Contact>();
        		conList = [SELECT Id, Name, CFPC_INT_Company__c, CFPC_CFPC_ID__c, Birthdate, FirstName, LastName, Email, Phone, Salutation,CFPC_Status__c,
                      Middlename, CFPC_Gender__c, MailingAddress, 	CFPC_Address2__c, 	CFPC_Address3__c,
                      MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingGeocodeAccuracy, Country_Code__c,
                      OtherAddress, CFPC_Preferred_Language__c,
                      OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherGeocodeAccuracy,
                      HomePhone, MobilePhone, CFPC_Phone_Number_Extension__c,
                      CFPC_Affiliated_Medical_School__c, CFPC_Affiliated_Medical_School_Title_ID__c,
                      CFPC_Membership_Discontinued_Date__c, CFPC_Membership_Discontinued_Reason__c,
                      CFPC_Membership_Reinstatement_Date__c, CFPC_MINC_Number__c, CFPC_Class__c,
                      CFPC_Chapter__c, CFPC_Class_Type__c, CFPC_Membership_Enrolment_Date__c, CFPC_Membership_Expiration_Date__c,
                      CFPC_IMG_Assessment_Program__c, CFPC_IMG_Program_End_Date__c, CFPC_FM_Completion_Flag_Checkbox__c, 
                      CFPC_EM_Completion_Flag_Checkbox__c, CFPC_EM_Completion_Date__c, CFPC_FM_Completion_Date__c,
                      CFPC_Residency_Program__c, CFPC_Residency_Program_End_Date__c, CFPC_Graduation_Year__c,
                      CFPC_Residency_Program_Start_Date__c, CFPC_Residency_School__c, CFPC_Residency_Completion_Flag__c,
                      CFPC_Undergraduate_Medical_School__c, CFPC_Undergraduate_Program_End_Date__c, CFPC_Undergraduate_Medical_School_Code__c,
                      	(SELECT Id from SLPs__r ),
                      	(SELECT Id, CFPC_OpenWater_ID__c,
                       	 	CFPC_Billing_Type__c, CFPC_Order_Date__c,
                       	 	CFPC_Payment_Amount__c, CFPC_Transaction_Reference_ID__c from Payments_Custom__r),
                      	(SELECT Id, Name, CFPC_Designation__c, CFPC_DesignationRoute__c,
                       		CFPC_DesignationStartDate__c, CFPC_DesignationEndDate__c from Designations__r
                        	where CFPC_Designation_Status__c = 'Active')
                      FROM Contact where CFPC_CFPC_ID__c = :memberId LIMIT 1];
        if(conList.size() > 0){
            return conList[0];
        }
        else{
            return null;
        }
    }
    

    public static String generateUnivJSONFormatDataWithArray(){
        List<Account> univList = [SELECT Name, BillingCountry, BillingCity, CFPC_Medical_School_Code__c, CFPC_Medical_School_Name_FR__c
                            	  From Account Where RecordType.DeveloperName = 'CFPC_University' WITH SECURITY_ENFORCED ORDER By Name ASC];//Type = 'University' WITH SECURITY_ENFORCED ORDER By Name ASC];
        List<CFPC_UniversityMapping__mdt> mappingList = [SELECT DeveloperName, SObject_Name__c, Field_API_Name__c, Type__c, 
        												 Order__c 
                                                         FROM CFPC_UniversityMapping__mdt 
                                                         WITH SECURITY_ENFORCED ORDER BY Order__c ASC];
        JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject();
        
        CFPC_Constants.createOperationSuccessfulJSON(jsGen);
        jsGen.writeFieldName('MedicalSchoolData');
        jsGen.writeStartArray();
        
        for(Account uni: univList){
            jsGen.writeStartObject();
            for(CFPC_UniversityMapping__mdt mp : mappingList){
                String sm = (String)uni.get(mp.Field_API_Name__c);
                jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : sm);
            }
        	jsGen.writeEndObject();
        }

        jsGen.writeEndArray();
        
        jsGen.writeEndObject();
        
        String jsonData = jsGen.getAsString();
        
        System.debug('univs: ' +jsonData);
        return jsonData;
    }    
    
    

    public static String generateCACApplicantJSON(String memberId){
        Map<String,Integer> getResult = new Map<String,Integer>();
        CFPC_Education__c edu = new CFPC_Education__c();
        SObject obj;
        
        String designations = '';
        Contact con = CFPC_OW_DataGenerator.getMember(memberId);
        JSONGenerator jsGen = JSON.createGenerator(true);
        List<CFPC_CACApplicantMapping__mdt> mappingList = [SELECT DeveloperName, SObject_Name__c, 
                                                           Field_API_Name__c, Type__c, Order__c 
                                                           FROM CFPC_CACApplicantMapping__mdt
                                          				   WITH SECURITY_ENFORCED ORDER BY Order__c ASC];
        
        if(con != null){
                      
            for(CFPC_Designation__c dsgn : con.Designations__r){
                String desName = dsgn.Name;
                designations +=  desName + ', '; 
            }
            designations = designations.removeEnd(', ');
            
            jsGen.writeStartObject();
            for(CFPC_CACApplicantMapping__mdt mp : mappingList){
                
                switch on mp.SObject_Name__c{
                    when 'Contact' {
                        obj = con;
                        
                    }
                }
                
                if(mp.Type__c == 'String'){
                	String sm = (String)obj.get(mp.Field_API_Name__c);
                	jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : sm);
                }
                    
                else if(mp.Type__c == 'Date'){
                    Date sm = (Date)obj.get(mp.Field_API_Name__c);
                	jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                }
                else if(mp.Type__c == 'Boolean'){
                    Boolean sm = (Boolean)obj.get(mp.Field_API_Name__c);
                    jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                }
                else{
                    jsGen.writeStringField(mp.DeveloperName, designations == null ? '' :designations);
                }
            	                
            }
            
            jsGen.writeFieldName('SubCategories');
                jsGen.writeStartArray();
                for(CFPC_Designation__c dsgn : con.Designations__r){
                    jsGen.writeStartObject();
                    jsGen.writeStringField('SubcategoryDesc', dsgn.Name);
                    jsGen.writeStringField('EffDate', dsgn.CFPC_DesignationStartDate__c == null ? '' : String.valueOf(dsgn.CFPC_DesignationStartDate__c));
                    jsGen.writeStringField('Subcategory', dsgn.CFPC_Designation__c == null ? '' : dsgn.CFPC_Designation__c);
                    jsGen.writeEndObject();
                }
                jsGen.writeEndArray();
            
            CFPC_Constants.createOperationSuccessfulJSON(jsGen);
            jsGen.writeEndObject();
			
			getResult.put(jsGen.getAsString(),200);        
            
        }
        else{
            CFPC_Constants.createApplicantNotFoundJSON(jsGen);
            
            getResult.put(jsGen.getAsString(),400);
        }
        String jsonData = jsGen.getAsString();
        System.debug('jsonData:' +jsonData);
        return jsonData;
    }
    

    public static String generateExamApplicantJSON(String memberId){
        CFPC_Education__c edu = new CFPC_Education__c();
        SObject obj;
        
        String designations = '';
        Contact con = CFPC_OW_DataGenerator.getMember(memberId);
        JSONGenerator jsGen = JSON.createGenerator(true);
        List<CFPC_ExamApplicantMapping__mdt> mappingList = [SELECT DeveloperName, SObject_Name__c, Field_API_Name__c, Type__c, 
                                                            Order__c 
                                                            FROM CFPC_ExamApplicantMapping__mdt 
                                                            WITH SECURITY_ENFORCED ORDER BY Order__c ASC];
        
        if(con != null){
            
            for(CFPC_Designation__c dsgn : con.Designations__r){
                String desName = dsgn.Name;
                designations +=  desName + ', '; 
            }
            designations = designations.removeEnd(', ');
            
            jsGen.writeStartObject();
            for(CFPC_ExamApplicantMapping__mdt mp : mappingList){
                
                switch on mp.SObject_Name__c{
                    when 'Contact' {
                        obj = con;
                        
                    }
                }
                
                if(mp.Type__c == 'String'){
                	String sm = (String)obj.get(mp.Field_API_Name__c);
                	jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : sm);
                }
                    
                else if(mp.Type__c == 'Date'){
                    Date sm = (Date)obj.get(mp.Field_API_Name__c);
                	jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                }
                
                else if(mp.Type__c == 'Boolean'){
                    Boolean sm = (Boolean)obj.get(mp.Field_API_Name__c);
                    
                    jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                }
                else{
                    jsGen.writeStringField(mp.DeveloperName, designations == null ? '' :designations);
                }     
            }
            
            jsGen.writeFieldName('SubCategories');
                jsGen.writeStartArray();
                for(CFPC_Designation__c dsgn : con.Designations__r){
                    jsGen.writeStartObject();
                    jsGen.writeStringField('SubcategoryDesc', dsgn.Name);
                    jsGen.writeStringField('EffDate', dsgn.CFPC_DesignationStartDate__c == null ? '' : String.valueOf(dsgn.CFPC_DesignationStartDate__c));
                    jsGen.writeStringField('Subcategory', dsgn.CFPC_Designation__c == null ? '' : dsgn.CFPC_Designation__c);
                    jsGen.writeEndObject();
                }
                jsGen.writeEndArray();
            
            jsGen.writeStringField('ResponseStatus', 'true');
            jsGen.writeStringField('Message', 'Operation Successful!');
            jsGen.writeEndObject();
			
			          
        }
        else{
            CFPC_Constants.createApplicantNotFoundJSON(jsGen);

        }
        String jsonData = jsGen.getAsString();
        System.debug('jsonData:' +jsonData);
        return jsonData;
    }
    

    public static String generateDegreeJSON(String schoolId){

        List<CFPC_Degree__c> degrees = new List<CFPC_Degree__c>();
        JSONGenerator jsGen = JSON.createGenerator(true);
        degrees = [SELECT Name, CFPC_Medical_School_Name_FR__c, CFPC_Medical_School_Code__c FROM CFPC_Degree__c
                   WHERE CFPC_Medical_School_Code__c = :schoolId WITH SECURITY_ENFORCED];
        if(degrees.size() > 0){
            jsGen.writeStartObject();
        
        jsGen.writeBooleanField('ResponseStatus', true);
        jsGen.writeStringField('Message', 'Operation Successful!');
        jsGen.writeFieldName('MedicalSchoolDegreesData');
                jsGen.writeStartArray();
                for(CFPC_Degree__c dg : degrees){
                    jsGen.writeStartObject();
                    jsGen.writeStringField('MedDegreeName', dg.Name);
                    jsGen.writeStringField('MedDegreeNameFr', dg.CFPC_Medical_School_Name_FR__c);
                    jsGen.writeStringField('MedSchoolCode', dg.CFPC_Medical_School_Code__c);
                    jsGen.writeEndObject();
                }
                jsGen.writeEndArray();
        
        jsGen.writeEndObject();
        }
        else{
            jsGen.writeStartObject();
            jsGen.writeStringField('ResponseStatus', 'false');
            jsGen.writeStringField('Message', 'University Not Found');
            jsGen.writeEndObject();
        }
        
        String jsonData = jsGen.getAsString();
        System.debug('jsonData:' +jsonData);
        
        return jsonData;
    }
    

    public static String generateMemberJSON(String username){
        List<User> member = new List<User>();
        member = [SELECT Id, Contact.cfpc_cfpc_id__c, Username, LastName, FirstName, Email, Contact.CFPC_Old_CFPC_ID__c, Contact.CFPC_Preferred_Language__c
                  FROM User WHERE username = :username WITH SECURITY_ENFORCED LIMIT 1];
        JSONGenerator jsGen = JSON.createGenerator(true);
        if(member.size() > 0){
            jsGen.writeStartArray();
        	for(User us : member){
                jsGen.writeStartObject();
                jsGen.writeStringField('MemberId', us.Contact?.cfpc_cfpc_id__c);
                jsGen.writeStringField('UserName', us.Username);
                jsGen.writeStringField('LastName', us.LastName);
                jsGen.writeStringField('FirstName', us.FirstName);
                jsGen.writeStringField('Email', us.Email);  
                jsGen.writeStringField('OldMemberId', (us.Contact != null && us.Contact.CFPC_Old_CFPC_ID__c != null) ? us.Contact.CFPC_Old_CFPC_ID__c : '');
                jsGen.writeStringField('Language', us.Contact?.CFPC_Preferred_Language__c); 
                
                jsGen.writeEndObject();
        	}
        		jsGen.writeEndArray();
        }
        
        
        else if(member.size() == 0){
            
            CFPC_Constants.createMemberNotFoundJSON(jsGen);
        }
        
        String jsonData = jsGen.getAsString();
        System.debug('jsonData:' +jsonData);
        
        return jsonData;
    }
    

    public static Boolean isEligibleForDiscount(String memberID){
        Boolean result = false;
        List<Contact> cfpcMember = new List<Contact>();
        JSONGenerator jsGen = JSON.createGenerator(true);
        Set<String> desgn = new Set<String>();
        desgn.add('CCFP');
        desgn.add('MCFP');
        desgn.add('CCMF');
        desgn.add('MCMF');
        
        Set<String> classtype = new Set<String>();
        classtype.add('MBR');
        classtype.add('SEN');
        classtype.add('RET');
        
        cfpcMember = [SELECT Id, CFPC_Class__c, 
                      		(SELECT Id from Designations__r
                        	WHERE CFPC_Designation_Status__c = 'Active' and CFPC_Designation__c in :desgn) 
                      FROM Contact WHERE cfpc_cfpc_id__c = :memberID and CFPC_Class__c in :classtype WITH SECURITY_ENFORCED limit 1];
        if(cfpcMember.size() > 0 && cfpcMember[0]?.Designations__r.size() > 0){
            result = TrUE;
        }

        else{
        	result = FaLSE;
        }
        
        return result;       
    }   
    
}