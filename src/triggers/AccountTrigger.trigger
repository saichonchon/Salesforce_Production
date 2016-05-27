trigger AccountTrigger on Account (before insert, before update) 
{
	//------------------------------------------------------------------------------------
	//// Commented out on 5/22/2013 
	////	- Workflow currently performing status validation, and all partner accounts assigned to single person
	////	- All partner accounts assigned to single person
	////	- MBA Partner ID field moving off Account and onto Subscriptions
	//------------------------------------------------------------------------------------
	/*
	
	// Map the partner IDs
    map<Double, list<Integer>> externalIds = new map<Double, list<Integer>>();
    for (Integer thisAccountIndex = 0; thisAccountIndex < trigger.new.size(); thisAccountIndex++) 
    {
    	Account thisAccount = trigger.new.get(thisAccountIndex);
    	
    	// Swap the below lines if we want to keep the sync between the two partner fields.
    	//if (thisAccount.MBA_Partner_ID__c != null) {
    	if (thisAccount.MBA_Partner_ID__c != null && thisAccount.Partner_Account__c == null) 
    	{
    		if (externalIds.containsKey(thisAccount.MBA_Partner_ID__c)) 
    		{
    			externalIds.get(thisAccount.MBA_Partner_ID__c).add(thisAccountIndex);
    		}
    		else 
    		{
    			list<Integer> accounts = new list<Integer>();
    			accounts.add(thisAccountIndex);
    			externalIds.put(thisAccount.MBA_Partner_ID__c, accounts);
    		}
    	}
    }
	
	List <Account> partnerAccounts = [SELECT Id, iDev_Partner_ID__c, OwnerId FROM Account WHERE iDev_Partner_ID__c IN :externalIds.keySet()];
	
	if (partnerAccounts.size() > 0) 
	{
		for (Account thisAccount : partnerAccounts) 
		{
			list<Integer> accountIndexes = externalIds.get(thisAccount.iDev_Partner_ID__c);
			
			for (Integer thisId : accountIndexes) 
			{
				trigger.new.get(thisId).OwnerId = thisAccount.OwnerId;
				trigger.new.get(thisId).Partner_Account__c = thisAccount.Id;
			}
		}
	}
	
	// For updates, check that we're not setting an illegal status
	if (Trigger.isUpdate) {
		for (Account thisAccount : trigger.new) {
			// Check that we're actually dealing with a partner account
			if (thisAccount.RecordTypeId == BCSettings.partnerRecordTypeId) {
				// Check that the statuses are right - they can't be an 'Open' partner if they don't have an iDev account
				if ((thisAccount.iDev_Partner_ID__c == NULL || thisAccount.iDev_Partner_ID__c == 0) && thisAccount.Status__c == 'Open') {
					// Show a message explaining why the update didn't work
					thisAccount.Status__c.addError('This partner can not be changed to "Open" as they do not have an iDev Affiliate ID attached to their account. Please use the "Approve Partner" button.');	
				}
			}
		}
	}
		
	// if it's an insert then route as appropriate and set the right status
	else if (Trigger.isInsert) {
		// Get the list of Partner Managers and most recently created partner so we can roundRobbin
		list<User> PartnerManagers = [SELECT Id, Included_in_Round_Robin__c FROM User WHERE ProfileId = :BCSettings.partnerManagerProfileId AND IsActive = true ORDER BY Id];
	    list<User> PartnerManagersInRR = new list<User>();
	    for (User thisUser : PartnerManagers) {
	    	if (thisUser.Included_in_Round_Robin__c == 'Included') {
	    		PartnerManagersInRR.add(thisUser);
	    	}
	    }
	    if (PartnerManagersInRR.size() == 0) {
	    	PartnerManagersInRR = PartnerManagers;
	    }
	    
	    list<Account> MostRecentPartnerList = new list<Account>();
	    Date myDate = Date.Today();
	    integer itt = 1;
	    while (MostRecentPartnerList.size() < 1 && itt < 3) {
	        Date checkDate = myDate.addDays(-30 * itt);
            MostRecentPartnerList = [SELECT Id, OwnerId FROM Account WHERE RecordTypeId = :BCSettings.partnerRecordTypeId AND CreatedDate > :checkDate AND OwnerId IN :PartnerManagersInRR ORDER BY CreatedDate DESC, Id DESC LIMIT 1];
	        itt++;
	    }
		
		// Sort out the start point of the routing before we enter the loop
        Integer Position = -1;
		if (MostRecentPartnerList.size() > 0 && PartnerManagersInRR.size() > 0) {
        	Account MostRecentPartner = MostRecentPartnerList.get(0);
            for (Integer i = 0; i < PartnerManagersInRR.size(); i++) {
                if (PartnerManagersInRR.get(i).Id == MostRecentPartner.OwnerId) {
                    Position = i;
                    break;
                }
            }	
		}	
		
		// Start the loop
		for (Account thisAccount : trigger.new) {
			// Check that we're actually dealing with a partner account
			if (thisAccount.RecordTypeId == BCSettings.partnerRecordTypeId) {
				// Check that the statuses are right - they can't be an 'Open' partner if they don't have an iDev account
				if ((thisAccount.iDev_Partner_ID__c == NULL || thisAccount.iDev_Partner_ID__c == 0) && thisAccount.Status__c == 'Open') {
					if (thisAccount.OwnerId == BCSettings.apiUser.Id) {
						// Just set it to pending. We don't want to stop inserts happening over the API
						thisAccount.Status__c = 'Pending';
					}
					else {
						thisAccount.Status__c.addError('This partner can not be set to "Open" as they do not have an iDev Affiliate ID attached to their account. Please set the account to "Pending" then use the "Approve Partner" button.');	
					}
				}
				
				// If it's unassigned at the moment then route the account to one of the partner managers to be approved and assigned etc.
				// NOTE: This is a more simple routing than for leads, as it's less important to keep it even.
				if (thisAccount.OwnerId == BCSettings.apiUser.Id || thisAccount.OwnerId == NULL) {
	                // keep track of where we're up to in the list.
	                Position++;
	                if (Position >= PartnerManagersInRR.size()) {
	                    Position = 0;
	                }
	                
	                thisAccount.OwnerId = PartnerManagersInRR.get(Position).Id;
				}
			}
		}
	}
	*/
}