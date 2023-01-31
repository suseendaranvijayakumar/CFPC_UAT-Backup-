public class CFPC_OW_WebServiceHelper {
	
	
    public static String processCreatePaymentInfo(String inputJSON){
		
		CFPC_OW_PaymentParser paymentInfo = CFPC_OW_PaymentParser.parse(inputJSON);

		CFPC_Mock_Payment__c pt = new CFPC_Mock_Payment__c();
        pt =  CFPC_OW_WebServiceHelper.mapPaymentFields(paymentInfo, TRUE, FALSE, FALSE);
        String billingStatus = Constants__mdt.getInstance('Billed_Status2').Constant_Value__c;
        
        List<CFPC_Mock_Payment__c> existingNewPayment = [SELECT Id
                                                   FROM CFPC_Mock_Payment__c
                                                   WHERE CFPC_Member_ID__c =:paymentInfo.CfpcMemberId
                                                   AND CFPC_OpenWater_ID__c =:paymentInfo.OpenWaterId
                                                   AND CFPC_Status__c =:billingStatus]; 
        

        if(existingNewPayment.size() == 0 && pt != null){
            insert pt;
            return CFPC_Constants.SUCCESS_RESPONSE; 
        }
        else{
            return CFPC_Constants.DUP_RESPONSE;
        }
    }
    

    public static String processCACPaymentInfo(String inputJSON){
        CFPC_OW_PaymentParser paymentInfo = CFPC_OW_PaymentParser.parse(inputJSON);
        
        String msg;
		CFPC_Mock_Payment__c pt = new CFPC_Mock_Payment__c();
        pt =  CFPC_OW_WebServiceHelper.mapPaymentFields(paymentInfo, FALSE, TRUE, FALSE);
        try{
            Database.UpsertResult upsertResult = Database.upsert(pt, CFPC_Mock_Payment__c.CFPC_Transaction_Reference_ID__c);
            
            if(upsertResult.isSuccess()){
                msg = CFPC_Constants.SUCCESS_RESPONSE;  
            }
            else {
                msg = upsertResult.getErrors()[0].getMessage();
                
            }
        }
        catch(Exception ex){
            msg = ex+'';  
        }
        
        return msg;
    }
    

    public static String processAEGPaymentInfo(String inputJSON){
        CFPC_OW_PaymentParser paymentInfo = CFPC_OW_PaymentParser.parse(inputJSON);

		String msg;
		CFPC_Mock_Payment__c pt = new CFPC_Mock_Payment__c();
        pt =  CFPC_OW_WebServiceHelper.mapPaymentFields(paymentInfo, FALSE, FALSE, TRUE);
        try{
            Database.UpsertResult upsertResult = Database.upsert(pt, CFPC_Mock_Payment__c.CFPC_Transaction_Reference_ID__c);
            
            if(upsertResult.isSuccess()){
                msg = CFPC_Constants.SUCCESS_RESPONSE; 
            }
            else {
                msg = upsertResult.getErrors()[0].getMessage();

            }
        }
        catch(Exception ex){
            msg = ex+'';  
        }
        
        return msg;
    }
    

    public static String processDesignationAEG(String inputJSON){
        String msg;
        Map<String,CFPC_Subcategory__mdt> validDsgns = new Map<String,CFPC_Subcategory__mdt>();
        Map<String,CFPC_Subcategory__mdt> validRoutes = new Map<String,CFPC_Subcategory__mdt>();
        String activeDsgn = Constants__mdt.getInstance('Active').Constant_Value__c;
        CFPC_OW_DesignationParser desgnInfo = CFPC_OW_DesignationParser.parse(inputJSON);
        CFPC_Designation__c dsgn = mapAEGDesignationFields(desgnInfo); 
        
        List<CFPC_Designation__c> existingDsgn = [SELECT Id FROM CFPC_Designation__c 
                                                  WHERE CFPC_Member_Id__r.cfpc_cfpc_id__c = :desgnInfo.MemberId
                                                  AND CFPC_Designation__c = :desgnInfo.DesignationCode
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
        
        if(existingDsgn.size() == 0 && validDsgns.containsKey(desgnInfo.DesignationCode) && (validRoutes.containsKey(desgnInfo.RouteCode) || desgnInfo.RouteCode == null)){
            insert dsgn;
            msg = CFPC_Constants.SUCCESS_RESPONSE; //'Success';
        }
        else if(existingDsgn.size() > 0){
            msg = CFPC_Constants.DUP_RESPONSE;
        }
        
         else if(!validDsgns.containsKey(desgnInfo.DesignationCode)){
            msg = CFPC_Constants.INCORRECT_DSGN_CODE_RESPONSE;
        }
        
        else if(!validRoutes.containsKey(desgnInfo.RouteCode)){
            msg = CFPC_Constants.INCORRECT_ROUTE_CODE_RESPONSE;
        }
        
        else{
            msg = 'Invalid Input';
        }
        return msg;
    }
    

    public static String processDesignationCAC(String inputJSON){
        String msg;
        Map<String,CFPC_Subcategory__mdt> validDsgns = new Map<String,CFPC_Subcategory__mdt>();
        Map<String,CFPC_Subcategory__mdt> validRoutes = new Map<String,CFPC_Subcategory__mdt>();
        String activeDsgn = Constants__mdt.getInstance('Active').Constant_Value__c;
        CFPC_OW_DesignationParser desgnInfo = CFPC_OW_DesignationParser.parse(inputJSON);
        CFPC_Designation__c dsgn = mapCACDesignationFields(desgnInfo);
        Contact member = getCfpcMember(String.valueOf(desgnInfo.CfpcMemberId));
        	if(member != null){
            	dsgn.CFPC_Member_Id__c = member.Id;
        	}
        
        List<CFPC_Designation__c> existingDsgn = [SELECT Id FROM CFPC_Designation__c 
                                                  WHERE CFPC_Member_Id__r.cfpc_cfpc_id__c = :desgnInfo.CfpcMemberId
                                                  AND CFPC_Designation__c = :desgnInfo.CacDesignation
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

        if(member != null && existingDsgn.size() == 0 && validDsgns.containsKey(desgnInfo.CacDesignation) && (validRoutes.containsKey(desgnInfo.RouteCode) || desgnInfo.RouteCode == null)){
            insert dsgn;
            //To-do: Need to update Member record with CAC Flag = 1
            member.CFPC_CAC__c = TRUE;
            update member;
            msg = CFPC_Constants.SUCCESS_RESPONSE; //'Success';
        }
        else if(existingDsgn.size() > 0){
            msg = CFPC_Constants.DUP_RESPONSE;
        }
        
        else if(!validDsgns.containsKey(desgnInfo.CacDesignation)){
            msg = CFPC_Constants.INCORRECT_DSGN_CODE_RESPONSE;
        }
        
        else if(!validRoutes.containsKey(desgnInfo.RouteCode)){
            msg = CFPC_Constants.INCORRECT_ROUTE_CODE_RESPONSE;
        }
        else if(member == null){
            msg = CFPC_Constants.MEM_NOT_FOUND;//'Member Not Found';
        }
        return msg;
    }
    
    

    public static String processCACApplicant(String inputJSON){
        String msg;
        String activeDsgn = Constants__mdt.getInstance('Active').Constant_Value__c;
        CFPC_OW_CACApplicantParser cacAppInfo = CFPC_OW_CACApplicantParser.parse(inputJSON);
        CFPC_Exam_Application__c examApp = mapCACAppFields(cacAppInfo);
        
        List<CFPC_Exam_Application__c> existingApp = 	[SELECT Id FROM CFPC_Exam_Application__c 
                                                  		WHERE CFPC_Member__r.cfpc_cfpc_id__c = :String.valueOf(cacAppInfo.CfpcMemberId)
                                                  		AND CFPC_CAC_OW_ID__c = :cacAppInfo.CacOpenWaterId];
        Map<String,CFPC_CAC_App_Type__mdt> validAppTypes = CFPC_CAC_App_Type__mdt.getAll();
        Map<String,CFPC_CAC_App_Area__mdt> validAreas = CFPC_CAC_App_Area__mdt.getAll();

        
        Contact member = getCfpcMember(String.valueOf(cacAppInfo.CfpcMemberId));
        if(member != null){
            examApp.CFPC_Member__c = member.Id;
        }
        
        if(existingApp.size() == 0 && validAppTypes.containsKey(cacAppInfo.CacApplicationType) && validAreas.containsKey(cacAppInfo.CacApplicationArea)){
            insert examApp;
            
            msg = CFPC_Constants.SUCCESS_RESPONSE; 
        }
        else if(existingApp.size() > 0){
            msg = CFPC_Constants.DUP_RESPONSE;
        }
        
        else if(!validAppTypes.containsKey(cacAppInfo.CacApplicationType)){
            msg = CFPC_Constants.INCORRECT_APP_TYPE_RESPONSE;
        }
        
        else if(!validAreas.containsKey(cacAppInfo.CacApplicationArea)){
            msg = CFPC_Constants.INCORRECT_APP_AREA_RESPONSE;
        }
        
        else{
            msg = 'Invalid Input';
        }
        return msg;
    }
    
    

    public static CFPC_Mock_Payment__c mapPaymentFields(CFPC_OW_PaymentParser paymentInfo, Boolean isCreatePayment,
                                                        Boolean isUpdateCAC, Boolean isUpdateAEG){
        
        CFPC_Mock_Payment__c pt = new CFPC_Mock_Payment__c();
                                                  
        pt.CFPC_Member_ID__c = paymentInfo.CfpcMemberId; 
        //pt.CFPC_Credit_Card_Type__c = paymentInfo?.CreditCardType;
        pt.CFPC_Type__c = paymentInfo?.CreditCardType;
        //pt.CFPC_OpenWater_ID__c = paymentInfo.OpenWaterId;
        pt.CFPC_Payment_Amount__c = paymentInfo.PaymentAmount;
        pt.CFPC_Transaction_Reference_ID__c = paymentInfo.PaymentTxnRefId;
        pt.CFPC_Transaction_Response_Code__c = String.valueof(paymentInfo.PaymentTxnResponseCode);
        //pt.CFPC_Source_System__c = paymentInfo.SourceSystem;
        pt.CFPC_Status__c = Constants__mdt.getInstance('Billed_Status2').Constant_Value__c;
        pt.CFPC_Bill_Creation_Date__c = DateTime.now();
        pt.CFPC_Order_Date__c = DateTime.now();
        pt.CFPC_Billing_Type__c = Constants__mdt.getInstance('Billing_Type1').Constant_Value__c;
        pt.CFPC_BT_ID__c = String.valueOf(paymentInfo.CfpcMemberId); 
        pt.CFPC_ST_ID__c = String.valueOf(paymentInfo.CfpcMemberId);
        pt.Test_Data__c = true;
        if(isCreatePayment){
        	pt.CFPC_Product_Code__c = paymentInfo.ProductCode;  
            pt.CFPC_PO_NUM__c = paymentInfo.OpenWaterId;
            pt.CFPC_Order_Description__c = paymentInfo.ProductCode;
            pt.CFPC_OpenWater_ID__c = paymentInfo.OpenWaterId;
            pt.CFPC_Source_System__c = paymentInfo.SourceSystem;
            
            Contact member = getCfpcMember(paymentInfo.CfpcMemberId);
        	if(member != null){
            	pt.CFPC_Member__c = member.Id;
        	}
        }
        else if(isUpdateCAC){
            pt.CFPC_Product_Code__c = 'CAC_RF';
            pt.CFPC_PO_NUM__c = 'CAC' + paymentInfo.CacOpenWaterId;
            pt.CFPC_Order_Description__c = 'CAC PAYMENT' + paymentInfo.PaymentTxnRefId;
        }
        else if(isUpdateAEG){
        	pt.CFPC_Product_Code__c = 'EX_AR';
            pt.CFPC_PO_NUM__c = String.valueOf(paymentInfo.Sequence);
            pt.CFPC_Order_Description__c =  String.valueOf(paymentInfo.Sequence) + ' ' + paymentInfo.PaymentTxnRefId;
        }                                                    
        
        return pt;
    }
    

    public static CFPC_Designation__c mapAEGDesignationFields(CFPC_OW_DesignationParser dsgnInfo){
        CFPC_Designation__c dsgn = new CFPC_Designation__c();
        dsgn.CFPC_Designation_Status__c = Constants__mdt.getInstance('Active').Constant_Value__c;
        dsgn.CFPC_DesignationStartDate__c = dsgnInfo.EffectiveDate;
        dsgn.Name = dsgnInfo.DesignationCode;
        dsgn.CFPC_Designation__c = dsgnInfo.DesignationCode;
        dsgn.CFPC_DesignationRoute__c = dsgnInfo.RouteCode;
        
        Contact member = getCfpcMember(dsgnInfo.MemberId);
        if(member != null){
            dsgn.CFPC_Member_Id__c = member.Id;
        }
        return dsgn;
                                                            
    }
    

    public static CFPC_Designation__c mapCACDesignationFields(CFPC_OW_DesignationParser dsgnInfo){
        CFPC_Designation__c dsgn = new CFPC_Designation__c();
        dsgn.CFPC_Designation_Status__c = Constants__mdt.getInstance('Active').Constant_Value__c;
        dsgn.CFPC_DesignationStartDate__c = dsgnInfo.CacEffectiveDate;
        dsgn.Name = dsgnInfo.CacDesignation;
        dsgn.CFPC_Designation__c = dsgnInfo.CacDesignation;
        dsgn.CFPC_OW_CAC_ID__c = dsgnInfo.CacOpenWaterId;
        dsgn.CFPC_DesignationRoute__c = dsgnInfo.RouteCode;
        

        return dsgn;
                                                            
    } 
    

    public static CFPC_Exam_Application__c mapCACAppFields(CFPC_OW_CACApplicantParser appInfo){
        CFPC_Exam_Application__c app = new CFPC_Exam_Application__c();
        app.CFPC_CAC_Application_Type__c = appInfo.CacApplicationType;
        app.CFPC_CAC_Application_Area__c = appInfo.CacApplicationArea;
        app.CFPC_Preferred_Language__c = appInfo.PreferredLanguage;
        app.CFPC_Name_on_Certificate__c = appInfo.NameOnCertificate;
        app.CFPC_CAC_OW_ID__c = appInfo.CacOpenWaterId;
        
        

        return app;
                                                            
    }
    

    public static Contact getCfpcMember(String memberID){
        List<Contact> cfpcMember = new List<Contact>();
        cfpcMember = [SELECT Id FROM Contact WHERE cfpc_cfpc_id__c = :memberID limit 1];
        if(cfpcMember.size() > 0){
            return cfpcMember[0];
        }
        else {
            return null;
        }
    }
    

    public static String resetData(){
        String mcfp = 'MCFP';
        List<CFPC_Mock_Payment__c> ptList = [SELECT ID from CFPC_Mock_Payment__c where CFPC_Transaction_Reference_ID__c = '1111'];
		if(ptList.size() > 0){
    		delete ptList;
		}
		//List<CFPC_Designation__c> desgnList = [SELECT ID from CFPC_Designation__c where CFPC_Designation__c = 'CCFP' OR CFPC_Designation__c = 'EM'];
		List<CFPC_Designation__c> desgnList = [SELECT ID from CFPC_Designation__c where CFPC_Designation__c != :mcfp 
                                               and CFPC_Member_Id__r.CFPC_CFPC_Id__c = '660004'
                                               and CreatedDate = Today];
		if(desgnList.size() > 0){
    		delete desgnList;
		}
        
        List<CFPC_Exam_Application__c> exAppList = [SELECT ID from CFPC_Exam_Application__c where CFPC_Member__r.CFPC_CFPC_Id__c = '660004'];
        
        if(exAppList.size() > 0){
            delete exAppList;
        }
       
        return 'Data Reset';
    }
	 
}