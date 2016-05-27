/**
 * This class contains unit tests for validating the Account triggers and 
 * other functionality.
 */
@isTest
private class AccountTests {
	/*
	private static list<User> AllPartnerManagers = [SELECT Id, Included_in_Round_Robin__c FROM User WHERE ProfileId = :BCSettings.partnerManagerProfileId AND IsActive = true ORDER BY Id];
	private static list<User> SomeUsers = [SELECT Id, Name FROM User WHERE ProfileId != :BCSettings.partnerManagerProfileId AND IsActive = true LIMIT 5];

	private static Account partner1, partner2;
	
    static testMethod void partnerRequestRoutingTest() {
		// Set up our accounts
		Account account1 = new Account();
		Account account2 = new Account();
		Account account3 = new Account();
		Account account4 = new Account();
		Account account5 = new Account();
		list<Account> allAccounts = new list<Account>();
		list<String> accountNames = new list<String>();

        // Switch to some user. Don't care who.
        User theUser = SomeUsers.get(0);
        System.runAs(theUser) {
        	// 1 create a non-partner (as a user)
        	account1.Name = 'Partner Test Account 1';
        	account1.Phone = 'NotAPhoneNumber1';
        	account1.RecordTypeId = BCSettings.clientRecordTypeId;
        	account1.Status__c = 'Pending';
        	insert account1;
        	allAccounts.add(account1);
	        accountNames.add(account1.Name);
	        
	        // 2 create a partner (as a user)
        	account2.Name = 'Partner Test Account 2';
        	account2.Phone = 'NotAPhoneNumber2';
        	account2.RecordTypeId = BCSettings.partnerRecordTypeId;
        	account2.Status__c = 'Pending';
        	insert account2;
        	allAccounts.add(account2);
	        accountNames.add(account2.Name);
	        
	        // Create a partner that won't work
	        Account openPartnerTest = new Account();
	        openPartnerTest.Name = 'Partner Test Account Open';
        	openPartnerTest.Phone = 'NotAPhoneNumberOpen';
        	openPartnerTest.RecordTypeId = BCSettings.partnerRecordTypeId;
        	openPartnerTest.Status__c = 'Open';
	
	 	    Boolean wasAnError = false;
            try {
	    		insert openPartnerTest;
	        }
	        catch(Exception e) {
	        	wasAnError = true;
	        }
	        system.assertEquals(wasAnError, true);
	    }

        // switch to API user
        System.runAs(BCSettings.apiUser) {
			Account[] apiAccounts = new Account[]{};

	        // 3 create a non-partner
        	account3.Name = 'Partner Test Account 3';
        	account3.Phone = 'NotAPhoneNumber3';
        	account3.RecordTypeId = BCSettings.clientRecordTypeId;
        	account3.Status__c = 'Pending';
        	apiAccounts.add(account3);
        	allAccounts.add(account3);
	        accountNames.add(account3.Name);
	        
	        // 4 create a partner
        	account4.Name = 'Partner Test Account 4';
        	account4.Phone = 'NotAPhoneNumber4';
        	account4.RecordTypeId = BCSettings.partnerRecordTypeId;
        	account4.Status__c = 'Pending';
        	apiAccounts.add(account4);
        	allAccounts.add(account4);
	        accountNames.add(account4.Name);
	        
	        // 5 create a partner with status 'Open'
        	account5.Name = 'Partner Test Account 5';
        	account5.Phone = 'NotAPhoneNumber5';
        	account5.RecordTypeId = BCSettings.partnerRecordTypeId;
        	account5.Status__c = 'Open';
        	apiAccounts.add(account5);
        	allAccounts.add(account5);
	        accountNames.add(account5.Name);
	        
        	insert apiAccounts;
        }
        
        // get out the accounts we just added
        allAccounts = [SELECT Id, Name, Phone, RecordTypeId, Status__c, OwnerId FROM Account WHERE Name IN :accountNames];
        for (Account thisAccount : allAccounts) {
        	if (thisAccount.Name == 'Partner Test Account 1') {
        		account1 = thisAccount;
        	} else if (thisAccount.Name == 'Partner Test Account 2') {
        		account2 = thisAccount;
        	} else if (thisAccount.Name == 'Partner Test Account 3') {
        		account3 = thisAccount;
        	} else if (thisAccount.Name == 'Partner Test Account 4') {
        		account4 = thisAccount;
        	} else if (thisAccount.Name == 'Partner Test Account 5') {
        		account5 = thisAccount;
        	} 
        }
        
        // check that
        // - 1 + 2 are assigned to the user that created them
        system.assertEquals(account1.OwnerId, theUser.Id);
        system.assertEquals(account2.OwnerId, theUser.Id);
        
        // - 3 is assigned to API user (Look into this. We don't want to have things owned by the API user if we can help it)
        system.assertEquals(account3.OwnerId, BCSettings.apiUser.Id);
        
        // - 4 + 5 are both assigned to partner reps
        system.assertEquals(idBelongsToPartnerManager(account4.OwnerId), true);
        system.assertEquals(idBelongsToPartnerManager(account5.OwnerId), true);

        // - 5 has the status 'Pending'
        system.assertEquals(account5.Status__c, 'Pending');
        
        // Update 5 to have status 'Open' and check it causes an error.
	    Boolean wasAnError = false;
        account5.Name = 'Partner Test Account 5 Updated';
        account5.Status__c = 'Open';
        try {
        	update account5;
        }
        catch(Exception e) {
        	wasAnError = true;
        }
        system.assertEquals(wasAnError, true);
    }
    
    //
    // Check that accounts with a partner ID are being associated with the correct partner account
    // and routed to the correct person.
    //
    static testMethod void partnerMappingAndRoutingTest() {
    	SetUpPartnerAccounts();
    	
    	System.runAs(BCSettings.apiUser) {
    		Test.startTest();

			List<Account> newAccounts = new List<Account>();
			
	    	// Routes to partner 2
	    	Account client1 = new Account();
	    	client1.Name = 'Client Test Account 1';
	    	client1.Phone = 'NotAPhoneNumber1';
	    	client1.RecordTypeId = BCSettings.clientRecordTypeId;
	    	client1.MBA_Partner_ID__c = partner2.iDev_Partner_ID__c;
	    	newAccounts.add(client1);

	    	// Routes to partner 1
	    	Account client2 = new Account();
	    	client2.Name = 'Client Test Account 2';
	    	client2.Phone = 'NotAPhoneNumber2';
	    	client2.RecordTypeId = BCSettings.clientRecordTypeId;
	    	client2.MBA_Partner_ID__c = partner1.iDev_Partner_ID__c;
	    	newAccounts.add(client2);

	    	// No valid partner
	    	Account client3 = new Account();
	    	client3.Name = 'Client Test Account 3';
	    	client3.Phone = 'NotAPhoneNumber3';
	    	client3.RecordTypeId = BCSettings.clientRecordTypeId;
	    	client3.MBA_Partner_ID__c = 777777;
	    	newAccounts.add(client3);

	    	insert newAccounts;
    		
    		Test.stopTest();
    		
    		// Get the automatically assigned data out to check.
    		list<String> clientNames = new List<String>();
    		for (Integer i = 1; i < 3; i++) {
    			clientNames.add('Client Test Account ' + i);
    		}
    		
    		list<Account> insertedAccounts = [SELECT Id, Name, RecordTypeId, MBA_Partner_id__c, Partner_Account__c, OwnerId FROM Account WHERE Name IN :clientNames];
    		
    		for(Account thisAccount : insertedAccounts) {
    			
    			system.assertEquals(thisAccount.RecordTypeId, BCSettings.clientRecordTypeId);
    			
    			if (thisAccount.Name == 'Client Test Account 1') {
    				system.assertEquals(thisAccount.MBA_Partner_id__c, partner2.iDev_Partner_ID__c);
    				system.assertEquals(thisAccount.Partner_Account__c, partner2.Id);
    				system.assertEquals(thisAccount.OwnerId, partner2.OwnerId);
    			}
    			else if (thisAccount.Name == 'Client Test Account 2') {
     				system.assertEquals(thisAccount.MBA_Partner_id__c, partner1.iDev_Partner_ID__c);
    				system.assertEquals(thisAccount.Partner_Account__c, partner1.Id);
    				system.assertEquals(thisAccount.OwnerId, partner1.OwnerId);
    			}
    			else if (thisAccount.Name == 'Client Test Account 3') {
     				system.assertEquals(thisAccount.MBA_Partner_id__c, client3.MBA_Partner_id__c);
    				system.assertEquals(thisAccount.Partner_Account__c, null);
    			}
    		}
    	}
    }
    
    //
    // Confirm that accounts are owned by the same person who owned the lead after conversion.
    //
    static testMethod void checkAccountOwnership() {
  		System.runAs(BCSettings.apiUser) {
	    	
	    	SetUpPartnerAccounts();
	    	
	 	   	// Bulkify the tests so that we don't run out of queries
		   	Lead[] leads = new Lead[]{};
	 
	    	// Create some leads
			Lead convertLeadTest1 = new Lead();
	    	convertLeadTest1.FirstName = 'convertLeadTest1';
	    	convertLeadTest1.LastName = 'Lead1';
	    	convertLeadTest1.Status = 'Open';
	    	convertLeadTest1.Company = 'convertLeadTest1';
	    	convertLeadTest1.Email = 'convertLeadTest1@example.com';
			leads.add(convertLeadTest1);
						
			Lead convertLeadTest2 = new Lead();
	    	convertLeadTest2.FirstName = 'convertLeadTest2';
	    	convertLeadTest2.LastName = 'Lead2';
	    	convertLeadTest2.Status = 'Open';
	    	convertLeadTest2.Company = 'convertLeadTest2';
	    	convertLeadTest2.Email = 'convertLeadTest2@example.com';
			convertLeadTest2.MBA_Partner_ID__c = partner1.iDev_Partner_ID__c;
			leads.add(convertLeadTest2);
			
			Lead convertLeadTest3 = new Lead();
	    	convertLeadTest3.FirstName = 'convertLeadTest3';
	    	convertLeadTest3.LastName = 'Lead3';
	    	convertLeadTest3.Status = 'Open';
	    	convertLeadTest3.Company = 'convertLeadTest3';
	    	convertLeadTest3.Email = 'convertLeadTest3@example.com';
			convertLeadTest3.MBA_Partner_ID__c = partner2.iDev_Partner_ID__c;
			leads.add(convertLeadTest3);
	    	
	    	insert leads;
	    	
	    	// Get out all the autmatic assingment data.
	    	List<string> companies = new List<string>();
	    	for (Lead thisLead : leads) {
	    		companies.add(thisLead.Company);
	    	}
	    	
	    	Lead lead1, lead2, lead3;
	    	
	    	leads = [SELECT Id, OwnerId, MBA_Partner_ID__c, Partner_Account__c, Company FROM Lead WHERE Company IN :companies];
	    	Id originalOwnerId1, originalOwnerId2, originalOwnerId3;
	    	for (Lead thisLead : leads) {
	    		if (thisLead.Company == convertLeadTest1.Company) {
	    			lead1 = thisLead;
	    			originalOwnerId1 = thisLead.OwnerId;
	    		}
	    		else if (thisLead.Company == convertLeadTest2.Company) {
	    			lead2 = thisLead;
	    			originalOwnerId2 = thisLead.OwnerId;
	    		}
	    		else if (thisLead.Company == convertLeadTest3.Company) {
	    			lead3 = thisLead;
	    			originalOwnerId3 = thisLead.OwnerId;
	    		}
	    	}
	    	
	    	// Check they routed correctly to start with
	    	system.assertEquals(lead2.OwnerId, partner1.OwnerId);
	    	system.assertEquals(lead3.OwnerId, partner2.OwnerId);

			Test.StartTest();
			
	    	// Convert them.
	    	for (Lead thisLead : leads) {
				Database.LeadConvert lc = new database.LeadConvert();
				lc.setLeadId(thisLead.Id);
				
				LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
				lc.setConvertedStatus(convertStatus.MasterLabel);
				
				Database.LeadConvertResult lcr = Database.convertLead(lc);
				system.assert(lcr.isSuccess());	    		
	    	}
	    	
	    	Test.StopTest();
	    	
	    	List<Account> createdAccounts = [SELECT Id, OwnerId, MBA_Partner_ID__c, Partner_Account__c, Name, RecordTypeId FROM Account WHERE Name IN :companies];
	    	
	    	system.assert((createdAccounts.size() == 3));
	    	
	    	// Check the new owners are correct.
	    	for (Account thisAccount : createdAccounts) {
	    		if (thisAccount.Name == lead1.Company) {
	    			system.assertEquals(thisAccount.OwnerId, originalOwnerId1);
	    			system.assertEquals(thisAccount.OwnerId, lead1.OwnerId);
	    		}
	    		else if (thisAccount.Name == lead2.Company) {
	    			system.assertNotEquals(thisAccount.RecordTypeId, BCSettings.partnerRecordTypeId);
	    			system.assertEquals(thisAccount.OwnerId, originalOwnerId2);
	    			system.assertEquals(thisAccount.OwnerId, partner1.OwnerId);
	    			system.assertEquals(thisAccount.OwnerId, lead2.OwnerId);
	    		}
	    		else if (thisAccount.Name == lead3.Company) {
	    			system.assertEquals(thisAccount.OwnerId, originalOwnerId3);
	    			system.assertEquals(thisAccount.OwnerId, partner2.OwnerId);
	    			system.assertEquals(thisAccount.OwnerId, lead3.OwnerId);
	    		}
	    	}
  		}
  		
    }
    
    private static Boolean idBelongsToPartnerManager(Id theId) {
    	Boolean belongsToPM = false;
        for (User thisPM : AllPartnerManagers) {
        	if (theId == thisPM.Id) {
        		belongsToPM = true;
        		break;
        	}
        }
    	return belongsToPM;
    }
    
    private static Double partnerAccountItteration = 0;
    private static void SetUpPartnerAccounts() {
 		System.runAs(BCSettings.apiUser) {
	        Account insert1 = new Account();
	    	insert1.Name = 'Partner Test Account 1-' + partnerAccountItteration;
	    	insert1.OwnerId = AllPartnerManagers[0].Id;
	    	insert1.Phone = 'NotAPhoneNumber1';
	    	insert1.RecordTypeId = BCSettings.partnerRecordTypeId;
	    	insert1.iDev_Partner_ID__c = 1000000000 + partnerAccountItteration;
	    	insert1.Partner_iDevID__c = 'partner1';
	    	insert1.Status__c = 'Open';
	    	insert insert1;
	    	
	    	partner1 = [SELECT Id, Name, OwnerId, Phone, RecordTypeId, iDev_Partner_ID__c, Partner_iDevID__c, Status__c FROM Account WHERE Name = :insert1.Name LIMIT 1];
	 
	     	Account insert2 = new Account();
	    	insert2.Name = 'Partner Test Account 2-' + partnerAccountItteration;
	    	insert2.OwnerId = AllPartnerManagers[1].Id;
	    	insert2.Phone = 'NotAPhoneNumber2';
	    	insert2.RecordTypeId = BCSettings.partnerRecordTypeId;
	    	insert2.iDev_Partner_ID__c = 2000000000 + partnerAccountItteration;
	    	insert2.Partner_iDevID__c = 'partner2';
	    	insert2.Status__c = 'Open';
	    	insert insert2;

	    	partner2 = [SELECT Id, Name, OwnerId, Phone, RecordTypeId, iDev_Partner_ID__c, Partner_iDevID__c, Status__c FROM Account WHERE Name = :insert2.Name LIMIT 1];
	    }
	    
	    partnerAccountItteration++;
    }
    */
}