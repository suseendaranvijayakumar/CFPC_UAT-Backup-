public without sharing class OrderTriggerHandlerCFPC {
    public static void createOrderItems(List<Order> orders){
        List<Order> standaloneOrderstoActivate = new List<Order>();
        List<OrderItem> orderItemstoInsert = new List<OrderItem>();
        //Set<Id> result=new Set<Id>();
        Map<Id,PriceBookEntry> mapPriceBookToProducts = new Map<Id,PriceBookEntry>();
        List<Pricebook2> priceBook = [SELECT Id, IsDeleted, Name, IsActive, IsArchived, Description, IsStandard, ValidFrom, ValidTo FROM Pricebook2 where IsActive=true and name='Pricebook 2023-2024' LIMIT 1];
        if(priceBook.size()>0){
            List<PriceBookEntry> priceBookList = [SELECT Id,Pricebook2Id,UnitPrice, isactive,Product2Id, Product2.Id, Product2.Name,Product2.Productcode FROM PriceBookEntry WHERE Pricebook2Id=:priceBook[0].id];
            for(PriceBookEntry ids:priceBookList){
                mapPriceBookToProducts.put(ids.Product2Id,ids);
            }
        }
        
        for(Order eachOrder:orders){
            if(eachOrder.cfpc_product_code__c!='' && mapPriceBookToProducts.size()>0){
                Id ProductId = getPricebookId(eachOrder.cfpc_product_code__c);
                if(ProductId!=null){
                    OrderItem  orderItem = new OrderItem ();
                    orderItem.OrderId = eachOrder.id;
                    orderItem.ServiceDate = eachOrder.EffectiveDate;
                    orderItem.EndDate = eachOrder.EffectiveDate;
                    orderItem.Product2Id  = getPricebookId(eachOrder.cfpc_product_code__c);
                    orderItem.ListPrice = mapPriceBookToProducts.get(ProductId).UnitPrice;
                    orderItem.blng__BillableUnitPrice__c = eachOrder.CFPC_Standalone_Order_Amount__c;
                    orderItem.UnitPrice  = eachOrder.CFPC_Standalone_Order_Amount__c;
                    orderItem.Quantity = 1;
                    orderItem.SBQQ__ChargeType__c = 'One-Time';
                    orderItem.SBQQ__OrderedQuantity__c = 1;
                    orderItem.PricebookEntryId =mapPriceBookToProducts.get(ProductId).ID;
                    orderItemstoInsert.add(orderItem); 
                }
                              
            }
        }
        if(orderItemstoInsert.size()>0){
            
            insert orderItemstoInsert;
        }
        for(OrderItem eachOrderItem : orderItemstoInsert){
            Order updateOrder = new Order();
            updateOrder.id=eachOrderItem.OrderId;
            updateOrder.Status = 'Activated';
           updateOrder.blng__BillNow__c  = True;
            standaloneOrderstoActivate.add(updateOrder);
            //result.add(eachOrderItem.OrderId);
        }
        if(standaloneOrderstoActivate.size()>0){
            //Database.executeBatch(new CFPC_Creation_Invoice_standloneOrder(standaloneOrderstoActivate),1);
            update standaloneOrderstoActivate;
        }
    }
    public static Id getPricebookId(String productCode){
        Id productId=null;
        List<Product2> proddata = new List<Product2>();
        if(productCode!=null){
            proddata = [Select Id,productcode,blng__TaxRule__c FROM Product2 where productcode=:productCode and isactive=true Limit 1];
        }
        if(proddata.size()>0){
            productId = proddata[0].Id;
        }
        return productId;
    }
}