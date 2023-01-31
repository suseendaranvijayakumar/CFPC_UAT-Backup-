/*******************************************************************************************
* @Description   Test class for CFPC_WSL_WebService 
*				
*******************************************************************************************/
@isTest
public class CFPC_WSL_WebServiceRepo_Test {
    
    static final String SFDC_INT_WSL1_GET_MEMBER_UPDATES = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/GetMemberUpdates';
    static final String SFDC_INT_WSL2_POST_MEMBER_UPDATES = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/PostMemberUpdates';
    static final String SFDC_INT_WSL3_GET_MEMBER_COUNT = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/GetMemberCount';
    static final String SFDC_INT_WSL4_UPDATE_EM_FM_DATES = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/UpdateEmFmDates';
    static final String SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/UpdateExamApplicantDesignation';
    static final String RESET_DATA_ENDPOINT = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/test/ResetData/';
    static final String SET_FLAG_ENDPOINT = 'services/apexrest/CFPCWebServicesLegacy/api/LegacyMember/testapi/SetMemberPushFlagToTrue/'; 
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_WSL1_GetMemberUpdates i.e. gets MemberList for existing member(s) in Constituent table      
    **************************************************************************************/

	public testmethod static void testSFDC_INT_WSL1_GetMemberUpdates(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        CFPC_IntegrationTestDataFactory.createWSLMemberInfo();
		
        rq.httpMethod = 'GET';
        rq.requestURI = SFDC_INT_WSL1_GET_MEMBER_UPDATES;

        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doGet();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_WSL2_PostMemberUpdates posted as key-value pairs      
    **************************************************************************************/
    
    public testmethod static void testSFDC_INT_WSL2_PostMemberUpdates(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_PostMemberUpdates'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL2_POST_MEMBER_UPDATES;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    } 
    
    public testmethod static void testSFDC_INT_WSL2_PostMemberUpdatesSuccess(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_PostMemberUpdatesSuccess'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL2_POST_MEMBER_UPDATES;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    } 
    
    public testmethod static void testSFDC_INT_WSL3_GetMemberCount(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL3_GET_MEMBER_COUNT;

		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doGet();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    } 
    
    public testmethod static void testSFDC_INT_WSL4_UpdateEmFmDatesEM(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateEmFmDates_EM'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL4_UPDATE_EM_FM_DATES;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL4_UpdateEmFmDatesFM(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateEmFmDates_FM'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL4_UPDATE_EM_FM_DATES;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL5_UpdateExamApplicantDesignation(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateExamApplicantDesignation'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        CFPC_WSL_WebService.doPost();
        System.assertEquals(200, rs.statusCode);
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL5_UpdateExamApplicantDesignationInvalidDsgn(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateExamApplicantDesignation_InvalidDsgn'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL5_UpdateExamApplicantDesignationInvalidRoute(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateExamApplicantDesignation_InvalidRoute'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL5_UpdateExamApplicantDesignationIncorrectParameters(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateExamApplicantDesignation_IncorrectParameters'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL5_UpdateExamApplicantDesignationInvalidDateTime(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
		StaticResource s = [select body from staticresource where name = 'CFPC_UpdateExamApplicantDesignation_InvalidDateTime'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = SFDC_INT_WSL5_UPDATE_EXAM_APPLICANT_DESIGNATION;
		rq.requestBody = Blob.valueOf(dummyJSON);
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL0_ResetData(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'GET';
        rq.requestURI = RESET_DATA_ENDPOINT + '660004';
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doGet(); 
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_WSL0_SetMemberPushFlagToTrue(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'POST';
        rq.requestURI = SET_FLAG_ENDPOINT + '660004';
		rq.requestBody = Blob.valueOf('');
		
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSL_WebService.doPost();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
}