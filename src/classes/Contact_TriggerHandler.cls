public class Contact_TriggerHandler {

/*
    Map<String,Id> emailToContactId = new Map<String,Id>();
    Map<String,Id> emailToAccountId = new Map<String,Id>();
    //Map<String,Id> emailToOwnerId = new Map<String, Id>();
    //List<Id> updatedOwners = new List<Id>();
    
    public void getWebinar(List<Contact> contactList){

        for (Contact c : contactList){

            if (!String.isBlank(c.email)) {
              emailToContactId.put(c.email.toLowerCase(), c.Id);
              emailToAccountId.put(c.email.toLowerCase(), c.AccountId);
             // emailToOwnerId.put(c.email.toLowerCase(), c.OwnerId);             
            }
        }   

        if (!emailToContactId.keySet().isEmpty()) {

            System.debug('getWebinar : emailToContactId.keySet() ' +  emailToContactId.keySet());
            
            List<Webinar__c> dbWebinars = [SELECT Id, Contact__c, Account__c, OwnerId,Registrant_email__c FROM Webinar__c WHERE Contact__c = null AND Registrant_email__c IN : emailToContactId.keySet()];
            System.debug('getWebinar : dbWebinars ' +  dbWebinars);
            
            if (!dbWebinars.isEmpty()) {                

              for (Webinar__c webinar : dbWebinars) {

                    if (webinar.Contact__c == null) {
                      webinar.Contact__c = emailToContactId.get(webinar.Registrant_email__c.toLowerCase());
                    }
                    if (webinar.Account__c == null) {
                      webinar.Account__c = emailToAccountId.get(webinar.Registrant_email__c.toLowerCase());
                    }
                   // webinar.OwnerId = emailToOwnerId.get(webinar.Registrant_email__c.toLowerCase());
                }
                update dbWebinars;
            }
        }    
    }   

  //  public void newContactOwner(List<Contact> contactList){
  //    User webinarOwner = [SELECT Id FROM User WHERE LastName = 'Bedrock'];
  //    List<Webinar__c> dbWebinars = [SELECT Id, Contact__r.OwnerId, OwnerId FROM Webinar__c WHERE Contact__c IN : contactList];       

     //   if(dbWebinars[0].OwnerId != webinarOwner.Id){
     //     if (!dbWebinars.isEmpty()) {
                   
     //       for(Webinar__c web : dbWebinars){       
     //         web.OwnerId = web.Contact__r.OwnerId;    
     //       }           
     //       update dbWebinars;
     //     } 
     //   }         
    //}
    */
    
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
    
  public  void updatePhoneNumbers(List<Contact> newList, List<Contact> oldList)
  {
  	
  	  List<Contact> updList = new List<Contact>();
  	  
  	  for (integer i =0; i < newList.size(); i++)
        {

            if (newList[i].Phone <> null 
                && oldList[i].Phone <> null
                 && newList[i].Phone.replaceAll('[^0-9]', '') <> oldList[i].Phone.replaceAll('[^0-9]', ''))
 //               || (newList[i].Sales_Phone__c <> oldList[i].Sales_Phone__c && newList[i].Bad_Phone_Number__c == true))
                {
 
                   if (newList[i].MBA_Phone_3__c<> null) newList[i].MBA_Phone_4__c =  oldList[i].MBA_Phone_3__c;
                   newList[i].Bad_MBA_Phone_4__c = oldList[i].Bad_MBA_Phone_3__c ;
                   if (newList[i].MBA_Phone_2__c<> null) newList[i].MBA_Phone_3__c =  oldList[i].MBA_Phone_2__c;
                   newList[i].Bad_MBA_Phone_3__c = oldList[i].Bad_MBA_Phone_2__c ;
                   if (newList[i].MBA_Phone_1__c<> null) newList[i].MBA_Phone_2__c =  oldList[i].MBA_Phone_1__c;
                   newList[i].Bad_MBA_Phone_2__c = oldList[i].Bad_MBA_Phone_1__c ;
                   if (newList[i].Phone <> null) newList[i].MBA_Phone_1__c =  oldList[i].Phone;
                   newList[i].Bad_MBA_Phone_1__c = newList[i].Bad_Phone_Number__c;
 
/*                  if (newList[i].Sales_Phone__c <> oldList[i].Sales_Phone__c && 
                      newList[i].Bad_Phone_Number__c == true)
                  {
                  	newList[i].Phone = newList[i].Sales_Phone__c;
                  } 
 */                  
                  newList[i].Bad_Phone_Number__c= false ;
                   
                }
         }
  
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