trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) 
{
    // Ensure this trigger is not being called by an asynchronous method (@future) or by a the rollup functionality
    if (!system.isFuture() && SObjectUtils.lookUpRollUpIsRunning != true)
    { 
        set<Id> stCaseIds_Insert = new set<Id>();
        set<Id> stCaseIds_Update = new set<Id>();
        set<Id> stAcctIds = new set<Id>();
        set<Id> stLeadIds = new set<Id>();
        map<String, Case> mpChatKeyToCase = new map<String, Case>();
        
        list<Case> lstCases;
        
        if (trigger.isDelete)
        {
        	lstCases = trigger.old;
        }
        else
        {
        	lstCases = trigger.new;
        }
        
        List<Case> emailCases = new List<Case>();
        // Ensure this is an After trigger
        if (trigger.isAfter)
        {
        	for (Case c : lstCases)
        	{
        		// If this is for a new or updated case and the Chat key exists
        		if ((trigger.isInsert || trigger.isUpdate) && c.Chat_Key__c != null)
        		{
        			mpChatKeyToCase.put(c.Chat_Key__c, c);
        		}
        		
        		// If this is for a new case make sure the case is not already closed
	        	if (trigger.isInsert && !c.IsClosed)
	        	{
                    // Grab the case id
                    stCaseIds_Insert.add(c.Id);
	            }
	            
	            // If this is an update trigger and the case was just closed
        		if (trigger.isUpdate && c.IsClosed == true && trigger.oldMap.get(c.Id).IsClosed == false)
        		{
        			// Capture the Case Id since it was just set to closed
        			stCaseIds_Update.add(c.Id);
        		}
        		
        		// Check if this is either a delete, undelete, insert with a survey date, or update with survey date changing
        		if (trigger.isDelete || trigger.isUnDelete || (trigger.isInsert && c.Survey_Completion_Date__c != null) || (trigger.isUpdate && c.Survey_Completion_Date__c != trigger.oldMap.get(c.Id).Survey_Completion_Date__c))
        		{
        			// If the case is associated to an account
        			if (c.AccountId != null)
        			{
        				stAcctIds.add(c.AccountId);
        			}
        			
        			// If the case is associated to a Lead
        			if (c.Lead__c != null)
        			{
        				stLeadIds.add(c.Lead__c);
        			}
        		} 
				
				CaseHandle_Helper.rollupMigrations(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.new, Trigger.old, Trigger.newMap);
				
				
				if (!trigger.isDelete)
				{
					CaseTeamHandler.AddToCaseTeam(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.new, Trigger.old, Trigger.newMap);
         			CaseHandle_Helper.updateLead(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.new, Trigger.old, Trigger.newMap);
  //      			CaseHandle_Helper.createSSCase(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.new, Trigger.old, Trigger.newMap);       		
					if (c.Send_Initial_Email__c && !trigger.oldMap.get(c.Id).Send_Initial_Email__c)
					{
						emailCases.add(c);
					}
				}
        	}
        	if (emailCases.size()>0) CaseHandle_Helper.addPublicCaseComment(emailCases);
        	// If cases with Chat Keys exist
        	if (mpChatKeyToCase.size() > 0)
        	{
        		list<LiveChatTranscript> lstLCT = new list<LiveChatTranscript>();
        		
	    		// Now loop through all the live chat transcipts for these chat keys and update them to the correct case accordingly		
				for (LiveChatTranscript lct : [SELECT Id, CaseId, ChatKey
												FROM LiveChatTranscript
												WHERE ChatKey IN :mpChatKeyToCase.keySet()])
				{
					// Check to ensure the chat key is in the map
					if (mpChatKeyToCase.containsKey(lct.ChatKey))
					{
						// Only update the LCT record if the case id does not match the case it should be on
						if (lct.CaseId != mpChatKeyToCase.get(lct.ChatKey).Id)
						{
							lct.CaseId = mpChatKeyToCase.get(lct.ChatKey).Id;
							lstLCT.add(lct);
						}
					}
				}
				
				// If there are LiveChatTranscript records to update
				if (!lstLCT.isEmpty())
				{
					update lstLCT;
				}
        	}
 /*       	
            if (!stCaseIds_Insert.isEmpty())
            {
                // If Case Ids were grabbed then send them to see if a time worked record needs to be created
                CaseHandle_Helper.case_StartWorkingNewCase(stCaseIds_Insert);
            }
        	
        	if (!stCaseIds_Update.isEmpty())
            {
                // If Case Ids were grabbed then send them to see if an Open time worked record exists so it can be stopped
                CaseHandle_Helper.case_StopWorkingAllOpenTime(stCaseIds_Update);
            }
*/            
            // If Account Ids exist then call the function to roll-up the most recent survey date to the account
            if (!stAcctIds.isEmpty())
            {
            	SObjectUtils.lookUpRollUpIsRunning = true;
            	CaseHandle_Helper.account_LastSurveyDate(stAcctIds);
            }
 /*           
            // If Lead Ids exist then call the function to roll-up the most recent survey date to the lead
            if (!stLeadIds.isEmpty())
            {
            	SObjectUtils.lookUpRollUpIsRunning = true;
            	CaseHandle_Helper.lead_LastSurveyDate(stLeadIds);
            }
 */
        }
    }
}