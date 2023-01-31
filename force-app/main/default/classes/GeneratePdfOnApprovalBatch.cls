/**
* @ClassName:GeneratePdfOnApprovalBatch
* @CreatedDate:4/07/2022
* @Purpose: Generate PDF files and send email to contact assocaited with opportunity on Opportunity Approved.
**/

global with sharing class GeneratePdfOnApprovalBatch implements Database.Batchable<SObject>,Database.Stateful{
    Map<Id,Opportunity> idToOpprtunityMapBatch=new Map<Id,Opportunity>();
    public EmailTemplate emailTemplateRecEnglish;
    public EmailTemplate emailTemplateRecFrench;
    public PageReference ref1 = Page.CFPC_VF_MCR_BL;
    public PageReference ref2 = Page.CFPC_VF_MCT_EN;
    public PageReference ref3 = Page.CFPC_VF_OAL_EN;
    public PageReference ref4 = Page.CFPC_VF_PWL_EN;
    
    global GeneratePdfOnApprovalBatch(Map<Id,Opportunity> idToOpportunityMap){
        idToOpprtunityMapBatch = idToOpportunityMap;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> oppIdSet = idToOpprtunityMapBatch.keySet();
        
        //fetch email template for contact with preferred language English
        emailTemplateRecEnglish = [Select Id, Name
                                   FROM EmailTemplate
                                   WHERE Name = 'HTML CFPC Email Body English'];
        
        
        //fetch email template for contact with preferred language French
        emailTemplateRecFrench = [Select Id, Name
                                  FROM EmailTemplate
                                  WHERE Name = 'HTML CFPC Email Body French'];
        String query = 'SELECT Id, Name, AccountId, OwnerId, StageName FROM Opportunity Where Id IN :oppIdSet';
        
        //call checkAvailability method
        checkAvailability();
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        system.debug('emailTemplateRecFrench::'+emailTemplateRecFrench);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        User userRec = new User();
        Contact conRec = new Contact();
        Map<String, Account> IdToAccountMap = new Map<String, Account>();
        Set<Id> OpportunityAccountIdSet = new Set<Id>();
        
        for(Opportunity oppRec : scope){
            OpportunityAccountIdSet.add(oppRec.AccountId);
        }
        if(OpportunityAccountIdSet != null){
            IdToAccountMap = new Map<String, Account>([Select Id,(Select Id, Email, CFPC_Preferred_Language__c From Contacts Where RecordType.Name = 'Group B - Member' LIMIT 1) From Account Where Id IN : OpportunityAccountIdSet]);
        }
        system.debug('scope::'+scope);
        
        for(Opportunity oppRec : scope){
            //get frst contact record associated with opportunity's account
            conRec = IdToAccountMap.get(oppRec.AccountId).Contacts[0];
            
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
            mail.setWhatId(oppRec.Id); 
            mail.setSaveAsActivity(false);
            mail.setToAddresses(new String[] {conRec.Email});
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach1,attach2,attach3,attach4});    
            mails.add(mail);
        }
        system.debug('mails size::'+mails.size());
        system.debug('mails::'+mails);
        
        if(!mails.isEmpty())
        {
            Messaging.SendEmail(mails);
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
        String IsBatch = 'False';
        system.debug('conRec.Id in batch::'+conRec.Id);
        ref.getParameters().put('Id', ''+conRec.Id);
        ref.getParameters().put('IsCommunity', IsBatch);
        system.debug('IsBatch::'+IsBatch);
        attach.setContentType('application/pdf');
        attach.setFileName(fileName);
        //attach.Body = ref.getContentAsPDF();  
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
    global void finish(Database.BatchableContext bc) {
        System.debug('Email send successfully');
    }
    
    public class CustomForBatchException extends Exception {
        public CustomForBatchException(Exception e,String message){
            System.debug('message:'+message);
        }    
    }
}