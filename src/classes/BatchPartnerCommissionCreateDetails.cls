/**
 * BatchPartnerCommissionCreateDetails
 * Author: Steve O'Neal
 * Created: 2016-06-08
 * For building out partner commission data
 *
 *
 * 2016-08-03	Steve O'Neal	BAP-4085	Added functionality to take into consideration the partners' Approved Date and their Date Inactivated
 */

global class BatchPartnerCommissionCreateDetails implements Database.Batchable<sObject> {
	
	global String query;
	global Date startDate;
	global Date endDate;
	private Date earliestDate;
	global List<rvpe__RVAccount__c> targetPartnerAccounts;
	global integer firstDayOfBillCycle;
	global boolean ProcessEveryMonthUntilToday;
	global boolean ProcessHistory;

	/**
	 * Instantiator
	 * @author Steve O'Neal
	 * @date   2016-06-08
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return Nothing
	 */
	global BatchPartnerCommissionCreateDetails() {
		Partner_Commission_Settings__c pcs = Partner_Commission_Settings__c.getInstance();
		firstDayOfBillCycle = (pcs.First_Day_of_Bill_Cycle__c != null)?Integer.valueOf(pcs.First_Day_of_Bill_Cycle__c):1;
		earliestDate = (pcs.Earliest_Possible_Start_Date__c != null)?pcs.Earliest_Possible_Start_Date__c:Date.newInstance(2013, 1, 1);
		startDate = earliestDate;
		// get the last day of the current bill cycle using the custom setting.
		endDate = Date.newInstance(Date.today().year(), Date.today().month(), firstDayOfBillCycle).addMonths(1).addDays(-1);
		targetPartnerAccounts = new List<rvpe__RVAccount__c>();
		ProcessEveryMonthUntilToday = false;
		ProcessHistory = true;
	}

	/**
	 * Returns a date in the YYYY-MM-DD format
	 * @author Steve O'Neal
	 * @date   2016-06-09
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  dt         The date to format
	 * @return            Formatted date
	 */
	global static string formatDateForQuery(Date dt)
	{
		string yearVal = String.valueOf(dt.year());
		string monthVal = String.valueOf('00' + String.valueOf(dt.month())).right(2);
		string dayVal = String.valueOf('00' + String.valueOf(dt.day())).right(2);

		return yearVal + '-' + monthVal + '-' + dayVal;
	}


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
		// Note that we not only exclude any records that are not currently assigned to any partner, we also exclude any that are assigned to our generic placeholder account with an external id of 0
		string retVal = ' select id, name, Amount_Accrued_for_Commissions__c, Amount_Not_Yet_Accrued_for_Commissions__c, Amount_Paid_net__c, CMRR__c, Date_Paid__c, Date_Payment_Effective_Until__c, Number_of_Partner_Commissions__c, Partner_Account_Date_Inactivated__c, Partner_Account_Date_Activated__c, Partner_Account_ID__c, Partner_Account_External_ID__c, Partner_Commission_Percent__c, Payment_Term_Calculated__c, Product_Type__c, Store_Opportunity__c';
		retVal +=		' from Invoice_Transaction__c';
		retVal +=		' where Partner_Account_ID__c != \'\'';
		retVal +=		'	and Partner_Account_External_ID__c != 0';
		retVal +=		'	and Product_Type__c = \'Hosting\'';
		retVal +=		'	and Amount_Not_Yet_Accrued_for_Commissions__c != 0';
		retVal +=		' 	and Date_Paid__c <= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate);
		retVal +=		' 	and Date_Payment_Effective_Until__c >= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(startDate);
		//retVal +=		' 	and Payment_Term_Calculated__c > 1';
		// filter the results to only the specified partners
		if (targetPartnerAccounts.size() > 0)
		{
			retVal += 	'	and Partner_Account_ID__c in (';
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
   	global void execute(Database.BatchableContext BC, List<sObject> scope) 
   	{
		List<Partner_Commission_Invoice_Transaction__c> pcitList = new List<Partner_Commission_Invoice_Transaction__c>();
		Map<string, Partner_Commission_Summary__c> pcsMap = new Map<string, Partner_Commission_Summary__c>();
		Set<string> pcsKeySet = new Set<string>();

		// look through the BI Data and create the appropriate junction objects
		for (sObject sobj : scope)
		{
			// query the db for any summaries that we have already created
			// we could create them on demand, but the thinking here is that if the payment falls outside of the range that the partner was active, they should not get credit for it.
			Invoice_Transaction__c invTrans = (Invoice_Transaction__c)sobj;
			pcsKeySet.add(PartnerCommissionSummaryTriggerHandler.getDedupeKey(String.valueOf(invTrans.Partner_Account_External_ID__c), startDate, endDate));
		}

		List<string> pcsKeyList = new List<string>(pcsKeySet);
		System.debug(pcsKeySet);
		List<Partner_Commission_Summary__c> pcsList = [Select Id, Name, Start_Date__c, End_Date__c, Partner_Account__c, RecordTypeId, Partner_Commission_Summary_Dedupe_Key__c from Partner_Commission_Summary__c where Partner_Commission_Summary_Dedupe_Key__c in :pcsKeyList];
		for (Partner_Commission_Summary__c pcs : pcsList)
		{
			pcsMap.put(pcs.Partner_Commission_Summary_Dedupe_Key__c, pcs);
		}


		// now we have a fully-scoped list of partner commission summaries, create the junction objects
		for (sObject sobj : scope)
		{
			Invoice_Transaction__c invTrans = (Invoice_Transaction__c)sobj;
			string PartnerCommissionSummaryKey = PartnerCommissionSummaryTriggerHandler.getDedupeKey(String.valueOf(invTrans.Partner_Account_External_ID__c), startDate, endDate);
			System.debug(PartnerCommissionSummaryKey);

			if (pcsMap.containsKey(PartnerCommissionSummaryKey))
			{
				/**
				 * Logical example for the code below:
				 * 
				 * Payment of $1200, term of 12 months
				 * Based on simple math, the partner should accrue $100 each month towards calculating their commission
				 *
				 * Month 1
				 * PercentageAccrued = 1/12
				 * Amount accrued from previous months = 0
				 * Amount accrued this month = 1/12 * 1200 = 100
				 * New amount accrued this month = 100-0 = 100
				 *
				 * Month 2
				 * PercentageAccrued = 2/12
				 * Amount accrued from previous months = 100
				 * Amount accrued this month = 2/12 * 1200 = 200
				 * New amount accrued this month = 200-100 = 100
				 */

				// figure out how many payments we should be paying the customer for if their term spans more than one month
				double netPaid = invTrans.Amount_Paid_net__c;
				double amountAccrued = 0;
				// if the payment term is blank or 1, or the effective end date is in the past, assume we owe them the entire amount
				decimal percentageAccrued = 0;
				// if the payment term is more than one, or the effective end date is in the past, calculate what percentage they have accrued
				/**
				 * Our partners will only accrue payments from whichever date is LATEST:
				 *   1) The payment date
				 *   2) The commission run start date
				 *   3) The Partner Account Date Activated
				 */
				Date effectiveStartDate = invTrans.Date_Paid__c;
				System.Debug('effectiveStartDate: ' + effectiveStartDate);
				if (startDate != null && effectiveStartDate < startDate)
				{
					effectiveStartDate = startDate;
				}
				System.Debug('effectiveStartDate: ' + effectiveStartDate);

				if (invTrans.Partner_Account_Date_Activated__c != null && effectiveStartDate < invTrans.Partner_Account_Date_Activated__c)
				{
					effectiveStartDate = invTrans.Partner_Account_Date_Activated__c;
				}
				System.Debug('effectiveStartDate: ' + effectiveStartDate);
				/**
				 * Payments will end on whichever date is the EARLIEST:
				 * 	 1) The effective payment end date
				 * 	 2) The commission run end date
				 * 	 3) The Partner Account Date Inactivated
				 */
				Date effectiveEndDate = endDate;
				System.Debug('effectiveEndDate: ' + effectiveEndDate);
				if (invTrans.Date_Payment_Effective_Until__c != null && effectiveEndDate > invTrans.Date_Payment_Effective_Until__c)
				{
					effectiveEndDate = invTrans.Date_Payment_Effective_Until__c;
				}
				System.Debug('effectiveEndDate: ' + effectiveEndDate);

				if (invTrans.Partner_Account_Date_Inactivated__c != null && effectiveEndDate > invTrans.Partner_Account_Date_Inactivated__c)
				{
					effectiveEndDate = invTrans.Partner_Account_Date_Inactivated__c;
				}
				System.Debug('effectiveEndDate: ' + effectiveEndDate);

				integer numberOfPaymentsEarned = 0;

				System.debug('effectiveStartDate: ' + effectiveStartDate + ' <= effectiveEndDate: ' + effectiveEndDate);
				// while the adjusted payment date does not exceed the date range we are calculating for, and it does not exceed the effective until date, calculate how many months they have accrued to date
				while (effectiveStartDate <= effectiveEndDate && numberOfPaymentsEarned < invTrans.Payment_Term_Calculated__c)
				{
					effectiveStartDate = effectiveStartDate.addMonths(1);
					numberOfPaymentsEarned++;
				}
				System.debug('numberOfPaymentsEarned: ' + numberOfPaymentsEarned + ' < invTrans.Payment_Term_Calculated__c: ' + invTrans.Payment_Term_Calculated__c);

				// we now know how many CMRRs we owe them for, calculate the percentage that we should pay this month
				percentageAccrued = (numberOfPaymentsEarned/invTrans.Payment_Term_Calculated__c);

				System.debug('Percentage accrued = ' + percentageAccrued);

				// create the commission object
				if (percentageAccrued > 0)
				{
					System.debug('Total Payment: ' + netPaid + ', payment term: ' + invTrans.Payment_Term_Calculated__c + ', payment date: ' + invTrans.Date_Paid__c);
					// this amount represents the TOTAL amount accrued on this date based on the net payment for this transaction
					amountAccrued = netPaid * percentageAccrued;

					System.debug('Total accrued: ' + amountAccrued);
					// to get the REMAINING amount accrued to this date, we must subtract the amount already accrued
					amountAccrued = amountAccrued - invTrans.Amount_Accrued_for_Commissions__c;

					System.debug('Net accrued: ' + amountAccrued);
					// sanity check for rounding errors.  If the value we are trying to accrue goes past the total, make them equal
					if (
						(invTrans.Amount_Not_Yet_Accrued_for_Commissions__c >= 0 && amountAccrued > invTrans.Amount_Not_Yet_Accrued_for_Commissions__c)
						|| (invTrans.Amount_Not_Yet_Accrued_for_Commissions__c <= 0 && amountAccrued < invTrans.Amount_Not_Yet_Accrued_for_Commissions__c)
					   )
					{
						amountAccrued = invTrans.Amount_Not_Yet_Accrued_for_Commissions__c;
					}
					System.debug('Corrected net accrued: ' + amountAccrued);
					Partner_Commission_Invoice_Transaction__c pcit = new Partner_Commission_Invoice_Transaction__c();
					pcit.Invoice_Transaction__c = invTrans.id;
					pcit.Partner_Account__c = invTrans.Partner_Account_Id__c;
					pcit.Accrued_Transaction_Amount__c = amountAccrued;
					pcit.Partner_Commission_Percent__c = invTrans.Partner_Commission_Percent__c;
					pcit.Partner_Commission_Earned__c = pcit.Accrued_Transaction_Amount__c * (pcit.Partner_Commission_Percent__c/100);
					pcit.Partner_Commission_Summary__c = pcsMap.get(PartnerCommissionSummaryKey).Id;
					System.Debug(pcit);
					if (pcit.Partner_Commission_Earned__c != 0)
					{
						pcitList.add(pcit);
						System.Debug('Adding partner commission');
					}
				}
				
			}
			else
			{
				System.Debug('Invalid partner commission for ' + invTrans.Id);
			}
		}

		System.debug('Total records inserted: ' + pcitList.size());
		insert pcitList;

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

		if (ProcessHistory)
		{
			BatchPartnerCommissionCreateHistory bpcch = new BatchPartnerCommissionCreateHistory();
			// if we're building up data from the beginning of time, make a summary for the end of each month.  Otherwise, the summary will default to daily
			if (ProcessEveryMonthUntilToday && endDate < date.today())
			{
				bpcch.endDate = endDate;
			}
			database.executeBatch(bpcch, 200);
		}

		if (ProcessEveryMonthUntilToday && endDate < date.today())
		{
			BatchPartnerCommissionCreateSummaries bpccs = new BatchPartnerCommissionCreateSummaries();
			bpccs.startDate = startDate;
			// what's with the weird date manipulation?
			// by doing this, if the person launched the batch on the last day of the month, it will continue to run on the last day of the month
			bpccs.endDate = endDate.addDays(1).addMonths(1).addDays(-1);
			bpccs.targetPartnerAccounts = targetPartnerAccounts;
			bpccs.firstDayOfBillCycle = firstDayOfBillCycle;
			bpccs.ProcessEveryMonthUntilToday = ProcessEveryMonthUntilToday;

			database.executeBatch(bpccs, 200);
		}
		
	}
	
}