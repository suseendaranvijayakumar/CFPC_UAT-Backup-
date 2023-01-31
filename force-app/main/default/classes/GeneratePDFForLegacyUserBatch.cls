/**
* @ClassName:GeneratePDFForLegacyUserBatch
* @CreatedDate: 23/12/2022
* @Purpose: Generate PDF files and send email to legacy users
**/

public with sharing class GeneratePDFForLegacyUserBatch implements Database.Batchable<SObject>, Database.Stateful{
    public EmailTemplate emailTemplateRecEnglish;
    public EmailTemplate emailTemplateRecFrench;
    public PageReference ref1 = Page.CFPC_VF_MCR_BL;
    public PageReference ref2 = Page.CFPC_VF_MCT_EN;
    public PageReference ref3 = Page.CFPC_VF_OAL_EN;
    public PageReference ref4 = Page.CFPC_VF_PWL_EN;
    public List<User> errorUserList = new List<User>();
    public String errormessage;
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        //fetch email template for contact with preferred language English
        emailTemplateRecEnglish = [Select Id, Name
                                   FROM EmailTemplate
                                   WHERE Name = 'CFPC Email Body English'];
        
        
        //fetch email template for contact with preferred language French
        emailTemplateRecFrench = [Select Id, Name
                                  FROM EmailTemplate
                                  WHERE Name = 'CFPC Email Body French'];
        
        //fetch user record
        String query = 'SELECT Id,Name, ContactId, Username, Email FROM User WHERE Is_Legacy_User__c = true AND Is_Document_Sent__c = false';
        
        //call checkAvailability method
        checkAvailability();
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<User> scope){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id,Contact> mapConIdToContact = new Map<Id,Contact>();
        
        system.debug('scope::'+scope);
        
        for(User userRec : scope){
            contactIds.add(userRec.ContactId);
        }
        if(contactIds.size()>0){
            List<Contact> contactList = [SELECT Id, CFPC_Preferred_Language__c FROM Contact Where Id IN :contactIds];
            if(contactList.size()>0){
                for(Contact conRec: contactList){
                    mapConIdToContact.put(conRec.Id,conRec);
                }
            }
        }
        for(User userRec : scope){        
            if(mapConIdToContact!=null && mapConIdToContact.containsKey(userRec.ContactId)){
                
                //fetch contactId from user record
                Contact conRec = mapConIdToContact.get(userRec.ContactId);
                
                Messaging.EmailFileAttachment attach1 = generatePDF('Membership Card.pdf', conRec, ref1);
                Messaging.EmailFileAttachment attach2 = generatePDF('Membership Certificate.pdf', conRec, ref2);
                Messaging.EmailFileAttachment attach3 =  generatePDF('Original Approval Letter.pdf', conRec, ref3);
                Messaging.EmailFileAttachment attach4 = generatePDF('CFPC Presidents Welcome Letter.pdf', conRec, ref4);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                //set email template based on contact preferred language
                if(conRec.CFPC_Preferred_Language__c!=null && conRec.CFPC_Preferred_Language__c == 'English'){
                    
                    mail.setTemplateId(emailTemplateRecEnglish.Id);
                }
                else if(conRec.CFPC_Preferred_Language__c!=null && conRec.CFPC_Preferred_Language__c == 'French'){
                    
                    mail.setTemplateId(emailTemplateRecFrench.Id);
                }
                mail.setTargetObjectId(conRec.Id);
                mail.setTreatTargetObjectAsRecipient(false);
                mail.setSaveAsActivity(false);
                mail.setToAddresses(new String[] {userRec.Email});
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach1,attach2,attach3,attach4});    
                mails.add(mail);
            }
        }
        
        //call sendEmail method
        sendEmail(mails, scope);
        
    }
    /*  
* @MethodName: sendEmail
* @Purpose: Send email to legacy users
* @Parameter: List<Messaging.SingleEmailMessage> mailList, List<User> userList
* @Return: void
* */  
    public void sendEmail(List<Messaging.SingleEmailMessage> mailList, List<User> userList){
        
        List<User> userRectoUpdate = new List<User>();
        try{
            Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(mailList);
            system.debug('sendEmailResults::'+sendEmailResults);
            
            for(User userRec: userList){
                userRec.Is_Document_Sent__c = true;
                userRectoUpdate.add(userRec);
            }
            if(!userRectoUpdate.isEmpty()){
                UPDATE userRectoUpdate;
            }
        }
        catch(Exception e){
            //store error message in a variable
            errormessage = e.getMessage()+' '+e.getStackTraceString();
            system.debug('errormessage::'+errormessage);
            
            //add error user list to send admin
            errorUserList.addAll(userList);
        }
    }
    
    /*  
* @MethodName: generatePDF
* @Purpose: Generate the PDF file
* @Parameter: String fileName,Contact conRec, PageReference ref
* @Return: Messaging.EmailFileAttachment
* */    
    public Messaging.EmailFileAttachment generatePDF(String fileName,Contact conRec, PageReference ref){  
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        //Pass parameter to page reference
        ref.getParameters().put('Id', ''+conRec.Id);
        attach.setContentType('application/pdf');
        attach.setFileName(fileName);
        
        if(Test.isRunningTest()) {
            attach.Body = Blob.valueOf('Test');
        } else {
            attach.Body = ref.getContentAsPDF();    
        }
        return attach;
    }
    /*  
* @MethodName: checkAvailability
* @Purpose: Checkes the email template for english and frensh and the page references
* @Parameter: None
* @Return: void
* */
    public void checkAvailability() {
        List<String> messageList = new List<String>();
        
        if(emailTemplateRecEnglish == null){
            messageList.add('emailTemplateRecEnglish');
        }
        if(emailTemplateRecFrench == null){
            messageList.add('emailTemplateRecFrench');
        }
        if(ref1 == null){
            messageList.add('Page.CFPC_VF_MCR_BL');
        }
        if(ref2 == null){
            messageList.add('Page.CFPC_VF_MCT_EN');
        }
        if(ref3 == null){
            messageList.add('Page.CFPC_VF_OAL_EN');
        }
        if(ref4 == null){
            messageList.add('Page.CFPC_VF_PWL_EN');
        }
        String finalStr = String.join(messageList, ',');
        
        if(!messageList.isEmpty()){
            throw new CustomForBatchException(finalStr +' Not Deployed');
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
        if(!errorUserList.isEmpty()){
            Profile profileRec = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
            List<User> uerListToSendEmail = [SELECT Id, Email, Username, Name, ProfileId FROM User WHERE ProfileId =:profileRec.Id];
            List<String> userEmailList = new List<String>();
            
            for(User userRecToSendEmail: uerListToSendEmail){
                userEmailList.add(userRecToSendEmail.Email);
            }
            // send email to admin with list of user in CSV format
            String csvColumnHeader;
            List<String> csvRowValues = new List<String>();
            for(User errorUserRec : errorUserList){
                String Id = errorUserRec.Id;
                String Name = errorUserRec.Name;
                String Username = errorUserRec.Username;
                String Email = errorUserRec.Email;
                
                String csvRowVal = Id + ',' + Name + ',' + Username + ',' + Email;
                csvRowValues.add(csvRowVal);
            }
            csvColumnHeader = 'Id, Name, Username, Email\n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            
            //send email
            Messaging.SingleEmailMessage messageRec = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
            blob blobRec;
            if(Test.isRunningTest()) {
                blobRec = blob.valueOf('Unit.Test');
            } else {
                blobRec = Blob.valueOf(csvFile);
            }                        
            
            attach1.setFileName('FailedBatchUsers.csv');
            attach1.setBody(blobRec);
            messageRec.setFileAttachments(new Messaging.EmailFileAttachment[]{attach1});
            //String[] toAddresses = new String[] {''};
            //messageRec.setToAddresses(toAddresses);
            messageRec.setToAddresses(userEmailList);
            messageRec.setSubject('Legacy User Batch Failed');
            messageRec.setHtmlBody('Hi, <br> The batch class i.e. GeneratePDFForLegacyUserBatch was executed and batch failed during the execution of the batch. <br> Please find the attached file of failed batch below:<br> Error Message:'+errormessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { messageRec });
        }
    }
    
    public class CustomForBatchException extends Exception {
        public CustomForBatchException(Exception e,String message){
            System.debug('message:'+message);
        }    
    }
}