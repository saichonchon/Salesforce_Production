global class BatchUpdateOwner implements Schedulable {
   global void execute(SchedulableContext sc) {
      
       Id TrialRecordTypeId =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Trial').getRecordTypeId();

     //Prepare Query to query all Opps where owner is not Queue or partner prospect record type
        string queryTrial ='Select Id, Name, PurchaseDate__c, AccountId, OwnerId, Owner.Name, StageName, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c from Opportunity Where  RecordTypeId = :trialRecordTypeId  ' ;
 		queryTrial = queryTrial + Label.ROE_Trial_Query;
 //		if(!Test.isRunningTest()){   query = query + ' limit 2';}
        //CreatedDate < LAST_N_DAYS:90 and Owner_Team__c = \'Outbound\'  limit 100 ';
        system.Debug('#query# '+queryTrial); 
      
      
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryTrial;
      database.executebatch(b);

/*      
      ROEForPurchasedOpps storeroe = new ROEForPurchasedOpps();
   	  database.executebatch(storeroe);
   	  
   	  ROEForUpsellOpportunity upsells = new ROEForUpsellOpportunity ();
   	  database.executebatch(upsells);
 */
   }

}