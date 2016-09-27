@isTest(seeAllData=true) 
public class TestSubscription_Utility
{	
	static testMethod void testSubNewLeadToConvert() 
	{
		// Variables to use in testing
		MBA_Staging_Account__c objMBAAcct;
		MBA_Staging_Subscription__c objMBASub;
		MBA_Staging_Contact__c objMBAContact;
		Subscription__c objSub;
		
		// Start Test
		test.startTest();
			
		// Create Test Data
		TestDataGenerator td = new TestDataGenerator();
		
		// Initialize the Custom Setting Map   
		td.getStagingToTableMappingSettings();
		
		// Create Staging Account records as not Paid and grab one of them
		td.getAccountMBAs(true, false);
		objMBAAcct = td.AccountMBAs[0];		
		
		// Create Staging Contact records as not Paid
		td.getContactMBAs(true, false);
		objMBAContact = td.ContactMBAs[0];
		
		// Create Staging Subscription records as trial, but do NOT save yet; then grab one of them
		td.getStagingSubscriptions(false, true, objMBAAcct.MBAAccountID__c, 9898119);
		objMBASub = td.lstStagingSubscriptions[0];
			
		// Now save just one of the staging subscriptions
		insert objMBASub;
			
		// Capture the Subscription that should have just been created
		objSub = [SELECT Id, IsTrial__c, MBAAccountID__c, Lead__c, Account__c 
					FROM Subscription__c 
					WHERE MBAAccountID__c = :objMBASub.MBAAccountID__c];
		
		// Validate that actual subscriptions was created and associated to a lead
		system.assertNotEquals(objSub, null);
		system.assertNotEquals(objSub.Account__c, null);
		
		// Now create a new sub as paid
		objMBASub = new MBA_Staging_Subscription__c();
		objMBASub = td.lstStagingSubscriptions[1];
		objMBASub.MBAAccountID__c = objSub.MBAAccountID__c;
		objMBASub.IsTrial__c = false;		
		insert objMBASub;
		
		test.stopTest();    
	}
	
	static testMethod void testSubNewLeadByEmail() 
	{
		// Variables to use in testing
		MBA_Staging_Account__c objMBAAcct;
		MBA_Staging_Subscription__c objMBASub;
		MBA_Staging_Contact__c objMBAContact;
		Subscription__c objSub;
		Id leadId;
		
		// Create Test Data
		TestDataGenerator td = new TestDataGenerator();
		
		// Initialize the Custom Setting Map    
		td.getStagingToTableMappingSettings();
		
		// Create Staging Account records as not Paid and grab one of them
		td.getAccountMBAs(true, false);
		objMBAAcct = td.AccountMBAs[0];		
		
		// Create Staging Contact records as not Paid
		td.getContactMBAs(true, false);
		objMBAContact = td.ContactMBAs[0];
		
		// Create Staging Subscription records as trial and save one of them
		td.getStagingSubscriptions(false, true, objMBAAcct.MBAAccountID__c, 9898119);
		objMBASub = td.lstStagingSubscriptions[0];
		
		// Create a lead using the data from the MBA Account, MBA Contact
		Lead objLead = new Lead();
		objLead.FirstName = objMBAContact.FirstName__c;
		objLead.LastName = objMBAContact.LastName__c;
		objLead.Company = objMBAAcct.CompanyName__c;
		objLead.Email = objMBAContact.Email__c;
		
		insert objLead;
			
		// Start Test
		test.startTest();
		
		// Insert the new staging subscription
		insert objMBASub;
		
		test.stopTest();
								
		// Now query the new subscription
		objSub = [SELECT Id, IsTrial__c, MBAAccountID__c, Lead__c, Account__c 
					FROM Subscription__c 
					WHERE MBAAccountID__c = :objMBASub.MBAAccountID__c];

		// Validate that actual subscriptions was created and associated to the lead previously created
		system.assertNotEquals(objSub, null);
		
		// Now query the Lead to ensure it has been updated with a MBA Account ID
		Lead oLead = [SELECT Id, Name, MBAAccountID__c
					FROM Lead
					WHERE Id = :objLead.Id];
		
		system.assertNotEquals(oLead.MBAAccountID__c, null);
	}
	
	static testMethod void testSubNewAccount() 
	{
		// Variables to use in testing
		MBA_Staging_Account__c objMBAAcct;
		MBA_Staging_Subscription__c objMBASub;
		MBA_Staging_Contact__c objMBAContact;
		Subscription__c objSub;
		Id acctId;
		
		// Create Test Data
		TestDataGenerator td = new TestDataGenerator();
		
		// Initialize the Custom Setting Map    
		td.getStagingToTableMappingSettings();
		
		// Create Staging Account records as not Paid and grab one of them
		td.getAccountMBAs(true, false);
		objMBAAcct = td.AccountMBAs[0];	
		
		// Create Staging Contact records as not Paid
		td.getContactMBAs(true, false);
				
		// Create Staging Subscription records as paid
		td.getStagingSubscriptions(false, false, objMBAAcct.MBAAccountID__c, 9898119);
		objMBASub = td.lstStagingSubscriptions[0];
		
		// Start Test
		test.startTest();
		
		insert objMBASub;
		
		// Capture the Subscription that should have just been created
		objSub = [SELECT Id, IsTrial__c, MBAAccountID__c, Lead__c, Account__c, RecordTypeId, MBASubscriptionID__c
					FROM Subscription__c 
					WHERE MBAAccountID__c = :objMBASub.MBAAccountID__c];
		
		// Ensure an account id exists on the sub
		system.assertNotEquals(null, objSub.Account__c);
				
		acctId = objSub.Account__c;
		
		// Now capture the Account that was just created
		Account objAcct = [SELECT Id, Name, MBAAccountID__c, OwnerId
							FROM Account
							WHERE Id = :acctId];
							
		system.assertEquals(objAcct.MBAAccountID__c, objSub.MBAAccountID__c);
				
		Profile p = [SELECT Name, Id 
					FROM Profile  
					WHERE Name = 'System Administrator'];
		
		User usr = td.getUser(p, 'thisisunique');
		insert usr;
		
		// Grab a different account
		td.getAccounts(false);
		Account objAcctPartner = td.accounts[0];
		
		// Set the partner id on the account, and make the owner someone other than the running user
		objAcctPartner.iDev_Partner_ID__c = 55445599;
		objAcctPartner.OwnerID = usr.Id;		
		insert objAcctPartner;
		
		// Now insert a new subscription with the same partner id
		Subscription__c objSub2 = new Subscription__c();
		objSub2.RecordTypeId = objSub.RecordTypeId;
		objSub2.Account__c = null;
		objSub2.Lead__c = null;
		objSub2.MBAPartnerID__c = string.valueOf(objAcctPartner.iDev_Partner_ID__c);
		objSub2.MBASubscriptionID__c = objSub.MBASubscriptionID__c + '-99';
		objSub2.MBAAccountID__c = objAcct.MBAAccountID__c;
		
		insert objSub2;
		
		test.stopTest();
		 
		// Capture the Subscription that should have just been created
		Subscription__c objSub2_Res = [SELECT Id, IsTrial__c, MBAAccountID__c, Lead__c, Account__c, MBASubscriptionID__c, OwnerId
										FROM Subscription__c 
										WHERE Id = :objSub2.Id];
		
		system.debug('*** New Sub for Ownershipt Check: ' + objSub2_Res);
		system.debug('*** Expected Account Id: ' + objAcct.Id);
			
	}
}