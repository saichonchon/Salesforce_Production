global class BatchSetCurrentMonthCommissions implements Schedulable {
   global void execute(SchedulableContext sc) {
      
		string queryDetails='Select Id, p.Payment_Date__c, p.PaymentYear__c, p.PaymentMonth__c, p.IncludeInCurrentMonth__c, p.Current_Month__c From Partner_Commission__c p ';
     	 queryDetails =  queryDetails +'where (current_month__c = true  and IncludeInCurrentMonth__c = false) or (current_month__c = false and IncludeInCurrentMonth__c = true) ';
     
      SetCommissionsCurrent commissions = new SetCommissionsCurrent(); 
      commissions.query = queryDetails;
      database.executebatch(commissions);

   }
}