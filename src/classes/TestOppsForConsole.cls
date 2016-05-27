@isTest
public class TestOppsForConsole {

static testMethod void testContactConsole() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	// Create some accounts, contacts and subs
    	td.getAccounts(true);
    	td.getContacts(true); 	
    	list<Subscription__c> lstSubs = td.getSubscriptions(true);
    	List<Opportunity> lstOpps = td.getOpportunities(true);
    	
    	Id accountId = td.accounts[0].Id;
    	Id contactId = td.contacts[0].Id;
    	
    	// Update the first contact record to be associated with the account
    	td.contacts[0].AccountId = accountId;
    	update td.contacts;
    	
    	// Loop through the subscriptions and set the account id
    	for (Subscription__c sub : lstSubs)
    	{
    		sub.Account__c = accountId;
    	}
    	    	
    	update(lstSubs);
    	
    	// Loop through the opportunities and set the account id
    	Id trialRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
	 
    	for (Opportunity opp : lstOpps)
    	{
    		opp.AccountId = accountId;
    		opp.RecordTypeId = trialRecordTypeId;
    		opp.Subscription__c = lstSubs[0].Id;
    	}
    	    	
    	update(lstOpps);
    	list<Opportunity> returnOpps = [SELECT Id, Status__c FROM Opportunity WHERE AccountId = :accountId];
    	
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Account Id: ' + accountId); 
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Contact Id: ' + contactId);
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Test: ' + lstOpps); 
    	system.debug('@@@ TestSubsForConsole:testContactConsole - Subs for Contact: ' + returnOpps);
    	
    	Test.startTest();
    				
		PageReference pageRef = Page.OppForConsole;
		pageRef.getParameters().put('Id', contactId);
		pageRef.getParameters().put('selId', lstOpps[0].Id);
		Test.setCurrentPage(pageRef);		
		
		OppForConsoleController cont = new OppForConsoleController();			
		
		cont.LoadOpportunities();
		
		// ensure the correct number of subscriptions loaded
//		system.assertEquals(td.subscriptionNum, cont.getSubs().size());
		
		string acctPrefix = cont.accountPrefix;
		string contPrefix = cont.contactPrefix;
//		string casePrefix = cont.caseCreateURLPrefix;
		
		accountId = cont.getAcctId();
		contactId = cont.getContactId();
		
		system.debug('@@@ TestSubsForConsole:testContactConsole - Account Id for page: ' + accountId);
		system.debug('@@@ TestSubsForConsole:testContactConsole - Contact Id for page: ' + contactId);
		
		// By calling this all subs should not be selected	
		cont.SelectOpp();
		
		system.assertEquals(null, cont.getSelectedOppId());
		
		// Now actually select a sub
		for (OppForConsoleController.OpportunityWrapper wrap : cont.getOpps())
		{
			if (wrap.objOpp.Id == lstOpps[0].Id)
			{
				wrap.isSelected = true;
				break;
			}
		}
		
		cont.SelectOpp();
		
		system.assertNotEquals(null, cont.getSelectedOppId());
		string oppName = cont.getSelectedOppName();
		cont.CreateCase();
//		list<SelectOption> caseOpts = cont.lstCaseRTs;
//		list<OppForConsoleController.CaseRTWrapper> lstCaseWrap = cont.lstCaseRTWraps;
				
		
		Test.stopTest();
    }
}