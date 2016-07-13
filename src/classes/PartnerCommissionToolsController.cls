/**
 * ParterCommissionToolsController
 * Author: Steve O'Neal
 * Date: 6-25-2016
 * Purpose: For monitoring batch jobs and PartnerCommissionSummaryHistory
 */
public with sharing class PartnerCommissionToolsController {

    private final sObject mysObject;
    private Partner_Commission_Summary_History__c pvtPartnerCommissionSummaryHistory;
    private Map<Id,ApexClass> batchJobs;
    private Map<String,String> batchNames;
    private List<String> batchStatuses;
    private BatchMonitor currentBatchStatus;

    /**
     * Instantiator
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
     * @return An instance of the page controller
     */
    public PartnerCommissionToolsController()
    {
        initializeMe();
    }

    /**
     * Intializes all local variables
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
     */
    private void initializeMe()
    {
        // fill in the list of batches we will monitor
        batchNames = new Map<String,String>();
        batchNames.put('BatchPartnerCommissionCleanup', 'Cleanup');
        batchNames.put('BatchPartnerCommissionCreateSummaries', 'Create Summaries');
        batchNames.put('BatchPartnerCommissionCreateDetails', 'Create Details');
        batchNames.put('BatchPartnerCommissionCreateHistory', 'Create History');

        // fill in the statuses of batches we will monitor
        batchStatuses = new List<String>();
        batchStatuses.add('Holding');
        batchStatuses.add('Queued');
        batchStatuses.add('Preparing');
        batchStatuses.add('Processing');

        // get the setup data to query the batch jobs
        batchJobs = new Map<Id,ApexClass>([Select Id, Name from ApexClass where Name in :batchNames.keyset()]);

        RefreshPageData();
    }

    /**
     * Returns the most recent Partner Commission Summary History
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
     * @return The most recent instance of the commission summary history
     */
    public Partner_Commission_Summary_History__c GetPartnerCommissionSummaryHistory()
    {
        return pvtPartnerCommissionSummaryHistory;
    }


    /**
     * Refreshes the page data
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
     * @return Null
     */
    public PageReference RefreshPageData()
    {
        fillBillingPeriodData();
        createBatchStatus();

        return null;
    }

    /**
     * Fetches the most recent partner commission summary history from the database
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
     */
    private void fillBillingPeriodData()
    {
        pvtPartnerCommissionSummaryHistory = new Partner_Commission_Summary_History__c();

        // get the most recent record from the db
        List<Partner_Commission_Summary_History__c> pcshResults = [select Id, Name, Key__c, Active_Partners__c, Active_Partners_Closed__c, Active_Partners_Open__c, Commissionable_Revenue__c, Commissionable_Revenue_Closed__c, Commissionable_Revenue_Open__c, Commissionable_Transactions__c, Commissionable_Transactions_Closed__c, Commissionable_Transactions_Open__c, Commission_Earned__c, Commission_Earned_Closed__c, Commission_Earned_Open__c, Earliest_Start_Date__c, Earliest_Start_Date_Closed__c, Earliest_Start_Date_Open__c, Latest_End_Date__c, Latest_End_Date_Closed__c, Latest_End_Date_Open__c, Summary_Count__c, Summary_Count_Closed__c, Summary_Count_Open__c, LastModifiedDate, Partners_Paid__c, Payment_Amount__c, Payments__c, Balance__c from Partner_Commission_Summary_History__c order by Key__c desc limit 1];
        if (pcshResults.size() > 0)
        {
            pvtPartnerCommissionSummaryHistory = pcshResults[0];
        }

    }

    /**
     * Fetches the current running batch job
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link       https://jira.bigcommerce.com/browse/BAP-3698
     */
    private void createBatchStatus()
    {
        List<AsyncApexJob> apexJobs = [select Id, createdDate, ApexClassID, Status, ExtendedStatus, JobItemsProcessed, JobType, MethodName, TotalJobItems, NumberOfErrors, CompletedDate from AsyncApexJob where JobType = 'BatchApex' and ApexClassId in :batchJobs.keyset() and Status in :batchStatuses order by createddate desc];
        currentBatchStatus = new BatchMonitor();

        if (apexJobs.size() > 0)
        {
            // fill in the data from the first record
            currentBatchStatus.Id = apexJobs[0].Id;
            currentBatchStatus.Status = apexJobs[0].Status;
            currentBatchStatus.CreatedDate = apexJobs[0].CreatedDate;
            // get the friendly name of the batch job
            currentBatchStatus.JobName = batchNames.get(batchJobs.get(apexJobs[0].ApexClassID).Name);
            currentBatchStatus.NumberOfBatches = apexJobs[0].TotalJobItems;
            currentBatchStatus.NumberOfBatchesProcessed = apexJobs[0].JobItemsProcessed;
        }
    }

    /**
     * Returns the most recent batch status
     * @author Steve O'Neal
     * @date   2016-07-05
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
     * @return The most recent batch status
     */
    public BatchMonitor getBatchStatus()
    {
        return currentBatchStatus;
    }
    
    /**
     * Class used for encapsulating the batch details
     */
    public class BatchMonitor
    {
        public Datetime CreatedDate {get;set;}
        public string Id {get;set;}
        public string JobName {get;set;}
        public string Status {get;set;}
        public integer BatchSize {get;set;}
        public integer NumberOfBatches {get;set;}
        public integer NumberOfBatchesProcessed {get;set;}

        /**
         * Gets the number of records being processed, assuming a 200 record batch size
         * @author Steve O'Neal
         * @date   2016-07-05
         * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
         * @return Number of estimated records being processed in the batch
         */
        public integer getNumberOfRecords()
        {
            return NumberOfBatches * BatchSize;
        }

        /**
         * Gets the number of records already processed, assuming a 200 record batch size
         * @author Steve O'Neal
         * @date   2016-07-05
         * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
         * @return Estimated number of records already processed
         */
        public integer getNumberOfRecordsProcessed()
        {
            return NumberOfBatchesProcessed * BatchSize;
        }

        /**
         * Gets the percent completed of the batch job
         * @author Steve O'Neal
         * @date   2016-07-05
         * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
         * @return The percent completed of the batch job
         */
        public integer getProgressPercent()
        {
            if (NumberOfBatches == 0)
            {
                return 0;
            }
            else
            {
                return (NumberOfBatchesProcessed * 100) / NumberOfBatches;
            }
        }

        /**
         * Instantiator
         * @author Steve O'Neal
         * @date   2016-07-05
         * @ticket link          https://jira.bigcommerce.com/browse/BAP-3698
         * @return An instance of BatchMonitor
         */
        public BatchMonitor()
        {
            Id = '';
            BatchSize = 200;
            NumberOfBatches = 0;
            NumberOfBatchesProcessed = 0;
            Status = 'Sleeping';
            JobName = 'N/A';
        }
    }

}