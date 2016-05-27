global class BatchUpdateUpsellOwner implements Schedulable {
   global void execute(SchedulableContext sc) {
      
       //Prepare Query to query all Opps where owner is not Queue or partner prospect record type
        string queryUpsell ='Select Id, Name, AccountId, OwnerId, StageName, PurchaseDate__c, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c from Opportunity Where  RecordType.Name = \'Upgrade Store\'  ' ;
 		queryUpsell = queryUpsell + Label.ROE_Upsell_Query;
 		if(Test.isRunningTest()){   queryUpsell = queryUpsell + ' limit 2';}
        //CreatedDate < LAST_N_DAYS:90 and Owner_Team__c = \'Outbound\' AND stageName <> 'Closed Won' limit 100 ';
        system.Debug('#query# '+queryUpsell); 
      
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryUpsell;
      database.executebatch(b);

   }

}