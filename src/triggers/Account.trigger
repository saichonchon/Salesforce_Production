trigger Account on Account (after insert, after update) {
/*
	if (trigger.isAfter)
	{
		AccountTriggerHandler.AddToAccountTeam(trigger.isBefore, trigger.isAfter, 
                                               trigger.isInsert, trigger.isUpdate,     
      											trigger.new,  trigger.old, trigger.newmap);
	}
*/
	if (trigger.isAfter)
	{
		Map<String, String> bmpsfIds = new Map<String, String>();
		for(Account acc : trigger.new)
        {
            
            if ((Trigger.isInsert && acc.Source__c == 'BMP') ||
                  (!Trigger.isInsert && acc.Source__c == 'BMP' 
                	&& (trigger.oldMap.get(acc.id).Source__c <> 'BMP'
                	     || acc.Source__c == 'BMP' && acc.MBAAccountID__c!= trigger.oldMap.get(acc.id).MBAAccountID__c)
                	    )
               )
            {      
              
                 bmpsfIds.put(acc.MBAAccountID__c, acc.Id);                   
            }
                  
        }
        
        if (!bmpsfIds.isEmpty())
        {
	        Map<String, String> mapBmpIdBody = RESTAPIUtility.getJSONBody( bmpsfIds);
	        for (String sendbmpId :mapBmpIdBody.KeySet())
			{
			  RESTAPICallouts.BMPRequest('account', sendbmpId, mapBmpIdBody.get(sendbmpId));
			}
        }
	}

	if (trigger.isUpdate && trigger.isAfter)
	{
        Map <Id, Account> mapacct = new Map <Id, Account>();
        Map <Id, Id> mapacctowner = new Map <Id, Id>();
 
        for(Account acc : trigger.new)
        {
            
            if(acc.OwnerId!= trigger.oldMap.get(acc.id).OwnerId)
            {      
              mapacct.put(acc.Id, acc);  
              mapacctowner.put(acc.Id, acc.OwnerId);
                                    
            }
                  
        }
		if (mapacct.size() > 0) AccountTriggerHandler.UpdateSubOwner(mapacct);
		if (mapacctowner.size() > 0) AccountTriggerHandler.UpdateContactOwner(mapacctowner);
 	}
}