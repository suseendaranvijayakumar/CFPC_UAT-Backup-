/**
* @ClassName:GeneratePDFForLegacyUserBatchTest
* @CreatedDate: 30-12-2022
* @Purpose: Test class for this class (GeneratePDFForLegacyUserBatch)
**/
@isTest
public class GeneratePDFForLegacyUserBatchTest {
    @testSetup
    public static void setUp(){
        List<Account> accountList = new  List<Account>();
        List<Contact> contactList = new  List<Contact>();
        List<User> userList = new  List<User>();
        Profile profileRec  = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User' limit 1];
        Integer f=0;
        for(Integer i = 0; i < 3; i++){
            Account accountRecord = createAccount();
            accountRecord.Name = accountRecord.Name+' '+i;     
            accountList.add(accountRecord);
        }
        Insert accountList;
        for(Integer i = 0; i < 3; i++){
            Contact contactRecord = createContact();
            contactRecord.LastName = contactRecord.LastName+' '+i;
            contactRecord.AccountId = accountList[i].Id; 
            If(f==1)   
                contactRecord.CFPC_Preferred_Language__c = 'French';
            else 
                contactRecord.CFPC_Preferred_Language__c = 'English';
            contactList.add(contactRecord);
            f++;
        }
        Insert contactList;
        for(Integer i = 0; i < 3; i++){
            User userRecord = createUser();
            userRecord.LastName = userRecord.LastName +' '+i;
            userRecord.Username = 'test'+i+'234444@tes1t.com';
            userRecord.Email = 'test'+i+'@test.com';  
            userRecord.CommunityNickname = 'test'+i+'46345734672';
            userRecord.ProfileId = profileRec.Id;
            userRecord.ContactId = contactList[i].Id;
            userList.add(userRecord); 
        }
        Insert userList;
    }
    
    //create User using this method
    public static User createUser(){
        User userRecord = new User(
            LastName = 'Test Code1',
            Email = 'test@test.com',
            Alias = 'Tcode',
            Username = 'test1234444@tes1t.com',
            CommunityNickname = 'test146345734672',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            Is_Legacy_User__c = true,
            Is_Document_Sent__c = false 
        );
        return userRecord;
    }
    //create Contact using this method
    public static Contact createContact(){
        Contact contactRecord = new Contact(
            LastName = 'Test Code1',
            CFPC_Gender__c = 'Male',
            CurrencyIsoCode = '',
            CFPC_Class__c = 'NMMP',
            CFPC_Status__c = 'Active',
            CFPC_Preferred_Language__c  = 'English'
        );
        return contactRecord;
    }
    //create Account using this method
    public static Account createAccount(){
        Account accountRecord = new Account(
            Name = 'Test Code1'
        );
        return accountRecord;
    }
    
    @isTest
    public static void executeBatchclass(){
        List<EmailTemplate> emailTemplateList = [SELECT Id, Name
                                                 FROM EmailTemplate
                                                 WHERE Name = 'CFPC Email Body English' OR Name = 'CFPC Email Body French'];
        List<User> userList = [SELECT Id, Name, Username, Email 
                               FROM User];
        PageReference pageRef1 = Page.CFPC_VF_MCR_BL;
        PageReference pageRef2 = Page.CFPC_VF_MCT_EN;
        PageReference pageRef3 = Page.CFPC_VF_OAL_EN;
        //PageReference pageRef4 = Page.CFPC_VF_PWL_EN;
        
        GeneratePDFForLegacyUserBatch batchObj = new GeneratePDFForLegacyUserBatch();            
        batchObj.errorUserList = userList;
        
        test.startTest();
        DataBase.executeBatch(batchObj);
        test.stopTest();
    }    
}