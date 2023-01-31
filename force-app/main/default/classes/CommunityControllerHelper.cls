public class CommunityControllerHelper {
    @AuraEnabled
    public static User getLoggedInUser(){
        return [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
    }
}