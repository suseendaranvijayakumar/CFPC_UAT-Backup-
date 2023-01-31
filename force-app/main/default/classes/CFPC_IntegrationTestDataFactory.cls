@isTest
public class CFPC_IntegrationTestDataFactory {
    
    public static final String SFDC_INT_03_1_CREATE_PAYMENT = 'services/apexrest/CFPC_OW_WebService/api/Certification/CreatePayment';
    public static final String SFDC_INT_03_2_UPDATE_CAC_PAYMENT = 'services/apexrest/CFPC_OW_WebService/api/cac/UpdateCacPayment';
    public static final String SFDC_INT_03_3_UPDATE_DESIGNATION = 'services/apexrest/CFPC_OW_WebService/api/aeg/UpdateDesignation';
    public static final String SFDC_INT_03_4_UPDATE_APPROVAL_OF_CAC = 'services/apexrest/CFPC_OW_WebService/api/cac/UpdateApprovalOfCac';
    public static final String SFDC_INT_03_5_UPDATE_CAC_APPLICANT = 'services/apexrest/CFPC_OW_WebService/api/cac/UpdateCacApplicant';
    public static final String SFDC_INT_07_1_GET_UNIVERSITIES = 'services/apexrest/CFPC_OW_WebService/api/exam/GetUniversities/';
    public static final String SFDC_INT_07_2_GET_DEGREES_BY_SCHOOL_CODE = 'services/apexrest/CFPC_OW_WebService/api/exam/GetDegreesBySchoolCode/';
    public static final String SFDC_INT_06_1_GET_CAC_APPLICANT_DETAILS = 'services/apexrest/CFPC_OW_WebService/api/cac/GetCacApplicantDetails/';
    public static final String SFDC_INT_06_2_GET_EXAM_APPLICATION_DETAILS = 'services/apexrest/CFPC_OW_WebService/api/exam/GetExamApplicationDetails/';
    public static final String SFDC_INT_06_3_IS_MEMBER = 'services/apexrest/CFPC_OW_WebService/api/Membership/IsMember/';
    public static final String SFDC_INT_06_5_GET_MEMBER_BY_USERNAME = 'services/apexrest/CFPC_OW_WebService/api/query/GetData/GetMemberByUserName';
    
    public static void createMemberInfo(){
        
        Contact member = new Contact();
        member.LastName = 'Robin Ellacot';
        member.CFPC_CFPC_ID__c = '660004';
        member.Send_to_CECity__c = true;
        member.CFPC_INT_Send_To_Legacy__c = true;
        member.CFPC_Status__c = 'Active';
        member.CFPC_Class__c = 'MBR';
        member.CFPC_Class_Type__c = 'FULL';
        member.CFPC_Primary_Address__c = 'Practice';
        member.CFPC_Practicing__c = false;
        member.CFPC_Membership_Discontinued_Reason__c = 'Unable to Contact';
        insert member;
        
        createActiveDesignation(member.Id);
        createInactiveDesignation(member.Id, 'COE');
        createClassChangeHistory(member.Id);
        createLicense(member.Id);
        createFYP(System.today(), '660004');
    }
    
    public static void createWSLMemberInfo(){
        
        Contact member = new Contact();
        member.LastName = 'Robin Ellacot Jr.';
        member.CFPC_CFPC_ID__c = '760004';
        member.Send_to_CECity__c = true;
        member.CFPC_INT_Send_To_Legacy__c = true;
        member.CFPC_Status__c = 'Active';
        member.CFPC_Class__c = 'MBR';
        member.CFPC_Class_Type__c = 'FULL';
        member.CFPC_Primary_Address__c = 'Home';
        member.CFPC_Practicing__c = false;
        member.CFPC_Membership_Reinstatement_Date__c = System.today();
        insert member;
        
        createActiveDesignation(member.Id);
        createInactiveDesignation(member.Id, 'COE');
        createClassChangeHistory(member.Id);
        createLicense(member.Id);
        createPayment(member.Id);
        
    }
    
    public static void createFMFMemberInfo(){
        
        Contact member = new Contact();
        member.LastName = 'Robin Ellacot III.';
        member.CFPC_CFPC_ID__c = '660004';
        member.Send_to_CECity__c = true;
        member.CFPC_INT_Send_To_Legacy__c = true;
        member.CFPC_Status__c = 'Active';
        member.CFPC_Class__c = 'MBR';
        member.CFPC_Class_Type__c = 'FULL';
        member.CFPC_Primary_Address__c = 'Home';
        member.CFPC_Practicing__c = false;
        //member.CFPC_Membership_Reinstatement_Date__c = System.today();
        insert member;
        createFYPChangeLog('1', '660004');
        createFYP(System.today().addDays(-5000), '660004');
    }
    
    public static void createProspectInfo(){
        
        Contact member = new Contact();
        member.LastName = 'Robin Ellacot V.';
        member.CFPC_CFPC_ID__c = '777999';
        member.Send_to_CECity__c = true;
        member.CFPC_INT_Send_To_Legacy__c = true;
        member.CFPC_Status__c = 'Active';
        member.CFPC_Class__c = 'Prospect';
        member.CFPC_Class_Type__c = 'FULL';
        member.CFPC_Primary_Address__c = 'Home';
        member.CFPC_Practicing__c = false;
        //member.CFPC_Membership_Reinstatement_Date__c = System.today();
        insert member;
        createFYPChangeLog('1', '777999');
        createFYP(System.today().addDays(-5000), '777999');
    }
    
