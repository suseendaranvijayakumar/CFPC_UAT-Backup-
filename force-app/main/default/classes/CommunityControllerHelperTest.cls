@isTest
public with sharing class CommunityControllerHelperTest {
    @IsTest
    static void CommunityControllerHelperTest() {
        CFPC_IntegrationTestDataFactory.createPortalMember();
        User thisUser = [ select Id from User where email = 'sfuser.dr.robin@cfpc.ca.intsso' Limit 1 ];
        System.runAs(thisUser){
        Test.StartTest();
        CommunityControllerHelper.getLoggedInUser();
        Test.StopTest();
        }   
    }
}