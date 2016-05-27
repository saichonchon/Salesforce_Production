public class TaskHandler {
	
	public static void validActivityUpdate(List<Task> lstTasks)
	{
		Set<String> setCallResult = new Set<String>{'correct contact','contact','set callback', 'Success'};
        Set<String> lstAccIds = new Set<String>();  
 //       List<Account> updAcc = new List<Account>();
        Map<Id, Account> mapUpdAccts = new Map<Id, Account>();
		
		for (Task t :lstTasks)
		{
			lstAccIds.add(t.AccountId);
		}

		Map<Id, Account> mapAccounts = new Map<Id, Account>([Select Id, Owner.Name, OwnerId, Valid_Activity_Date__c, Valid_Activity_By__c from Account where Id in :lstAccIds]);
		
		Boolean updValidActivity = false;
		
		for (Task obj :lstTasks)
		{
		  
		  if (mapAccounts.get(obj.AccountId) <> null)
		  {	
			Account acc = mapAccounts.get(obj.AccountId);
			if ( acc.Valid_Activity_Date__c == null  ||
			    ( acc.Valid_Activity_Date__c <> null && obj.ActivityDate > acc.Valid_Activity_Date__c))
//			system.debug('test '+acc.Id);
			{
				Id AccOwner = acc.OwnerId;
	            if(obj.OwnerId == AccOwner && obj.Subject!=null && obj.Type.equalsIgnoreCase('Email') && (obj.Subject.startsWith('←') || obj.ToutApp__Tout_Replied__c == true ))
	            {
	                updValidActivity = true;
	            }
	             
	            if(obj.OwnerId == AccOwner && obj.Type!=null && obj.Type.equalsIgnoreCase('Call') && obj.CallDisposition!=null && setCallResult.contains(obj.CallDisposition.toLowerCase()))
	            {   
	                updValidActivity = true;
	            }  
	            
	            if (updValidActivity == true)
	            {
	             	acc.Valid_Activity_By__c =acc.Owner.Name;
	            	acc.Valid_Activity_Date__c = obj.ActivityDate;
	            	system.debug(' activity date' +obj.ActivityDate);
	   		 		
	             	if (mapUpdAccts.containsKey(acc.Id)) 
	            	 { 
	            	 	
	            	 	if (obj.ActivityDate > acc.Valid_Activity_Date__c)
	            	 	{
	             	 		system.debug(' latest activity date' +obj.ActivityDate);
	            	 		mapUpdAccts.put(acc.Id, acc);
	            	 	}
	                 }
	            	 else
	            	 {	system.debug(' adding'+obj.ActivityDate);
	            	     mapUpdAccts.put(acc.Id, acc);
	            	 }
	            }
		 	 }
		  }
		}
		
		update mapUpdAccts.Values();
	}

}