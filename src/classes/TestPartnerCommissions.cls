@isTest
private class TestPartnerCommissions {
	private static List<Account> testAccounts;
	private static List<Opportunity> testOpportunities;
	private static List<Invoice_Transaction__c> testInvoiceTransactions;
	private static List<rvpe__RVAccount__c> testRVAccounts;

	/**
	 * Creates test data for testing the partner commission batches
	 * @author Steve O'Neal
	 * @date   2016-07-01
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 */
	private static void SetupTestData()
	{
		// create instance of partner commission settings
		Partner_Commission_Settings__c pcs = Partner_Commission_Settings__c.getInstance();
		if (pcs == null || pcs.First_Day_of_Bill_Cycle__c == null || pcs.Earliest_Possible_Start_Date__c == null)
		{
			pcs = new Partner_Commission_Settings__c();
			pcs.First_Day_of_Bill_Cycle__c = 1;
			pcs.Earliest_Possible_Start_Date__c = Date.newInstance(2013, 1, 1);
			insert pcs;
		}

		testRVAccounts = TestDataFactory.createTestRVAccounts(4);

		testAccounts = TestDataFactory.createTestAccounts(4, false, TestDataFactory.AccountRecordType.Client_Record_Type);

		testOpportunities = TestDataFactory.createTestOpportunities(1, testAccounts, TestDataFactory.OpportunityRecordType.Store_Purchase);
		
		// give credit to the RV Accounts for the opportunities
		for (Opportunity opp : testOpportunities)
		{
			// randomly assign an rv account
			opp.rvpe__RVAccount__c = testRVAccounts[MathUtility.RandomInteger(0,testRVAccounts.size()-1)].Id;
		}
		update testOpportunities;

		// add payments from customers
		testInvoiceTransactions = TestDataFactory.createTestInvoiceTransactions(20, testOpportunities);
		// test bad data for trigger InvoiceTransactionTrigger
		testInvoiceTransactions[0].Payment_Term__c = 0;
		testInvoiceTransactions[1].Date_Paid__c = null;
		update testInvoiceTransactions;

	}

	/**
	 * Tests the BatchPartnerCommissionCleanupScheduler
	 * @author Steve O'Neal
	 * @date   2016-07-02
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return Nothing
	 */
	@isTest static void testScheduler() {
		Test.startTest(); 
		BatchPartnerCommissionCleanupScheduler schedJob = new BatchPartnerCommissionCleanupScheduler(); 
		String schedule = '0 0 23 * * ?'; 
		system.schedule('Test Batch Partner Commission Cleanup Scheduler', schedule, schedJob); 
		Test.stopTest();

	}
	

	/**
	 * Tests all of the Partner Commission batch jobs
	 * @author Steve O'Neal
	 * @date   2016-07-05
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return Nothing
	 */
	@isTest static void testBatchPartnerCommission() {
		SetupTestData();
        Test.startTest(); 
		
		BatchPartnerCommissionCreateSummaries bpccs = new BatchPartnerCommissionCreateSummaries();
		bpccs.targetPartnerAccounts = testRVAccounts;
		bpccs.ProcessEveryMonthUntilToday = false;
		bpccs.CreateDetailsWhenFinished = false;
		bpccs.startDate = Date.newInstance(1990,1,1);
		// run last month's and this month's batch for maximum coverage
		bpccs.endDate = Date.newInstance(Date.today().year(), Date.today().month(), 1).addDays(-1);
		Database.executeBatch(bpccs);
		
		bpccs.endDate = Date.newInstance(Date.today().year(), Date.today().month(), 1).addMonths(1).addDays(-1);
		// test BatchPartnerCommissionCreateDetails and BatchPartnerCommissionCreateHistory as well
		bpccs.CreateDetailsWhenFinished = true;
		Database.executeBatch(bpccs);



		// test BatchPartnerCommissionCleanup
		BatchPartnerCommissionCleanup bpcc = new BatchPartnerCommissionCleanup();
		string query = '';
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.deleteAllOpenSummaries;
		query = bpcc.buildQuery();
		bpcc.query = null;
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.deleteAllZeroDollarSummaries;
		query = bpcc.buildQuery();
		bpcc.query = null;
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.closeAllOpenPastSummaries;
		query = bpcc.buildQuery();
		bpcc.query = null;
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.closeAllOpenSummaries;
		query = bpcc.buildQuery();
		bpcc.query = null;



		// add partner payment information based on the closed summary data
		List<Partner_Commission_Summary__c> pcSummaries = [Select Id, Name, RecordTypeId, Commissionable_Revenue__c, Start_Date__c, End_Date__c, Partner_Account__c, Partner_Commission_Earned__c from Partner_Commission_Summary__c where RecordTypeId =: PartnerCommissionSummaryTriggerHandler.ClosedRecordType.Id];
		List<Partner_Commission_Payment__c> pcPayments = new List<Partner_Commission_Payment__c>();
		for (Partner_Commission_Summary__c pcSummary : pcSummaries)
		{
        	String seed1 = String.valueof(MathUtility.RandomInteger(10000, 99999));

			Partner_Commission_Payment__c pcPayment = new Partner_Commission_Payment__c();
			pcPayment.Payment_Amount__c = pcSummary.Partner_Commission_Earned__c;
			pcPayment.Custom_Note__c = 'Test Data';
			pcPayment.Description__c = pcPayment.Custom_Note__c;
			pcPayment.Fee__c = 0;
			pcPayment.Message__c = pcPayment.Custom_Note__c;
			pcPayment.Partner_Account__c = pcSummary.Partner_Account__c;
			pcPayment.Payment_Date__c = Date.today().addDays(-4);
			pcPayment.Payment_Method__c = 'PayPal';
			pcPayment.Reason_Code__c = '';
			pcPayment.Recipient__c = 'me@bigcommerce.com';
			pcPayment.Status__c = 'Completed';
			pcPayment.Transaction_ID__c = seed1;

			pcPayments.add(pcPayment);
		}
		insert pcPayments;


		// execute the batch for closing all open summaries
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.closeAllOpenSummaries;
		bpcc.query = null;
		bpcc.CreateSummariesWhenFinished = true;
		Database.executeBatch(bpcc);

		BatchPartnerCommissionCreateHistory  bpch = new BatchPartnerCommissionCreateHistory();
		Database.executeBatch(bpch);

		// delete all the Partner Commission objects
		bpcc.CurrentAction = BatchPartnerCommissionCleanup.BatchCleanupAction.deleteAllSummaries;
		bpcc.query = null;
		Database.executeBatch(bpcc);
		
    	Test.stopTest();

	}


	/**
	 * Tests the logic of the PartnerCommissionToolsController
	 * @author Steve O'Neal
	 * @date   2016-07-05
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return Nothing
	 */
	@isTest static void testToolsPageController()
	{
		SetupTestData();
        Test.startTest();

        PageReference testPageRef = Page.PartnerCommissionTools;
        Test.setCurrentPage(testPageRef);

        PartnerCommissionToolsController pctc = new PartnerCommissionToolsController();
        pctc.RefreshPageData();
        pctc.GetPartnerCommissionSummaryHistory();
        PartnerCommissionToolsController.BatchMonitor testBatchStatus = pctc.getBatchStatus();
        testBatchStatus.getNumberOfRecords();
        testBatchStatus.getNumberOfRecordsProcessed();
        testBatchStatus.NumberOfBatches = 0;
        testBatchStatus.getProgressPercent();
        testBatchStatus.NumberOfBatches = 10;
        testBatchStatus.getProgressPercent();

        DateTime tmpDate = testBatchStatus.CreatedDate;

        Test.stopTest();
	}

}