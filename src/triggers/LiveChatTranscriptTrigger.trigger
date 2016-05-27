trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert, after insert, after update, after delete, after undelete) 
{
/* commented out 
	if (trigger.isBefore && trigger.isInsert)
	{
		system.debug('*** LiveChatTranscriptTrigger : Before Insert - start');
		
		map<String, LiveChatTranscript> mpKeyToChat = new map<String, LiveChatTranscript>();
		
		// Capture all the chat keys
		for (LiveChatTranscript lct : trigger.new)
		{			
			mpKeyToChat.put(lct.ChatKey, lct);
		}
		
		// Now loop through all the cases for these chat keys and update the LCT accordingly		
		for (Case c : [SELECT Id, Chat_Key__c
						FROM Case
						WHERE Chat_Key__c IN :mpKeyToChat.keySet()])
		{
			if (mpKeyToChat.containsKey(c.Chat_Key__c))
			{
				mpKeyToChat.get(c.Chat_Key__c).CaseId = c.Id;
			}
		}
	}
*/	
	if (trigger.isAfter)
	{
		///////////////////////////////////////////////////////////////////////////
		// 09/27/2013 - Stragtegic Growth (CDB): Code to handle the Roll-Up logic of Live Chat created records for Case to Cases
		///////////////////////////////////////////////////////////////////////////	
		list<LiveChatTranscript> lstChatForCase = new list<LiveChatTranscript>();
		list<LiveChatTranscript> lstChatForCase_Old = new list<LiveChatTranscript>();
		list<LiveChatTranscript> lstChat = new list<LiveChatTranscript>();
		set<Id> stCaseId = new set<Id>();
		
		if (trigger.isDelete)
		{
			lstChat = trigger.old;
		}
		else
		{
			lstChat = trigger.new;
		}
						
		for (LiveChatTranscript lct : lstChat)
		{		
			// Check if the task is for a case
			if (lct.CaseId != null)
			{		
				stCaseId.add(lct.CaseId);	
				lstChatForCase.add(lct);
			    if (trigger.oldMap != null) 
			    {
			    	lstChatForCase_Old.add(trigger.oldMap.get(lct.Id));
			    }
			}
		}
		
		if (!lstChatForCase.isEmpty() && !SObjectUtils.lookUpRollUpIsRunning)
		{				
			system.debug('*** In RollUp Trigger Code - Live Chat Transcript to Case Rollup');
	
			SObjectUtils.lookUpRollUpIsRunning = true;
								
			CaseHandle_Helper.rollUpCaseHandleTime(stCaseId);
			
			//Pass in the name of the child record, in this case 'LiveChatTranscript' and the name of the parent record, in this case 'Case';   
			LookupRollupHelper lrh = new LookupRollupHelper('LiveChatTranscript', 'Case');
					
			if(!lstChatForCase_Old.isEmpty()) 
			{
				lrh.rollupSummary((list<sObject>)lstChatForCase, (list<sObject>)lstChatForCase_Old);   
			} 
			else 
			{
				lrh.rollupSummary((list<sObject>)lstChatForCase, null);
			}
					
			SObjectUtils.lookUpRollUpIsRunning = false;
		}
		///////////////////////////////////////////////////////////////////////////
	}
}