public class User_Permission_assigment {
    @future 
    public static void afterInsert(Set<Id> userId){
        System.debug('Entered into permission class');
        List<String> str= new List<String>();
        List<User> usertoupdate = new List<User>();
        
         
        List<PermissionSetLicense> prmset=[SELECT DeveloperName,Id FROM PermissionSetLicense WHERE DeveloperName ='SalesforceCPQ_CPQStandardPerm'];
        List<PermissionSet> prset=[SELECT Id,Label,Name FROM PermissionSet WHERE Label ='Salesforce CPQ Partner User']; 
        List<PermissionSet> btset=[SELECT Id,Label,Name FROM PermissionSet WHERE Label ='Blackthorn | Payments (Community/Platform User)']; 
        List<PermissionSetLicenseAssign> prmsetlic= new List<PermissionSetLicenseAssign>();
        List<PermissionSetAssignment> prsetinsert= new List<PermissionSetAssignment>();
        System.debug('Permission set License assign '+prmset);
        System.debug('Permission set  '+prset);
        
        
        
        List<User> usrper = [SELECT Id, Name,Profile.Name,ContactId,Contact.CFPC_CFPC_ID__c,Contact.CFPC_ID_Auto_Num__c,Email from User where Id in:userId];
        for(User user: usrper){
            System.debug('list of contacts user'+user.Profile.Name);
            System.debug('User with profile cfpc prospect profile'+user);
            if(user.Contact.CFPC_CFPC_ID__c==null){
               user.CFPC_Member_Id_Text__c=user.Contact.CFPC_ID_Auto_Num__c;
            }else{
                user.CFPC_Member_Id_Text__c=user.Contact.CFPC_CFPC_ID__c;
            }
            
            user.FederationIdentifier=user.Email;
            usertoupdate.add(user);
            
            if(user.Profile.Name=='CFPC Prospect'){
                System.debug('User with profile cfpc prospect profile');
                PermissionSetLicenseAssign prm= new PermissionSetLicenseAssign();
                prm.AssigneeId=user.Id;
                prm.PermissionSetLicenseId=prmset[0].Id;
                System.debug('permission set license'+prm);
                prmsetlic.add(prm);
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.PermissionSetId = prset[0].Id;
                psa.AssigneeId = user.Id;
                System.debug('User with profile cfpc prospect profile');
                System.debug('permission set'+psa);
                prsetinsert.add(psa);
                // BlackThorn Permission Set
                PermissionSetAssignment bt = new PermissionSetAssignment();
                bt.PermissionSetId = btset[0].Id;
                bt.AssigneeId = user.Id;
                prsetinsert.add(bt);
             
            }
        }
        System.debug('Permission set before insert License assign '+prmsetlic);
        System.debug('Permission set before insert '+prsetinsert);
        insert prmsetlic;
        insert prsetinsert;
        Update usertoupdate;
        
    }
}