public class CFPC_Creation_of_bulk_jobs {

    /*  Developed By : Suseendaran.v
     *  Apex Class to create Bulk job for "Bulk Renewal" or "Bulk Discontinuation" 
     *  This class run after the insertion of bulk job record ( Bulk job is a custom object created for scheduling bulk job)
     */
    
    public static void afterInsert(List<Bulk_Job__c> blkrec){
        
        /* Varaible declaration
         * These variable are used to create a CRON expression to create a schedule job
         * 
         */
         String sDay;        
         String sHour;        
         String sMinute;        
         String sMonth;        
         String sYear;        
         String CRON_EXP = '0 '+sMinute+' '+sHour+' '+sDay+' '+sMonth+' ? '+sYear;  
         Id Disc_recordTypeId = Schema.SObjectType.Bulk_Job__c.getRecordTypeInfosByDeveloperName().get('Discontinuation').getRecordTypeId();
         Id Renewal_recordTypeId = Schema.SObjectType.Bulk_Job__c.getRecordTypeInfosByDeveloperName().get('Renewal').getRecordTypeId();
       
        /* Descrition:
         * Loop to which is iterated create schedule job for bulk discontinutaion or bulk renewal
         */
    for(Bulk_Job__c bdc :blkrec){
        /* Descrition:
         * Creation of CRON Experssion date on the job run date entered while creating bulk job record
         * Irrespective of the job date the job scheduled time is 12am
         * eg: Bulk job record is created on March 20th , and job run date is mentioned as Mrach 30th, the job will be schedule for march 30th and to run at 12am
         */
       sMinute= String.valueOf(bdc.Job_Run_Date__c.minute());       
       sHour=string.valueOf(bdc.Job_Run_Date__c.hour());        
       sDay=String.valueof(bdc.Job_Run_Date__c.day());        
       sMonth=String.valueof(bdc.Job_Run_Date__c.month());        
       sYear=String.valueof(bdc.Job_Run_Date__c.year());        
       CRON_EXP = '0 '+sMinute+' '+sHour+' '+sDay+' '+sMonth+' ? '+sYear;  
        
        
        
        /*Check the job type in order to schedule the job
         * Job type describes which type of job need to be scheduled
         * if job type is " Bulk Renewal Quote Generation" Once Identified renew the contract to create the renewal quote and quote line 
         * if job type is " Bulk discontinuation" the bulk discontinutaion job is scheduled
         * if job type is " Identify Bulk Discontinuation records" the schedule class to identifiey the record which needs to be discontinued
         * if job type is " Bulk Renewal Identification" a batch class run which Identifies the constituent for which contract needs to be renewed
         * if job type is " Bulk Renewal Order Generation"  Once renewal quote is created creation of order/Invoice/Contract
         */
        

       if(bdc.RecordTypeId==Disc_recordTypeId && bdc.Job_Type__c=='Bulk discontinuation'){
           
         List<CronTrigger> JOBIDLIST = new List<CronTrigger>();
          // List varaible to check if the job already exist 
         JOBIDLIST = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'Bulk discontinuation Scheduled job'];
            // Check is the bulk discontinuation job is all ready scheduled 
            // if scheduled ,abort the old job and reschedule a new job
           if(JOBIDLIST.size()>0){
           for(CronTrigger job:JOBIDLIST )
              {
               System.abortJob(job.id);
              }
            }
        
       String jobID = System.schedule('Bulk discontinuation Scheduled job', CRON_EXP, new CFPC_Constituent_Discontinutation());
       
       } 
        
        else if(bdc.RecordTypeId==Renewal_recordTypeId && bdc.Job_Type__c=='Bulk Renewal Quote Generation'){
            // List varaible to check if the job already exist 
           List<CronTrigger> JOBIDLIST = new List<CronTrigger>();
           JOBIDLIST = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'Bulk Renewal Quote Generation job'];
            // Check is the bulk renewal job is all ready scheduled 
            // if scheduled ,abort the old job and reschedule a new job
           if(JOBIDLIST.size()>0){
             for(CronTrigger job:JOBIDLIST )
               {
                System.abortJob(job.id);
               }
              }
           String jobID = System.schedule('Bulk Renewal Quote Generation job', CRON_EXP, new CFPC_Generate_RenewalQuote_scheduler(bdc.Record_To_Process__c));
           
       }
        else if(bdc.RecordTypeId==Renewal_recordTypeId && bdc.Job_Type__c=='Bulk Renewal Order Generation'){
             // List varaible to check if the job already exist 
           List<CronTrigger> JOBIDLIST = new List<CronTrigger>();
           JOBIDLIST = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'Bulk Renewal Order Generation job'];
            // Check is the bulk renewal job is all ready scheduled 
            // if scheduled ,abort the old job and reschedule a new job
           if(JOBIDLIST.size()>0){
             for(CronTrigger job:JOBIDLIST )
               {
                System.abortJob(job.id);
               }
              }
           String jobID = System.schedule('Bulk Renewal Order Generation job', CRON_EXP, new CFPC_Bulk_Renewal_Contract_Schedule(bdc.Record_To_Process__c));
           
            
        }
        
         else if(bdc.RecordTypeId==Disc_recordTypeId && bdc.Job_Type__c=='Identify Bulk Discontinuation records'){
             //schedule a class to check mark down the contact for bulk discontinuation
               List<CronTrigger> JOBIDLIST = new List<CronTrigger>();
              JOBIDLIST = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'Bulk Discontinuation Identification'];
            // Check is the BulkDiscontinuation Identification job is already scheduled 
            // if scheduled ,abort the old job and reschedule a new job
           if(JOBIDLIST.size()>0){
             for(CronTrigger job:JOBIDLIST )
               {
                System.abortJob(job.id);
               }
              }
           String jobID = System.schedule('Bulk Discontinuation Identification', CRON_EXP, new CFPC_bulk_discontinuation_iden_job());
             
         }
        else if(bdc.RecordTypeId==Renewal_recordTypeId&& bdc.Job_Type__c=='Identify Bulk Renewal records'){
            //Batch class to check mark down the contact for bulk renewal
             List<CronTrigger> JOBIDLIST = new List<CronTrigger>();
              JOBIDLIST = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name = 'Bulk Renewal Identification'];
            // Check is the Bulk Renewal Identification job is already scheduled 
            // if scheduled ,abort the old job and reschedule a new job
           if(JOBIDLIST.size()>0){
             for(CronTrigger job:JOBIDLIST )
               {
                System.abortJob(job.id);
               }
              }
           String jobID = System.schedule('Bulk Renewal Identification', CRON_EXP, new CFPC_bulk_renewal_iden_job(bdc.Record_To_Process__c));
            
             
         }
        
       
        
    }
        
    }
}