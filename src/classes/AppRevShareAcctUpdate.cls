global class AppRevShareAcctUpdate implements 
   Database.Batchable<sObject> {
   

     global Database.QueryLocator start(Database.BatchableContext BC)
    {  
      Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
        String published = 'Published';         
       String query = 'SELECT AccountId, Name FROM Opportunity WHERE RecordTypeId = :AppRecordTypeId AND STAGENAME =:published';  //Get the App opps
        
        system.Debug('#query# '+query); 
        return Database.getQueryLocator(query);     
    }
   
   
   global void execute(Database.BatchableContext BC, List <sObject> opps){     
               
                Set<Id> acctIds = new Set<ID>(); //initialize set to store AcctIds
                
                //Loop through the sObject opps and get the account Ids and put in a set
                for(Sobject sO : opps) //Collect App Opp Account IDs in a list 
                
                {
                  Opportunity opp = (Opportunity)sO;  //cast the sObject as if it's an opportunity
                  acctIds.add(opp.AccountId);
                }
                
                              
                List<account> aa = new list<account>([SELECT Id, App_Send_Rev_Share_Email__c FROM ACCOUNT WHERE Id IN:acctIds]);
               
               //Set Account "App Send Rev Share Email" date to Today
                
                for (Account a :aa)
                  { 
                      a.App_Send_Rev_Share_Email__c = Date.Today(); //workflow rule is triggered from this
                      
                  }
                update aa;
           
 
}

   global void finish(Database.BatchableContext BC){
       AsyncApexJob a = 
           [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
                          
       // Send an email to the Apex job's submitter 
       //   notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('App Partner Account Update Status: ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }
}