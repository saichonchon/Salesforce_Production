global class RetentionCampaignUpdate implements Database.Batchable<sObject>, Database.Stateful
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
        map<Id,string> mpContactCamId = new map<Id, string>();
        map<Id, Decimal> mpContactRev = new map<Id, Decimal>();
		
//       	mpNameCamId = CampaignUtility.LoadNameCampaignIdMap('Retention Campaign');
        CampaignRules__c camrule = CampaignUtility.getCampaignByName('Retention Campaign');
        
        List<Opportunity> listContacts = (List<Opportunity>)scope;
        system.debug(' Scope ' +listContacts.size());
 //       Date lastMonthDate = Date.Today().addMonths(-2);
 //       Date SixMonthDate = Date.Today().addMonths(-6);
                
        
        for (Opportunity o: listContacts)
  		{
  			
  			If (o.contact__r.Id <> null && o.contact__r.Primary_MBA_Contact__c == true)
  			{   
 // 				contactIds.add(o.contact__r.Id);
	  			Decimal gmv = 0.0;
	  			if (o.bi_Data__r.Lifetime_GMV__c <> null)
	  			   gmv = o.bi_Data__r.Lifetime_GMV__c;
	  			
	  			if (mpContactRev.containsKey(o.contact__r.Id))
	  			{
	  				gmv = mpContactRev.get(o.contact__r.Id) + + gmv;
	  				mpContactRev.remove(o.contact__r.Id);
  				
	  			}
	  			
	  			mpContactRev.put(o.contact__r.Id, gmv);
			
  			}	
  		}
  		
  		for (Id conId :mpContactRev.KeySet())	
  		{	  			
	  		if (mpContactRev.get(conId) < camrule.Ending_GMV__c)
	  		{
	  			mpContactCamId.put(conId, camrule.Campaign_Id__c);	
	  		}
  		}
  		CampaignUtility.AddContactToCampaign(mpContactCamId);

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