    public static CFPC_Designation__c createActiveDesignation(Id contactId){
        CFPC_Designation__c dsgn= new CFPC_Designation__c();
        dsgn.Name = 'CCFP';
        dsgn.CFPC_Designation__c = 'CCFP';
        dsgn.CFPC_Designation_Status__c = 'Active';
        dsgn.CFPC_Member_Id__c = contactId;
        insert dsgn;
        return dsgn;
    }
    
    public static CFPC_Designation__c createInactiveDesignation(Id contactId, String dsgnValue){
        CFPC_Designation__c dsgn= new CFPC_Designation__c();
        dsgn.Name = dsgnValue;
        dsgn.CFPC_Designation__c = dsgnValue;
        dsgn.CFPC_Designation_Status__c = 'Inactive';
        dsgn.CFPC_Member_Id__c = contactId;
        insert dsgn;
        return dsgn;
    }
    
    public static void createMedicalSchoolInfo(){
        Id univRecordTypeId = [SELECT Id, Name from RecordType where sObjectType = 'Account' AND Name = 'University'].Id;
        Account univ = new Account();
        univ.Name = 'Test University';
        univ.CFPC_Medical_School_Code__c = '898989';
        univ.RecordTypeId = univRecordTypeId;
        insert univ;
        
        createDegree(univ.Id);
    }
    
    public static void createDegree(Id univAccountId){
    	CFPC_Degree__c medDegree = new CFPC_Degree__c();
        medDegree.Name = 'Test Degree';
        medDegree.CFPC_Medical_School_Name_FR__c = 'French Test Degree';
        medDegree.CFPC_Medical_School_Code__c = '898989';
        insert medDegree;
    }
    
    public static void createCPDUpdateMember(){
        CFPC_CPD_Cycle_Update_Member__c cpdMember = new CFPC_CPD_Cycle_Update_Member__c();
        cpdMember.Name = '660004';
        insert cpdMember;
    }
    
    public static void createPracticingChangeLog(String currentValue){
        CFPC_Change_Log__c changeLog = new CFPC_Change_Log__c();
        changeLog.CPFC_INT_Object_Type_Name__c = 'CFPC_MEMBER';
        changeLog.CFPC_INT_Property__c = 'PRACTICING';
        changeLog.CFPC_INT_Member_ID__c = '660004';
        changeLog.CFPC_INT_Current_Value__c = currentValue;
        changeLog.CFPC_INT_Change_Date__c = System.today();
        insert changeLog;
    }
    
    public static void createFYPChangeLog(String currentValue, String memberId){
        CFPC_Change_Log__c changeLog = new CFPC_Change_Log__c();
        changeLog.CPFC_INT_Object_Type_Name__c = 'CFPC_MEMBER';
        changeLog.CFPC_INT_Property__c = 'FirstYear';
        changeLog.CFPC_INT_Member_ID__c = memberId;
        changeLog.CFPC_INT_Current_Value__c = currentValue;
        changeLog.CFPC_INT_Change_Date__c = System.today();
        insert changeLog;
    }
    
    public static void createClassChangeHistory(Id contactId){
        CFPC_Class_Change_History__c classChg = new CFPC_Class_Change_History__c();
        classChg.CFPC_Class__c = 'MBR';
        classChg.CFPC_Status__c = 'Active';
        classChg.CFPC_Member_Id__c = contactId;
        classChg.CFPC_Start_Date__c = System.today();
        insert classChg;
    }
    
    public static void createLicense(Id contactId){
        CFPC_License__c lcs = new CFPC_License__c();
        lcs.CFPC_Member_Id__c = contactId;
        lcs.CFPC_Province__c = 'AB';
        insert lcs;
    }
    
    public static void createPayment(Id contactId){
        CFPC_Mock_Payment__c mckPayment = new CFPC_Mock_Payment__c();
        mckPayment.CFPC_Member__c = contactId;
        mckPayment.CFPC_OpenWater_ID__c = '741';
        mckPayment.CFPC_Type__c = 'VISA';
        mckPayment.CFPC_Payment_Amount__c = 5000;
        mckPayment.CFPC_Transaction_Reference_ID__c = '4856';
        insert mckPayment;
    }
    
    public static void createFYP(Date fypDate, String memberId){
        First_Year_Practice__c fyp = new First_Year_Practice__c();
        fyp.Member_ID__c = memberId;
        fyp.First_Year_Practice__c = fypDate;
        insert fyp;
    }
    
    public static void createPortalMember(){
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
            Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
            Account acc = new Account (
            Name = 'newAcc1'
            );  
            insert acc;
            Contact con = new Contact (
            AccountId = acc.id,
            LastName = 'portalTestUser'
            );
            insert con;
            Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
             
            User newUser = new User(
            profileId = p.id,
            username = 'sfuser.dr.robin@cfpc.ca.intsso',
            email = 'sfuser.dr.robin@cfpc.ca.intsso',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='Robin',
            lastname='Ellacot',
            contactId = con.id
            );
            insert newUser;
        }
        
    }
        
}