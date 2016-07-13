global class BatchPartnerCommissionAddPaymentHistory implements Database.Batchable<sObject> {
	
	global Date endDate;
	global Date startDate;
	private Date earliestDate;
	global String query;

	/**
	 * Builds the query for the batch process.  Note that this will not run if the query is manually overridden.
	 * @author Steve O'Neal
	 * @date   2016-06-20
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return String representing a SOQL query
	 */
	private string buildQuery()
	{
		if (!String.isEmpty(query))
		{
			return query;
		}

		if (startDate == null || startDate < earliestDate)
		{
			startDate = earliestDate;
		}

		string retVal = 'SELECT Id, Payment_Amount__c, Payment_Date__c, Partner_Account__c, Partner_Account__r.Most_Recent_Commission_Payment__c, Partner_Account__r.Most_Recent_Commission_Payment__r.Payment_Date__c  from Partner_Commission_Payment__c where Partner_Account__r.rvpe__ExtAccountId__c != 0 and Status__c = \'Completed\' and Payment_Date__c  <= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate) + ' and Payment_Date__c  >= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(startDate);
		System.Debug('Generated SOQL query: ' + retVal);

		return retVal;
	}

	/**
	 * Instantiator
	 * @author Steve O'Neal
	 * @date   2016-06-20
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return nothing
	 */
	global BatchPartnerCommissionAddPaymentHistory() {
		endDate = Date.today();
		Partner_Commission_Settings__c pcs = Partner_Commission_Settings__c.getInstance();
		earliestDate = (pcs.Earliest_Possible_Start_Date__c != null)?pcs.Earliest_Possible_Start_Date__c:Date.newInstance(2013, 1, 1);
		// assume that we pay in arears, so any payment made out to a partner would need to be at least one month after the minimum start date for Invoice Transactions
		earliestDate = earliestDate.addMonths(1);
		startDate = earliestDate;
	}
	
	/**
	 * QueryLocator gets the records from the db based on the generated query
	 * @author Steve O'Neal
	 * @date   2016-06-20
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @return            Query locator that represents the scope of the batch
	 */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Partner_Commission_Summary_History__c pcsh = BatchPartnerCommissionCreateHistory.getPartnerCommissionSummaryHistory(endDate);
		pcsh = initalizePaymentHistory(pcsh);
		upsert pcsh;
		return Database.getQueryLocator(buildQuery());
	}


	private static Partner_Commission_Summary_History__c initalizePaymentHistory(Partner_Commission_Summary_History__c pcsh)
	{
		pcsh.Payment_Amount__c = 0;
		pcsh.Payments__c = 0;
		return pcsh;
	}


 	/**
	 * Execute the scope
	 * @author Steve O'Neal
	 * @date   2016-06-20
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @param  scope      Current scope of batch
	 * @return            Nothing
	 */
  	global void execute(Database.BatchableContext BC, List<sObject> scope) {
  		if (scope.size() > 0)
  		{
	  		// get the history record from the database
	   		Partner_Commission_Summary_History__c pcsh = BatchPartnerCommissionCreateHistory.getPartnerCommissionSummaryHistory(endDate);

	   		Set<Id> RVPartnerIdsThatNeedMostRecentPayment = new Set<Id>();

	   		for (sObject sobj : scope)
	   		{
	   			Partner_Commission_Payment__c pcp = (Partner_Commission_Payment__c)sobj;
	   			pcsh.Payment_Amount__c += pcp.Payment_Amount__c;
	   			pcsh.Payments__c++;

	   			// see if the payment being processed is the most recent
	   			if (pcp.Partner_Account__r.Most_Recent_Commission_Payment__c == null || pcp.Partner_Account__r.Most_Recent_Commission_Payment__r.Payment_Date__c < pcp.Payment_Date__c)
	   			{
	   				System.Debug('RV Account with outdated payment data: ' + pcp.Partner_Account__c);
	   				RVPartnerIdsThatNeedMostRecentPayment.add(pcp.Partner_Account__c);
	   			}
	   		}


	   		if (RVPartnerIdsThatNeedMostRecentPayment.size() > 0)
	   		{
	   			// if we found partners who have an out-of-date most recent payment, update it
	   			List<rvpe__RVAccount__c> rvAccounts = [Select Id, Most_Recent_Commission_Payment__c, Most_Recent_Commission_Payment__r.Payment_Date__c from rvpe__RVAccount__c where Id in:RVPartnerIdsThatNeedMostRecentPayment];
	   			for (rvpe__RVAccount__c rvAccount : rvAccounts)
	   			{
			   		for (sObject sobj : scope)
			   		{
			   			Partner_Commission_Payment__c pcp = (Partner_Commission_Payment__c)sobj;
			   			if (pcp.Partner_Account__c == rvAccount.Id)
			   			{
			   				if (rvAccount.Most_Recent_Commission_Payment__c == null || rvAccount.Most_Recent_Commission_Payment__r.Payment_Date__c < pcp.Payment_Date__c)
			   				{
				   				System.Debug('Adding new payment data: ' + pcp.Partner_Account__c);
				   				rvAccount.Most_Recent_Commission_Payment__c = pcp.Id;
				   				rvAccount.Most_Recent_Commission_Payment__r = pcp;
				   			}
			   			}
			   		}
	   			}

   				System.Debug('Updating RV Accounts: ' + rvAccounts.size());
	   			update rvAccounts;
	   		}

	   		upsert pcsh;
   		}
	}
	
	/**
	 * Post-processing logic
	 * @author Steve O'Neal
	 * @date   2016-06-20
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @return            nothing
	 */
	global void finish(Database.BatchableContext BC) {
	}
	
	
}