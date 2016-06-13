trigger Lead_Trigger on Lead (after insert, after update) {
           
    DatanyzeLeadHandler.AfterDatanyze(trigger.New);
    // create an instance for Google Analytics to send out data
 	GAUtility GAUtil = new GAUtility();
    List<string> GAapiCalloutStrings = new List<string>();
    
    //GA change   
    if (trigger.isAfter && Trigger.isInsert)
    {
        for(Lead l : trigger.new)
        {
            if ( l.GAClientID__c <> null)             
            {      
                 GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.lead_capture, l));                 
            }
        }
        
    }
         
 
    if (trigger.isUpdate && trigger.isAfter)
    {
        Map <Id, Id> mapleadowner = new Map <Id, Id>();
		// Map to Hold Lead Id and Lead Object.
        Map<Id,Lead> mpLeadIdToLead = new Map<Id,Lead>();
 		// for chats       
        Map<Id,Lead> mpcLeadIdToLead = new Map<Id,Lead>();
		// for GA
		List<Lead> gaLostLeads = new List<Lead>();
		List<Lead> gaConvertedLeads = new List<Lead>();
		List<Lead> gaQualifiedLeads = new List<Lead>();
		List<Lead> gaReactivatedLeads = new List<Lead>();
        Map<String, String> gaQualfIds = new Map<String, String>();
     	
        for(Lead l : trigger.new)
        {
        
		    if(l.IsConverted && !trigger.oldMap.get(l.Id).isConverted) 
		    {
           		system.debug('newLeadIsConverted '); 
				// check for chats 
                mpcLeadIdToLead.put(l.Id,l); 
            
                system.debug('Check for a User');
                if(!UserInfo.getProfileId().equals(Label.API_User_Profile))
                {   
                    system.debug('User is not an API User');
                    mpLeadIdToLead.put(l.Id,l); 
                }

 				// GA change           	
        	    if (l.GACLientID__c <> null)
        	    {
					// add the GA client Id on the Account
 					gaConvertedLeads.add(l);
            	}
            }
            
			if (!l.IsConverted && l.GACLientID__c <> null)
			{
			   	if (l.Status == 'Unqualified' && l.Status  <> trigger.oldMap.get(l.Id).Status)
				{
					gaLostLeads.add(l); //'Lead Closed Lost' 
				}
				else if (l.Status  <> trigger.oldMap.get(l.Id).Status && trigger.oldMap.get(l.Id).Status == 'Unqualified')
				{
					gaReactivatedLeads.add(l); // 'Lead Reactivated'
				}
				else if (l.Status == 'Qualified' && l.Status  <> trigger.oldMap.get(l.Id).Status)
				{
					gaQualifiedLeads.add(l); // 'Lead Qualified'
				}
			}
        }
        
        if (gaConvertedLeads.size() > 0)
    	{
            // Send converted leads to Google Analytics
         	for (Lead l : gaConvertedLeads)
        	{
                GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.lead_conversion, l));
        	}

            // Update the accounts for converted leads
            System.debug('Invoked accountGAUpdate method');
            Lead_TriggerHandler.accountGAUpdate(gaConvertedLeads);
    	}
    	
		if (gaLostLeads.size() > 0)
    	{
            // Send lost leads to Google Analytics
            for (Lead l : gaLostLeads)
            {
                GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.lead_lost, l));
            }
    	}

		if (gaReactivatedLeads.size() > 0)
		{
            // Send reactivated leads to Google Analytics
        	for (Lead l : gaReactivatedLeads)
        	{
        		GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.lead_reactivated, l));
        	}
		}

 		if (gaQualifiedLeads.size() > 0)
		{
            // Send qualfied leads to Google Analytics
        	for (Lead l : gaQualifiedLeads)
        	{
        		GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.sales_funnel_stage, l));
        	}
		}
 

        if(mpLeadIdToLead.size()>0)
        {   
            system.debug('Calling class method for converted Lead');
            Lead_TriggerHandler.updateSubAccountandContact(mpLeadIdToLead);
        }
        
        if(mpcLeadIdToLead.size()>0)
        {   
            system.debug('Calling class method for converted Lead chat');
            Lead_TriggerHandler.updateChatTranscript(mpLeadIdToLead);
        }
    }

    // make the callout to google analytics
    if (GAapiCalloutStrings.size() > 0)
    {
        GAUtility.GARequest(GAapiCalloutStrings);
    }

}