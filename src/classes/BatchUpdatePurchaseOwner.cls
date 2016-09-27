global class BatchUpdatePurchaseOwner implements Schedulable {
   global void execute(SchedulableContext sc) {
      
       //Prepare Query to query all Opps where owner is not Queue or partner prospect record type
        string queryPurchase ='Select Id, Name, AccountId, OwnerId, StageName, PurchaseDate__c, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c from Opportunity Where  RecordTypeId = :storeRecordTypeId  ' ;
 		queryPurchase = queryPurchase + Label.ROE_Purchase_Query;
 		if(Test.isRunningTest()){   queryPurchase = queryPurchase + ' limit 2';}
        system.Debug('#query# '+queryPurchase); 
      
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryPurchase;
      database.executebatch(b);

   }

}