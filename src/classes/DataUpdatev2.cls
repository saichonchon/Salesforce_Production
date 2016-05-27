/***********************************************************************
  File					: DataUpdate 
  API Version			: 29.0
  Created by			: Maggie Frederick
  Created Date			: 4/10/14

  Description			: This class will update the data passed to it 

***********************************************************************/


global class DataUpdatev2 implements Database.Batchable<sObject>{
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> cases){
 
      List <Account> alist = new List <Account>();
      Map<Id, Integer> mapOpenCases = new Map<Id, Integer>();
      Map<Id, Integer> mapClosedCases = new Map<Id, Integer>();
      Set<ID> acctIds = new Set<ID>();
                   
	   for(sObject sobj : cases)
	  {
	  	Case c  = (Case)sobj;
		
		{
			acctIds.add(c.AccountId);
			Integer newCount =0;
			if (c.Status <> 'Closed' && c.Status <> 'Completed') 
			{
				
				if (!mapOpenCases.containsKey(c.AccountId))
				{
				  newCount++;
				  mapOpenCases.put(c.AccountId, newCount++);
				}
				else
				{ 
					newCount = mapOpenCases.remove(c.AccountId) + 1;
				    mapOpenCases.put(c.AccountId, newCount);
				}
			}
			else if (c.Status == 'Closed' || c.Status == 'Completed') 
			{
				
				if (!mapClosedCases.containsKey(c.AccountId)) 
				{
					newCount++;
					mapClosedCases.put(c.AccountId, newCount);
				}
				else
				{ 
					newCount = mapClosedCases.remove(c.AccountId) + 1;
					mapClosedCases.put(c.AccountId, newCount);
				}
			}
		} 
	  }
	  for (Account a:[Select a.Id, Open_Migration_Cases__c, Closed_Migration_Cases__c From Account a where id in :acctIds ])
	  {
	  	 Integer newOpen =0;
	  	 Integer newClosed =0;
	  	 if ( mapOpenCases.get(a.Id) <> null) newOpen = a.Open_Migration_Cases__c.intValue() + mapOpenCases.get(a.Id);
	  	 if ( mapClosedCases.get(a.Id) <> null) newClosed = a.Closed_Migration_Cases__c.intValue() + mapClosedCases.get(a.Id);
	  	 
	  	 if (a.Open_Migration_Cases__c <> newOpen || a.Closed_Migration_Cases__c <> newClosed)
	  	 {
	  	 	if (a.Open_Migration_Cases__c  <> newOpen) a.Open_Migration_Cases__c  = newOpen;
	  	 	if (a.Closed_Migration_Cases__c <> newClosed) a.Closed_Migration_Cases__c = newClosed;
	  	 	alist.add(a);
	  	 }
	     
	  }
	  
      update alist;
  }
      
    

    global void finish(Database.BatchableContext BC)
    {
    // Get the ID of the AsyncApexJob representing this batch job 
    // from Database.BatchableContext. 
    
   // Query the AsyncApexJob object to retrieve the current job's information. 
    
   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :BC.getJobId()];
   // Send an email to the Apex job's submitter notifying of job completion. 
    
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {a.CreatedBy.Email};
   mail.setToAddresses(toAddresses);
   mail.setSubject('Apex Data Update ' + a.Status);
   mail.setPlainTextBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.');
//   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}