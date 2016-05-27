/**
 * This class contains unit tests for exercising and validating AssignLeadHandler and AssignLead.trigger
 */
@isTest
private class AssignLeadTests {
	/*
	// TODO: Write a test around the email sending so that we can make sure they
	// are going out, correct, and send to the right people.

	private static list<User> AllSalesUsers = [SELECT Id, Name FROM User WHERE ProfileId = :BCSettings.conversionRepProfileId AND IsActive = true];
	private static list<User> SalesUsersInRR = [SELECT Id, Name FROM User WHERE ProfileId = :BCSettings.conversionRepProfileId AND IsActive = true AND Included_in_Round_Robin__c = 'Included'];
	private static list<User> NonSalesUsers = [SELECT Id, Name FROM User WHERE ProfileId != :BCSettings.conversionRepProfileId AND IsActive = true];
	private static list<User> PartnerManagers = [SELECT Id, Name FROM User WHERE ProfileId = :BCSettings.partnerManagerProfileId AND IsActive = true AND Included_in_Round_Robin__c = 'Included'];
	private static list<User> AcquisitionsRepUsers = [SELECT Id FROM User WHERE ProfileId = :BCSettings.acquisitionRepProfileId AND IsActive = true];
	
    //
     // Check that the Round Robin assigns leads to differnet people
     //
    static testMethod void testRoundRobinLeadAssignemnt() {
        Lead[] RoundRobinLeads = new Lead[]{};
        
        System.runAs(BCSettings.apiUser) {
        
	        for (Integer i = 0; i < 5; i++) {
	        	Lead newLead = new Lead();
	        	newLead.FirstName = 'RoundRobin';
	        	newLead.LastName = 'Test' + i;
	        	newLead.Status = 'Open';
	        	newLead.Company = 'RoundRobinTest' + i;
	        	newLead.Email = 'RoundRobinTest' + i + '@example.com';
	        	
	        	RoundRobinLeads.add(newLead);
	        }
	        
	        Test.startTest();
		        for (Integer i = 0; i < RoundRobinLeads.size(); i++) {
		        	insert RoundRobinLeads[i];
		        }
	        Test.stopTest();
	    }
        
        // Assert!!
        // Check that all the leads went to differernt people in the RR.
        list<Lead> InsertedLeads = [SELECT Id, OwnerId, Lead_Assignment_Method__c FROM Lead WHERE Id In :RoundRobinLeads AND OwnerId IN :SalesUsersInRR];
        set<Id> OwnerIds = new set<Id>();
        for (Lead thisLead : InsertedLeads) {
        	System.assertEquals(thisLead.Lead_Assignment_Method__c, 'Round Robin');
        	if (thisLead.OwnerId != NULL) {
        		OwnerIds.add(thisLead.OwnerId);
        	}
        }
        
		System.assertEquals(OwnerIds.size(), RoundRobinLeads.size());
    }
    
    //
     // Check that the script properly processes bulk actions
     // as separate leads.
     //
    static testMethod void testGroupLeadAssignemnt() {
        Lead[] GroupTestLeads = new Lead[]{};

		System.runAs(BCSettings.apiUser) {
	        for (Integer i = 0; i < 5; i++) {
	        	Lead newLead = new Lead();
	        	newLead.FirstName = 'GroupLeads';
	        	newLead.LastName = 'Test' + i;
	        	newLead.Status = 'Open';
	        	newLead.Company = 'GroupLeadsTest' + i;
	        	newLead.Email = 'GroupLeadsTest' + i + '@example.com';
	        	
	        	GroupTestLeads.add(newLead);
	        }
	        
	        Test.startTest();
	        insert GroupTestLeads;
	        Test.stopTest();
		}
		
        // Assert!!
        // Check that all the leads went to differernt people.
        list<Lead> InsertedLeads = [SELECT Id, OwnerId, Lead_Assignment_Method__c FROM Lead WHERE Id In :GroupTestLeads AND OwnerId IN :SalesUsersInRR];
        set<Id> OwnerIds = new set<Id>();
        for (Lead thisLead : InsertedLeads) {
        	System.assertEquals(thisLead.Lead_Assignment_Method__c, 'Round Robin');
       		if (thisLead.OwnerId != NULL) {
        		OwnerIds.add(thisLead.OwnerId);
        	}
        }

		System.assertEquals(OwnerIds.size(), GroupTestLeads.size());
	}
    
    //
     // Check partner lead assignment
     //
    static testMethod void testPartnerLeadAssignemnt() {
 		System.runAs(BCSettings.apiUser) {
	        // Get a sales person and a non sales person
	    	User salesRep = SalesUsersInRR.get(0);
	    	User nonSalesRep = NonSalesUsers.get(0);
	    	
	    	// Bulkify the tests so that we don't run out of queries
	    	Account[] partners = new Account[]{};
	    	
	        // Create a partner account for each of them
			Account salesRepPartner = new Account();
			salesRepPartner.RecordTypeId = BCSettings.partnerRecordTypeId;
			salesRepPartner.Name = 'Partner Owned by a Rep';
			salesRepPartner.OwnerId = salesRep.Id;
			salesRepPartner.Status__c = 'Open';
			salesRepPartner.iDev_Partner_ID__c = 999999999;
			partners.add(salesRepPartner);

			Account nonSalesRepPartner = new Account();
			nonSalesRepPartner.RecordTypeId = BCSettings.partnerRecordTypeId;
			nonSalesRepPartner.Name = 'Partner Owned by a Non-Rep';
			nonSalesRepPartner.OwnerId = nonSalesRep.Id;
			nonSalesRepPartner.Status__c = 'Open';
			nonSalesRepPartner.Partner_iDevID__c = 'TestPartner2';
			nonSalesRepPartner.iDev_Partner_ID__c = 888888888;
			partners.add(nonSalesRepPartner);
			
			insert partners;
			
	        Test.startTest();

	    	// Bulkify the tests so that we don't run out of queries
	    	Lead[] leads = new Lead[]{};

	        // Create a couple of leads for each partner account
			Lead salesRepLead1 = new Lead();
        	salesRepLead1.FirstName = 'SalesRep';
        	salesRepLead1.LastName = 'Lead1';
        	salesRepLead1.Status = 'Open';
        	salesRepLead1.Company = 'SalesRepLead1';
        	salesRepLead1.Email = 'SalesRepLead1@example.com';
			salesRepLead1.MBA_Partner_ID__c = salesRepPartner.iDev_Partner_ID__c;
			leads.add(salesRepLead1);
						
			Lead salesRepLead2 = new Lead();
        	salesRepLead2.FirstName = 'SalesRep';
        	salesRepLead2.LastName = 'Lead2';
        	salesRepLead2.Status = 'Open';
        	salesRepLead2.Company = 'SalesRepLead2';
        	salesRepLead2.Email = 'SalesRepLead2@example.com';
			salesRepLead2.MBA_Partner_ID__c = salesRepPartner.iDev_Partner_ID__c;
			leads.add(salesRepLead2);
			
			Lead nonSalesRepLead1 = new Lead();
        	nonSalesRepLead1.FirstName = 'NonSalesRep';
        	nonSalesRepLead1.LastName = 'Lead1';
        	nonSalesRepLead1.Status = 'Open';
        	nonSalesRepLead1.Company = 'NonSalesRepLead1';
        	nonSalesRepLead1.Email = 'NonSalesRepLead1@example.com';
			nonSalesRepLead1.MBA_Partner_ID__c = nonSalesRepPartner.iDev_Partner_ID__c;
			leads.add(nonSalesRepLead1);
						
			Lead nonSalesRepLead2 = new Lead();
        	nonSalesRepLead2.FirstName = 'NonSalesRep';
        	nonSalesRepLead2.LastName = 'Lead2';
        	nonSalesRepLead2.Status = 'Open';
        	nonSalesRepLead2.Company = 'NonSalesRepLead2';
        	nonSalesRepLead2.Email = 'NonSalesRepLead2@example.com';
			nonSalesRepLead2.MBA_Partner_ID__c = nonSalesRepPartner.iDev_Partner_ID__c;
			leads.add(nonSalesRepLead2);

			insert leads;

	        Test.stopTest();
			
			// Grab our data back out again. Override the previous lead varialbes with the ones we just got
	        list<String> companyNames = new List<String>();
	        for (Integer i = 1; i < 3; i++) {
	        	companyNames.add('SalesRepLead' + i);
	        	companyNames.add('NonSalesRepLead' + i);
	        }
	        list<Lead> insertedLeads = [SELECT Id, OwnerId, Lead_Assignment_Method__c, Partner_Account__c, Company, Email FROM Lead WHERE Company IN :companyNames];
	        for (Lead thisLead : insertedLeads) {
	        	// Really... Apex doesn't have switch... SIGH!
	        	if (thisLead.Company == 'SalesRepLead1') {
	        		salesRepLead1 = thisLead;
	        	}
	        	else if (thisLead.Company == 'SalesRepLead2') {
	        		salesRepLead2 = thisLead;
	        	}
	        	else if (thisLead.Company == 'NonSalesRepLead1') {
	        		nonSalesRepLead1 = thisLead;
	        	}
	        	else if (thisLead.Company == 'NonSalesRepLead2') {
	        		nonSalesRepLead2 = thisLead;
	        	}
	        }
			
			// Check they were assigned to the correct partner account
			system.assertEquals(nonSalesRepLead1.Partner_Account__c, nonSalesRepPartner.Id);
			system.assertEquals(nonSalesRepLead2.Partner_Account__c, nonSalesRepPartner.Id);
			system.assertEquals(salesRepLead1.Partner_Account__c, salesRepPartner.Id);
			system.assertEquals(salesRepLead2.Partner_Account__c, salesRepPartner.Id);

			// Check they all went to the people who own the main partner account
			system.assertEquals(nonSalesRepLead1.OwnerId, nonSalesRepPartner.OwnerId);
			system.assertEquals(nonSalesRepLead2.OwnerId, nonSalesRepPartner.OwnerId);
			system.assertEquals(salesRepLead1.OwnerId, salesRepPartner.OwnerId);
			system.assertEquals(salesRepLead2.OwnerId, salesRepPartner.OwnerId);

			// Check they were all set to parnter leads
			system.assertEquals(nonSalesRepLead1.Lead_Assignment_Method__c, 'Partner Lead'); 
			system.assertEquals(nonSalesRepLead2.Lead_Assignment_Method__c, 'Partner Lead'); 
			system.assertEquals(salesRepLead1.Lead_Assignment_Method__c, 'Partner Lead'); 
			system.assertEquals(salesRepLead2.Lead_Assignment_Method__c, 'Partner Lead'); 

 		}
    }
    
    //
     // Check that duplicate leads are caught
     //
    static testMethod void testDuplicateLeadChecking() {
 		System.runAs(BCSettings.apiUser) {
	        // Get a sales person and a non sales person
	    	User salesRep = SalesUsersInRR.get(0);
	    	User nonSalesRep = NonSalesUsers.get(0);

			// Bulkify as much as we can...
			Account[] clients = new Account[]{};
	    	Contact[] contacts = new Contact[]{};
			
	        // Create an account and a contact for each of them
			Account salesRepClient = new Account();
			salesRepClient.RecordTypeId = BCSettings.clientRecordTypeId;
			salesRepClient.Name = 'Client Owned by a Rep';
			salesRepClient.OwnerId = salesRep.Id;
			salesRepClient.Status__c = 'Open';
			salesRepClient.Phone = 'NotAPhoneNumber1';
			clients.add(salesRepClient);
	        
	        Contact salesRepContact = new Contact();
			salesRepContact.FirstName = 'Contact';
			salesRepContact.LastName = 'Owned by a Rep';
			salesRepContact.OwnerId = salesRep.Id;
			salesRepContact.AccountId = salesRepClient.Id;
			salesRepContact.Email = 'salesRepContact@example.com';
			salesRepContact.Phone = salesRepClient.Phone;
			contacts.add(salesRepContact);
			
			Account nonSalesRepClient = new Account();
			nonSalesRepClient.RecordTypeId = BCSettings.clientRecordTypeId;
			nonSalesRepClient.Name = 'Client Owned by a Non-Rep';
			nonSalesRepClient.OwnerId = nonSalesRep.Id;
			nonSalesRepClient.Status__c = 'Open';
			nonSalesRepClient.Phone = 'NotAPhoneNumber2';
			clients.add(nonSalesRepClient);
	        
	        Contact nonSalesRepContact = new Contact();
			nonSalesRepContact.FirstName = 'Contact';
			nonSalesRepContact.LastName = 'Owned by a Non-Rep';
			nonSalesRepContact.OwnerId = nonSalesRep.Id;
			nonSalesRepContact.AccountId = nonSalesRepClient.Id;
			nonSalesRepContact.Email = 'nonSalesRepContact@example.com';
			nonSalesRepContact.Phone = nonSalesRepClient.Phone;
			contacts.add(nonSalesRepContact);
			
			insert clients;
			insert contacts;

			// START			
			Test.startTest();
			
			// NOTE: The order of these groups is important to correctly simulate
			// the senarios that each one is meant to simulate.
	    	Lead[] group1 = new Lead[]{};
	    	Lead[] group2 = new Lead[]{};
			
			
			// Create lead 1 + 2 (target to RR)
	        Lead lead1 = new Lead();
        	lead1.FirstName = 'Lead';
        	lead1.LastName = 'One';
        	lead1.Status = 'Open';
        	lead1.Company = 'DupCheckLead1';
			lead1.Phone = 'NotAPhoneNumber3';
        	lead1.Email = 'DupCheckLead1@example.com';
			group1.add(lead1);

	        Lead lead2 = new Lead();
        	lead2.FirstName = 'Lead';
        	lead2.LastName = 'Two';
        	lead2.Status = 'Open';
        	lead2.Company = 'DupCheckLead2';
			lead2.Phone = 'NotAPhoneNumber4';
        	lead2.Email = 'DupCheckLead2@example.com';
			group1.add(lead2);
	        
	        // Create lead 3 (Same email as 1)
	        Lead lead3 = new Lead();
        	lead3.FirstName = 'Lead';
        	lead3.LastName = 'Three';
        	lead3.Status = 'Open';
        	lead3.Company = 'DupCheckLead3';
			lead3.Phone = 'NotAPhoneNumber5';
        	lead3.Email = lead1.Email;
			group2.add(lead3);
	        	        
	        // Create lead 4 (Same phone as 2)
	        Lead lead4 = new Lead();
        	lead4.FirstName = 'Lead';
        	lead4.LastName = 'Four';
        	lead4.Status = 'Open';
        	lead4.Company = 'DupCheckLead4';
			lead4.Phone = lead2.Phone;
        	lead4.Email = 'DupCheckLead4@example.com';
			group2.add(lead4);
	        
	        // Create lead 5 + 6 (Same email as each contact)
	        Lead lead5 = new Lead();
        	lead5.FirstName = 'Lead';
        	lead5.LastName = 'Five';
        	lead5.Status = 'Open';
        	lead5.Company = 'DupCheckLead5';
			lead5.Phone = 'NotAPhoneNumber6';
        	lead5.Email = salesRepContact.Email;
			group1.add(lead5);

	        Lead lead6 = new Lead();
        	lead6.FirstName = 'Lead';
        	lead6.LastName = 'Six';
        	lead6.Status = 'Open';
        	lead6.Company = 'DupCheckLead6';
			lead6.Phone = 'NotAPhoneNumber7';
        	lead6.Email = nonSalesRepContact.Email;
			group1.add(lead6);
	        
	        // Create lead 7 + 8 (Same phone as each account)
	        Lead lead7 = new Lead();
        	lead7.FirstName = 'Lead';
        	lead7.LastName = 'Seven';
        	lead7.Status = 'Open';
        	lead7.Company = 'DupCheckLead7';
			lead7.Phone = salesRepClient.Phone;
        	lead7.Email = 'DupCheckLead7@example.com';
			group1.add(lead7);
	        
	        Lead lead8 = new Lead();
        	lead8.FirstName = 'Lead';
        	lead8.LastName = 'Eight';
        	lead8.Status = 'Open';
        	lead8.Company = 'DupCheckLead8';
			lead8.Phone = nonSalesRepContact.Phone;
        	lead8.Email = 'DupCheckLead8@example.com';
			group1.add(lead8);
	        
	        // Bulk create leads 9 + 10 with same email and lead 11 with different email
	        Lead[] bulkLeads = new Lead[] {};
	        for (Integer i = 9; i < 12; i++) {
	        	Lead thisLead = new Lead();
	        	thisLead.FirstName = 'Lead';
	        	thisLead.LastName = 'Bulk' + i;
	        	thisLead.Status = 'Open';
	        	thisLead.Company = 'DupCheckLead' + i;
	        	if (i == 9) {
					thisLead.Phone = 'NotAPhoneNumber9';
					thisLead.Email = 'DupCheckBulk1@example.com';
	        	}
	        	else if (i == 10) {
					thisLead.Phone = 'NotAPhoneNumber10';
					thisLead.Email = 'DupCheckBulk1@example.com';
	        	}
	        	else {
					thisLead.Phone = 'NotAPhoneNumber11';
					thisLead.Email = 'DupCheckBulk2@example.com';
	        	}
	        	bulkLeads.add(thisLead);
	        }
	        Lead lead9 = new Lead();
	        Lead lead10 = new Lead();
	        Lead lead11 = new Lead();

	        insert group1;
	        insert group2;
	        insert bulkLeads;
	        
	        // END
	        Test.stopTest();
	        
	        // Grab our data back out again. Override the previous lead varialbes with the ones we just got
	        list<String> companyNames = new List<String>();
	        for (Integer i = 1; i < 12; i++) {
	        	companyNames.add('DupCheckLead' + i);
	        }
	        list<Lead> insertedLeads = [SELECT Id, OwnerId, Lead_Assignment_Method__c, Company, Email FROM Lead WHERE Company IN :companyNames];
	        for (Lead thisLead : insertedLeads) {
	        	// Really... Apex doesn't have switch... SIGH!
	        	if (thisLead.Company == 'DupCheckLead1') {
	        		lead1 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead2') {
	        		lead2 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead3') {
	        		lead3 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead4') {
	        		lead4 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead5') {
	        		lead5 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead6') {
	        		lead6 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead7') {
	        		lead7 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead8') {
	        		lead8 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead9') {
	        		lead9 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead10') {
	        		lead10 = thisLead;
	        	}
	        	else if (thisLead.Company == 'DupCheckLead11') {
	        		lead11 = thisLead;
	        	}
	        }
	        
	        
	        // Assert that:
	        
	        // 1 + 2 not owned by same person and were assigned by RR
	        system.assertEquals(idBelongsToRep(lead1.OwnerId), true);
	        system.assertEquals(idBelongsToRep(lead2.OwnerId), true);
	        system.assertNotEquals(lead1.OwnerId, lead2.OwnerId);
	        system.assertEquals(lead1.Lead_Assignment_Method__c, 'Round Robin');
	        system.assertEquals(lead2.Lead_Assignment_Method__c, 'Round Robin');
	        
	        // 3 owned by same person as 1 and assigned by Same as existing lead (email)
	        system.assertEquals(lead1.OwnerId, lead3.OwnerId);
	        system.assertEquals(lead3.Lead_Assignment_Method__c, 'Same as existing lead (email)');
	        	        
	        // 4 owned by same person as 2 and assigned by Same as existing lead (phone)
	        system.assertEquals(lead2.OwnerId, lead4.OwnerId);
	        system.assertEquals(lead4.Lead_Assignment_Method__c, 'Same as existing lead (phone)');

	        // 5 owned by same sales rep as contact and assigned by Same as existing contact (email)
	        system.assertEquals(lead5.OwnerId, salesRepContact.OwnerId);
	        system.assertEquals(lead5.Lead_Assignment_Method__c, 'Same as existing contact (email)');
	              
	        // 6 owned by a sales guy and assigned by RR (didn't assign to non-sales guy)
	        system.assertEquals(idBelongsToRep(lead6.OwnerId), true);
	        system.assertEquals(lead6.Lead_Assignment_Method__c, 'Round Robin');
	        
	        // 7 owned by same sales rep as account and assigned by Same as existing account (phone)
	        system.assertEquals(lead7.OwnerId, salesRepClient.OwnerId);
	        system.assertEquals(lead7.Lead_Assignment_Method__c, 'Same as existing account (phone)');
	                
	        // 8 owned by a sales guy and assigned by RR (didn't assign to non-sales guy)
	        system.assertEquals(idBelongsToRep(lead8.OwnerId), true);
	        system.assertEquals(lead8.Lead_Assignment_Method__c, 'Round Robin');
	        
	        // 9 + 10 are owned by the same person and assigned by RR
	        system.assertEquals(idBelongsToRep(lead9.OwnerId), true);
	        system.assertEquals(lead9.OwnerId, lead10.OwnerId);
	        system.assertEquals(lead9.Lead_Assignment_Method__c, 'Round Robin');
	        system.assertEquals(lead10.Lead_Assignment_Method__c, 'Round Robin');
        
	        // 11 is owned by a different person than 9 + 10 and assigned by RR
	        system.assertNotEquals(lead11.OwnerId, lead10.OwnerId);
	        system.assertEquals(lead10.Lead_Assignment_Method__c, 'Round Robin');
 		}
    }
    

    //
     // Check that leads are being routed to the acquisitions team where appropriate.
     //
    static testMethod void testAcquisitionsLeadChecking() {
 		System.runAs(BCSettings.apiUser) {
			// check we have an acquisitions rep
	    	if (AcquisitionsRepUsers.isEmpty()) {
				User u = new User();
				u.FirstName = 'Joe';
				u.LastName = 'The Acquisitions Rep';
				u.Email = 'JoeTheAcquisitionsRep@example.com';
				u.Username='JoeTheAcquisitionsRep@example.com';
				u.ProfileId = BCSettings.acquisitionRepProfileId;
				u.alias = 'joea';
				u.TimeZoneSidKey = 'America/Mexico_City';
				u.LocaleSidKey = 'en_US';
				u.EmailEncodingKey = 'ISO-8859-1';
				u.LanguageLocaleKey = 'en_US';
				insert u;
          		AcquisitionsRepUsers = [SELECT Id FROM User WHERE ProfileId = :BCSettings.acquisitionRepProfileId AND IsActive = true];
	    	}

	        // Get a sales person and an acquisitions sales person
	    	User salesRep = SalesUsersInRR.get(0);
    		User acquisitionsRep = AcquisitionsRepUsers.get(0);

	    	// Bulkify the tests so that we don't run out of queries
	    	Lead[] leads = new Lead[]{};

	        // Create a Lead for each of the users
			Lead salesRepLead1 = new Lead();
        	salesRepLead1.FirstName = 'SalesRep';
        	salesRepLead1.LastName = 'Lead1';
        	salesRepLead1.Status = 'Open';
        	salesRepLead1.Company = 'SalesRepLead1';
        	salesRepLead1.Email = 'SalesRepLeadNotAcquisitions@example.com';
        	salesRepLead1.Phone = '951753852';
        	salesRepLead1.OwnerId = salesRep.Id;
			leads.add(salesRepLead1);
			
			Lead acquisitionsRepLead1 = new Lead();
        	acquisitionsRepLead1.FirstName = 'AcquisitionsRep';
        	acquisitionsRepLead1.LastName = 'Lead1';
        	acquisitionsRepLead1.Status = 'Open';
        	acquisitionsRepLead1.Lead_Type__c = 'Acquisition';
        	acquisitionsRepLead1.Company = 'AcquisitionsRepLead1';
        	acquisitionsRepLead1.Email = 'AcquisitionsLeadNotSalesRep@example.com';
        	acquisitionsRepLead1.Phone = '987456132';
        	acquisitionsRepLead1.OwnerId = acquisitionsRep.Id;
			leads.add(acquisitionsRepLead1);

			insert leads;
			
			// Start the test
			Test.startTest();
			
	    	Lead[] testLeads = new Lead[]{};

			Lead salesRepLead2 = new Lead();
        	salesRepLead2.FirstName = 'SalesRep';
        	salesRepLead2.LastName = 'Lead2';
        	salesRepLead2.Status = 'Open';
        	salesRepLead2.Company = 'SalesRepLead2';
        	salesRepLead2.Email = 'SalesRepLeadNotAcquisitions@example.com';
			testLeads.add(salesRepLead2);
			
			Lead acquisitionsRepLead2 = new Lead();
        	acquisitionsRepLead2.FirstName = 'AcquisitionsRep';
        	acquisitionsRepLead2.LastName = 'Lead2';
        	acquisitionsRepLead2.Status = 'Open';
        	acquisitionsRepLead2.Company = 'AcquisitionsRepLead1';
        	acquisitionsRepLead2.Email = 'AcquisitionsLeadNotSalesRep@example.com';
			testLeads.add(acquisitionsRepLead2);
			
			Lead acquisitionsRepLead3 = new Lead();
        	acquisitionsRepLead3.FirstName = 'AcquisitionsRep';
        	acquisitionsRepLead3.LastName = 'Lead3';
        	acquisitionsRepLead3.Status = 'Open';
        	acquisitionsRepLead3.Company = 'AcquisitionsRepLead3';
        	acquisitionsRepLead3.Email = 'NoonesEmail@example.com';
        	acquisitionsRepLead3.Phone = '987456132';
        	testLeads.add(acquisitionsRepLead3);
			
			insert testLeads;

	        // END
	        Test.stopTest();

	        list<Lead> InsertedLeads = [SELECT Id, OwnerId, Lead_Assignment_Method__c, Email FROM Lead WHERE Id IN :testLeads];
	        for (Lead thisLead : InsertedLeads) {
	        	if(thisLead.Email == 'SalesRepLeadNotAcquisitions@example.com') {
	        		system.assertEquals(salesRep.Id, thisLead.OwnerId);
	        		system.assertEquals('Same as existing lead (email)', thisLead.Lead_Assignment_Method__c);
	        	}
	        	else if(thisLead.Email == 'AcquisitionsLeadNotSalesRep@example.com') {
	        		system.assertEquals(acquisitionsRep.Id, thisLead.OwnerId);
	        		system.assertEquals('Acquisition team lead (email)', thisLead.Lead_Assignment_Method__c);
	        	}
	        	else if(thisLead.Email == 'NoonesEmail@example.com') {
	        		system.assertEquals(acquisitionsRep.Id, thisLead.OwnerId);
	        		system.assertEquals('Acquisition team lead (phone)', thisLead.Lead_Assignment_Method__c);
	        	}
	        }
 		}
    }

    //
     // Check bulk processing
     // This doesn't really need an assert. It's just to check that we're not going
     // over the govenor limits.
     //
    static testMethod void testBulkProcessing() {
        Lead[] LotsaLeads = new Lead[]{};
        for (Integer i = 0; i < 200; i++) {
        	Lead newLead = new Lead();
        	newLead.FirstName = 'BulkProcessing';
        	newLead.LastName = 'Test' + i;
        	newLead.Status = 'Open';
        	newLead.Company = 'BulkProcessingTest' + i;
        	newLead.Email = 'BulkProcessingTest' + i + '@example.com';
        	
        	LotsaLeads.add(newLead);
        }
        
        Test.startTest();
        insert LotsaLeads;
        Test.stopTest();
    }
    
    
    
    //
     // Utility function to tell you if an ID belongs to an in-RR sales person
     //
    private static Boolean idBelongsToRep(Id theId) {
    	Boolean belongsToRep = false;
        for (User thisRep : SalesUsersInRR) {
        	if (theId == thisRep.Id) {
        		belongsToRep = true;
        		break;
        	}
        }
    	return belongsToRep;
    }
    
    private static Boolean idBelongsToPartnerManager(Id theId) {
    	Boolean belongsToRep = false;
        for (User thisRep : PartnerManagers) {
        	if (theId == thisRep.Id) {
        		belongsToRep = true;
        		break;
        	}
        }
    	return belongsToRep;
    }
   */   
}