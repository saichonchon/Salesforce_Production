public without sharing class Lead_TriggerHandler {

/*
  Map<String, Id> leadEmail = new Map<String, Id>();
  List<Id> convertedLeadIds = new List<Id>();
  Map<Id,Id> leadToContactIds = new Map<Id,Id>();
  Map<Id,Id> leadToAccountIds = new Map<Id,Id>();  
 
  public void getWebinar(List<Lead> leadList){    
    
    for(Lead leadId : leadList){
     
      leadEmail.put(leadId.Email,leadId.Id);
    }   

    List<Webinar__c> dbWebinarRec = [SELECT Registrant_Email__c FROM Webinar__c WHERE Registrant_Email__c IN : leadEmail.keySet() ];    

    if(!dbWebinarRec.isEmpty()){

      for(Webinar__c updateWebinar : dbWebinarRec ){

        updateWebinar.Lead__c = leadEmail.get(updateWebinar.Registrant_email__c);

        System.debug('getWebinar : lead__c Id ' + leadEmail.get(updateWebinar.Registrant_email__c));
      }
    }
    update dbWebinarRec;   
  } 

  public void newLeadIsConverted(List<Lead> leadList){

    for (Lead l : leadList) {       
      convertedLeadIds.add(l.Id);
      leadToContactIds.put(l.Id,l.ConvertedContactId);
      leadToAccountIds.put(l.Id,l.ConvertedAccountId);     
    }
    if (!convertedLeadIds.isEmpty()) {
      //Get webinar__c objects for these leads
      List<Webinar__c> dbWebinars = [SELECT Id, Lead__c, Contact__c, Account__c FROM Webinar__c WHERE Lead__c IN :convertedLeadIds];

      System.debug('newLeadIsConverted : dbWebinars ' + dbWebinars);
      if (!dbWebinars.isEmpty()) {
        for (Webinar__c webinar : dbWebinars) {
          if (webinar.Contact__c == null) {
            webinar.Contact__c = leadToContactIds.get(webinar.Lead__c);
          }
          if (webinar.Account__c == null) {
            webinar.Account__c = leadToAccountIds.get(webinar.Lead__c);
          }
        }
        update dbWebinars;
      }
    }    
  }
 
  public static void updateSubOwner(Map <Id, Id> mapleadowner)
  	
  {
	  
    	List<Subscription__c> subs = new List<Subscription__c>([select Id, OwnerId, Lead__c from Subscription__c where  Lead__c in :mapleadOwner.KeySet() and Channel_Partner__c = null]);
        
        List<Subscription__c> updsubs = new List<Subscription__c>();
             
        
        for (Subscription__c sub :subs)
            {
              if (sub.OwnerId <> mapLeadOwner.get(sub.Lead__c))	
              {
            	sub.OwnerId = mapLeadOwner.get(sub.Lead__c);
                updsubs.add(sub);
              }	
            }
            
            try
            {
                
                update updsubs;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('Lead Trigger Handler', 'after update', 'Error in Lead Trigger Handler - update ', ': update Subscription' + subs[0].Id);
 
               system.debug('***ERROR: LeadTrigger:update Sub: ' + exc.getStackTraceString());
            }
    
  } 
  */
    public static void updateSubAccountandContact(Map<Id,Lead> mpLeadIdToLead)
    {
        system.debug('Inside updateAccountandContact Method'+mpLeadIdToLead);
        // Map to hold LeadId and Subscription.
        //List to hold Account to Update.
        List<Subscription__c> lstsub = new List<Subscription__c>();
        
        for(Subscription__c sub:[SELECT Id,Lead__c, OwnerId FROM Subscription__c WHERE Lead__c IN : mpLeadIdToLead.keyset()])
        {
 			Lead clead = mpLeadIdToLead.get(sub.Lead__c);
 			sub.Contact__c = cLead.ConvertedContactId;
            sub.Account__c = cLead.ConvertedAccountId;
            sub.OwnerId = cLead.OwnerId;
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
 //              ErrorEmailHelper.notifyOnError('Lead Trigger Handler', 'after update', 'Error in Lead Trigger Handler - update ', ': update Subscription Account, Contact' + lstsub[0].Id);
 
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
			//fetch the Email, needed for SOQL
			if (objLead.Email <> null ) setLeadEmail.add(objLead.Email);
			if (objLead.Phone <> null) setLeadPhone.add(objLead.Phone);
		}

		Map<String, Account> mapAccount = new Map<String, Account>();
		//Create a map of Email, Contact
		Map<String, Contact> mapContact = new Map<String, Contact>();
		Map<String, Contact> mapPhoneContact = new Map<String, Contact>();
		
		for(Contact c : [SELECT Id, email,OwnerId, Phone FROM Contact WHERE email in :setLeadEmail AND IsDeleted = false ORDER BY CreatedDate DESC]){
			mapContact.put(c.email, c);
//			String numData = c.Phone.replaceAll('[^0-9]', '');
			mapPhoneContact.put(c.Phone, c);
		}
		//Create a map of Email, Lead
		Map<String, Lead> mapLead = new Map<String, Lead>();
		Map<String, Lead> mapPhoneLead = new Map<String, Lead>();
		for(Lead l : [SELECT Id, email, Phone FROM Lead WHERE isConverted = false and (email in :setLeadEmail or phone in :setLeadPhone)]){
			if (l.email <> null) mapLead.put(l.email, l);
//			String numData = c.Phone.replaceAll('[^0-9]', '');
			if (l.phone <> null) mapPhoneLead.put(l.phone, l);
		}
	
		for(Lead l : newLeads){
			//Check if Email is present in map
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
				
//				l.status = 'Duplicate Contact Found';
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
				
//				l.status = 'Duplicate Lead Found';
			}
			if(mapPhoneLead.containsKey(l.Phone) && mapPhoneLead.get(l.Phone).Id <> l.Id)
			{
				
				system.debug('*** Test'+userinfo.getLastName());
				
				l.phone_match__c = true;
				
//				l.status = 'Duplicate Lead Found';
			}
	    }
	   
  }
  
  public static void updatePhoneNumbers(List<Lead> newList, List<Lead> oldList)
  {
  	
  	  List<Lead> updList = new List<Lead>();
  	  
  	  for (integer i =0; i < newList.size(); i++)
        {
//			String newph = newList[i].Phone.replaceAll('[^0-9]', '');
//			String oldph = oldList[i].Phone.replaceAll('[^0-9]', '');
            if (  oldList[i].Phone <> null && 
                  newList[i].Phone <> null && 
                  newList[i].Phone.replaceAll('[^0-9]', '') <> oldList[i].Phone.replaceAll('[^0-9]', '')
//                  || (newList[i].Sales_Phone__c <> oldList[i].Sales_Phone__c && newList[i].Bad_Phone_Number__c == true)
  				)
                {
 
                   if (newList[i].MBA_Phone_3__c<> null) 
                   {
	                   newList[i].MBA_Phone_4__c =  oldList[i].MBA_Phone_3__c;
	                   newList[i].Bad_MBA_Phone_4__c = oldList[i].Bad_MBA_Phone_3__c ;
                   }
                   if (newList[i].MBA_Phone_2__c<> null) 
                   {
	                   newList[i].MBA_Phone_3__c =  oldList[i].MBA_Phone_2__c;
	                   newList[i].Bad_MBA_Phone_3__c = oldList[i].Bad_MBA_Phone_2__c ;
                   }
                   if (newList[i].MBA_Phone_1__c<> null) 
                   {
	                   newList[i].MBA_Phone_2__c =  oldList[i].MBA_Phone_1__c;
	                   newList[i].Bad_MBA_Phone_2__c = oldList[i].Bad_MBA_Phone_1__c ;
                   }
                   if (newList[i].Phone <> null) 
                   {
	                   newList[i].MBA_Phone_1__c =  oldList[i].Phone;
	                   newList[i].Bad_MBA_Phone_1__c = newList[i].Bad_Phone_Number__c;
                   }
 
 /*                 if (newList[i].Sales_Phone__c <> oldList[i].Sales_Phone__c && 
                      newList[i].Bad_Phone_Number__c == true)
                  {
                  	newList[i].Phone = newList[i].Sales_Phone__c;
                  } 
 */                  
                   newList[i].Bad_Phone_Number__c= false ;
                   
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
	            else {
			            mapLeadOwner.put(newList[i].Id, UserInfo.getuserId());
//			            newList[i].OwnerId= mapLeadOwner.get(newList[i].Id);
//			            system.debug('*** user' +newList[i].OwnerId);
//			            newList[i].Stage__c = 'Engaged';
//			            newList[i].Take_Ownership__C = false;
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
        
        //List to hold ChatTranscript to Update.
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
  
}