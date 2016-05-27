global class BatchUpdateAccount implements Schedulable{
	
	global void execute(SchedulableContext sc) {
		
		//Prepare Query to query all Opps where owner is not Queue or partner prospect record type
        string query ='SELECT AccountId, WhoId, Subject, ActivityDate, CallDisposition, Type, OwnerId, ToutApp__Tout_Replied__c  FROM Task where AccountID <> null and CreatedDate = LAST_90_DAYS And (Type = \'Call\' or Type = \'Email\') AND Status = \'Completed\' and (Owner.ProfileId =\'00e130000024OSc\' or Owner.ProfileId =\'00e13000000jUyt\') ' ;
 		query = query + Label.ROE_AccountActivity_Query;
 //		if(Test.isRunningTest()){   query = query + ' limit 2';}
        system.Debug('#query# '+query); 
      
      
	      AccountActivityUpdate b = new AccountActivityUpdate(); 
	      b.query = query;
	      database.executebatch(b);
      
   }

}