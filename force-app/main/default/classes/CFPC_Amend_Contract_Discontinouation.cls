public class CFPC_Amend_Contract_Discontinouation {
    public static void afterUpdate(List<Contact> newContList,Map<Id,Contact> oldConList){
        ID ContractId ;
        date FPendate;
        date FPstartDate;
        date Currentdate= System.today();
        integer Currentyear=Currentdate.year();
        Set<Id> setAcctid= new Set<Id>();
        Map<Id,Contract> MapContract= new Map<Id,Contract>();
        List<Contract> conrt= new List<Contract>();
        if(Currentdate.month()<=6){
            FPstartDate = date.newinstance(Currentyear-1,07,01);
            FPendate = date.newinstance(Currentyear,06,30);
            
        }
         if(Currentdate.month()>=7){
            FPstartDate = date.newinstance(Currentyear,07,01);
            FPendate = date.newinstance(Currentyear+1,06,30);
            
        }
        
        for(Contact cnt: newContList){
            Contact old = oldConList.get(cnt.Id);
            if(cnt.CFPC_Status__c != old.CFPC_Status__c){
             if(cnt.CFPC_Status__c=='Discontinued'){
                 system.debug('status is discontinouned');
            setAcctid.add(cnt.AccountId);
             }
            }
        }
        if(setAcctid.size()>0){
          System.debug('Account foe amendentment'+setAcctid);
            System.debug('Contract strt date foe amendentment'+FPstartDate);
            System.debug('Contract strt date foe amendentment'+FPendate);

          conrt=[Select Name,Id,AccountId,StartDate,EndDate from Contract where AccountId in:setAcctid and StartDate>=:FPstartDate and EndDate<=:FPendate];
            System.debug('Contract foe amendentment'+conrt);
          
        }
        if(conrt.size()>0){
             for(Contract crnt : conrt){
            ContractId=crnt.Id;
          MapContract.put(crnt.Id,crnt);
        }
        }
       
        if(MapContract.size()>0){   
            system.debug('List of contract'+MapContract);
            Database.executeBatch(new Generate_Ameneded_contract(MapContract),3);
       }
    }

}