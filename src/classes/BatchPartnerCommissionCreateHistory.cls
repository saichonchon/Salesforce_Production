/**
 * BatchPartnerCommissionCreateHistory
 * Author: Steve O'Neal
 * Ticket: BAP-3698
 * Description: After Partner Commission details are updated or created, creates a history object for reporting purposes
 */
global class BatchPartnerCommissionCreateHistory implements Database.Batchable<sObject> {
	
	global Date endDate;
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

		string retVal = 'SELECT ID, Start_Date__c, End_Date__c, Commissionable_Revenue__c, Partner_Commission_Earned__c, Number_of_Invoice_Transactions__c, RecordTypeId from Partner_Commission_Summary__c where End_Date__c  <= ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate);
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
	global BatchPartnerCommissionCreateHistory() {
		endDate = Date.today();
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
		// always re-initialize the instance of the commission history
	  	Partner_Commission_Summary_History__c pcsh = BatchPartnerCommissionCreateHistory.getPartnerCommissionSummaryHistory(endDate);
	  	pcsh = BatchPartnerCommissionCreateHistory.initializeHistoryObject(pcsh, endDate);
	  	upsert pcsh;

		return Database.getQueryLocator(buildQuery());
	}


	global static Partner_Commission_Summary_History__c getPartnerCommissionSummaryHistory(Date endDate)
	{
  		string pcshKey = BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate);
		Partner_Commission_Summary_History__c retVal = new Partner_Commission_Summary_History__c();
   		List<Partner_Commission_Summary_History__c> pcshList = [Select id, Key__c, Active_Partners_Open__c, Commissionable_Revenue_Open__c, Commissionable_Transactions_Open__c, Commission_Earned_Open__c, Summary_Count_Open__c, Earliest_Start_Date_Open__c, Latest_End_Date_Open__c,  Active_Partners_Closed__c, Commissionable_Revenue_Closed__c, Commissionable_Transactions_Closed__c, Commission_Earned_Closed__c, Summary_Count_Closed__c, Earliest_Start_Date_Closed__c, Latest_End_Date_Closed__c, Payment_Amount__c, Payments__c from Partner_Commission_Summary_History__c where Key__c =:pcshKey limit 1];
   		
   		if (pcshList.size() > 0)
		{
			retVal = pcshList[0];
		}
		else
		{
			retVal = BatchPartnerCommissionCreateHistory.initializeHistoryObject(retVal, endDate);
		}

		return retVal;
	} 

	global static Partner_Commission_Summary_History__c initializeHistoryObject(Partner_Commission_Summary_History__c pcsh, Date endDate)
	{
  		string pcshKey = BatchPartnerCommissionCreateDetails.formatDateForQuery(endDate);
		pcsh.Key__c = pcshKey;
		pcsh.Active_Partners_Open__c = 0;
		pcsh.Commissionable_Revenue_Open__c = 0;
		pcsh.Commissionable_Transactions_Open__c = 0;
		pcsh.Commission_Earned_Open__c = 0;
		pcsh.Summary_Count_Open__c = 0;
		pcsh.Earliest_Start_Date_Open__c = null;
		pcsh.Latest_End_Date_Open__c = null;

		pcsh.Active_Partners_Closed__c = 0;
		pcsh.Commissionable_Revenue_Closed__c = 0;
		pcsh.Commissionable_Transactions_Closed__c = 0;
		pcsh.Commission_Earned_Closed__c = 0;
		pcsh.Summary_Count_Closed__c = 0;
		pcsh.Earliest_Start_Date_Closed__c = null;
		pcsh.Latest_End_Date_Closed__c = null;

		pcsh.Payments__c = 0;
		pcsh.Payment_Amount__c = 0;

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
	  		Partner_Commission_Summary_History__c pcsh = BatchPartnerCommissionCreateHistory.getPartnerCommissionSummaryHistory(endDate);

	   		for (sObject sobj : scope)
	   		{
   				Partner_Commission_Summary__c pcs = (Partner_Commission_Summary__c)sobj;
	   			if (pcs.RecordTypeId == PartnerCommissionSummaryTriggerHandler.OpenRecordType.Id)
	   			{
	   				pcsh.Commissionable_Revenue_Open__c += pcs.Commissionable_Revenue__c;
	   				pcsh.Commissionable_Transactions_Open__c += pcs.Number_of_Invoice_Transactions__c;
	   				pcsh.Commission_Earned_Open__c += pcs.Partner_Commission_Earned__c;
	   				pcsh.Summary_Count_Open__c++;
	   				if (pcsh.Earliest_Start_Date_Open__c == null || pcsh.Earliest_Start_Date_Open__c > pcs.Start_Date__c)
	   				{
	   					pcsh.Earliest_Start_Date_Open__c = pcs.Start_Date__c;
	   				}
	   				if (pcsh.Latest_End_Date_Open__c == null || pcsh.Latest_End_Date_Open__c < pcs.End_Date__c)
	   				{
		   				pcsh.Latest_End_Date_Open__c = pcs.End_Date__c;
		   			}
	   			}
	   			else
	   			{
	   				pcsh.Commissionable_Revenue_Closed__c += pcs.Commissionable_Revenue__c;
	   				pcsh.Commissionable_Transactions_Closed__c += pcs.Number_of_Invoice_Transactions__c;
	   				pcsh.Commission_Earned_Closed__c += pcs.Partner_Commission_Earned__c;
	   				pcsh.Summary_Count_Closed__c++;
	   				if (pcsh.Earliest_Start_Date_Closed__c == null || pcsh.Earliest_Start_Date_Closed__c > pcs.Start_Date__c)
	   				{
	   					pcsh.Earliest_Start_Date_Closed__c = pcs.Start_Date__c;
	   				}
	   				if (pcsh.Latest_End_Date_Closed__c == null || pcsh.Latest_End_Date_Closed__c < pcs.End_Date__c)
	   				{
		   				pcsh.Latest_End_Date_Closed__c = pcs.End_Date__c;
		   			}
	   			}
	   		}

   			upsert(pcsh);

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
		// add payment data
		BatchPartnerCommissionAddPaymentHistory bpcch = new BatchPartnerCommissionAddPaymentHistory();
		bpcch.endDate = endDate;
		database.executeBatch(bpcch, 200);
		
	}
	
}