global class BatchUpdateCommissionStatus implements Schedulable{
	
	global void execute(SchedulableContext sc) { 

	    String q = 'Select Id, Commission_Payment_Status__c from rvpe__RVAccount__c  where 	Commission_Payment_Status__c = \'In Progress\'';
		String e = 'rvpe__RVAccount__c';
		String f = 'Commission_Payment_Status__c';
		String v = 'Completed';
		Id batchInstanceId = Database.executeBatch(new UpdateFields(q,e,f,v), 95); 
	   
	}

}