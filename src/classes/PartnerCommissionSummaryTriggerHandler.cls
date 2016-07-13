/**
 * PartnerCommissionSummaryTriggerHandler
 * Author: Steve O'Neal
 * Purpose: Provide tools for modifying the Partner_Commission_Summary__c object in a trigger
 */
public with sharing class PartnerCommissionSummaryTriggerHandler {
	private static Schema.RecordType pvtOpenRecordType = null;
	private static Schema.RecordType pvtClosedRecordType = null;

	/**
	 * Returns the definition for the PartnerCommissionSummary 'Open' record type
	 */
	public static Schema.RecordType OpenRecordType
	{
		get
		{
			if (pvtOpenRecordType == null)
			{
				getRecordTypes();
			}
			return pvtOpenRecordType;
		}
	}

	/**
	 * Returns the definition for the PartnerCommissionSummary 'Closed' record type
	 */
	public static Schema.RecordType ClosedRecordType
	{
		get
		{
			if (pvtClosedRecordType == null)
			{
				getRecordTypes();
			}
			return pvtClosedRecordType;
		}
	}

	/**
	 * Fetches the Partner Commission Summary record types from the database
	 * @author Steve O'Neal
	 * @date   2016-06-13
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 */
	private static void getRecordTypes()
	{
		List<Schema.RecordType> recordTypes = [select Id, Name, DeveloperName, SObjectType from RecordType where SObjectType = 'Partner_Commission_Summary__c'];
		for (Schema.RecordType rt : recordTypes)
		{
			if (rt.DeveloperName == 'Closed')
			{
				pvtClosedRecordType = rt;
			}
			else if (rt.DeveloperName == 'Open')
			{
				pvtOpenRecordType = rt;
			}
		}

	}



	/**
	 * Create an external id that can be used in the Partner Commission Summary.  Note that when the PCS is marked closed, its key will become blank because it can no longer be modified.
	 * @author Steve O'Neal
	 * @date   2016-06-13
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  pcs        The Partner Commission Summary object that is affected by the change
	 * @return            String representing the PCS object's new key
	 */
	public static string GetDedupeKey(String PartnerAccountId, Date StartDate, Date EndDate)
	{
		return PartnerAccountId.left(15) + '|' + String.valueOf(StartDate) + '|' + String.valueOf(EndDate);
	}

}