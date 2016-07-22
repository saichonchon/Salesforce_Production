/**
 * TestBatchSubscriptionCleanup
 * Author: Steve O'Neal
 * Date: 7/14/2016
 * Purpose: To test BatchSubscriptionCleanup and BatchSubscriptionCleanupScheduler
 */
@isTest
private class TestBatchSubscriptionCleanup {
	
	/**
	 * Creates test data
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3991
	 */
	private static void SetupTestData()
	{
		List<Account> testAccounts = TestDataFactory.createTestAccounts(50, false, TestDataFactory.AccountRecordType.Client_Record_Type);
		List<Subscription__c> testSubscriptions = TestDataFactory.createTestSubscriptions(1, testAccounts, TestDataFactory.SubscriptionRecordType.MBA_Subscription);

		// make sure that at least some of the subscriptions have the wrong account
		for (Subscription__c sub : testSubscriptions)
		{
			sub.Account__c = testAccounts[0].Id;
		}

		update testSubscriptions;
	}

	/**
	 * Tests the scheduler
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3991
	 * @return Nothing
	 */
	@isTest static void testScheduler() {
		Test.startTest(); 
		BatchSubscriptionCleanupScheduler schedJob = new BatchSubscriptionCleanupScheduler(); 
		String schedule = '0 0 23 * * ?'; 
		system.schedule('Test BatchSubscriptionCleanupScheduler', schedule, schedJob); 
		Test.stopTest();
	}

	/**
	 * Tests the batch job
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3991
	 * @return Nothing
	 */
	@isTest static void testBatch() {
		SetupTestData();
		BatchSubscriptionCleanup b = new BatchSubscriptionCleanup();
		b.query = 'select ID, Account__c, Product__c from Subscription__c limit 50';
		Database.executeBatch(b);
	}
	
}