/*******************************************************************************************
* @Description   Test class for CFPC_Premier_WebService 
*				
*******************************************************************************************/
@isTest
public class CFPC_Premier_WebService_Test {
    
    static final String SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE_URI = 'services/apexrest/CFPCPremierWebServices/api/CeCity/TriggerCpdCycleUpdate/';
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_05_1_TriggerCpdCycleUpdate for existing member not in CPD Table 
    * @Param		
    * @Return        
    **************************************************************************************/ 
	public testmethod static void testSFDC_INT_05_1_TriggerCpdCycleUpdate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        
        rq.httpMethod = 'GET';
        rq.requestURI =  SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE_URI + '4';
        
        
        RestContext.request = rq;
        RestContext.response = rs;
        CFPC_Premier_WebService.doGet();
        rq.requestURI = SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE_URI + '660004';
        
        Test.StartTest();
		CFPC_Premier_WebService.doGet();
        Test.StopTest();
        
        System.assertEquals(200, +rs.statusCode);
    }
    
    /**************************************************************************************
    * @Description  Validates SFDC_INT_05_1_TriggerCpdCycleUpdate for existing member already in CPD Table 
    * @Param		
    * @Return        
    **************************************************************************************/
    public testmethod static void testSFDC_INT_05_1_TriggerCpdCycleUpdateDuplicate(){
        RestRequest rq = new RestRequest();
        RestResponse rs = new RestResponse();
        
        CFPC_IntegrationTestDataFactory.createMemberInfo();
        CFPC_IntegrationTestDataFactory.createCPDUpdateMember();
        rq.httpMethod = 'GET';
        rq.requestURI = SFDC_INT_05_1_TRIGGER_CPD_CYCLE_UPDATE_URI + '660004';
        
        RestContext.request = rq;
        RestContext.response = rs;
        
        Test.StartTest();
        CFPC_Premier_WebService.doGet(); 
        Test.StopTest();
        
        System.assertEquals(200, +rs.statusCode);
    }
        
}