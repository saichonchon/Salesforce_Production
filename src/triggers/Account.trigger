/*
Name: Account.Trigger
Author: 
Created: 
Purpose: 
Ticket: 

Updates:
*********
Author: Maggie Frederick
Created: 4/6/2016
Purpose: Update to post to Google Analytics when conditions are met
Ticket: BAP-2406

Author: Steve O'Neal
Created: 5/9/2016
Purpose: Reviewing code, fixing a potential weakness
Ticket: BAP-3444
*/

trigger Account on Account (after insert, after update) {

    List<string> GAapiCalloutStrings = new List<string>();


	//Sets the Account source to 'BMP' if the source is 'BMP' or the source is updated to BMP and the Account's MBA Account ID is changed
	if (trigger.isAfter)
	{
		Map<String, String> bmpsfIds = new Map<String, String>(); //Stores Salesforce Account IDs to send to BMP
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

		//If there are new accounts with source BMP or an account is updated from a source of MBA to BMP, send the account details to BMP via JSON Rest API request 
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
        List<Account> gaActivatedAccounts = new List<Account>(); // Stores accounts with Google Analytics activation activity
        List<Account> gaTerminatedAccounts = new List<Account>(); // Stores accounts with Google Analytics termination activity
 		
        for(Account acc : trigger.new)
        {
            
            if(acc.OwnerId!= trigger.oldMap.get(acc.id).OwnerId)
            {      
              mapacct.put(acc.Id, acc);  
              mapacctowner.put(acc.Id, acc.OwnerId);
                                    
            }
           
           
			// *Google Analytics*  If the Account has a GA Client ID and the active store count is changed...          
            if (acc.GAClientID__c <> null && acc.Active_Stores_Opp__c <> trigger.oldMap.get(acc.id).Active_Stores_Opp__c)
            {
            	
            	//If the store count increases and was formerly 0...
            	// Steve O'Neal, BAP-3444: switched the check from seeing if value increases to 1 to seeing if value increased and the old value was 0
            	if (acc.Active_Stores_Opp__c  > trigger.oldMap.get(acc.id).Active_Stores_Opp__c
            	    && trigger.oldMap.get(acc.id).Active_Stores_Opp__c == 0)
            	{
					gaActivatedAccounts.add(acc);
            	}
            	
            	//If the store count changes and now is 0...
            	else if (acc.Active_Stores_Opp__c  < trigger.oldMap.get(acc.id).Active_Stores_Opp__c
            	          && acc.Active_Stores_Opp__c ==0)
            	{
            		gaTerminatedAccounts.add(acc);
            	}
            	system.debug('### call GA');
            }
        }
        
		if (mapacct.size() > 0) AccountTriggerHandler.UpdateSubOwner(mapacct);
		if (mapacctowner.size() > 0) AccountTriggerHandler.UpdateContactOwner(mapacctowner);
		
		//If we have any accounts tagged as a Subscription Activation or Subscription Termination...
		
		if (gaActivatedAccounts.size() > 0) 
		{

			for (Account a : gaActivatedAccounts)
			{
                GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.subscription_activation, a));
			}
		}
		
		if (gaTerminatedAccounts.size() > 0) 
		{
			for (Account a : gaTerminatedAccounts)
			{
        		GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.subscription_termination, a));
			}
		}

 	}

    // make the callout to google analytics
    if(GAapiCalloutStrings.size() > 0)
    {
        GAUtility.GARequest(GAapiCalloutStrings);
    }
}