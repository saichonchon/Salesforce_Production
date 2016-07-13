/**
 * BatchPartnerCommissionCreateSummaries
 * Author: Steve O'Neal
 * Ticket: BAP-3698
 * Description: Creates Partner Commission Summary objects in advance of creating the detail records.
 * Technically this process isn't necessary except to make sure that a zero-dollar summary is created for each partner for each bill period, 
 * driving it entirely by BI Data would leave data gaps if no payments were made.
 */
global class BatchPartnerCommissionCreateSummaries implements Database.Batchable<sObject> {
	
	global String query;
	global Date startDate;
	global Date endDate;
	private Date earliestDate;
	global List<rvpe__RVAccount__c> targetPartnerAccounts;
	global integer firstDayOfBillCycle;
	global boolean CreateDetailsWhenFinished;
	global boolean ProcessEveryMonthUntilToday;

	
	/**
	 * Builds the query for the batch process.  Note that this will not run if the query is manually overridden.
	 * @author Steve O'Neal
	 * @date   2016-06-09
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return String representing a SOQL query
	 */
	private string buildQuery()
	{
		if (!String.isEmpty(query))
		{
			return query;
		}

		// make sure that start date is within the parameters
		if (startDate == null || startDate < earliestDate)
		{
			startDate = earliestDate;
		}
		string retVal = ' select id, name, This_Month_s_Partner_Commission_Summary__c, Last_Month_s_Partner_Commission_Summary__c, Approved_Date__c, Inactivated_Date__c, IDev_ID__c, rvpe__ExtAccountId__c';
		retVal +=		' from rvpe__RVAccount__c';
		retVal +=		' where Commission__c != null';
		// filter for all partner that could have possibly collected revenue in this period
		retVal +=		' 	and (Approved_Date__c <= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate) + ' or IDev_ID__c != null)';
		retVal +=		' 	and (Inactivated_Date__c = null or Inactivated_Date__c >= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate) + ')';
		retVal +=		'	and rvpe__ExtAccountId__c != 0';

		if (targetPartnerAccounts.size() > 0)
		{
			// filter the results to only the specified partners
			retVal += 	'	and ID in (';
			string comma = '';
			for (rvpe__RVAccount__c pAcct : targetPartnerAccounts)
			{
				retVal += comma + '\'' + String.valueOf(pAcct.Id).Left(15) + '\'';
				comma = ',';
			}
			retVal +=	')';
		}

		System.Debug('Generated SOQL query: ' + retVal);
		return retVal;
	}


	/**
	 * Instantiator
	 * @author Steve O'Neal
	 * @date   2016-06-10
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return Creates an instance of the batch job and initializes the variables
	 */
	global BatchPartnerCommissionCreateSummaries() {
		Partner_Commission_Settings__c pcs = Partner_Commission_Settings__c.getInstance();
		firstDayOfBillCycle = (pcs.First_Day_of_Bill_Cycle__c != null)?Integer.valueOf(pcs.First_Day_of_Bill_Cycle__c):1;
		earliestDate = (pcs.Earliest_Possible_Start_Date__c != null)?pcs.Earliest_Possible_Start_Date__c:Date.newInstance(2013, 1, 1);
		startDate = earliestDate;
		// get the last day of the current bill cycle using the custom setting.
		endDate = Date.newInstance(Date.today().year(), Date.today().month(), firstDayOfBillCycle).addMonths(1).addDays(-1);
		// by default, chain up the detail calculation batch job when this is finished
		CreateDetailsWhenFinished = true;
		targetPartnerAccounts = new List<rvpe__RVAccount__c>();
		ProcessEveryMonthUntilToday = false;
	}
	
	/**
	 * QueryLocator gets the records from the db based on the generated query
	 * @author Steve O'Neal
	 * @date   2016-06-10
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @return            Query locator that represents the scope of the batch
	 */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = buildQuery();

		return Database.getQueryLocator(query);
	}

	/**
	 * Execute the scope
	 * @author Steve O'Neal
	 * @date   2016-06-10
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @param  scope      Current scope of batch
	 * @return            Nothing
	 */
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Partner_Commission_Summary__c> pcSummaries = new List<Partner_Commission_Summary__c>();

		Date thisMonthsLastDay = Date.newInstance(Date.today().year(), Date.today().month(), 1).addMonths(1).addDays(-1);
		Date lastMonthsLastDay = Date.newInstance(Date.today().year(), Date.today().month(), 1).addDays(-1);
		Map<Id, rvpe__RVAccount__c> rvAccountMap = new Map<Id, rvpe__RVAccount__c>();

		for (sObject sobj : scope)
		{
			rvpe__RVAccount__c rvAccount = (rvpe__RVAccount__c)sobj;
			Partner_Commission_Summary__c pcs = new Partner_Commission_Summary__c();
			pcs.Start_Date__c = startDate;
			pcs.End_Date__c = endDate;
			pcs.Partner_Account__c = sobj.Id;
			pcs.RecordTypeId = PartnerCommissionSummaryTriggerHandler.OpenRecordType.Id;
			pcs.Partner_Commission_Summary_Dedupe_Key__c = PartnerCommissionSummaryTriggerHandler.GetDedupeKey(String.valueOf(rvAccount.rvpe__ExtAccountId__c), startDate, endDate);
			pcSummaries.add(pcs);

			rvAccountMap.put(rvAccount.id, rvAccount);
		}

		// insert the records into the db
		Database.insert(pcSummaries, false);

		// also record the current month's and previous month's commission summary
		List<Partner_Commission_Summary__c> pcSummaries2 = [Select Id, Partner_Account__c, Start_Date__c, End_Date__c, Partner_Commission_Summary_Dedupe_Key__c from Partner_Commission_Summary__c where Partner_Account__c in :rvAccountMap.KeySet() and (End_Date__c = :thisMonthsLastDay or End_Date__c = :lastMonthsLastDay)];

		if (pcSummaries2.size() > 0)
		{
			for (Partner_Commission_Summary__c pcs : pcSummaries2)
			{
				if (pcs.End_Date__c == thisMonthsLastDay)
				{
					rvAccountMap.get(pcs.Partner_Account__c).This_Month_s_Partner_Commission_Summary__c = pcs.Id;
				}
				else if (pcs.End_Date__c == lastMonthsLastDay)
				{
					rvAccountMap.get(pcs.Partner_Account__c).Last_Month_s_Partner_Commission_Summary__c = pcs.Id;
				}
			}

			Database.update(rvAccountMap.values(), false);
		}


	}
	

	/**
	 * Post-processing logic
	 * @author Steve O'Neal
	 * @date   2016-06-10
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  BC         Batchable context
	 * @return            nothing
	 */
	global void finish(Database.BatchableContext BC) {
		if (CreateDetailsWhenFinished)
		{
			BatchPartnerCommissionCreateDetails bpccd = new BatchPartnerCommissionCreateDetails();
			bpccd.startDate = startDate;
			bpccd.endDate = endDate;
			bpccd.targetPartnerAccounts = targetPartnerAccounts;
			bpccd.firstDayOfBillCycle = firstDayOfBillCycle;
			bpccd.ProcessEveryMonthUntilToday = ProcessEveryMonthUntilToday;

			database.executeBatch(bpccd, 200);
		}
	}
	
}