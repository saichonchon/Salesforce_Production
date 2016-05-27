trigger ZuoraSubProductCharge on Zuora__SubscriptionProductCharge__c (before insert, before update, after insert, after update, before delete) {

	if (!Trigger.isDelete && Trigger.isBefore)
	{
		    for (Zuora__SubscriptionProductCharge__c obj : Trigger.New)
		    {
				if (obj.OpportunityId__c <> null )
	            obj.Related_Opportunity__c  = obj.OpportunityId__c;
		    }
		    
		    
	}

	if (!Trigger.isDelete && Trigger.isAfter)
	{
			List<Zuora__SubscriptionProductCharge__c > charges = new List<Zuora__SubscriptionProductCharge__c >();
		    Set<Id> oppIds = new Set<Id>();
		    for (Zuora__SubscriptionProductCharge__c zsc : Trigger.New)
		    {
	
		    	if (zsc.Related_Opportunity__c <> null ) 
		    	{
		    		system.debug(' opp '+zsc.Related_Opportunity__c);
		    		charges.add(zsc);
		    		oppIds.add(zsc.Related_Opportunity__c);
		    	}
		    }
		    
		    ZuoraUtility.deleteProducts(oppIds);
		    if (!charges.isEmpty()) ZuoraUtility.createLineItems(charges);
	}
	
	if (Trigger.isDelete)
	{
		Map<Id, Id> mapOppCharge = new Map<Id, Id>();
	    for (Zuora__SubscriptionProductCharge__c dzsc : Trigger.Old)
	    {
	    	if (dzsc.Related_Opportunity__c <> null)
	    	mapOppCharge.put(dzsc.Related_Opportunity__c, dzsc.Id);
	    }
	    
	    List<OpportunityLineItem> exOppLntm = new List<OpportunityLineItem>([Select Id from OpportunityLineItem where OpportunityId in :mapOppCharge.KeySet()
	    																		and Zuora_SubscriptionCharge_Id__c in :mapOppCharge.Values()]);  
	    delete exOppLntm;
	    
	}
	
}