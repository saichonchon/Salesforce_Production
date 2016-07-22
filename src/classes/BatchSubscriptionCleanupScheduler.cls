/**
 * BatchSubscriptionCleanupScheduler
 * Author: Steve O'Neal
 * Date: 7/14/2016
 * Purpose: Schedules BatchSubscriptionCleanup
 */
global class BatchSubscriptionCleanupScheduler implements Schedulable {
	/**
	 * Schedules the BatchSubscriptionCleanup job
	 * @author Steve O'Neal
	 * @date   2016-07-14
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3991
	 * @param  sc         Schedulable context
	 * @return            Nothing
	 */
	global void execute(SchedulableContext sc) {
		BatchSubscriptionCleanup b = new BatchSubscriptionCleanup();
		database.executebatch(b,10);
	}
}