@isTest
public class TestCreateNewTrialController 
{
	private static User createPartnerUser()
	{
		//create partner user 
		TestDataGenerator td = new TestDataGenerator();
		Contact c = td.getContacts(false)[0];
		c.AccountId = c.Account.Id;
		insert c;
		
		Account a = c.Account;
		a.iDev_Partner_ID__c = 1;
		update a;
		
		Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'PRM Portal User' Limit 1];
		User partnerUser = td.getUser(portalProfile, 'partner');
		partnerUser.ContactId = c.Id;
		insert partnerUser;
		
		return partnerUser;
	}
	
	// test creation of New Customer Trial
	static testMethod void createNewCustomerTrial() 
	{
		System.debug('*****createNewCustomerTrial');		
		
		
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);			
			cont.firstName = 'First';
			cont.lastName = 'Last';
			cont.company = 'Company';
			cont.phone = '555-555-5555';
			cont.email = 'test@email.com';
			cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.selectedAccountId = 'NONE';
			
			cont.createNewTrial();			
			
			System.debug('*****cont.subscription.Id: ' + cont.subscription.Id);	
			System.debug('*****cont.subscription.Lead__c: ' + cont.subscription.Id);
			
			Test.stopTest();
			System.debug('*****createNewCustomerTrial END');						
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c WHERE Id = :cont.subscription.Id];			
			System.assertEquals(1, subsToTest.size());
			//System.assertEquals('428231', subsToTest[0].MBASubscriptionID__c);
			
			System.debug('*****createNewCustomerTrial END');
		}
		
	}
	
	// test creation of Existing Customer (Lead) Trial
	static testMethod void createExistingCustomerTrialLead() 
	{
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		Lead l = td.getLeads(true)[0];	
		
		Subscription__c subscription = new Subscription__c();
		subscription.MBAPartnerID__c = '1';
		//subscription.Lead__c = l.Id;
		insert subscription;
		
		subscription.Lead__c = l.Id;
		update subscription;
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);		
			
			cont.selectedAccountId = l.Id;
			cont.changeAccount();
			List<SelectOption> emails = cont.getEmails();
			cont.email = l.Email;
			
			cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.createNewTrial();
			
			cont.doAgain();
			
			Test.stopTest();
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c];
			System.assertEquals(2, subsToTest.size());
			//System.assertEquals('428231', subsToTest[0].MBASubscriptionID__c);
		}
	}
	
	// test creation of Existing Customer (Account) Trial
	static testMethod void createExistingCustomerTrialAccount() 
	{
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		Contact c = td.getContacts(false)[0];
		c.AccountId = c.Account.Id;
		insert c;
		
		Subscription__c subscription = new Subscription__c();
		subscription.MBAPartnerID__c = '1';
		subscription.Account__c = c.AccountId;
		subscription.Contact__c = c.Id;
		insert subscription;
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);		
			
			cont.selectedAccountId = c.Account.Id;
			cont.changeAccount();
			List<SelectOption> emails = cont.getEmails();
			cont.email = c.Email;
			
			cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.createNewTrial();
			
			cont.doAgain();
			
			Test.stopTest();
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c];
			System.assertEquals(2, subsToTest.size());			
			//System.assertEquals('428231', subsToTest[1].MBASubscriptionID__c);
		}		
	}
	
	// test creation of New Customer Trial - not all data filled
	static testMethod void createNewCustomerTrialDataEntryError() 
	{
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);		
			
			cont.lastName = 'Last';
			cont.company = 'Company';
			cont.phone = '555-555-5555';
			cont.email = 'test@email.com';
			cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.selectedAccountId = 'NONE';
			cont.changeAccount();
			
			cont.createNewTrial();		
			
			Test.stopTest();
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c];
			System.assertEquals(0, subsToTest.size());			
		}
		
	}
	
	// test creation of New Customer Trial - invalid Email
	static testMethod void createNewCustomerTrialInvalidEmailError() 
	{
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);		
			cont.firstName = 'First';
			cont.lastName = 'Last';
			cont.company = 'Company';
			cont.phone = '555-555-5555';
			cont.email = 'bad email';
			cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.selectedAccountId = 'NONE';
			cont.changeAccount();
			
			cont.createNewTrial();		
			
			Test.stopTest();
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c];
			System.assertEquals(0, subsToTest.size());			
		}
		
	}
	
	// test creation of Existing Customer (Lead) Trial - data entry error
	static testMethod void createExistingCustomerTrialLeadDataEntryError() 
	{
		TestDataGenerator td = new TestDataGenerator();		
		User partnerUser = createPartnerUser();
		
		Lead l = td.getLeads(true)[0];	
		
		Subscription__c subscription = new Subscription__c();
		subscription.MBAPartnerID__c = '1';
		subscription.Lead__c = l.Id;
		insert subscription;
		
		system.runAs(partnerUser)
		{
			Test.startTest();
			
			PageReference pageRef = Page.CreateNewTrial;
			Test.setCurrentPage(pageRef);			
			
			Subscription__c subs = new Subscription__c();
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(subs);
			
			CreateNewTrialController cont = new CreateNewTrialController(sc);		
			
			cont.selectedAccountId = l.Id;
			cont.changeAccount();
			List<SelectOption> emails = cont.getEmails();
			
			//cont.password = 'password';
			cont.storeName = 'Test Store';			
			// get list of countries
			List<SelectOption> countries = cont.getCountries();			
			cont.country = countries[0].getValue();		
			// get list of industries
			List<SelectOption> industries = cont.getIndustries();
			cont.industry = industries[0].getValue();			
			
			cont.createNewTrial();		
			
			Test.stopTest();
			
			List<Subscription__c> subsToTest = [SELECT Id, MBASubscriptionID__c FROM Subscription__c];
			System.assertEquals(1, subsToTest.size());			
		}
	}	
	
}