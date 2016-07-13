/**
 * BatchPartnerCommissionCleanup
 * Author: Steve O'Neal
 * Ticket: BAP-3698
 * Description: Updates or deletes existing Partner Commission Summary objects depending on the BatchCleanupAction.  Default action is to close out all open summaries on the 1st of the month.
 */
global class BatchPartnerCommissionCleanup implements Database.Batchable<sObject> {
	
	global String query;

	/**
	 * BatchCleanupAction:
	 * 		deleteAllOpenSummaries = delete all summary data plus their supporting detail records if the summary is not marked closed.
	 * 		deleteAllSummaries - completely delete all records, regardless if they are closed or not.  Reset button for testing, not recommended for production use.
	 * 		closeAllOpenSummaries = mark all open summary data as closed.
	 * 		closeAllOpenPastSummaries - (default) if today is the bill cycle day (the 1st by default), close any open 
	 */
	global enum BatchCleanupAction {deleteAllOpenSummaries, deleteAllSummaries, deleteAllZeroDollarSummaries, closeAllOpenSummaries, closeAllOpenPastSummaries}
	private BatchCleanupAction pvtCurrentAction;
	global BatchCleanupAction CurrentAction
	{
		get
		{
			return pvtCurrentAction;
		}
		set
		{
			pvtCurrentAction = value;
		}
	}

	global integer firstDayOfBillCycle;
	global boolean CreateSummariesWhenFinished;
	global boolean Stage2Delete;
	Schema.RecordType OpenRecordType;
	Schema.RecordType ClosedRecordType;


	private boolean IsDeleteAction(BatchCleanupAction currAct)
	{
		return (CurrentAction == BatchCleanupAction.deleteAllOpenSummaries
			 || CurrentAction == BatchCleanupAction.deleteAllZeroDollarSummaries
			 || CurrentAction == BatchCleanupAction.deleteAllSummaries);
	}

	private boolean IsForOpenRecords(BatchCleanupAction currAct)
	{
		return (CurrentAction == BatchCleanupAction.deleteAllOpenSummaries 
			 || CurrentAction == BatchCleanupAction.closeAllOpenSummaries
			 || CurrentAction == BatchCleanupAction.closeAllOpenPastSummaries);
	}


	/**
	 * Builds the query for the batch process.  Note that this will not run if the query is manually overridden.
	 * @author Steve O'Neal
	 * @date   2016-06-09
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return String representing a SOQL query
	 */
	global string buildQuery()
	{
		if (!String.isEmpty(query))
		{
			return query;
		}

		// by default, we work against summaries
		string whereClausePrepend = '';
		string targetObject = 'Partner_Commission_Summary__c';

		// When deleting huge amounts of data where master/detail records exist, it's important to do it in two stages.
		// The first stage is to delete all of the children, so the filters have to be modified to use the child objects' perspective
		if (!Stage2Delete && IsDeleteAction(CurrentAction))
		{
			whereClausePrepend = 'Partner_Commission_Summary__r.';
			targetObject = 'Partner_Commission_Invoice_Transaction__c';
		}

		string retVal = ' select id';
		// When deleting, we don't want anything other than an ID.  This prevents problems when switching objects
		if (!IsDeleteAction(CurrentAction))
		{
			retVal += 	', name, Start_Date__c, End_Date__c, RecordTypeId';
		}
		retVal +=		' from ' + targetObject;

		if  (IsForOpenRecords(CurrentAction))
		{
			// get all the open records
			retVal +=	' where ' + whereClausePrepend + 'RecordTypeId = \'' + OpenRecordType.Id + '\'';
		}
		else if (CurrentAction == BatchCleanupAction.deleteAllZeroDollarSummaries)
		{
			retVal +=	' where ' + whereClausePrepend + 'Partner_Commission_Earned__c = 0';
		}

		if (CurrentAction == BatchCleanupAction.closeAllOpenPastSummaries)
		{
			// also get all records in the past
			retVal +=	'	and ' + whereClausePrepend + 'End_Date__c < ' + BatchPartnerCommissionCreateDetails.formatDateForQuery(Date.today());
		}

		// note that DeleteAllSummaries is not in the above if statement because there is no need for a where clause

		System.Debug('Generated SOQL query: ' + retVal);
		return retVal;
	}
	

	/**
	 * Instantiator
	 * @author Steve O'Neal
	 * @date   2016-06-09
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
	 * @return nothing
	 */
	global BatchPartnerCommissionCleanup() {
		pvtCurrentAction = BatchCleanupAction.closeAllOpenPastSummaries;
		CreateSummariesWhenFinished = true;
		Stage2Delete = false;

		OpenRecordType = PartnerCommissionSummaryTriggerHandler.OpenRecordType;
		ClosedRecordType = PartnerCommissionSummaryTriggerHandler.ClosedRecordType;
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
	
		if  (IsDeleteAction(CurrentAction))
		{
			// delete the summaries
			database.delete(scope, false);
		}
		else
		{
			List<Partner_Commission_Summary__c> pcsToUpdate = new List<Partner_Commission_Summary__c>();
			// close the summaries
			for (SObject sobj : scope)
			{
				Partner_Commission_Summary__c pcs = (Partner_Commission_Summary__c)sobj;
				pcs.RecordTypeId = PartnerCommissionSummaryTriggerHandler.ClosedRecordType.Id;
				pcsToUpdate.add(pcs);
			}

			if (pcsToUpdate.size() > 0)
			{
				database.update(pcsToUpdate, false);
			}
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

		if (IsDeleteAction(CurrentAction) && !Stage2Delete)
		{
			// delete stage 2
			BatchPartnerCommissionCleanup bpcc = new BatchPartnerCommissionCleanup();
			bpcc.CreateSummariesWhenFinished = this.CreateSummariesWhenFinished;
			bpcc.CurrentAction = this.CurrentAction;
			bpcc.Stage2Delete = true;
			database.executeBatch(bpcc, 200);
		}
		else if (CreateSummariesWhenFinished)
		{
			BatchPartnerCommissionCreateSummaries bpccs = new BatchPartnerCommissionCreateSummaries();
			database.executeBatch(bpccs, 200);

		}
		else
		{
			BatchPartnerCommissionCreateHistory bpcch = new BatchPartnerCommissionCreateHistory();
			database.executeBatch(bpcch, 200);
		}
	}
	
}