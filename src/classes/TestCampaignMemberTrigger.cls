@isTest
private class TestCampaignMemberTrigger {
	
	@isTest static void test_method_one() {
		// create setup objects
		List<Lead> leads = TestDataFactory.createTestLeads(1, false, TestDataFactory.LeadRecordType.Client_Prospect);
		List<Account> accounts = TestDataFactory.createTestAccounts(1, false, TestDataFactory.AccountRecordType.Client_Record_Type);
		List<Contact> contacts = TestDataFactory.createTestContacts(1, accounts);
		List<Opportunity> opportunities = TestDataFactory.createTestOpportunities(1, accounts, TestDataFactory.OpportunityRecordType.Trial);

		List<Contact> contactWithoutAccount = TestDataFactory.createTestContacts(1, null);


		// create campaign members
		List<Campaign> cmpgns = TestDataFactory.createTestCampaigns(1);
		for (Campaign c : cmpgns)
		{
			c.Name += ' DEMO REQUEST';
		}

		List<CampaignMember> cmpgnMemberLead = TestDataFactory.createTestCampaignMembers(cmpgns, true, leads);
		List<CampaignMember> cmpgnMemberContact = TestDataFactory.createTestCampaignMembers(cmpgns, true, contacts);
		List<CampaignMember> cmpgnMemberContactNoAccount = TestDataFactory.createTestCampaignMembers(cmpgns, true, contactWithoutAccount);

	}
}