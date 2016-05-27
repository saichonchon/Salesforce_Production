trigger MBA_Staging_Account_Trigger on MBA_Staging_Account__c (before insert, before update, after insert, after update) 
{

 if (Trigger.isBefore)
	{
		for (MBA_Staging_Account__c mba : trigger.new)
    	{
        	
	        if (mba.CompanyName__c == null || mba.CompanyName__c == '')
  			    mba.CompanyName__c = 'Name to be replaced';
        	else
        	{
        		mba.CompanyName__c = DataUtility.truncateString(mba.CompanyName__c, 255);
        	}
        	if (mba.PostalCode__c <> null && mba.PostalCode__c.Length() > 20)
        	{
        		mba.PostalCode__c = DataUtility.truncateString(mba.PostalCode__c, 20);
        	}
    	}	
	}

  if (Trigger.isAfter)
  {

		string soqlWHERE_SubIDs = '';
		string soqlWHERE_MBAAcctIDs = '';  
			
		// Set to hold MBA Account Ids
		set<string> stMBAAcctId = new set<string>();
			
		// Map to hold existing Accounts Records by MBA Account Id
		map<string, Account> mpAcc = new map<string, Account>();
		
		// Map to hold the Staging Record to the Existing Record
		map<SObject, SObject> mpStagingToExisting = new map<SObject, SObject>();
		
	    ///////////////////////////////////////////////////////////////////////////
	    // First try and match to existing Accounts
	    ///////////////////////////////////////////////////////////////////////////
	    // Loop through all staging records
	    for (MBA_Staging_Account__c mba : trigger.new)
	    {
	        // Grab all the MBA Account Ids
	        if (mba.MBAAccountID__c != null)
	        {
	        	if (stMBAAcctId.add(mba.MBAAccountID__c))
	        	{
	        		soqlWHERE_MBAAcctIDs += (soqlWHERE_MBAAcctIDs.length() == 0 ? '' : ', ') + '\'' + mba.MBAAccountID__c + '\'';
	        	}
	        }
	    }
	    
	    // Build the SOQL to query for existing Subscriptions using the custom setting to retrieve all needed fields	
		string soql_Sub = SObjectUtils.AccountSelect + ' WHERE MBAAccountID__c IN (' + soqlWHERE_MBAAcctIDs + ')';
		
		system.debug('**** Account Query: ' + soql_Sub);
			
		// Grab all the Accounts that match the MBA Account ID
	    for (Account a : database.query(soql_Sub))
		{
			mpAcc.put(a.MBAAccountID__c, a);
		}
		
		
		///////////////////////////////////////////////////////////////////////////
		// Find all the Accounts being inserted/updated
	    ///////////////////////////////////////////////////////////////////////////
	    for (MBA_Staging_Account__c mba : trigger.new)
	    {
	    	system.debug('***** trigger.new : ' + trigger.new);
	        // Check if a Account record exists already
	        if (mpAcc.containsKey(mba.MBAAccountID__c))
	        {
	        	// Add to the map of the staging record to the existing Account
	        	mpStagingToExisting.put(mba, mpAcc.get(mba.MBAAccountID__c));
	        	        	
	        	system.debug('***** mpStagingToExisting: ' + mpStagingToExisting);
	        }
	        else if(!mpAcc.containsKey(mba.MBAAccountID__c) && mba.IsPaid__c)
	        { 
	        	// If it is not found then create a new one 
	        	Account acc = new Account();
	        	acc.OwnerId = Label.Lead_Default_Owner;
	        	mpStagingToExisting.put(mba, acc);
	        }
	    }
	    
	    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	    // Create/Update Accounts records from the staging records -- This updates and syncs the selected records from the MBA Accounts to Accounts object 
	    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	    database.Dmloptions dml = new database.Dmloptions();
		dml.assignmentRuleHeader.useDefaultRule = false;
		dml.emailHeader.triggerUserEmail = false;
		dml.optAllOrNone = Subscription_Utility.blnAllOrNone;
		
	    SObjectUtils.SyncObjects('MBA_Staging_Account__c', 'Account', mpStagingToExisting, dml);
   }
}