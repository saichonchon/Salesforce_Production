public class Contact_TriggerHandler {

    public void UpdateSubsContact(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
                                    List<Contact> newList,  List<Contact> oldList, Map<Id, Contact> newMap)
    {    
 	  if (!SObjectUtils.SubscriptionLogicRunning)
 	  {
        Set<id> contIds = new Set<Id>();  
       
        for(integer i = 0; i < newList.size(); i++)
        {
            if ((newList[i].phone != null
                && (isInsert || (!isInsert &&  newList[i].phone != oldList[i].phone )))
                || (newList[i].email != null
                && (isInsert || (!isInsert &&  newList[i].email != oldList[i].email )))
                )
            { contIds.add(newList[i].Id); }
        }
        
        List <Subscription__c> subs = new List<Subscription__c>([Select s.Id, s.Phone__c, s.Email__c, s.Contact__c, s.Account__c, s.Account_ID__c 
                                                                From Subscription__c s
                                                                where Contact__c in :contIds]);
        for (Subscription__c s : subs)
        {
            Contact con = newmap.get(s.Contact__c);
            If (con <> null)
            {
                s.Email__c = con.Email;
                s.Phone__c = con.Phone;
            }
        }                                                       
        update subs;                                                        
 	  }

    }   
     
    public void UpdateOppContact(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
                                    List<Contact> newList,  List<Contact> oldList, Map<Id, Contact> newMap)
    {    
 	  if (!SObjectUtils.SubscriptionLogicRunning)
 	  {
        Set<id> contIds = new Set<Id>();  
       
        for(integer i = 0; i < newList.size(); i++)
        {
            if (newList[i].phone != null
                && (!isInsert &&  newList[i].phone != oldList[i].phone )
                )
            { contIds.add(newList[i].Id); }
        }
        
        List <Opportunity> updopps = new List<Opportunity>();
        for (Opportunity o : [Select Id, Contact_Phone__c, Contact__c
                                From Opportunity
                                where Contact__c in :contIds])
        {
            Contact con = newmap.get(o.Contact__c);
            If (con <> null && con.Phone <> o.Contact_Phone__c)
            {
               
                o.Contact_Phone__c = con.Phone;
                updopps.add(o);
            }
        }                                                       
        update updopps;                                                        
 	  }

    }   
       
 
 // Method To Set State,timeZone in Contact.
    
    public void UpdateTZ(List<Contact> consList){
        
	     AreaCodeUtility areacodes = new AreaCodeUtility();
	     areacodes.UpdateContacts(consList);
 
    }
    
    public void updAcctAppContact(List<Contact> contactList)   	
	{
	   Id partnerRecordTypeId  = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Channel Partner Record Type').getRecordTypeId();
		 
		Map<Id, Contact> mapcont = new Map<Id,Contact>([select Id, AccountId, Account.AppDeveloperContact__c, Account.RecordTypeId from Contact where Id in : Trigger.New]);
 		List<Account> accts = new List<Account>();
 		
        for (Contact c : contactList)
        {
        	Contact con = mapcont.get(c.Id);
        	if (con.Account.RecordTypeId == partnerRecordTypeId
        	    && con.Account.AppDeveloperContact__c == null)
        	{
        		Account updAcc = new Account();
        		updAcc.Id = con.AccountId;
        		updAcc.AppDeveloperContact__c = con.Id;
        		accts.add(updAcc);
        	}

            
        }   
		update accts;
	}  
                                                            
}