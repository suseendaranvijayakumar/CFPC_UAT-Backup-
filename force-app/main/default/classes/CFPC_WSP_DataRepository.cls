public with sharing class CFPC_WSP_DataRepository {
    
  //to-do make dynamic / remove hardcoded
  //static String groupBMember = '';
  //static Strng groupCMember = '';  
        
  private Map<String, String> effectiveDateMap = new Map<String, String>{
    '660004' => '2018-07-01T00:00:00'
  };

  private Map<String, String> otherLicensingProvincesMap = new Map<String, String>{
    '660004' => 'Alberta|Nova Scotia|Ontario'
  };

  private Set<String> existingMemberSet = new Set<String>{ '660004' };

  public boolean existsMemberWithId(String memberid) {
    boolean exists = false;
    if ((null != memberid) && existingMemberSet.contains(memberid)) {
      exists = true;
    }
    return exists;
  }

  public CFPC_WSP_DataRepository() {
      
  }

  	public String getMemberCountData() {
        Set<String> excludedClassSet = new Set<String>();
        excludedClassSet.add('Associate');
        excludedClassSet.add('Exhibitor');
        excludedClassSet.add('Exam Only');
        excludedClassSet.add('Honorary');
        excludedClassSet.add('Prospect');
        excludedClassSet.add('Public Member');
        excludedClassSet.add('STU');
        String response = '';
    	String memberCountResponse = '0';
        JSONGenerator jsGen = JSON.createGenerator(true);
		memberCountResponse = String.valueOf([SELECT COUNT() FROM Contact WHERE Send_To_CECity__c = TRUE AND CFPC_CFPC_ID__c != '' AND CFPC_Class__c NOT IN :excludedClassSet]);
        jsGen.writeStartObject();
        jsGen.writeStringField('count', memberCountResponse);
        jsGen.writeEndObject();
        response = jsGen.getAsString();   
      	return response;
  	}

  public String getCpdUpdateMembers(List<CFPC_CPD_Cycle_Update_Member__c> cpdUpdateMembers) {
      String response = '';
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartArray();
      for(CFPC_CPD_Cycle_Update_Member__c cpdm : cpdUpdateMembers){
          gen.writeStartObject();
          gen.writeStringField('ID', cpdm.Name);
          gen.writeEndObject();
      }
    gen.writeEndArray();
      if(gen != null){
          response = gen.getAsString();
      }
      
    return response;
  }
	
    public  String getPracticingChangeDates(String memberId, Boolean isPracticingMember) {
        String responseStr = '';
        List<DateTime> changeDates = new List<DateTime>();
        List<CFPC_Change_Log__c> memberChangeLogs =   [SELECT Id, CFPC_INT_Change_Date__c, CFPC_INT_Current_Value__c
                                                		FROM CFPC_Change_Log__c 
                                                		WHERE CPFC_INT_Object_Type_Name__c = 'CFPC_MEMBER'
                                                		AND CFPC_INT_Property__c = 'PRACTICING'
                                                		AND CFPC_INT_Member_ID__c = :memberId
                                                		WITH SECURITY_ENFORCED ORDER BY CFPC_INT_Change_Date__c DESC];
        
        for(CFPC_Change_Log__c mc : memberChangeLogs){
            if(isPracticingMember){
                if(mc.CFPC_INT_Current_Value__c == 'True' || mc.CFPC_INT_Current_Value__c == '1' ){
                    changeDates.add(mc.CFPC_INT_Change_Date__c);
                }
            }
            else{
                if(mc.CFPC_INT_Current_Value__c == 'False' || mc.CFPC_INT_Current_Value__c == '0' ){
                    changeDates.add(mc.CFPC_INT_Change_Date__c);
                }
            }
        }
        if(changeDates.size() > 0){
            DateTime dtresponse = changeDates[changeDates.size()-1];
            responseStr = '"' + String.valueOf(dtresponse).replaceFirst(' ', 'T') + '-4:00' + '"';
        }
    	return responseStr;
    }
    
    public  String getMemberEffectiveDateForMember(String memberId) {
        String response = '';
        Date srtDate;
        String mbrClass = '';
        Map<String,Date> MbrClassStartDateMap = new Map<String,Date>();
        //Discontinued filter removed based on discussion with CFPC RS and JV
        List<CFPC_Class_Change_History__c> memberClasses = [SELECT CFPC_Start_Date__c, CFPC_Class__c, CFPC_Member_Id__c
                                                         FROM CFPC_Class_Change_History__c 
                                                         WHERE CFPC_Member_Id__r.CFPC_CFPC_ID__c = :memberId //AND CFPC_Status__c != 'Discontinued' //CFPC_Member_Id__r.CFPC_Status__c != 'Discontinued'
                                                         WITH SECURITY_ENFORCED ORDER BY CFPC_Start_Date__c DESC];  //LIMIT 1];
        
        if(memberClasses.size() > 0){
            mbrClass = memberClasses[0].CFPC_Class__c;
        }
        
        for(CFPC_Class_Change_History__c mc : memberClasses){
            if(mc.CFPC_Class__c == mbrClass){
                MbrClassStartDateMap.put(mc.CFPC_Class__c, mc.CFPC_Start_Date__c);
            }
            else{
                break;
            }
            //response = '"' + String.valueOf(mc.CFPC_Start_Date__c) + 'T00:00:00' + '"';
        }
        System.debug('StartDate: ' + MbrClassStartDateMap.get(mbrClass));
        
        if(mbrClass != ''){
            srtDate = MbrClassStartDateMap.get(mbrClass);
            if(srtDate != null){
                response = '"' + String.valueOf(srtDate) + 'T00:00:00' + '"';
            }
        }
    	return response;
    }

  	public String getMemberOtherLicenceProvince(String memberId) {
		List<CFPC_License__c> otherLcs = [SELECT Id, CFPC_Province__c FROM CFPC_License__c
                                        WHERE CFPC_Province__c != '' AND CFPC_Member_Id__r.CFPC_CFPC_ID__c = :memberId];
      	String otherLcsProvinces = ''; 
      	for(CFPC_License__c lcs : otherLcs){
          	String lcsProvince = Constants__mdt.getInstance(lcs.CFPC_Province__c).Constant_Value__c; //lcs.CFPC_Province__c;
          	otherLcsProvinces += lcsProvince + '|';
      	} 
            otherLcsProvinces = otherLcsProvinces.removeEnd('|');
        
      	
      	return otherLcsProvinces;
  	}

  public String getAllMemberDates(String memberId) {
    String response = '';
    List<CFPC_Class_Change_History__c> memberClasses = [SELECT CFPC_Start_Date__c, CFPC_Class__c, CFPC_Member_Id__c
                                                         FROM CFPC_Class_Change_History__c 
                                                         WHERE CFPC_Member_Id__r.CFPC_CFPC_ID__c = :memberId AND CFPC_Member_Id__r.CFPC_Status__c != 'Discontinued'
                                                         WITH SECURITY_ENFORCED ORDER BY CFPC_Start_Date__c DESC];
      
      if(memberClasses.size() > 0){
          JSONGenerator jsGen = JSON.createGenerator(true);
          jsGen.writeStartArray();
          for(CFPC_Class_Change_History__c mc : memberClasses){
              String mainProAPICode = '';
              mainProAPICode = mc?.CFPC_Class__c.replace(' ', '_');
              
              jsGen.writeStartObject();
          		//jsGen.writeStringField('Category', mc.CFPC_Class__c == null ? '' : CFPC_Premier_WSP6_Category_Mapping__mdt.getInstance(mc.CFPC_Class__c).CFPC_Mainpro_Code__c);
          		jsGen.writeStringField('Category', mc.CFPC_Class__c == null ? '' : CFPC_Premier_WSP6_Category_Mapping__mdt.getInstance(mainProAPICode).CFPC_Mainpro_Code__c);
          		jsGen.writeStringField('StartDate', String.valueOf(mc.CFPC_Start_Date__c) + 'T00:00:00');
          	jsGen.writeEndObject();
          }
          jsGen.writeEndArray();
          
          response = jsGen.getAsString();
      }
    return response;
  }
    
    public String getMemberData(){
        List<Contact> conList = getMembersForPush();
        Map<String,Integer> getResult = new Map<String,Integer>();
        CFPC_License__c lsc = new CFPC_License__c();
        SObject obj;
        
        JSONGenerator jsGen = JSON.createGenerator(true);
        List<CFPC_PremierMemberMapping__mdt> mappingList = [SELECT DeveloperName, SObject_Name__c, Field_API_Name__c, 
                                                            Type__c, Order__c, Temp__c, Alt_Field_API_Name__c 
                                                        	FROM CFPC_PremierMemberMapping__mdt ORDER BY Order__c ASC];
        
        jsGen.writeStartObject();
        for(Contact con : conList){
            List<CFPC_PremierMemberMapping__mdt> arrayList = new List<CFPC_PremierMemberMapping__mdt>();
            for(CFPC_License__c ls : con.Licenses__r){
                lsc = ls;
            }
            String designations = '';
            for(CFPC_Designation__c dsgn : con.Designations__r){
                String desName = dsgn.CFPC_Designation__c;//dsgn.Name;
                designations +=  desName + ' | '; 
            }
            designations = designations.removeEnd(' | ');
            
            jsGen.writeFieldName(con.CFPC_CFPC_ID__c == null ? '' : con.CFPC_CFPC_ID__c);
            jsGen.writeStartObject();
            for(CFPC_PremierMemberMapping__mdt mp : mappingList){
                
                switch on mp.SObject_Name__c{
                    when 'Contact' {
                        obj = con;
                        
                    }
                    when 'License' {
                        obj = lsc;
                    }
                    
                }
                if(mappingList.indexOf(mp) < 10){
                    if(mp.Type__c == 'String'){
                        String sm = (String)obj.get(mp.Field_API_Name__c);
                        
                        

                        if(obj.getSObjectType() == Schema.Contact.getSObjectType() && mp.Temp__c == 'Address' && (String)obj.get('CFPC_Primary_Address__c') == 'Practice'){
                            sm = (String)obj.get(mp.Alt_Field_API_Name__c);
                            
                        }
                        
                        sm = sm?.replaceAll('\r\n|\n|\r','  ');
                        
                        jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : sm);
                    }
                        
                    else if(mp.Type__c == 'Date'){
                        Date sm = (Date)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                    }
                    
                    else if(mp.Type__c == 'DateTime'){
                        DateTime sm = (DateTime)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField(mp.DeveloperName, sm == null ? '' : String.valueOf(sm));
                    }
                    
                    else if(mp.Type__c == 'Boolean'){
                        Boolean sm = (Boolean)obj.get(mp.Field_API_Name__c);
                        jsGen.writeBooleanField(mp.DeveloperName, sm == null ? FALSE :sm);
                    }
                    
                }
                else{
                        arrayList.add(mp);
                    }
                
            }

                
            jsGen.writeFieldName('Fields');
                jsGen.writeStartArray();
                for(CFPC_PremierMemberMapping__mdt mp : arrayList){
                    switch on mp.SObject_Name__c{
                    	when 'Contact' {
                        	obj = con;
                    	}
                    	when 'License' {
                        obj = lsc;
                    	}
                    }
                	jsGen.writeStartObject();    
                    
                	if(mp.Type__c == 'String'){
                        String sm = (String)obj.get(mp.Field_API_Name__c);
                        if(obj.getSObjectType() == Schema.Contact.getSObjectType() && mp.Temp__c == 'Address' && (String)obj.get('CFPC_Primary_Address__c') == 'Practice'){
                            sm = (String)obj.get(mp.Alt_Field_API_Name__c);
                            sm = sm?.replaceAll('\r\n|\n|\r',' ');
                            if(sm != null && sm.contains('\r\n')){
                                sm = sm.replace('\r\n', ' ').replace('\n',', ');
                            }
                            
                        }
                        sm = mp.DeveloperName == 'CFPC_Category' ? sm == null ? '' : CFPC_WSP_MemberClassCodeMapping.doCodeMapping(sm) : sm;
                        sm = mp.DeveloperName == 'CFPC_Province_Description' && sm?.length() == 2 ? Constants__mdt.getInstance(sm)?.Constant_Value__c : sm;
                        sm = mp.DeveloperName == 'CFPC_Chapter_Name' && sm?.length() == 2 ? Constants__mdt.getInstance(sm)?.Constant_Value__c : sm;
                        sm = mp.DeveloperName == 'CFPC_Location_Code' ? sm == null ? '' : sm == 'Home'? 'H' : 'O' : sm;
                        sm = sm == 'Male' ? 'M' : sm == 'Female' ? 'F' : sm;
                        sm = mp.DeveloperName == 'Profession' ? 'PHY' : sm;
                        sm = sm == 'English' ? 'E' : sm == 'French' ? 'F' : sm; 
                        sm = mp.DeveloperName == 'CFPC_Discontinued_Reason' ? sm == null ? '' : CFPC_WSP_MemberClassCodeMapping.doDiscontinuedCodeMapping(sm) : sm;
                            
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? '' : sm);
                    }
                        
                    else if(mp.Type__c == 'Date'){
                        Date sm = (Date)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? '' : String.valueOf(sm.month()+'/'+sm.day()+'/'+sm.year()) + ' 12:00:00 AM');
                    }
                    else if(mp.Type__c == 'DateTime'){
                        DateTime sm = (DateTime)obj.get(mp.Field_API_Name__c);
						jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? '' : String.valueOf(sm.format('MM/dd/yyyy hh:mm:ss a')));
                    }
                    else if(mp.Type__c == 'Boolean'){
                        Boolean sm = (Boolean)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? '' : String.valueOf(sm));
                    }
                    else if(mp.Type__c == 'BooleanText'){
                        String sm = (String)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? 'false' : sm == 'Yes' ? 'true' : 'false');
                    }
                    else if(mp.Type__c == 'StatusToFlag' && mp.DeveloperName == 'CFPC_Discontinued_Flag'){
                        String sm = (String)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? 'false' : sm == 'Discontinued' ? 'true' : 'false');
                    }
                    else if(mp.Type__c == 'StatusToFlag' && mp.DeveloperName == 'Reinstatement_Flag'){
                        String sm = (String)obj.get(mp.Field_API_Name__c);
                        jsGen.writeStringField('Name', mp.DeveloperName);
                        jsGen.writeStringField('Value', sm == null ? 'false' : sm == 'Active' ? 'true' : 'false');
                    }
                    else{
                        jsGen.writeStringField('Name', 'CFPC_Subcategory');
                        jsGen.writeStringField('Value', designations == null ? '' :designations);
                    }
                	jsGen.writeEndObject();      
                }
                jsGen.writeEndArray();
            
            jsGen.writeEndObject();
            
        }
        jsGen.writeEndObject();
        
            
			
			        
        
        
        String jsonData = jsGen.getAsString();
        //System.debug('jsonData:' +jsonData);
        return jsonData;
    } 
    
    public static List<Contact> getMembersForPush(){

        Set<String> excludedClassSet = new Set<String>();
        excludedClassSet.add('Associate');
        excludedClassSet.add('Exhibitor');
        excludedClassSet.add('Exam Only');
        excludedClassSet.add('Honorary');
        excludedClassSet.add('Prospect');
        excludedClassSet.add('Public Member');
        excludedClassSet.add('STU');
		List<Contact> conList = new List<Contact>();
        	conList = [SELECT Id, Name, CFPC_CFPC_ID__c, Birthdate, FirstName, LastName, Email, Phone, MobilePhone, Salutation, Profession__c,
                      Middlename, CFPC_Gender__c, MailingAddress, Country_Code__c, Location_Code__c, US_or_Foreign_Flag__c, CFPC_Primary_Address__c,
                      CFPC_Address2__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingGeocodeAccuracy, mailingcountrycode,
                      OtherAddress, CFPC_Preferred_Language__c, Degree__c, Discontinued__c, Reinstated__c, CFPC_Status__c,CFPC_Out_of_Country__c,
                      OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherGeocodeAccuracy, OtherCountryCode,
                      HomePhone, CFPC_Phone_Number_Extension__c, Temp_Ext__c, Phone_2_description__c,
                      CFPC_Affiliated_Medical_School__c, CFPC_Affiliated_Medical_School_Title_ID__c,
                      CFPC_Membership_Discontinued_Date__c, CFPC_Membership_Discontinued_Reason__c, CFPC_Int_MainPro_Enrolment_Date__c,
                      CFPC_Membership_Reinstatement_Date__c, CFPC_MINC_Number__c, CFPC_INT_Send_To_CeCity_DT__c,CFPC_INT_Practicing_Changed_On__c,
                      CFPC_Chapter__c, CFPC_INT_Chapter_Name__c, CFPC_Class_Type__c, CFPC_Class__c, CFPC_Membership_Enrolment_Date__c, CFPC_INT_Send_To_CeCity_Failure_Count__c,
                       CFPC_INT_PreviousPracticing__c,CFPC_Practicing__c, CFPC_Primary_License_License_Number__c, CFPC_Primary_License_Province__c, Contact.CFPC_INT_Province_Description__c,
                      	(SELECT Id, Name, CFPC_Designation__c, CFPC_DesignationRoute__c,
                       		CFPC_DesignationStartDate__c, CFPC_DesignationEndDate__c from Designations__r
                        	Where CFPC_Designation_Status__c = 'Active'),
                      	(SELECT Id, CFPC_License_Code__c, CFPC_License_Number__c, CFPC_Expiry_Date__c,
                         CFPC_Province__c, CFPC_is_Primary__c from Licenses__r)
                      FROM Contact where Send_To_CECity__c = TRUE AND CFPC_CFPC_ID__c != '' AND CFPC_Class__c NOT IN :excludedClassSet WITH SECURITY_ENFORCED ORDER BY LastModifiedDate ASC LIMIT 50];
        
        return conList;
    }
 

}