/**
* Central location for constants and default JSON responses  
*    
*/
public with sharing class CFPC_Constants {

	public static FINAL String RESPONSE_STATUS_STRING_LITERAL = Constants__mdt.getInstance('RESPONSE_STATUS_STRING_LITERAL').Constant_Value__c;
    public static FINAL String MESSAGE_STRING_LITERAL = Constants__mdt.getInstance('MESSAGE_STRING_LITERAL').Constant_Value__c;
    public static FINAL String OPSUCCESSFUL_STRING_LITERAL = Constants__mdt.getInstance('OPSUCCESSFUL_STRING_LITERAL').Constant_Value__c;
    public static FINAL String MEM_NOT_FOUND = Constants__mdt.getInstance('MEM_NOT_FOUND').Constant_Value__c; 
	public static FINAL	String SUCCESS_RESPONSE = Constants__mdt.getInstance('SUCCESS_RESPONSE').Constant_Value__c;
    public static FINAL String DUP_RESPONSE = Constants__mdt.getInstance('DUP_RESPONSE').Constant_Value__c;
    public static FINAL String NOT_FOUND_RESPONSE = Constants__mdt.getInstance('NOT_FOUND_RESPONSE').Constant_Value__c;
    public static FINAL String FAILED_RESPONSE = Constants__mdt.getInstance('FAILED_RESPONSE').Constant_Value__c; 
    public static FINAL String INCORRECT_PARAMETERS_RESPONSE = Constants__mdt.getInstance('INCORRECT_PARAMETERS_RESPONSE').Constant_Value__c; 
    public static FINAL String INCORRECT_ROUTE_CODE_RESPONSE = Constants__mdt.getInstance('INCORRECT_ROUTE_CODE_RESPONSE').Constant_Value__c; 
    public static FINAL String INCORRECT_DSGN_CODE_RESPONSE = Constants__mdt.getInstance('INCORRECT_DSGN_CODE_RESPONSE').Constant_Value__c; 
    public static FINAL String INCORRECT_APP_TYPE_RESPONSE = Constants__mdt.getInstance('INCORRECT_APP_TYPE_RESPONSE').Constant_Value__c; 
    public static FINAL String INCORRECT_APP_AREA_RESPONSE = Constants__mdt.getInstance('INCORRECT_APP_AREA_RESPONSE').Constant_Value__c; 
    public static FINAL String MEM_NOT_SPEC = Constants__mdt.getInstance('MEM_NOT_SPEC_RESPONSE').Constant_Value__c;
    
    /**
	* Adds 'Member not found' object to JSON
	*    
	*/
    public static void createMemberNotFoundJSON(JSONGenerator jsGen){
        jsGen.writeStartObject();
        jsGen.writeBooleanField(RESPONSE_STATUS_STRING_LITERAL, false);
        jsGen.writeStringField(MESSAGE_STRING_LITERAL, MEM_NOT_FOUND);
        jsGen.writeEndObject();
    }
    
    /**
	* Adds Success Response Message to JSON
	*    
	*/
    public static void createOperationSuccessfulJSON(JSONGenerator jsGen){
        
        jsGen.writeStringField(RESPONSE_STATUS_STRING_LITERAL, 'true');
        jsGen.writeStringField(MESSAGE_STRING_LITERAL, OPSUCCESSFUL_STRING_LITERAL);
        
    }
    
    
    /**
	* Adds Success Response Message to JSON
	*    
	*/
    public static void createApplicantNotFoundJSON(JSONGenerator jsGen){
        jsGen.writeStartObject();
        jsGen.writeStringField(RESPONSE_STATUS_STRING_LITERAL, 'false');
        jsGen.writeStringField(MESSAGE_STRING_LITERAL, 'Applicant data not found or data incomplete.');
        jsGen.writeEndObject();
    }
    
    /**
     * FMF Constants
	*/
    
    public static final string SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE = 'GetMemberFYPStartDate';
    public static final string FMF_STR = 'FMF/';
	public static final string FIRST_YEAR_STR = 'FirstYear%';  
    public static final string STR_1 = '1%';
    public static final string MEM_SUBCAT_STR = 'ADD: Member Subcategories%';
    public static final string F_STR = 'F%';
}