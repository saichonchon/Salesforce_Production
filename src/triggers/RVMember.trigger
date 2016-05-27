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
        string soqlWHERE_rvIds = '';
            
        // Set to hold RV Member Ids
        set<Integer> stRVMemId = new set<Integer>();

        // Map to hold existing Subscription Records by MBA Subscription Id
        map<Integer, Contact> mpCon = new map<Integer, Contact>();
        
        // Map to hold the Staging Record to the Existing Record
        map<SObject, SObject> mpStagingToExisting = new map<SObject, SObject>();
            
        ///////////////////////////////////////////////////////////////////////////
        // First try and match to existing Subscriptions
        ///////////////////////////////////////////////////////////////////////////
        //  Query the Fields of RV Member.
        for (rvpe__RVMember__c rvm : trigger.new)
        {
            // Grab all the Ids
            
    //            stRVMemId.add(rvm.rvpe__ExtMemberId__c.intValue());
            if (stRVMemId.add(rvm.rvpe__ExtMemberId__c.intValue()))
            {
                soqlWHERE_rvIds +=  (soqlWHERE_rvIds.length() == 0 ? '' : ',') + rvm.rvpe__ExtMemberId__c.intValue();
            } 
            
        }
        System.Debug('test '+stRVMemId);
        System.Debug('soqlWHERE_rvIds '+soqlWHERE_rvIds );
        // Build the SOQL to query for existing contacts using the custom setting to retrieve all needed fields  
    
        string soql_Con = SObjectUtils.ContactRVStagingSelect + ' WHERE RVMemberId__c <> null and RVMemberId__c IN (' +soqlWHERE_rvIds +')';
         System.Debug(' soql '+soql_Con);
                
        // Grab all the contacts that match the rv member id
        for (Contact c : database.query(soql_Con))
        {
            mpCon.put(c.RVMemberID__c.intValue(), c);
        }
        
        Contact con;
    
        // Find all the members being inserted/updated
        for (rvpe__RVMember__c rvm : trigger.new)
        {
            // Check if a contact record exists already
            if (mpcon.containsKey(rvm.rvpe__ExtMemberId__c.intValue()))
            {
                con = mpcon.get(rvm.rvpe__ExtMemberId__c.intValue());
                 
                // Add to the map of the staging record to the existing contact
                mpStagingToExisting.put(rvm, con);
                
                
            }
            // contact does not already exist so it is a new record
            else
            {
                // Create a new contact record
                con = new contact();
                con.AccountId = Label.RV_Partner_Account;
                con.RVAccountName__c = rvm.RVAccountName__c;
                con.Type__c ='Partner RV Member';
                con.RVMemberID__c = rvm.rvpe__ExtMemberId__c;
                
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