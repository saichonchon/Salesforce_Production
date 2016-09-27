public without sharing class Lead_TriggerHandler {


    public static void updateSubAccountandContact(Map<Id,Lead> mpLeadIdToLead)
    {
        system.debug('Inside updateAccountandContact Method'+mpLeadIdToLead);
        // Map to hold LeadId and Subscription.
        // List to hold Account to Update.
        List<Subscription__c> lstsub = new List<Subscription__c>();
        
        for(Subscription__c sub:[SELECT Id,Lead__c, OwnerId FROM Subscription__c WHERE Lead__c IN : mpLeadIdToLead.keyset()])
        {
 			Lead clead = mpLeadIdToLead.get(sub.Lead__c);
 			sub.Contact__c = cLead.ConvertedContactId;
            sub.Account__c = cLead.ConvertedAccountId;
 
            lstsub.add(sub);
           
        }

        system.debug('Subscription Data Need to update'+lstsub);

        if(!lstsub.isEmpty())
        {
        	SObjectUtils.ManualLeadConvert = true;
        	try
            {
                
               Update(lstsub);
            }
        	catch(Exception exc)
            {
               system.debug('***ERROR: LeadTrigger:update Sub: ' + exc.getStackTraceString());
            }
       		SObjectUtils.ManualLeadConvert = false;
          
        }
       
    
    }   
    
    public static void checkForDuplicates(List<Lead> newLeads)
    {
    	Set<String> setLeadEmail = new Set<String>();
		Set<String> setLeadPhone = new Set<String>();
		
		for ( Lead objLead : newLeads){	
			// Fetch the Email, needed for SOQL
			if (objLead.Email <> null ) setLeadEmail.add(objLead.Email);
			if (objLead.Phone <> null) setLeadPhone.add(objLead.Phone);
		}

		Map<String, Account> mapAccount = new Map<String, Account>();
		// Create a map of Email, Contact
		Map<String, Contact> mapContact = new Map<String, Contact>();
		Map<String, Contact> mapPhoneContact = new Map<String, Contact>();
		
		for(Contact c : [SELECT Id, email,OwnerId, Phone FROM Contact WHERE email in :setLeadEmail AND IsDeleted = false ORDER BY CreatedDate DESC]){
			mapContact.put(c.email, c);
			mapPhoneContact.put(c.Phone, c);
		}
		//Create a map of Email, Lead
		Map<String, Lead> mapLead = new Map<String, Lead>();
		Map<String, Lead> mapPhoneLead = new Map<String, Lead>();
		for(Lead l : [SELECT Id, email, Phone FROM Lead WHERE isConverted = false and (email in :setLeadEmail or phone in :setLeadPhone)]){
			if (l.email <> null) mapLead.put(l.email, l);
			if (l.phone <> null) mapPhoneLead.put(l.phone, l);
		}
	
		for(Lead l : newLeads){
			// Check if Email is present in map
			if(mapContact.containsKey(l.Email) )
			{
				
				if (userinfo.getLastName().contains('API') || Test.isRunningTest())
				{
					l.is_Duplicate__c = true;
				}
				else
				{
					l.Email.addError('Another Contact has the same email address.');
				}
				
			}
			//Check if Email is present in map
			else if(mapLead.containsKey(l.Email) && mapLead.get(l.Email).Id <> l.Id && !l.isConverted)
			{
				
				system.debug('*** Test'+userinfo.getLastName());
				if (userinfo.getLastName().contains('API')|| Test.isRunningTest())
				{
					l.is_Duplicate__c = true;
				}
				else
				{
					l.Email.addError('Another Lead has the same email address.');
				}
			}
			if(mapPhoneLead.containsKey(l.Phone) && mapPhoneLead.get(l.Phone).Id <> l.Id)
			{
				
				system.debug('*** Test'+userinfo.getLastName());
				
				l.phone_match__c = true;
			}
	    }  
  }
  	
    public static void changeLeadOwner(List<Lead> newList, List<Lead> oldList)
    {
		Map<Id,Id> mapLeadOwner = new Map<Id,Id>();	
		for (integer i =0; i < newList.size(); i++)
        {
	      if (newList[i].Take_Ownership__C && !oldList[i].Take_Ownership__C)
	      {
	           if (newList[i].OwnerId <> Label.Lead_Default_Owner)
	            {
	            	newList[i].Take_Ownership__C.addError('Not allowed to change owner.');
	            	
	            }
	            else 
                {
			            mapLeadOwner.put(newList[i].Id, UserInfo.getuserId());
         		 }
	       }
		}
		changeOwner(mapLeadOwner);
    }
  
  @future
    public static void changeOwner(Map<Id,Id> mapLeadOwner)
    {
		List<Lead> updLeads = new List<Lead>();	
		for ( Lead obj : [select Id, OwnerId from Lead where Id in:mapLeadOwner.KeySet()])
		{	
	      
			            obj.OwnerId= mapLeadOwner.get(obj.Id);
			            system.debug('*** user' +obj.OwnerId);
			            obj.Stage__c = 'Engaged';
			            obj.Take_Ownership__C = false;
			            updLeads.add(obj);
	         		 
	       
		}
		update updLeads;
    }
     
    public static void updateChatTranscript(Map<Id,Lead> mpLeadIdToLead)
    {
        
        //List to hold ChatTranscript to Update
        List<LiveChatTranscript> updlst = new List<LiveChatTranscript>();
        
        List<LiveChatTranscript> lstlct = new List<LiveChatTranscript>([SELECT Id, LeadId FROM LiveChatTranscript WHERE LeadId  IN :mpLeadIdToLead.keyset()]);
        
        for(LiveChatTranscript l: lstlct)
        {
 			Lead clead = mpLeadIdToLead.get(l.LeadId);
 			l.ContactId = cLead.ConvertedContactId;
            l.AccountId__c = cLead.ConvertedAccountId;
            l.AccountId = cLead.ConvertedAccountId;
            l.Opportunity__c = cLead.ConvertedOpportunityId;
            updlst.add(l);
           
        }

        if(!lstlct.isEmpty())
        {
	       	try
            {
                
               Update(updlst);
            }
        	catch(Exception exc)
            {
               system.debug('***ERROR: LeadTrigger:update Sub: ' + exc.getStackTraceString());
            }
          
        }
       
    
    }   
    
    public static void changePRMLeadOwner(List<Lead> newList)
    {
		Map<Id,Id> mapLeadOwner = new Map<Id,Id>();	
		Set<Id> rvaccts = new Set<Id>();
		for (integer i =0; i < newList.size(); i++)
        {
	      if (newList[i].rvpe__RVAccount__c <> null
	          && newList[i].OwnerId == Label.Lead_PRM_Owner
	          )
	            {
	            	rvaccts.add(newList[i].rvpe__RVAccount__c);
	            }
	            
	       
		}
		
		if (!rvaccts.isEmpty())
		{
			Map<Id, rvpe__RVAccount__c> mapRVAccount = new Map<Id, rvpe__RVAccount__c>([Select Id, OwnerId from rvpe__RVAccount__c
															 where Id in :rvaccts]);
			
			for (integer i =0; i < newList.size(); i++)
	        {
		      if (mapRVAccount.get(newList[i].rvpe__RVAccount__c) <> null
		          && newList[i].OwnerId == Label.Lead_PRM_Owner
		          )
		            {
		            	rvpe__RVAccount__c rva = mapRVAccount.get(newList[i].rvpe__RVAccount__c);
		            	newList[i].OwnerId = rva.OwnerId; 
		            	newList[i].No_Assign__c = true;
		            }
		            
		       
			}												 
		}												 
														 
    }
  	public static void accountGAUpdate(List<Lead> newList)
    {
       System.debug('Entering the GA account update criteria on lead convert' );
        Set<Id> setAccountIds = new Set<Id>();
        for (Lead l : newList) {
           if (l.isConverted && l.ConvertedAccountId != null) setAccountIds.add(l.ConvertedAccountId);
        }
       
        Map<Id, Account> mapAccounts = new Map<Id, Account>([select Id, GAClientId__c, galastTouchDate__c, gafirstTouchDate__c, gaTotalTouchCount__c from Account where Id in : setAccountIds]);
        Map<Id, Account> mapAccountsToupdate = new Map<Id, Account>();
       
        for (Lead l : newList) {
            if (l.isConverted && mapAccounts.containsKey(l.ConvertedAccountId)) {
                Account a = mapAccounts.get(l.ConvertedAccountId);
                if ( a.GAClientId__c == null) a.GAClientId__c = l.GAClientId__c;
                else a.GAClientId__c = a.GAClientId__c +','+ l.GAClientId__c;
                            
                // MH - Start lead mapping for BAP-3498 - this logic sets or updates the account's first touch and/or last touch details if the lead's first touch and/or last touch details are more accurate
                                
                // If the lead's last Touch Date is later than the Account's last touch date or the Account doesn't have a last touch date set... 
                System.debug('Account galastTouchdate' + a.galasttouchdate__c);
                System.debug('Lead galastTouchDate' + l.galasttouchdate__c);
                
                
                if (l.galastTouchDate__c != null && (a.galastTouchDate__c == null || l.galastTouchDate__c > a.galastTouchDate__c))
                {
                    System.debug('Entering the logic for galastTouch data');
                    a.galastTouchCampaign__c = l.galastTouchCampaign__c;
                    a.galastTouchChannel__c = l.galastTouchChannel__c;
                    a.galastTouchKeyword__c = l.galastTouchKeyword__c;
                    a.galastTouchMedium__c = l.galastTouchMedium__c;
                    a.galastTouchSource__c = l.galastTouchSource__c;
                    a.galastTouchDate__c = l.galastTouchDate__c;  
                }
                
                // If the lead's first Touch Date is earlier than the Account's first touch date or the Account doesn't have a first touch date set...
                System.debug('Account gafirstTouchDate__c' + a.gafirstTouchDate__c);
                System.debug('Lead gafirstTouchDate__c' + l.gafirstTouchDate__c);
                if (l.gafirstTouchDate__c != null && (a.gafirstTouchDate__c == null || l.gafirstTouchDate__c < a.gafirstTouchDate__c))
                {
                    System.debug('Entering the logic for gafirstTouch data');
                    a.gafirstTouchCampaign__c = l.gafirstTouchCampaign__c;
                    a.gafirstTouchChannel__c = l.gafirstTouchChannel__c;
                    a.gafirstTouchKeyword__c = l.gafirstTouchKeyword__c;
                    a.gafirstTouchMedium__c = l.gafirstTouchMedium__c;
                    a.gafirstTouchSource__c = l.gafirstTouchSource__c;
                    a.gafirstTouchDate__c = l.gafirstTouchDate__c;   
                }
                
                // MH - BAP-3498 - Aggregate the Account's TouchCount total by adding the lead's TouchCount value to the account's TouchCount value 
                
             if (l.gatotalTouchCount__c != null) 
                {
                	System.debug('Account gatotalTouch Count is' + a.gatotalTouchCount__c);
                    System.debug('Entering the logic for gatotalTouchCount data');
                    if(a.gatotalTouchCount__c == null) 
                    {
                        System.debug('Entering the logic for gatotalTouchCount data ACCOUNT TOUCH COUNT IS NULL');
                        a.gatotalTouchCount__c = l.gatotalTouchCount__c;
                    }

                    else 
                     {
                        System.debug('Entering the logic for gatotalTouchCount data ACCOUNT TOUCH COUNT IS ' +a.gatotalTouchCount__c);
                        a.gatotalTouchCount__c = a.gatotalTouchCount__c + l.gatotalTouchCount__c;       
                    }
                    
                }
         mapAccountsToupdate.put(a.Id, a);
   		 if (!mapAccountsToupdate.isEmpty()) update mapAccountsToupdate.values();
   
            }
        }
    }
}