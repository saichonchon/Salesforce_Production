trigger Zquote on zqu__Quote__c (after delete, after insert, after update) 
{
	if(!Trigger.isDelete)
    {
		Set<Id> zIds = new Set<Id>();
		Set<Id> zdelIds = new Set<Id>();
		Set<Id> oppIds = new Set<Id>();
		
		for(Integer i=0;i<Trigger.new.size();i++)
         {
    		if (Trigger.New[i].Quote_Charges__c > 0 
    				&& (Trigger.isInsert || Trigger.New[i].Quote_Charges__c <> Trigger.Old[i].Quote_Charges__c))
    		{
    			zdelIds.add(Trigger.New[i].zqu__Opportunity__c);
    			zIds.add(Trigger.New[i].Id);
    		}
    		if (!Trigger.isInsert && Trigger.New[i].Quote_Charges__c == 0 && Trigger.Old[i].Quote_Charges__c >0)
    		{
    			zdelIds.add(Trigger.New[i].zqu__Opportunity__c);
    		}
    		if (Trigger.New[i].zqu__Status__c == 'Sent to Z-Billing')
    		   oppIds.add(Trigger.New[i].zqu__Opportunity__c);
         }
         
         if(zdelIds.size()>0) 
         	ZuoraUtility.deleteProducts(zdelIds);
         if(zIds.size()>0) 
         	ZuoraUtility.addProductsFromQuote(zIds);
         if(oppIds.size()>0) 	
         	ZuoraUtility.updateOpps(oppIds);
    }
 // if quote is deleted, delete any opp line items.
    
    if(Trigger.isDelete)
    {
		Set<Id> zdelIds = new Set<Id>();
		for(Integer i=0;i<Trigger.old.size();i++)
         {
    		if ( Trigger.Old[i].Quote_Charges__c >0)
    		{
    			zdelIds.add(Trigger.Old[i].Id);
    		}
         }
         
        if(zdelIds.size()>0) ZuoraUtility.deleteProducts(zdelIds);
    }
    
}