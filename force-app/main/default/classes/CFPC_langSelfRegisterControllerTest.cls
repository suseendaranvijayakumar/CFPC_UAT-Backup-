@IsTest
public class CFPC_langSelfRegisterControllerTest {
    /* Verifies that IsValidPassword method with various password combinations. */
    @IsTest
    static void testIsValidPassword() {
        System.assert(langLightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(langLightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(langLightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(langLightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
    }
    
    @IsTest
    static void testSiteAsContainerEnabled() {
        System.assertNotEquals(null, langLightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'));
    }
    
    /* Verifies the selfRegistration method flow with various invalid inputs */
    @IsTest
    static void testSelfRegistration() {
        Map < String, String > paramsMap = initializeParams();
        System.assertNotEquals(null, paramsMap);
        System.assertEquals(Label.Site.lastname_is_required, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), '', paramsMap.get('regConfirmUrl'), '', paramsMap.get('startUrl'), true, 'en_US'));
        System.assertEquals(Label.Site.email_is_required, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'),true, 'en_US'));
        System.assertEquals(Label.Site.email_is_required, langLightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,'en_US'));
        System.assertEquals(Label.site.passwords_dont_match, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,'en_US'));
        System.assertNotEquals(null, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, 'en_US'));
    }
    
    
    /* Verifies the selfRegistration flow for valid inputs */
    @IsTest
    static void testSelfRegisterWithProperCredentials() {
        Map < String, String > paramsMap = initializeParams();
        System.assertEquals(null, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,'en_US'));
    }
    
    /* Verifies SelfRegistration flow with an accounId that is created within the test */
    @IsTest
    static void testSelfRegisterWithCreatedAccount() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        Map < String, String > paramsMap = initializeParams();
        System.assertEquals(null, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false,'en_US'));
    }
    
    @IsTest
    static void testGetNullExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), langLightningSelfRegisterController.getExtraFields(null));
    }
    
    @IsTest
    static void testGetNonEmptyExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), langLightningSelfRegisterController.getExtraFields('field1'));
    }
    
    /* Verifies validation of extraFields within the Self Registration flow */
    @IsTest
    static void testGetExtraFieldsInSelfRegistration() {
        List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
        Map < String, String > paramsMap = initializeParams();
        Map < String, Object > fieldMap = new Map < String, Object > ();
        fieldMap.put('description', 'new field');
        fieldMap.put('fieldPath', 'dummyPath');
        fieldlist.add(fieldMap);
        String extraFields = JSON.serialize(fieldlist);
        System.assertNotEquals(null, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true,'en_US'));
    }
    
    @IsTest
    static void LightningSelfRegisterControllerInstantiation() {
        langLightningSelfRegisterController controller = new langLightningSelfRegisterController();
        System.assertNotEquals(controller, null);
    }
    @IsTest
    static void testsetExperienceId() {
        langLightningSelfRegisterController.setExperienceId('ExperienceId');
    }
    @IsTest 
    static void testUsernameExsists(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        user u = New User(
            UserName = 'test54642@test3232.com',
            FirstName = 'Test-First',
            LastName = 'Test-Last',
            Alias = 'test',
            email = 'test' + math.random() + '@test.com',
            CommunityNickName = string.valueOf(math.random()).substring(0,6),
            ProfileID = p.id,
            TimeZoneSidKey = 'America/New_York', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US'
        );
        insert u;
        langIsUsernameExists.checkDupUsername(u);
        Map < String, String > paramsMap = initializeParams();
        System.assertNotEquals(null, langLightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), 'test54642@test3232.com', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), '', paramsMap.get('startUrl'), true,'en_US'));
        
    }
    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'testUser@salesforce.com';
        String password = 'testuser123';
        String confirmPasswordCorrect = 'testuser123';
        String confirmPasswordWrong = 'wrongpassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'http://registration-confirm.com';
        String startUrl = 'http://my.company.salesforce.com';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        return paramsMap;
    }
}