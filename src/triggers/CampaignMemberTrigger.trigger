/**
 * Trigger for Campaign Members
 * Author: Steve O'Neal
 */
trigger CampaignMemberTrigger on CampaignMember (after insert) {


	/**
	 * For updating the Demo Requested Date on the campaign members' related contact or opportunity
	 * @author Steve O'Neal
	 * @date   2016-06-22
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3811
	 */
	if (trigger.isAfter && trigger.isInsert)
	{
		System.debug('After Insert CampaignMember');
		Set<Id> ContactsAddedToDemoCampaignSet = new Set<Id>();
		Set<Id> LeadsAddedToDemoCampaignSet = new Set<Id>();
		// identify the opportunities or contacts that need to have their Demo Requested Date set.
		// as a paranoid check, don't assume that the contacts are unique as they could have been added to multiple campaigns at the same time
		// use Set as a way of uniquely identifying the list of contact ids
		for (CampaignMember cm : trigger.new)
		{
			System.Debug('Campaign member: ' + cm);
			if (cm.Demo_Request__c)
			{
				System.debug('Demo requested');
				if (cm.ContactId != null)
				{
					System.debug('Added to contact list');
					ContactsAddedToDemoCampaignSet.add(cm.ContactId);
				}
				else if (cm.LeadId != null)
				{
					System.debug('Added to lead list');
					LeadsAddedToDemoCampaignSet.add(cm.LeadId);
				}
			}
		}

		// a set of generic objects - either opps, contacts, or leads - to update the database
		List<sObject> demoRequestObjectsToUpdate = new List<sObject>();

		// if any contact records have had a demo requested, identify if the contact or its related store opportunity needs the demo requested flag updated
		if (ContactsAddedToDemoCampaignSet.size() > 0)
		{
			// get the contacts in the list
			List<Contact> ContactsToSearchForDemoStartDate = [Select Id, AccountId, Demo_Requested_Date__c from Contact where Id in :new List<Id>(ContactsAddedToDemoCampaignSet)];

			// get the opportunity record types that can have demos tied to them
			List<string> opportunityDemoRequestRecordTypeNames = new List<string>();
			opportunityDemoRequestRecordTypeNames.add('Store_Purchase');
			opportunityDemoRequestRecordTypeNames.add('Trial');
			Map<Id, Schema.RecordType> opportunityDemoRequestRecordTypes = new Map<Id, Schema.RecordType>([Select Id, Name, DeveloperName, SObjectType from RecordType where SObjectType = 'Opportunity' and DeveloperName in :opportunityDemoRequestRecordTypeNames]);

			// find any related Store Opps using the Account id from the Contacts
			Set<Id> AccountIdsToSearch = new Set<Id>();
			for (Contact cont : ContactsToSearchForDemoStartDate)
			{
				if (cont.AccountId != null)
				{
					AccountIdsToSearch.add(cont.AccountId);
				}
			}
			List<Opportunity> demoRequestOpportunities = [Select Id, Demo_Requested_Date__c, AccountId from Opportunity where AccountId in :new List<Id>(AccountIdsToSearch) and RecordTypeId in :opportunityDemoRequestRecordTypes.KeySet()];

			// We now have two different lists of data that we could possibly update - one for contacts and one for opportunities
			// Opportunities is preferred because it is more specific, so we will apply the data to those records first
			// Because the data is coming from two different data sources, we need to maintain a list of items we've already updated, so that we don't request two demos for the same person.
			Map<Id, Id> AccountIDsWithDemoSet = new Map<Id, Id>();

			// first opportunities
			for (Opportunity opp : demoRequestOpportunities)
			{
				if (!AccountIDsWithDemoSet.containsKey(opp.AccountId))
				{
					opp.Demo_Requested_Date__c = DateTime.now();
					demoRequestObjectsToUpdate.add(opp);
					AccountIDsWithDemoSet.put(opp.AccountId, opp.AccountId);
				}
			}

			// now contacts
			for (Contact cont : ContactsToSearchForDemoStartDate)
			{
				if (!AccountIDsWithDemoSet.containsKey(cont.AccountId))
				{
					cont.Demo_Requested_Date__c = DateTime.now();
					demoRequestObjectsToUpdate.add(cont);
					AccountIDsWithDemoSet.put(cont.AccountId, cont.AccountId);
				}
			}

		}

		// if any lead records have had a demo requested, set their demo requested date
		if (LeadsAddedToDemoCampaignSet.size() > 0)
		{

			// get the leads from the database
			List<Lead> leadsToUpdate = [Select ID, Projected_Annual_Revenue__c, Demo_Requested_Date__c from Lead where ID in :new List<ID>(LeadsAddedToDemoCampaignSet)];
			
			// finally leads
			for (Lead lead : leadsToUpdate)
			{
				lead.Demo_Requested_Date__c = DateTime.now();
				demoRequestObjectsToUpdate.add(lead);
			}
		}

		// update records where the demo requested date has been set
		if (demoRequestObjectsToUpdate.size() > 0)
		{
			System.Debug('Setting demo request date for ' + demoRequestObjectsToUpdate.size() + ' objects');
			// update the db with the new data
			update demoRequestObjectsToUpdate;
		}
	}
}