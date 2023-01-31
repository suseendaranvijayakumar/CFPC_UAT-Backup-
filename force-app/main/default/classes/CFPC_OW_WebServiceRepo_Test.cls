/*******************************************************************************************
* @Description   Test class for CFPC_OW_WebService 
*				
*******************************************************************************************/
@isTest
public class CFPC_OW_WebServiceRepo_Test {
    
    //CFPC_IntegrationTestDataFactory.SFDC_INT_03_1_CREATE_PAYMENT;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_03_2_UPDATE_CAC_PAYMENT;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_03_3_UPDATE_DESIGNATION;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_03_4_UPDATE_APPROVAL_OF_CAC;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_03_5_UPDATE_CAC_APPLICANT;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_07_1_GET_UNIVERSITIES;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_07_2_GET_DEGREES_BY_SCHOOL_CODE;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_06_1_GET_CAC_APPLICANT_DETAILS;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_06_2_GET_EXAM_APPLICATION_DETAILS;
    //CFPC_IntegrationTestDataFactory.SFDC_INT_06_3_IS_MEMBER;
   //CFPC_IntegrationTestDataFactory.SFDC_INT_06_5_GET_MEMBER_BY_USERNAME;
    
    //Given a payment payload, the CAC payment should update
	public testmethod static void testSFDC_INT_03_1_CreatePayment(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_1_CREATE_PAYMENT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        CFPC_OW_WebService.postPayment();
        System.assertEquals(200, rs.statusCode);
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_1_CreatePaymentIncorrectParameters(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        StaticResource s = [select body from staticresource where name = 'CFPC_CreatePayment_IncorrectParameters'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_1_CREATE_PAYMENT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_2_UpdateCacPayment(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCacPayment'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_2_UPDATE_CAC_PAYMENT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_3_UpdateDesignation(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTAEGDesignation'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_3_UPDATE_DESIGNATION;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        CFPC_OW_WebService.postPayment();
        System.assertEquals(200, rs.statusCode);
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_3_UpdateDesignationInvalidDesgn(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTAEGDesignationInvalidDsgn'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_3_UPDATE_DESIGNATION;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_3_UpdateDesignationInvalidRoute(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTAEGDesignationInvalidRoute'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_3_UPDATE_DESIGNATION;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;

        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_4_UpdateApprovalOfCac(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTCACDesignationAPI'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_4_UPDATE_APPROVAL_OF_CAC;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        CFPC_OW_WebService.postPayment();
        System.assertEquals(200, rs.statusCode);
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_4_UpdateApprovalOfCacInvalidDesgn(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTCACDesignationInvalidDsgn'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_4_UPDATE_APPROVAL_OF_CAC;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_4_UpdateApprovalOfCacInvalidRoute(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_POSTCACDesignationInvalidRoute'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_4_UPDATE_APPROVAL_OF_CAC;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_5_UpdateCacApplicant(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCacApplicant'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_5_UPDATE_CAC_APPLICANT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        CFPC_OW_WebService.postPayment();
        
        System.assertEquals(200, rs.statusCode);
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
   
    public testmethod static void testSFDC_INT_03_5_UpdateCacApplicantInvalidType(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCacApplicant_InvalidType'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_5_UPDATE_CAC_APPLICANT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_03_5_UpdateCacApplicantInvalidArea(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCacApplicant_InvalidArea'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_03_5_UPDATE_CAC_APPLICANT;
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.postPayment();
        Test.StopTest();
        
        System.assertEquals(400, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_07_1_GetUniversities(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMedicalSchoolInfo();
        
        
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_07_1_GET_UNIVERSITIES;
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        System.debug(rs.statusCode);
        //System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_07_2_GetDegreesBySchoolCode(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        
        
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_07_2_GET_DEGREES_BY_SCHOOL_CODE + '898989';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        CFPC_OW_WebService.getUniversities();
        CFPC_IntegrationTestDataFactory.createMedicalSchoolInfo();
        System.assertEquals(404, rs.statusCode);
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        
    }
    
	public testmethod static void testSFDC_INT_06_1_GetCacApplicantDetails(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_06_1_GET_CAC_APPLICANT_DETAILS + '660004';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        
        //System.assertEquals(200, rs.statusCode);
    }

	public testmethod static void testSFDC_INT_06_1_GetCacApplicantDetailsInvalidId(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_06_1_GET_CAC_APPLICANT_DETAILS + '2';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        
        //System.assertEquals(404, rs.statusCode);
    }	
    
    public testmethod static void testSFDC_INT_06_2_GetExamApplicationDetails(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_06_2_GET_EXAM_APPLICATION_DETAILS + '660004';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        
        //System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_06_3_IsMember(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_06_3_IS_MEMBER + '660004';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        
        //System.assertEquals(200, rs.statusCode);
    }
    
    public testmethod static void testSFDC_INT_06_5_GetMemberByUserName(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createPortalMember();
        
        rq.httpMethod = 'GET';
        rq.requestURI = CFPC_IntegrationTestDataFactory.SFDC_INT_06_5_GET_MEMBER_BY_USERNAME + '?Parameter=sfuser.dr.robin@cfpc.ca.intsso';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        Test.StopTest();
        List<User> urs = [SELECT Username from User];
        System.debug(urs); 
        //System.assertEquals(200, rs.statusCode);
        
    }
    
    public testmethod static void testSFDC_INT_00_0_RestData(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/test/ResetData';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_OW_WebService.getUniversities();
        System.debug(''); 
        Test.StopTest();
    }
}