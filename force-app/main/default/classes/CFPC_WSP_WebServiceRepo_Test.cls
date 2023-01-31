@isTest
public class CFPC_WSP_WebServiceRepo_Test {
	public testmethod static void testSFDC_INT_WSP1_GetMembersForDesignationStatusUpdate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/GetMembersForDesignationStatusUpdate';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        CFPC_WSP_WebService.doGet();
        CFPC_IntegrationTestDataFactory.createCPDUpdateMember();
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP2_UpdateDesignationByCpdCycleActive(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateDesignationByCpdCycleActive'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/UpdateDesignationByCpdCycle';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP2_UpdateDesignationByCpdCyclePending(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateDesignationByCpdCyclePending'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/UpdateDesignationByCpdCycle';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP3_GetMemberPracticingFlagChangeDateTrue(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        CFPC_IntegrationTestDataFactory.createPracticingChangeLog('True');
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/GetMemberPracticingFlagChangeDate/660004/True';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP3_GetMemberPracticingFlagChangeDateFalse(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        CFPC_IntegrationTestDataFactory.createPracticingChangeLog('False');
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/GetMemberPracticingFlagChangeDate/660004/False';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP4_GetMemberEffectiveDate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/GetMemberEffectiveDate/660004';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP5_GetMemberOtherLicenceProvince(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/GetMemberOtherLicenceProvince/660004';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP6_GetAllMemberDates(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/GetAllMemberDates/660004';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
  
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP7_UpdateCeCityFlagSuccess(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCeCityFlag'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/UpdateCeCityFlag';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP7_UpdateCeCityFlagNotUpdate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCeCityFlagNotUpdate'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/UpdateCeCityFlag';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP7_UpdateCeCityFlagNonEligible(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCeCityFlagNonEligable'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/UpdateCeCityFlag';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP7_UpdateCeCityFlagInvalidKey(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        StaticResource s = [select body from staticresource where name = 'CFPC_UpdateCeCityFlagInvalidValue'];
        String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/UpdateCeCityFlag';
        rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP8_GetMemberCount(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/GetMemberCount';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP9_GetMembers(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/GetMembers';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_05_1_TriggerCpdCycleUpdate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'GET';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/TriggerCpdCycleUpdate/4';
        //rq.requestBody = Blob.valueOf(dummyJSON);
        
        RestContext.request = rq;
        RestContext.response = rs;
        CFPC_WSP_WebService.doGet();
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_OW_WebService/api/CeCity/TriggerCpdCycleUpdate/660004';
        
        Test.StartTest();
        CFPC_WSP_WebService.doGet();
        System.debug(''); 
        Test.StopTest();
    }
    
    public testmethod static void testSFDC_INT_WSP0_SetMemberPushFlagToTrue(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        //StaticResource s = [select body from staticresource where name = 'CFPC_POSTCertificationPaymentPayload'];
        //String dummyJSON = s.body.tostring();
        rq.httpMethod = 'POST';
        rq.requestURI = 'https://cfpc--intuat.sandbox.my.salesforce.com/CFPC_WSP_WebService/api/CeCity/testapi/SetMemberPushFlagToTrue/660004';
        rq.requestBody = Blob.valueOf('');
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        
        Test.StartTest();
        CFPC_WSP_WebService.doPost();
        System.debug(''); 
        Test.StopTest();
    }
}