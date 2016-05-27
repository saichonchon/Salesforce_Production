global class CampaignContactsUpdate implements Database.Batchable<sObject>, Database.Stateful
{
	public String query;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
        Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
        return Database.getQueryLocator(query);     
    }
	
  	global void execute(Database.BatchableContext BC, List<sObject> scope)
  	{
        map<string, Id> mpNameCamId = new map<string, Id>();
        map<Id,string> mpNewContactCamId = new map<Id, string>();
        map<Id, Decimal> mpContactRev = new map<Id, Decimal>();
        
 		Set<Id> contactIds = new Set<Id>();
 		
       	mpNameCamId = CampaignUtility.LoadNameCampaignIdMap('GMV');
        List<Opportunity> listContacts = (List<Opportunity>)scope;
        system.debug(' Scope ' +listContacts.size());
        Date lastMonthDate = Date.Today().addMonths(-2);
        String zeroCamId = CampaignUtility.getCampaignId(0);
        
        
        for (Opportunity o: listContacts)
  		{
  			String newcamId ;
  			If (o.contact__r.Id <> null && o.contact__r.Primary_MBA_Contact__c == true)
  			{   
  				contactIds.add(o.contact__r.Id);
	  			Decimal prevgmv = 0.0;
	  			if (o.bi_Data__r.Previous_months_GMV__c <> null)
	  			   prevgmv = o.bi_Data__r.Previous_months_GMV__c;
	  			
	  			if (mpContactRev.containsKey(o.contact__r.Id))
	  			{
	  				Decimal rev = mpContactRev.get(o.contact__r.Id) + + prevgmv;
	  				mpContactRev.remove(o.contact__r.Id);
	  				mpContactRev.put(o.contact__r.Id, rev);
	  				
	  			}
	  			else {mpContactRev.put(o.contact__r.Id, prevgmv);}
	  			
	  			if (o.bi_Data__r.Previous_month_GMV_Date__c  <> null && 
	  			    o.bi_Data__r.Previous_month_GMV_Date__c > lastMonthDate)
	  			{
	  				newcamId = CampaignUtility.getCampaignId(o.bi_Data__r.Previous_months_GMV__c);
	  			}
	  			else 
	  			newcamId = zerocamId;
	  			
	  			if (mpNewContactCamId.containsKey(o.contact__r.Id))
	  			{
	  				mpNewContactCamId.remove(o.contact__r.Id);
	  				mpNewContactCamId.put(o.contact__r.Id, newcamId);
	  				
	  			}
	  			else {mpNewContactCamId.put(o.contact__r.Id, newcamId);}
  			}
  		}
  		
  		CampaignUtility.AddContactToCampaign(mpNewContactCamId);
/*  		
  		Map<Id, CampaignMember > mapContactCampaign = new Map<Id, CampaignMember >();
        for (CampaignMember cm : [SELECT Id, CampaignId, ContactId FROM CampaignMember 
        							where CampaignId in :mpNameCamId.Values() and 
        							contactId in :contactIds])
        {
        	 mapContactCampaign.put(cm.ContactId, cm);
        }

// add to campaign
		List<CampaignMember> addCamMem  = new List<CampaignMember>();
		List<CampaignMember> remCamMem  = new List<CampaignMember>();

		for (Id contId : mpNewContactCamId.KeySet())
		{
			String newCampId ='';
			String existCamId ='';

			if (mapContactCampaign.get(contId) <> null)
			{
			    CampaignMember existCam = mapContactCampaign.get(contId);
			    existCamId = existCam.CampaignId;
			}
			newCampId = mpNewContactCamId.get(contId);
			system.debug(' new campaign id '+newCampId);
			system.debug(' existing campaign id '+existCamId);

			if (!existCamId.contains(newCampId) )
			{
				CampaignMember cm = new CampaignMember(ContactId = contId, CampaignId = newCampId );
				addCamMem.add(cm);
				if (existCamId <> '' ) remCamMem.add(mapContactCampaign.get(contId)); 
		 	
			}
			
		}
		
		insert addCamMem;
		delete remCamMem;
*/
  	} 
   
   global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Campaign Update Completed');
        mail.setPlainTextBody('Batch Process has completed');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }     

}