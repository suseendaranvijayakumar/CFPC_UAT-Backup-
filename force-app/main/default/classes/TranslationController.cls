public without sharing class TranslationController {
    public string selectedLang{get;set;}
    public transient PdfDataWrapper pdfdata {get;set;}
    
    public TranslationController(ApexPages.StandardController controller){
        initProcess();
    }
    public void initProcess(){
        // get url parameter
        String contactId = fetchUrlParameter();
        // Initiate Wrapper
        pdfdata = new PdfDataWrapper();
        // get contact
        Contact conRec = fetchContact(contactId);
        // set language
        setLanguage(conRec);
        // set contact detail
        pdfdata.setContactDetails(conRec);
        // get opportunity
        Opportunity oppRec = fetchOpportunity(conRec);
        // set opportunity details
        pdfdata.setOpportunityDetails(oppRec);
    }
    public string fetchUrlParameter(){
        String IsCommunityUser = ApexPages.currentPage().getParameters().get('IsCommunity');
        String IsLegacyBatch = ApexPages.currentPage().getParameters().get('IsLegacyBatch');
        system.debug('IsCommunityUser::'+IsCommunityUser);
        
        if(IsCommunityUser == 'False'){
            String conId = ApexPages.currentPage().getParameters().get('Id');
            system.debug('conId In Controller::'+conId);
            return conId;
        }
        else{
            return [SELECT Id, ContactId FROM User where Id=:UserInfo.getUserId()].ContactId;
        }
    }
    
    public Contact fetchContact(String contactId){
        if(String.isNotBlank(contactId)){
            return [SELECT Id,Name,Email, AccountId,Salutation, CFPC_ID_Auto_Num__c,CFPC_CFPC_ID__c, 
                    CFPC_Bill_End_Date__c, CFPC_Preferred_Language__c, Suffix
                    FROM Contact 
                    Where Id = :contactId];
        }
        return null;
    }
    public Opportunity fetchOpportunity(Contact contactRec){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Application').getRecordTypeId();
        if(contactRec != null && contactRec.AccountId != null){

            List<Opportunity> oppList = [SELECT Id, AccountId, CFPC_Submission_Date__c 
                                  FROM Opportunity 
                                  Where AccountId = :contactRec.AccountId 
                                  AND RecordTypeId =:recordTypeId
                                  LIMIT 1];
            system.debug('oppList::'+oppList);

            if(!oppList.isEmpty()){
                return oppList[0];
            }
        }
        return null;
    }         
    public void setLanguage(Contact contactRec){
        
        if(contactRec != null && contactRec.CFPC_Preferred_Language__c == 'English'){
            selectedLang='EN';
        }
        else{
            selectedLang='FR';
        }
    }
    
    public class PdfDataWrapper {
        public String ContactName {get;set;}
        public String Suffix {get;set;}
        public String Salutation {get;set;}
        public String CFPCID {get;set;}
        public String BillEndDate {get;set;}
        public String SubmissionDate {get;set;}
        public String DocumentGenerationDate {get;set;}
        
        public PdfDataWrapper(){
            
        }
        public void setContactDetails(Contact conRec){
            if(conRec != null){
                CFPCID = conRec.CFPC_CFPC_ID__c;
                Salutation = conRec.Salutation;
                ContactName = conRec.Name;
                Suffix = conRec.Suffix;
                BillEndDate = formattedDate(conRec.CFPC_Bill_End_Date__c, 'yyyy/MM/dd');
                DocumentGenerationDate = formattedDate(system.today(), 'MM/dd/yyyy');
            }
            
        }
        public void setOpportunityDetails(Opportunity oppRec){
            if(oppRec != null && oppRec.CFPC_Submission_Date__c!=null){
                SubmissionDate = formattedDate(oppRec.CFPC_Submission_Date__c, 'dd MMMM yyyy');
                //DocumentGenerationDate = formattedDate(system.today(), 'MM/dd/yyyy');
            }  
        }
        public String formattedDate(DateTime dateValue, String dateFormatString){
            if(dateValue != null){
                Datetime DateTimeValue = Datetime.newInstance(dateValue.year(), dateValue.month(),dateValue.day());
                String formattedDate = DateTimeValue.format(dateFormatString);
                return formattedDate;
            }
            return '';
        }
    }
}