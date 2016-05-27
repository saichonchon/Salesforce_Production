trigger SupportSurvey on Support_Survey__c (before insert, before update, after insert, after update) {

	if (trigger.isBefore)
  {
        
    map<String, Support_Survey__c> mpKeyToChat = new map<String, Support_Survey__c>();
    
    // Capture all the chat keys
    for (Support_Survey__c ss : trigger.new)
    {      
       if ((ss.Case__c == null || ss.Live_Chat_Transcript__c == null) && ss.Chat_Key__c <> null)
       { mpKeyToChat.put(ss.Chat_Key__c, ss); }
       system.debug('chat key '+ss.Chat_Key__c);
    }
  
  /*   
    // Now loop through all the cases for these chat keys and update the ss accordingly    
    for (Case c : [SELECT Id, Chat_Key__c
            FROM Case
            WHERE  Chat_Key__c IN :mpKeyToChat.keySet()])
    {
      if (mpKeyToChat.containsKey(c.Chat_Key__c))
      {
        mpKeyToChat.get(c.Chat_Key__c).Case__c = c.Id;
        
      }
    }
  */
     // Now loop through all the transcripts for these chat keys and update the ss accordingly    
    for (LiveChatTranscript l : [SELECT Id, ChatKey, CaseId
            FROM LiveChatTranscript l
            WHERE  ChatKey IN :mpKeyToChat.keySet()])
    {
      if (mpKeyToChat.containsKey(l.ChatKey))
      {
        Support_Survey__c slt = mpKeyToChat.get(l.ChatKey);
        slt.Live_Chat_Transcript__c = l.Id;
        slt.Case__c = l.CaseId;
        mpKeyToChat.remove(l.ChatKey);
        mpKeyToChat.put(l.ChatKey, slt);
      }
    }
    
    for (Support_Survey__c updss : trigger.new)
    {      
       if(mpKeyToChat.get(updss.Chat_Key__c) <> null)
       { 
       	 Support_Survey__c fetchss = mpKeyToChat.get(updss.Chat_Key__c);
       	 if (fetchss.Case__c <> null) updss.Case__c = fetchss.Case__c;
       	 if (fetchss.Live_Chat_Transcript__c <> null) updss.Live_Chat_Transcript__c = fetchss.Live_Chat_Transcript__c;
       	}
    }
    
    
    
    
  }
  	if (trigger.isAfter)
  {
        
    map<Id, String> mpKeyToCase = new map<Id, String>();
    
  
    for (Support_Survey__c Verified : trigger.new)
    {   If (Verified.Survey_Name__c == 'Migration Verification Checklist')
    	{    
       //look to see if client stated that all migrated objects are complete
	       String VerifiedStr;
	       system.debug('**** '+Verified.Case__c);
	       if (   Verified.Redirect_301_transfer_successful__c.equalsignorecase('YES')
	            && Verified.Product_image_transfer_successful__c.equalsignorecase('YES') 
	            && Verified.Product_details_transfer_successful__c.equalsignorecase('YES')
	            && Verified.Product_Options_transfer_successful__c.equalsignorecase('YES')
	            && Verified.Customer_Info_transfer_successful__c.equalsignorecase('YES')
	            && Verified.Category_Structure_transfer_successful__c.equalsignorecase('YES')
	            && Verified.Category_Name_transfer_successful__c.equalsignorecase('YES')
	            )
	            {
	           		VerifiedStr = 'Yes';
	            }
	        else
	            	VerifiedStr = 'No';
            
        mpKeyToCase.put(Verified.Case__c, VerifiedStr); 
    	}
    }
     
    // Now loop through all the cases and update the status accordingly    
    List<Case> updCases = new List<Case>();
    
    for (Case c : [SELECT Id, Migration_Verified_Clicktools__c , Status
            FROM Case
            WHERE  Id IN :mpKeyToCase.keySet()])
    {
      if (mpKeyToCase.get(c.Id) == 'Yes' ) 
      { 
      	c.Migration_Verified_Clicktools__c = 'Yes';
      	c.Status = 'Closed';
      }
      else 
      {
      	c.Migration_Verified_Clicktools__c = 'No';
      	c.Status = 'UAT Review';
      }
      updCases.add(c);
    }
     
     update updCases;
    
  }
  
   if (trigger.isAfter)
  {
        
    map<Id, String> mpPhoneCase = new map<Id, String>();
    Set<ID> caseIds = new Set<ID>();
    Map<Id, Case> updateCases = new Map<Id,Case>();
   
    for (Support_Survey__c ph : trigger.new)
    {   If (ph.Survey_Name__c == 'Support NPS Phone Survey')
    	{    
           if (ph.Case__c <> null) 
           {
           	 mpPhoneCase.put(ph.Id, ph.Case__c);
           	 caseIds.add(ph.Case__c);
           }
    	}
    }
    
    if (caseIds.isEmpty()) return; 
     
    Map<ID, Case> mpCase = new Map<ID, Case> ([select Id, Satisfaction__c, Issue_Resolved__c, Survey_Completion_Date__c, Survey_Name__c, Recommend__c 
     											from Case
                                               where Id in :caseIds and origin = 'Phone']);
                                               
    for (Support_Survey__c ph : trigger.new)
    {   If (ph.Survey_Name__c == 'Support NPS Phone Survey')
    	{    
           Case updCase = mpCase.get(ph.Case__c);
           if (updCase <> null && (updCase.Survey_Completion_Date__c == null ||
               (updCase.Survey_Completion_Date__c <> null && ph.Survey_Completion_Date__c > updCase.Survey_Completion_Date__c) )
               )
           {
           	 
           	 updCase.Satisfaction__c = ph.Satisfaction__c;
           	 updCase.Survey_Completion_Date__c = ph.Survey_Completion_Date__c;
           	 updCase.Survey_Name__c = ph.Survey_Name__c;
           	 updCase.Recommend__c = ph.Recommend__c;
           	 updCase.Issue_Resolved__c = ph.Issue_Resolved__c;
           	 updateCases.put(updCase.Id, updCase);
           }
    	}
    }
  	
    update updateCases.values();	
  } 	
}