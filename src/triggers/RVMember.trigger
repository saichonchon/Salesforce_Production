trigger RVMember on rvpe__RVMember__c (before insert, after insert, after update) {
    
    // Set the owner from the RV Account
    if (trigger.isBefore)
    {
        Map<Id, Id> mpAcctOwner = new Map<Id,Id>();
        
        Set<ID> rvaccts = new Set<Id>();
        
        for(rvpe__RVMember__c rvm : trigger.new)
        {
            
            if( rvm.rvpe__RVAccount__c <> null)
            {      
              rvaccts.add(rvm.rvpe__RVAccount__c);
            }
                  
        }
        
        for (rvpe__RVAccount__c rva :[select Id, OwnerId from rvpe__RVAccount__c where Id in :rvaccts])
        {
             mpAcctOwner .put(rva.Id, rva.OwnerId);
        }
        
         for(rvpe__RVMember__c rvm : trigger.new)
        {
            
            if( mpAcctOwner.get(rvm.rvpe__RVAccount__c) <> null)
            {      
              rvm.OwnerId =mpAcctOwner.get(rvm.rvpe__RVAccount__c);
            }
                  
        }
        
    }
    
    if (trigger.isAfter)
    {
        ///////////////////////////////////////////////////////////////////////////
        // Build map for Syncing
        ///////////////////////////////////////////////////////////////////////////
            
        // Map to hold RV Member Id to the existing contact
        map<Id, Contact> mapRVMemberIdToContact = new map<Id, Contact>();
        
        // Map to hold the Staging Record to the Existing Record
        map<SObject, SObject> mpStagingToExisting = new map<SObject, SObject>();
            
        ///////////////////////////////////////////////////////////////////////////
        // First try and match to existing Subscriptions
        ///////////////////////////////////////////////////////////////////////////
        //  Query the Fields of RV Member.

        string soqlWHERE_rvIds = '';
        string soqlComma = '';

        for (rvpe__RVMember__c rvm : trigger.new)
        {
            // Grab all the Ids
            soqlWHERE_rvIds += soqlComma + '\'' + rvm.Id + '\'';
            soqlComma = ',';
        }
        // Build the SOQL to query for existing contacts using the custom setting to retrieve all needed fields  

        // create a map using the RV Member ID as the key and the contact record as the data
        string soql_Con = SObjectUtils.ContactRVStagingSelect + ' WHERE RV_Member__c IN (' +soqlWHERE_rvIds +')';
        System.Debug(' soql '+soql_Con);
                
        // Grab all the contacts that match the rv member id
        for (Contact rvContact : database.query(soql_Con))
        {
            mapRVMemberIdToContact.put(rvContact.RV_Member__c, rvContact);
        }
        
        // Find all the members being inserted/updated
        Contact con;
        for (rvpe__RVMember__c rvm : trigger.new)
        {
            // Check if a contact record exists already
            if (mapRVMemberIdToContact.containsKey(rvm.ID))
            {
                con = mapRVMemberIdToContact.get(rvm.Id);
                 
                // Add to the map of the staging record to the existing contact
                mpStagingToExisting.put(rvm, con);
            }
            // contact does not already exist so it is a new record
            else
            {
                // Create a new contact record
                con = new contact();
                con.RV_Member__c = rvm.Id;
                con.AccountId = Label.RV_Partner_Account;
                con.RV_Account__c = rvm.rvpe__RVAccount__c;
                con.Type__c ='Partner RV Member';
                
                // Add to the map of the staging record to the existing contact
                mpStagingToExisting.put(rvm, con);
            }
        } 
        
        // Call the Utility class to do the syncing
        database.Dmloptions dml = new database.Dmloptions();
        dml.assignmentRuleHeader.useDefaultRule = false;
        dml.emailHeader.triggerUserEmail = false;
        dml.optAllOrNone = Subscription_Utility.blnAllOrNone;
        
        SObjectUtils.SyncObjectsNew('rvpe__RVMember__c', 'Contact', mpStagingToExisting, dml);
        
        system.debug('*** Completed contact Handling: ' + trigger.new);
        
    }
    
}