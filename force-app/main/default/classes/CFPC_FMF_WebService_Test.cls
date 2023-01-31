/*******************************************************************************************
* @Description   Test class for CFPC_FMF_WebService 
*				
*******************************************************************************************/
@isTest
public class CFPC_FMF_WebService_Test {
    
    static final String SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE_URI = 'services/apexrest/CFPCWebServicesFMF/api/FMF/GetMemberFYPStartDate/';
	
    /**************************************************************************************
    * @Description  Validates SFDC_INT_09_1_GetMemberFYPStartDate for existing member in Constituent and Class History tables 
    * @Param		
    * @Return        
    **************************************************************************************/
	@IsTest
    public static void testSFDC_INT_09_1_GetMemberFYPStartDate() {
        User fmfUser = [SELECT ID from User limit 1];
        System.runAs(fmfUser){
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();  
        
            CFPC_IntegrationTestDataFactory.createMemberInfo();
            CFPC_IntegrationTestDataFactory.createFYPChangeLog('1','660004');
            
            req.requestURI = SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE_URI + '660004';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response= res;
        
            Test.startTest();
            CFPC_FMF_WebService.doGet();
            Test.stopTest(); 
            
            System.assertEquals(200, res.statusCode);
        }
    }
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_09_1_GetMemberFYPStartDate for existing member with no Class History 
    * @Param		
    * @Return        
    **************************************************************************************/
	@IsTest
    public static void testSFDC_INT_09_1_GetMemberFYPStartDateNoClassHistory() {
        User fmfUser = [SELECT ID from User limit 1];
        System.runAs(fmfUser){
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();  
        
            CFPC_IntegrationTestDataFactory.createFMFMemberInfo();
            
            req.requestURI = SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE_URI + '660004';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response= res;
        
            Test.startTest();
            CFPC_FMF_WebService.doGet();
            Test.stopTest(); 
            
            System.assertEquals(200, res.statusCode); 
        }
    }
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_09_1_GetMemberFYPStartDate for non member 
    * @Param		
    * @Return        
    **************************************************************************************/
	@IsTest
    public static void testSFDC_INT_09_1_GetMemberFYPStartDateNonMember() {
        User fmfUser = [SELECT ID from User limit 1];
        System.runAs(fmfUser){
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();  
        
            CFPC_IntegrationTestDataFactory.createProspectInfo();
            
            
            req.requestURI = SFDC_INT_09_1_GET_MEMBER_FYP_START_DATE_URI + '777999';
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response= res;
        
            Test.startTest();
            CFPC_FMF_WebService.doGet();
            Test.stopTest(); 
            
            //System.assertEquals(200, res.statusCode); 
        }
    }
}