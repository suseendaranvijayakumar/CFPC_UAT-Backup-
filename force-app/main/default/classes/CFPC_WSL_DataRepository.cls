public class CFPC_WSL_DataRepository {
	
    
    public String getMemberData(){
        List<Contact> conList = getMembersForPush();
        List<Account> affMedSchoolRecords = new List<Account>();
        Map<String,String> medSchoolNameCodeMap = new Map<String,String>();
        Set<String> affMedSchoolNames = new Set<String>();
        for(Contact ct : conList){
            if(ct.CFPC_Affiliated_Universities__c != null){
                affMedSchoolNames.add(ct.CFPC_Affiliated_Universities__c);
            }
        }
        affMedSchoolRecords = [SELECT Id, Name, CFPC_Medical_School_Code__c from Account where RecordType.DeveloperName = 'CFPC_University' AND Name in :affMedSchoolNames];
        for(Account acc : affMedSchoolRecords){
            if(acc.CFPC_Medical_School_Code__c != null){
                medSchoolNameCodeMap.put(acc.Name, acc.CFPC_Medical_School_Code__c);
            }
        }
        System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        //Datetime bd;
        //bd = ct.Birthdate == null ? null : (DateTime)ct.Birthdate;
        
        //System.debug('bd: ' +bd);
        JSONGenerator jsGen = JSON.createGenerator(true);
        
        jsGen.writeStartObject();  
        for(Contact ct : conList){
            CFPC_Education__c medSchool = null;
            CFPC_Education__c residency = null;
            CFPC_Education__c img = null;
            
            String medSchoolId = '';
            String residencyEdId = '';
			String imgProgramCode = '';
            String imgEndDate = '';
            
            for(CFPC_Education__c edu : ct.Education__r){
                if(medSchool == null && edu.CFPC_Type__c == 'Medical School'){
                    medSchool = edu;
                    medSchoolId = edu?.CFPC_School__r?.CFPC_Medical_School_Code__c;
                    System.debug('medSchool: ' +medSchool);
                }
                else if(residency == null && edu.CFPC_Type__c == 'Residency'){
                    residency = edu;
                    residencyEdId = edu?.CFPC_School__r?.CFPC_Medical_School_Code__c;
                }
                else if(img == null && edu.CFPC_Type__c == 'IMG Canadian Assessment/Training Program'){
                    img = edu;
                    imgProgramCode = edu?.CFPC_Program__c;//CFPC_IMG_Assessment_Program__c;
                    if(edu.CFPC_End_Date__c != null){
                        imgEndDate = convertToDateTime(edu.CFPC_End_Date__c);
                	}
                }
            }
            jsGen.writeFieldName(ct.CFPC_CFPC_ID__c == null ? '' : ct.CFPC_CFPC_ID__c);
            jsGen.writeStartObject();
            
            jsGen.writeStringField('iMisId', ct.CFPC_CFPC_ID__c == null ? '' : ct.CFPC_CFPC_ID__c);
            jsGen.writeStringField('memberId', ct.CFPC_Old_CFPC_ID__c == null ? '' : ct.CFPC_Old_CFPC_ID__c);
            jsGen.writeStringField('nameReference', ct.CFPC_INT_Name_Reference__c == null ? '' : ct.CFPC_INT_Name_Reference__c);
            
            jsGen.writeFieldName('memberDetails');
            jsGen.writeStartObject();
            
                jsGen.writeStringField('medSchool', medSchoolId == null ? '' : medSchoolId);
                jsGen.writeStringField('medSchoolYear', '');
                jsGen.writeStringField('medSchoolGradYear', ct.CFPC_Graduation_Year__c == null ? '' : ct.CFPC_Graduation_Year__c);
                jsGen.writeStringField('residencySchool', residencyEdId == null ? '' : residencyEdId);
                jsGen.writeStringField('residencyYear', '');
                jsGen.writeStringField('residencyProgramCode', ct.CFPC_Residency_Program__c == null ? '' : ct.CFPC_Residency_Program__c);
				jsGen.writeStringField('residencyCompDate', ct.CFPC_FM_Completion_Date__c == null ? '' : convertToDateTime(ct.CFPC_FM_Completion_Date__c));//revisit//revisit ct.CFPC_Residency_Program_End_Date__c == null ? '' : convertToDateTime(ct.CFPC_Residency_Program_End_Date__c));
                jsGen.writeStringField('residencyCompFlag', ct.CFPC_FM_Completion_Flag_Checkbox__c == null ? 'false' : 'true');
                jsGen.writeStringField('postResSchool', ct.CFPC_Undergraduate_Medical_School__c == null ? '' : ct.CFPC_Undergraduate_Medical_School__c);
                jsGen.writeStringField('postResProgramCode', ct.CFPC_Residency_Program__c == null ? '' : ct.CFPC_Residency_Program__c);
            String affMedCode = '';
            if(ct.CFPC_Affiliated_Universities__c != null){
                affMedCode = MedSchoolNameCodeMap.get(ct.CFPC_Affiliated_Universities__c);
            }
                jsGen.writeStringField('affiliateMedSchool', affMedCode == null ? '' : affMedCode); //ct.CFPC_Affiliated_Universities__c == null ? '' : ct.CFPC_Affiliated_Universities__c
            	jsGen.writeStringField('affiliateMedSchoolTitleId', ct.CFPC_Affiliated_Medical_School_Title_ID__c == null ? '' : ct.CFPC_Affiliated_Medical_School_Title_ID__c); //CFPC_Affiliated_Medical_School_Title_ID__c
            	jsGen.writeStringField('dabfpcertification', 'false');
            	jsGen.writeStringField('emResidencyCompFlag', String.valueOf(ct.CFPC_EM_Completion_Flag_Checkbox__c));
            	jsGen.writeStringField('emResidencyCompDate', ct.CFPC_EM_Completion_Date__c == null ? '' : convertToDateTime(ct.CFPC_EM_Completion_Date__c)); //  String.valueOf(ct.CFPC_EM_Completion_Date__c
                jsGen.writeStringField('imgassmtProgramCode', imgProgramCode == null ? '' : imgProgramCode); 
                jsGen.writeStringField('imglicenceExpDate', imgEndDate == null ?  '' : imgEndDate);
            
            
            jsGen.writeStringField('mincNumber', ct.CFPC_MINC_Number__c == null ? '' : ct.CFPC_MINC_Number__c);
            jsGen.writeStringField('category', ct.CFPC_Class__c == null ? '' : ct.CFPC_Class__c);
            jsGen.writeStringField('birthdate', ct.Birthdate == null ? '' : String.valueOf(ct.Birthdate));
            jsGen.writeStringField('enrollmentDate', ct.CFPC_Membership_Enrolment_Date__c == null ? '' : String.valueOf(ct.CFPC_Membership_Enrolment_Date__c));
            jsGen.writeStringField('discontinuedFlag', ct.CFPC_Membership_Discontinued_Date__c == null ? 'false' : 'true');
            jsGen.writeStringField('usOrForeignFlag', ct.CFPC_Out_of_Country__c == null ? 'false' : ct.CFPC_Out_of_Country__c == 'Yes' ? 'true' : 'false'); //String.valueOf(ct.US_or_Foreign_Flag__c));
            jsGen.writeStringField('discontinuedReason', ct.CFPC_Membership_Discontinued_Reason__c == null ? '' : CFPC_WSP_MemberClassCodeMapping.doDiscontinuedCodeMapping(ct.CFPC_Membership_Discontinued_Reason__c));
            jsGen.writeStringField('reinstatementDate', ct.CFPC_Membership_Reinstatement_Date__c == null ? '' : convertToDateTime(ct.CFPC_Membership_Reinstatement_Date__c));
            jsGen.writeStringField('discontinuedDate', ct.CFPC_Membership_Discontinued_Date__c == null ? '' : convertToDateTime(ct.CFPC_Membership_Discontinued_Date__c));
            jsGen.writeStringField('chapter', ct.CFPC_Chapter__c == null ? '' : ct.CFPC_Chapter__c);
            
            jsGen.writeEndObject();
            
            jsGen.writeFieldName('addresses');
            jsGen.writeStartArray();
            jsGen.writeStartObject();
            if(ct.CFPC_Primary_Address__c == 'Home' || ct.CFPC_Primary_Address__c == ''){
                jsGen.writeStringField('address2', '');
                jsGen.writeStringField('address3', '');
                jsGen.writeStringField('city', ct.MailingCity == null ? '' : ct.MailingCity);
                jsGen.writeStringField('countryCode', ct.MailingCountry == null ? '' : ct.MailingCountry);
                jsGen.writeStringField('province', ct.MailingState == null ? '' : ct.MailingStateCode);
                jsGen.writeStringField('postalCode', ct.MailingPostalCode == null ? '' : ct.MailingPostalCode);
                jsGen.writeStringField('address1', ct.MailingStreet == null ? '' : ct.MailingStreet.replace('\r\n', ' ').replace('\n', ', ')); //.replace('\r\n', ' ')
                jsGen.writeStringField('addressType', 'PRI');
                jsGen.writeStringField('locationCode', 'H');
            }
            if(ct.CFPC_Primary_Address__c == 'Practice'){
                jsGen.writeStringField('address2', '');
                jsGen.writeStringField('address3', '');
                jsGen.writeStringField('city', ct.OtherCity == null ? '' : ct.OtherCity);
                jsGen.writeStringField('countryCode', ct.OtherCountry == null ? '' : ct.OtherCountry);
                jsGen.writeStringField('province', ct.OtherState == null ? '' : ct.OtherStateCode);
                jsGen.writeStringField('postalCode', ct.OtherPostalCode == null ? '' : ct.OtherPostalCode);
                jsGen.writeStringField('address1', ct.OtherStreet == null ? '' : ct.OtherStreet.replace('\r\n', ' ').replace('\n', ', '));//.replace('\r\n', ' ')
                jsGen.writeStringField('addressType', 'PRI');
                jsGen.writeStringField('locationCode', 'O');
            }
            //ct.MailingGeocodeAccuracy == null ? '' : ct.MailingGeocodeAccuracy);
            jsGen.writeEndObject();
            
            //jsGen.writeStartArray();
            //jsGen.writeStartObject();
            //jsGen.writeStringField('address2', '');
            //jsGen.writeStringField('address3', '');
            //jsGen.writeStringField('city', ct.MailingCity == null ? '' : ct.MailingCity);
            //jsGen.writeStringField('countryCode', ct.MailingCountry == null ? '' : ct.MailingCountry);
            //jsGen.writeStringField('province', ct.MailingState == null ? '' : ct.MailingState);
            //jsGen.writeStringField('postalCode', ct.MailingPostalCode == null ? '' : ct.MailingPostalCode);
            //jsGen.writeStringField('address1', ct.MailingStreet == null ? '' : ct.MailingStreet);
            //jsGen.writeStringField('addressType', 'PRI');
            //jsGen.writeStringField('locationCode', 'H');//ct.MailingGeocodeAccuracy == null ? '' : ct.MailingGeocodeAccuracy);
            //jsGen.writeEndObject();
             
            
            //jsGen.writeStartObject();
            //jsGen.writeStringField('addressType', 'Secondary');
           // jsGen.writeStringField('address1', ct.OtherStreet == null ? '' : ct.OtherStreet);
           // jsGen.writeStringField('address2', '');
           // jsGen.writeStringField('address3', '');
            //jsGen.writeStringField('city', ct.OtherCity == null ? '' : ct.OtherCity);
           // jsGen.writeStringField('province', ct.OtherState == null ? '' : ct.OtherState);
           // jsGen.writeStringField('postalCode', ct.OtherPostalCode == null ? '' : ct.OtherPostalCode);
            //jsGen.writeStringField('countryCode', ct.OtherCountry == null ? '' : ct.OtherCountry);
            //jsGen.writeStringField('locationCode', ct.OtherGeocodeAccuracy == null ? '' : ct.OtherGeocodeAccuracy);
            //jsGen.writeEndObject();
            jsGen.writeEndArray();
            
            jsGen.writeFieldName('phones');
            jsGen.writeStartArray();
    
            jsGen.writeStartObject();
            jsGen.writeStringField('phoneTypeCode', 'HOM');
            jsGen.writeStringField('phoneNumber', ct.HomePhone == null ? '' : ct.HomePhone);
            jsGen.writeStringField('phoneExtension', '');
            jsGen.writeEndObject();
            
            jsGen.writeStartObject();
            jsGen.writeStringField('phoneTypeCode', 'CEL');
            jsGen.writeStringField('phoneNumber', ct.MobilePhone == null ? '' : ct.MobilePhone);
            jsGen.writeStringField('phoneExtension', '');
            jsGen.writeEndObject();
            
            jsGen.writeStartObject();
            jsGen.writeStringField('phoneTypeCode', 'OFC');
            jsGen.writeStringField('phoneNumber', ct.Phone == null ? '' : ct.Phone);
            jsGen.writeStringField('phoneExtension', '');
            jsGen.writeEndObject();
            
            jsGen.writeEndArray();
            
            
            jsGen.writeFieldName('licenses');
            jsGen.writeStartArray();
            for(CFPC_License__c lcs : ct.Licenses__r){
                jsGen.writeStartObject();
                jsGen.writeStringField('licenceNumber', lcs.CFPC_License_Number__c == null ? '' : String.valueOf(lcs.CFPC_License_Number__c));
                jsGen.writeStringField('expiryDate', lcs.CFPC_Expiry_Date__c == null ? '' : convertToDateTime(lcs.CFPC_Expiry_Date__c));
                jsGen.writeStringField('licenceCode', lcs.CFPC_License_Code__c == null ? '' : lcs.CFPC_License_Code__c);
                jsGen.writeEndObject();
            }
            jsGen.writeEndArray();
            
            jsGen.writeFieldName('profile');
            jsGen.writeStartObject();
            jsGen.writeStringField('surname', ct.LastName);
            jsGen.writeStringField('salutation', ct.Salutation == null ? '' : ct.Salutation);
            jsGen.writeStringField('firstName', ct.FirstName == null ? '' : ct.FirstName);
            //jsGen.writeStringField('sex', ct.CFPC_Gender__c == null ? '' : ct.CFPC_Gender__c);
            jsGen.writeStringField('sex', ct.CFPC_Gender__c == null ? '' : ct.CFPC_Gender__c == 'Male' ? 'M' : ct.CFPC_Gender__c == 'Female' ? 'F' : ct.CFPC_Gender__c);
            jsGen.writeStringField('mailLanguage', ct.CFPC_Preferred_Language__c == null ? '' : ct.CFPC_Preferred_Language__c == 'English' ? 'E' : 'F');
            jsGen.writeStringField('middleName', ct.MiddleName == null ? '' : ct.MiddleName);
            jsGen.writeStringField('eMail', ct.Email == null ? '' : ct.Email);
            jsGen.writeEndObject();
            
            jsGen.writeFieldName('subcategories');
            jsGen.writeStartArray();
            for(CFPC_Designation__c dsg : ct.Designations__r){
                jsGen.writeStartObject();
                jsGen.writeStringField('designationstartDate', dsg.CFPC_DesignationStartDate__c == null ? '' : convertToDateTime(dsg.CFPC_DesignationStartDate__c));
                jsGen.writeStringField('designationenddate', dsg.CFPC_DesignationEndDate__c == null ? '' : convertToDateTime(dsg.CFPC_DesignationEndDate__c));
                jsGen.writeStringField('designationroute', dsg.CFPC_DesignationRoute__c == null ? '' : dsg.CFPC_DesignationRoute__c);
                jsGen.writeStringField('designation', dsg.CFPC_Designation__c == null ? '' : dsg.CFPC_Designation__c);
                jsGen.writeEndObject();
            }
            jsGen.writeEndArray();
            
            jsGen.writeFieldName('openWaterApplications');
            jsGen.writeStartArray();
            for(CFPC_Mock_Payment__c pt : ct.Payments_Custom__r){
                jsGen.writeStartObject();
                jsGen.writeStringField('openWaterId', pt.CFPC_OpenWater_ID__c);
                jsGen.writeStringField('openWaterApplicationType', 'N/A');
                jsGen.writeStringField('paymentType', pt.CFPC_Type__c == null ? '' : pt.CFPC_Type__c);
                jsGen.writeStringField('applicationPaymentDate', pt.CFPC_Order_Date__c == null ? '' : String.valueOf(pt.CFPC_Order_Date__c));
                jsGen.writeNumberField('paymentAmount', pt.CFPC_Payment_Amount__c);
                jsGen.writeStringField('PAYMENTTXNREFID', pt.CFPC_Transaction_Reference_ID__c);
                jsGen.writeEndObject();
            }
            jsGen.writeEndArray();
            
            jsGen.writeFieldName('sliDetails');
            jsGen.writeStartObject();
            //jsGen.writeStringField('sliPurchasedFlag', ct.SLPs__r.size() > 0 ? 'true' : 'false'); 
            jsGen.writeStringField('sliPurchasedFlag', ct.CFPC_Int_Self_Learning_Access_Flag__c == true ? 'true' : 'false'); // based on new field
            jsGen.writeStringField('sliContractStartDate', ct.CFPC_INT_SLI_CONTRACT_START__c == null ? '' : String.valueOf(ct.CFPC_INT_SLI_CONTRACT_START__c)); // based on new field
            jsGen.writeEndObject();
            
            jsGen.writeEndObject();
            
            
        }        
		jsGen.writeEndObject();
        String jsonData = jsGen.getAsString();
        
        System.debug('json format Data==> ' + jsonData);
        return jsonData;
    }
    
    
    
    public static String convertToDateTime (date dateField){
        Datetime dt =  datetime.newInstance(dateField.year(),datefield.month(), datefield.day());  //dateField;//(Datetime)dateField;
        //String dtString = String.valueOf(dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        
        //String dtString = String.valueOf(dt.format('MM/dd/yyyy hh:mm:ss a')); //- dnu
        //String dtString = String.valueOf(dt.format('MM/dd/yyyy h:mm:ss a','America/New_York')); //-
        String dtString = String.valueOf(dt.format('MM/dd/yyyy h:mm:ss a','America/New_York'));
        return dtString;
    }
    

    public static String returnTruncatedString(String stringToBeTruncated, Integer maxLength){
        if(stringToBeTruncated.length() > maxLength ){
    		return stringToBeTruncated.substring(0, maxLength);
		}
        else{
            return stringToBeTruncated;
        }
    }
    
    public static List<Contact> getMembersForPush(){
        
        Set<String> educationTypes = new Set<String>();
        educationTypes.add('Medical School');
        educationTypes.add('Residency');
        educationTypes.add('IMG Canadian Assessment/Training Program');
        
		List<Contact> conList = new List<Contact>();
        	conList = [SELECT Id, Name, CFPC_INT_Name_Reference__c, CFPC_CFPC_ID__c, CFPC_Old_CFPC_ID__c, Birthdate, FirstName, LastName, Email, Phone, MobilePhone, Salutation,
                      Middlename, CFPC_Gender__c, MailingAddress, CFPC_Primary_Address__c, US_or_Foreign_Flag__c,
                      MailingStreet, MailingCity, MailingState, MailingStateCode, MailingPostalCode, MailingCountry, MailingGeocodeAccuracy,
                      OtherAddress, CFPC_Preferred_Language__c, CFPC_Int_Self_Learning_Access_Flag__c, CFPC_INT_SLI_CONTRACT_START__c, //new SLP fields
                      OtherStreet, OtherCity, OtherState, OtherStateCode, OtherPostalCode, OtherCountry, OtherGeocodeAccuracy, CFPC_Out_of_Country__c,
                      HomePhone,  //CFPC_Phone_Number_Extension__c,
                      CFPC_Affiliated_Universities__c, CFPC_Affiliated_Medical_School_Title_ID__c, //CFPC_Affiliated_Medical_School__c
                      CFPC_Membership_Discontinued_Date__c, CFPC_Membership_Discontinued_Reason__c,
                      CFPC_Membership_Reinstatement_Date__c, CFPC_MINC_Number__c,
                      CFPC_Chapter__c, CFPC_Class__c, CFPC_Class_Type__c, CFPC_Membership_Enrolment_Date__c,
                      CFPC_IMG_Assessment_Program__c, CFPC_IMG_Program_End_Date__c, CFPC_FM_Completion_Flag_Checkbox__c, 
                      CFPC_EM_Completion_Flag_Checkbox__c, CFPC_EM_Completion_Date__c, CFPC_FM_Completion_Date__c,
                      CFPC_Residency_Program__c, CFPC_Residency_Program_End_Date__c, CFPC_Graduation_Year__c,
                      CFPC_Residency_Program_Start_Date__c, CFPC_Residency_School__c, CFPC_Residency_Completion_Flag__c,
                      CFPC_Undergraduate_Medical_School__c, CFPC_Undergraduate_Program_End_Date__c, CFPC_Undergraduate_Medical_School_Code__c,
                      	(SELECT Id from SLPs__r),
                      	(SELECT Id, CFPC_OpenWater_ID__c, //openWaterApplicationType,
                       	 	CFPC_Billing_Type__c, CFPC_Order_Date__c,
                       	 	CFPC_Payment_Amount__c, CFPC_Transaction_Reference_ID__c, CFPC_Type__c from Payments_Custom__r),
                      	(SELECT Id, CFPC_Designation__c, CFPC_DesignationRoute__c,
                       		CFPC_DesignationStartDate__c, CFPC_DesignationEndDate__c from Designations__r
                        	Where CFPC_Designation_Status__c = 'Active'),
                      	(SELECT Id, CFPC_License_Code__c, CFPC_License_Number__c, CFPC_Expiry_Date__c from Licenses__r),
                       
						(SELECT Id, CFPC_School__r.CFPC_Medical_School_Code__c, CFPC_Program__c,//CFPC_IMG_Assessment_Program__c, CFPC_IMG_Program_End_Date__c,
                         CFPC_Start_Date__c, CFPC_End_Date__c, CFPC_Type__c
                         from Education__r
                         WHERE CFPC_Type__c in :educationTypes ORDER BY CreatedDate DESC)
                       
                      FROM Contact where CFPC_INT_Send_To_Legacy__c = True AND CFPC_CFPC_ID__c != '' AND CFPC_Class__c != 'Prospect' LIMIT 150];
        
        return conList;
    }  
}