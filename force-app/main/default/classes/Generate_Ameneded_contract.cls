global with sharing class Generate_Ameneded_contract implements Database.Batchable<SObject>, Database.AllowsCallouts,Database.Stateful {
   
    /* Developer name : Suseendaran.v
     * This class amendents the contract which is retuurned from database.query loactaor
     * The btach class uses Amender API to amend the contract
     * The input parameter for amender API is Contract Id and it return the Id of amended quote 
     * This batch class runs with batch size 3
     */
    
    /*Below are some variable declaration
     * Map idToContractMapBatch ro store id and values send to this btach class
     * quote1 varaiable to store value return from amender API
     * quotetoupdate list of which is created from the amendent process
     */
    Map<Id,Contract> idToContractMapBatch=new Map<Id,Contract>(); 
    SBQQ__Quote__c quote1= new SBQQ__Quote__c();
    List<SBQQ__Quote__c> quotetoupdate= new List<SBQQ__Quote__c> ();
    
    /* Getting the Id and Value of the contract passed to this btach class
     */
global Generate_Ameneded_contract(Map<Id,Contract> MapContract){
           List<Contract> cont_stage_upd =  new List<Contract>();
       
        for(Contract conrtRec1 : MapContract.values()){
            conrtRec1.SBQQ__AmendmentOpportunityStage__c='Approved';
            conrtRec1.Disconitnued__c=TRUE;
            cont_stage_upd.add(conrtRec1);
            
        }
        Update cont_stage_upd;
        idToContractMapBatch = MapContract;
        //conrtID = ContractId;
        
    }
    
    /* Query the contract which needs to be amended     */
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> ContIdSet = idToContractMapBatch.keySet();
        //system.debug('check ContIdSet'+ContIdSet);
        String query = 'SELECT Name,Id,AccountId from Contract Where Id IN :ContIdSet';
        //system.debug('check contract'+query);
        return Database.getQueryLocator(query);
    }
    
    /* The Contract returned from the query locator send to amender API which return quote Id ,a nd which is stored in a list */
    global void execute(Database.BatchableContext bc, List<Contract> scope){
        
         
        List<SBQQ__QuoteLine__c> quotelineUpdate=  new List<SBQQ__QuoteLine__c>();
      
        for(Contract conrtRec : scope){
            system.debug('check contract inside for'+conrtRec);
           AmendmentContext context = new AmendmentContext();
            context.returnOnlyQuoteId = true; 

            String contextJson = JSON.serialize(context);
            ContractAmender amender = new ContractAmender();
            QuoteModel quote = amender.load(conrtRec.ID, contextJson);
            quote1=quote.record;
            System.debug('quote11'+quote1.Id);
            quotetoupdate.add(quote1);
            
            
        }
        
    }
    /* The list of quote created is send to next batch class where it gets all the quote line and make the quntity to zero */
    global void finish(Database.BatchableContext bc) {
        
         Database.executeBatch(new CFPC_order_creation_batch_bulk_Dis(quotetoupdate),1);
        
    }

}