/**
 * This class contains unit tests for validating the behavior of the partner approval process
 */
@isTest
private class AccountApprovePartnerTests {

    static testMethod void testApprovals() {
		// Create a partner that will pass approval
		Account goodPartner = new Account();
		goodPartner.RecordTypeId = BCSettings.partnerRecordTypeId;
		goodPartner.Name = 'ToBe Approved';
		goodPartner.Status__c = 'Pending';
		goodPartner.Type = 'Partner';
		insert goodPartner;

        Contact goodContact = new Contact();
		goodContact.FirstName = 'Contact';
		goodContact.LastName = 'ToBe Approved';
		goodContact.AccountId = goodPartner.Id;
		goodContact.Email = 'goodContact@example.com';
		goodContact.Phone = 'Notanumbers';
		insert goodContact;

		// Create a partner that will fail approval
		Account badPartner = new Account();
		badPartner.RecordTypeId = BCSettings.partnerRecordTypeId;
		badPartner.Name = 'mitch';
		badPartner.Status__c = 'Pending';
		badPartner.Type = 'Partner';
		insert badPartner;
		
        Contact badContact = new Contact();
		badContact.FirstName = 'Contact';
		badContact.LastName = 'ToFail Approved';
		badContact.AccountId = badPartner.Id;
		badContact.Email = 'baddContact@example.com';
		badContact.Phone = 'Notanumberstoo';
		insert badContact;

		// Check that the good one passes
		ApexPages.StandardController standardController = new ApexPages.StandardController(goodPartner); 
		AccountApprovePartner controller = new AccountApprovePartner(standardController);
		controller.ApprovePartner();
		goodPartner = [SELECT Status__c, Partner_iDevID__c, iDev_Partner_ID__c FROM Account WHERE Id = :goodPartner.Id LIMIT 1];
		// Partner_iDevID__c and iDev_Partner_ID__c should be set by our fake response
		system.assertEquals(goodPartner.Partner_iDevID__c, 'ToBeApproved');
		system.assertEquals(goodPartner.iDev_Partner_ID__c, 999999999);
		// The status should be open.
		system.assertEquals(goodPartner.Status__c, 'Onboarding');
		
		// Check that the bad one fails
		standardController = new ApexPages.StandardController(badPartner); 
		controller = new AccountApprovePartner(standardController);
		controller.account.Partner_iDevID__c = 'mitch';
		controller.ApprovePartner();
		badPartner = [SELECT Status__c, Partner_iDevID__c FROM Account WHERE Id = :badPartner.Id LIMIT 1];
		// Error should be set
		
		// Partner_iDevID__c should not be set
		system.assertEquals(badPartner.Partner_iDevID__c, NULL);
		// The status should be pending.
		system.assertEquals(badPartner.Status__c, 'Pending');
	}
}