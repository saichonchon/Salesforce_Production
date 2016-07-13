/**
 * BatchPartnerCommissionCleanupScheduler
 * Author: Steve O'Neal
 * Date: 7/2/2016
 * Purpose: To schedule the BatchPartnerCommissionCleanup code
 */
global class BatchPartnerCommissionCleanupScheduler implements Schedulable {
	/**
	 * Schedules the BatchParterCommissionCleanup job
	 * @author Steve O'Neal
	 * @date   2016-07-02
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
	 * @param  sc         Schedulable Context
	 * @return            Nothing
	 */
	global void execute(SchedulableContext sc) {
		BatchPartnerCommissionCleanup b = new BatchPartnerCommissionCleanup();
		database.executebatch(b);
	}
}