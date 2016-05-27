@isTest
private class TestSubsForConsole 
{
    static testMethod void testLeadConsole() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	// Create some leads and subs
    	td.getLeads(true);    	
    	list<Subscription__c> lstSubs = td.getSubscriptions(true);
    	
    	Id leadId = td.leads[0].Id;
    	
    	// Loop through the subscriptions and set the lead id to the newly created leads
    	for (Subscription__c sub : lstSubs)
    	{
    		sub.Lead__c = leadId;
    	}
    	    	
    	update(lstSubs);    	
    	
    	list<Subscription__c> returnSubs = [SELECT Id, Status__c FROM Subscription__c WHERE Lead__c = :leadId];
    	
    	system.debug('@@@ TestSubsForConsole:testLeadConsole - Subs for LeadId: ' + leadId); 
    	system.debug('@@@ TestSubsForConsole:testLeadConsole - Subs for Test: ' + lstSubs); 
    	system.debug('@@@ TestSubsForConsole:testLeadConsole - Subs for Lead: ' + returnSubs);
    	
    	Test.startTest();
    				
		PageReference pageRef = Page.SubsForConsole;
		pageRef.getParameters().put('Id', leadId);
		pageRef.getParameters().put('selId', lstSubs[0].Id);
		Test.setCurrentPage(pageRef);		
		
		SubsForConsole_Controller cont = new SubsForConsole_Controller();			
		
		cont.LoadSubscriptions();
		
		// ensure the correct number of subscriptions loaded
		system.assertEquals(td.subscriptionNum, cont.getSubs().size());
		
		string acctPrefix = cont.accountPrefix;
		string contPrefix = cont.contactPrefix;
		string casePrefix = cont.caseCreateURLPrefix;
		string leadPrefix = cont.leadPrefix;
		leadId = cont.getLeadId();
		
		system.debug('@@@ TestSubsForConsole:testLeadConsole - Lead Id for page: ' + leadId);
		
		string leadName = cont.getLeadName();
		string objType = cont.getObjectType();
		
		// By calling this all subs should not be selected	
		cont.SelectSub();
		
		system.assertEquals(null, cont.getSelectedSubId());
		
		// Now actually select a sub
		for (SubsForConsole_Controller.SubscriptionWrapper wrap : cont.getSubs())
		{
			if (wrap.objSub.Id == lstSubs[0].Id)
			{
				wrap.isSelected = true;
				break;
			}
		}
		
		cont.SelectSub();
		
		system.assertNotEquals(null, cont.getSelectedSubId());
		string subName = cont.getSelectedSubName();
		
		list<SelectOption> caseOpts = cont.lstCaseRTs;
		list<SubsForConsole_Controller.CaseRTWrapper> lstCaseWrap = cont.lstCaseRTWraps;
				
		Test.stopTest();
    }
    
    static testMethod void testContactConsole() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	// Create some accounts, contacts and subs
    	td.getAccounts(true);
    	td.getContacts(true); 	
    	list<Subscription__c> lstSubs = td.getSubscriptions(true);
    	
    	Id accountId = td.accounts[0].Id;
    	Id contactId = td.contacts[0].Id;
    	
    	// Update the first contact record to be associated with the account
    	td.contacts[0].AccountId = accountId;
    	update td.contacts;
    	
    	// Loop through the subscriptions and set the lead id to the newly created account
    	for (Subscription__c sub : lstSubs)
    	{
    		sub.Account__c = accountId;
    	}
    	    	
    	update(lstSubs);
    	
    	list<Subscription__c> returnSubs = [SELECT Id, Status__c FROM Subscription__c WHERE Account__c = :accountId];
    	
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Account Id: ' + accountId); 
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Contact Id: ' + contactId);
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Test: ' + lstSubs); 
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Contact: ' + returnSubs);
    	
    	Test.startTest();
    				
		PageReference pageRef = Page.SubsForConsole;
		pageRef.getParameters().put('Id', contactId);
		pageRef.getParameters().put('selId', lstSubs[0].Id);
		Test.setCurrentPage(pageRef);		
		
		SubsForConsole_Controller cont = new SubsForConsole_Controller();			
		
		cont.LoadSubscriptions();
		
		// ensure the correct number of subscriptions loaded
		system.assertEquals(td.subscriptionNum, cont.getSubs().size());
		
		string acctPrefix = cont.accountPrefix;
		string contPrefix = cont.contactPrefix;
		string casePrefix = cont.caseCreateURLPrefix;
		string leadPrefix = cont.leadPrefix;
		accountId = cont.getAcctId();
		contactId = cont.getContactId();
		
		system.debug('@@@ TestSubsForConsole:testContactConsole - Account Id for page: ' + accountId);
		system.debug('@@@ TestSubsForConsole:testContactConsole - Contact Id for page: ' + contactId);
		
		Test.stopTest();
    }
}