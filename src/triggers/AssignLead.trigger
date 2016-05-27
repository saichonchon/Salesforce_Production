trigger AssignLead on Lead (before insert, after insert) {
	//------------------------------------------------------------------------------------
	//// Commented out on 5/22/2013 
	////	- Lead assignment done through assignment rules & round robin functionality
	//------------------------------------------------------------------------------------
	
	/*
	// Create the handler. All the logic for the trigger actually lives in there.
    AssignLeadHandler handler = new AssignLeadHandler(trigger.new, true);

    if (Trigger.isBefore && Trigger.isInsert) {
    	// Sanitise the incoming data.
    	for (Lead thisLead : trigger.new) {
    		if (thisLead.phone == 'false') {
    			thisLead.phone = null;
    		}
    		
    		if (thisLead.firstname == 'false') {
    			thisLead.firstname = null;
    		}
    	}
    	
	    // NOTE: These process* functions can be re-ordered freely. Each one will set the OwnerId, but not overwrite an existing
	    // OwnerId. This means that if one of the rules higher up is matched, then the lower down rule won't be applied.
	    
	    // Check whether there are any partner ids coming in
	    handler.processForIncomingPartnerIds();
	    
	    // Check the leads to see whether there are any existing leads belonging to the acquisition team
	    handler.processForAcquisitionLeads();
	    
	    // Check the leads to see whether there are any existing leads with the same email
	    handler.processForLeadsWithSameEmail();
	    
	    // Check the leads to see whether there are any existing contacts with the same email (The phone is on the account)
	    handler.processForContactsWithSameEmail();
	    
	    // Check the leads to see whether there are any existing leads with the same Phone Number
	    handler.processForLeadsWithSamePhoneNumber();
	    
	    // Check the leads to see whether there are any existing accounts with the same Phone number (Accounts don't have an email)
	    handler.processForAccountsWithSamePhoneNumber();
	    
	    // Assign all the unassigned leads on a round robin
	    handler.assignLeadsByRoundRobin();
    }

	if (Trigger.isAfter && Trigger.isInsert) {
	    // Send emails where they're needed. This will send an email to any lead
	    // assigned through any method other than "Assigned to Creator" and "Set via API"
	    handler.sendEmails(trigger.new);
	}
    
    // THE END!!
    */
}