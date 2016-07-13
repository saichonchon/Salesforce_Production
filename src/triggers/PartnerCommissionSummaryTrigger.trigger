/**
 * Processes functionality on save of Partner Commission Summary
 * @author Steve O'Neal
 * @date   2016-06-13
 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
 * @return            nothing
 */
trigger PartnerCommissionSummaryTrigger on Partner_Commission_Summary__c (before insert, before update, before delete, after insert, after update, after delete) {
	if (trigger.isBefore && (trigger.isUpdate || trigger.isInsert))
	{
		// when updating or inserting a new summary record, set the unique identifier
		for (Partner_Commission_Summary__c pcs : trigger.new)
		{
			if (pcs.RecordTypeId == PartnerCommissionSummaryTriggerHandler.ClosedRecordType.Id)
			{
				pcs.Partner_Commission_Summary_Dedupe_Key__c = '';
			}
		}
	}

}