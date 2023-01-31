public class Add_Payement_Allocation {
    public static void afterInsert(List<blng__Payment__c> payment){
        Set<Id> pytId= new Set<Id>();
        Map<Id,blng__Invoice__c> Mapinvoice = new Map<Id,blng__Invoice__c>();
        
        for(blng__Payment__c pymt : payment)
        {
            pytId.add(pymt.blng__Invoice__c);
        }
        //List<blng__InvoiceLine__c> invc= [Select id,Name,blng__Product__c,blng__TotalAmount__c,blng__Invoice__c from blng__InvoiceLine__c where blng__Invoice__c in:pytId];
        List<blng__Invoice__c> invc= [Select id,Name,blng__Balance__c from blng__Invoice__c where Id in:pytId];
        for(blng__Invoice__c invc1 : invc)
        {
            Mapinvoice.put(invc1.Id,invc1);

        }
        List<blng__PaymentAllocationInvoiceLine__c> pytInv= new List<blng__PaymentAllocationInvoiceLine__c>();
        
            for(blng__Payment__c pymt1 : payment)
            {
                
               if(pymt1.blng__Amount__c>=Mapinvoice.get(pymt1.blng__Invoice__c).blng__Balance__c ){
                   System.debug('invoice line loop 1');
                for(blng__InvoiceLine__c invline:[Select id,Name,blng__Product__c,blng__TotalAmount__c,blng__Invoice__c,blng__Balance__c from blng__InvoiceLine__c where blng__Invoice__c =:pymt1.blng__Invoice__c]){
                
                    blng__PaymentAllocationInvoiceLine__c ivt= new blng__PaymentAllocationInvoiceLine__c();
                    ivt.blng__InvoiceLine__c= invline.id;
                    ivt.blng__Amount__c=invline.blng__Balance__c;
                    ivt.blng__Type__c='Allocation';
                    ivt.blng__Payment__c=pymt1.id;
                    
                    pytInv.add(ivt); 
                    //System.debug('invoice line in loop 1 list '+pytInv);
                    }
             
            }
                 else if(pymt1.blng__Amount__c < Mapinvoice.get(pymt1.blng__Invoice__c).blng__Balance__c){
                    // System.debug('invoice line loop 2');
                     Decimal amt = pymt1.blng__Amount__c;
                    for(blng__InvoiceLine__c invline:[Select id,Name,blng__Product__c,blng__TotalAmount__c,blng__Invoice__c,blng__Balance__c from blng__InvoiceLine__c where blng__Invoice__c =:pymt1.blng__Invoice__c]){
                       blng__PaymentAllocationInvoiceLine__c ivt= new blng__PaymentAllocationInvoiceLine__c();
                        //System.debug('paymnet amount'+amt);
                        if(invline.blng__Balance__c<amt){
                            //System.debug('check balance leass than amount');
                            //System.debug('line blacnde'+invline.blng__Balance__c);
                            ivt.blng__InvoiceLine__c= invline.id;
                ivt.blng__Amount__c=invline.blng__Balance__c;
                ivt.blng__Type__c='Allocation';
                ivt.blng__Payment__c=pymt1.id;
                            amt= amt-invline.blng__Balance__c;
                            System.debug('paymnet amount ---> after'+amt);
               // System.debug('line added list 1'+ivt); 
                pytInv.add(ivt);
                            
                        }
                        else if(invline.blng__Balance__c>amt){
                           // System.debug('line blacnde'+invline.blng__Balance__c);
                           // System.debug('check balance more  than amount');
                            ivt.blng__InvoiceLine__c= invline.id;
                ivt.blng__Amount__c=amt;
                ivt.blng__Type__c='Allocation';
                ivt.blng__Payment__c=pymt1.id;
                           amt= 0;
                             //System.debug('line added list 2'+ivt);
                pytInv.add(ivt);
                            
                        }
 }
                    }
        }
        //System.debug('invoice line'+pytInv);
       // System.debug('invoice line size'+pytInv.size());
        Insert pytInv;
    }
    
    public static void updateConstituent(List<blng__Payment__c> payment){
        set<Id> accId = new set<Id>();
        for(blng__Payment__c pymt : payment)
        {
            accId.add(pymt.blng__Account__c);
        }
        for(AccountContactRelation ac:[select Id,ContactId,AccountId from AccountContactRelation where AccountId =:accId]){
            for(blng__Payment__c pymt : payment)
            {
                if(pymt.blng__Account__c == ac.AccountId){
                    pymt.blng__PaidBy__c = ac.ContactId;
                }
            } 
        }  
    }
    
}