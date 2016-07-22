/**
 * BatchSubscriptionCleanup
 * Author: Steve O'Neal
 * Date: 7/14/2016
 * Purpose: Cleans up subscriptions with an account mismatch by removing the account and saving the record again.
 * Not all subscriptions can be cleaned this way, but a large chunk can be.
 * Never run this batch with a scope larger than 10 due to callouts being made during the save.
 */
global class BatchSubscriptionCleanup implements Database.Batchable<sObject> {
	
	global String query;
	
	/**
	 * Instantiates the job and generates the default query
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3991
	 * @return Instance of BatchSubscriptionCleanup
	 */
	global BatchSubscriptionCleanup() {
		query = 'select ID, Account__c, Product__c from Subscription__c where Account_Mismatch__c = true and status__c = \'Active\' and ProductType__c = \'Store\' and (not Product__c like \'%TEST%\') and createddate > 2014-01-01T12:00:00Z';
	}
	
	/**
	 * Queries the database with the given query
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3991
	 * @param  BC         Batchable context
	 * @return            Query locator representing the results of the query
	 */
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	/**
	 * Updates the subscriptions by clearing out the account
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3991
	 * @param  BC         Batchable context
	 * @param  scope      Current scope
	 * @return            Nothing
	 */
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
	
		List<Subscription__c> subsToUpdate = new List<Subscription__c>();
		for (sObject sub : scope)
		{
			Subscription__c subToUpdate = (Subscription__c)sub;
		    subToUpdate.Account__c = null;
		    subsToUpdate.add(subToUpdate);
		}

		database.update(subsToUpdate,false);		
	}
	
	/**
	 * Finishes the batch job
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3991
	 * @param  BC         Batchable context
	 * @return            Nothing
	 */
	global void finish(Database.BatchableContext BC) {
		
	}
	
}