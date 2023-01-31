@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerCaptchaTest {

@IsTest
static void testloginReCaptcha() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    LightningLoginFormControllerReCaptcha.loginReCaptcha('Username','Password','startUrl', 'success.true');
}
@IsTest
static void testInvalidVerificationRequest() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    LightningLoginFormControllerReCaptcha.loginReCaptcha('Username','Password','startUrl', 'success.false');
}
@IsTest
static void testInvalidVerification() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    LightningLoginFormControllerReCaptcha.loginReCaptcha('Username','Password','startUrl', 'success.null');
}
@IsTest
static void testInvalidScore() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    LightningLoginFormControllerReCaptcha.loginReCaptcha('Username','Password','startUrl', 'score.null');
}
@IsTest
 static void LightningLoginFormControllerReCaptchaInstantiation() {
    LightningLoginFormControllerReCaptcha controller = new LightningLoginFormControllerReCaptcha();
    System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
    System.assertEquals(true, LightningLoginFormControllerReCaptcha.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
    System.assertEquals(false, LightningLoginFormControllerReCaptcha.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
    System.assertEquals(null, LightningLoginFormControllerReCaptcha.getSelfRegistrationUrl());
 }
 @IsTest
 static void testgetForgotPasswordUrl() {
    System.assertEquals(null, LightningLoginFormControllerReCaptcha.getForgotPasswordUrl());
 }
 @IsTest
 static void testsetExperienceId() {
    LightningLoginFormControllerReCaptcha.setExperienceId('ExperienceId');
 }
 @IsTest
 static void testNoExperienceId() {
    LightningLoginFormControllerReCaptcha.setExperienceId(NULL);
 }
 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormControllerReCaptcha.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
}