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
        // Get one of the selectable Opportunity Status from the custom setting that defines it
        Opp_RecordTypes_for_Case_Creation__c OppRTforCase = Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults();
		OppRTforCase.Selectable_Opp_Statuses__c = 'Active';
        OppRTforCase.Opp_Statuses_to_show__c = 'Active';
        OppRTforCase.Opp_RecordTypes_to_Show__c = 'Trial,Client Success';
        OppRTforCase.Selectable_Opp_RecordTypes__c = 'Trial,Client Success';
        upsert OppRTforCase;
        String SelectableOppStatus = '';
        Group t2queue = new Group(name='Tier 2 Support Queue',type='Queue');
        upsert t2queue; 
        
        Group t2q = [select id from group where name = 'Tier 2 Support Queue' and type = 'queue' limit 1];
        QueuesObject qobj = new QueuesObject(QueueID = t2q.id,SobjectType='Case');
        system.runAs(new User(Id = UserInfo.getUserId())){
        	upsert qobj;
        }
        CaseQueueRouting__c cs = CaseQueueRouting__c.getInstance();
        cs.Queue_ID__c = t2q.id;
        cs.Name = 'Tier 2 Support Queue';
        cs.Queue_Name__c = 'Tier 2 Support Queue';
        cs.SetupOwnerId = Userinfo.getOrganizationId();
        upsert cs;
        if(Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults().Selectable_Opp_Statuses__c!=null){
        	SelectableOppStatus = Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults().Selectable_Opp_Statuses__c.split(',')[0];
        }
    	for (Opportunity opp : lstOpps)
    	{
    		opp.AccountId = accountId;
    		opp.RecordTypeId = trialRecordTypeId;
            opp.Status__c = SelectableOppStatus;
    		opp.Subscription__c = lstSubs[0].Id;
    	}
    	    	
    	update(lstOpps);
    	list<Opportunity> returnOpps = [SELECT Id, Status__c FROM Opportunity WHERE AccountId = :accountId];

    	Test.startTest();
    				
		PageReference pageRef = Page.OppForConsole;
		pageRef.getParameters().put('Id', contactId);
		pageRef.getParameters().put('selId', lstOpps[0].Id);
        pageRef.getParameters().put('callernameid', 'Test Caller Name');
        pageRef.getParameters().put('casesubjectid', 'Test Subject');
        pageRef.getParameters().put('caseRecordTypeId','Trial');
		Test.setCurrentPage(pageRef);		
		
		OppForConsoleController cont = new OppForConsoleController();			
		
		cont.LoadOpportunities();
		
		// ensure the correct number of subscriptions loaded
		//system.assertEquals(td.subscriptionNum, cont.getSubs().size());
		
		string acctPrefix = cont.accountPrefix;
		string contPrefix = cont.contactPrefix;
		//string casePrefix = cont.caseCreateURLPrefix;
		
		accountId = cont.getAcctId();
		contactId = cont.getContactId();

		// By calling this all subs should not be selected	
		cont.SelectOpp();
		cont.CaptureOpp();
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
        system.assertNotEquals(null, cont.getSelectedOppName());
        system.assertNotEquals(null, cont.getObjectType());
        system.assertNotEquals(null, OppForConsoleController.getAvailableCaseRecordTypes());
		string oppName = cont.getSelectedOppName();
        cont.CaseSubject = 'test subject';
        cont.CallerName = 'Test Bob';
		cont.CreateCase();

		Test.stopTest();
    }

static testMethod void testOppConsole() 
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
        // Get one of the selectable Opportunity Status from the custom setting that defines it
        Opp_RecordTypes_for_Case_Creation__c OppRTforCase = Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults();
		OppRTforCase.Selectable_Opp_Statuses__c = 'Active';
        OppRTforCase.Opp_Statuses_to_show__c = 'Active';
        OppRTforCase.Opp_RecordTypes_to_Show__c = 'Trial,Client Success';
        OppRTforCase.Selectable_Opp_RecordTypes__c = 'Trial,Client Success';
        upsert OppRTforCase;
        String SelectableOppStatus = '';
        if(Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults().Selectable_Opp_Statuses__c!=null){
        	SelectableOppStatus = Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults().Selectable_Opp_Statuses__c.split(',')[0];
        }
    	for (Opportunity opp : lstOpps)
    	{
    		opp.AccountId = accountId;
    		opp.RecordTypeId = trialRecordTypeId;
            opp.Status__c = SelectableOppStatus;
    		opp.Subscription__c = lstSubs[0].Id;
    	}
    	    	
    	update(lstOpps);
    	list<Opportunity> returnOpps = [SELECT Id, Status__c FROM Opportunity WHERE AccountId = :accountId];

    	Test.startTest();
    				
		PageReference pageRef = Page.OppForConsole;
		pageRef.getParameters().put('Id', lstOpps[0].id);
		pageRef.getParameters().put('selId', lstOpps[0].Id);
        pageRef.getParameters().put('callernameid', 'Test Caller Name');
        pageRef.getParameters().put('casesubjectid', 'Test Subject');
        pageRef.getParameters().put('caseRecordTypeId','Trial');
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

		// By calling this all subs should not be selected	
		cont.SelectOpp();
		cont.CaptureOpp();
		//system.assertEquals(null, cont.getSelectedOppId());

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
        system.assertNotEquals(null, cont.getSelectedOppName());
        system.assertNotEquals(null, cont.getObjectType());
        system.assertNotEquals(null, OppForConsoleController.getAvailableCaseRecordTypes());
		string oppName = cont.getSelectedOppName();
		cont.CreateCase();

		Test.stopTest();
    }
}