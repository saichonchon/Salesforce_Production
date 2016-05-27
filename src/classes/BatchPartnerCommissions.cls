global class BatchPartnerCommissions implements Schedulable {
   global void execute(SchedulableContext sc) {
      
		string queryDetails='SELECT Id, Commission_Amount__c, Commission__c, PaymentNotActivated__c, PayPal_Account_ID__c, Agreement__c, rvpe__RVPrimaryMember__r.rvpe__DateAgreedToTerms__c  FROM rvpe__RVAccount__c  where Commission__c <> null and Commission__c > 0';
 //		if(!Test.isRunningTest()){   query = query + ' limit 2';}

 //      system.Debug('#query# '+queryTrial); 
      
     
      PartnerCommissionSummary monthlySummary = new PartnerCommissionSummary(); 
      monthlySummary.query = queryDetails;
      database.executebatch(monthlySummary);

   }
}