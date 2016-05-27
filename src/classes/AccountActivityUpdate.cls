global class  AccountActivityUpdate implements Database.Batchable<sObject>, Database.Stateful
{ 
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
 
        return Database.getQueryLocator(query);     
    }

    //Method where business logic gets executed
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
       Set<String> setCallResult = new Set<String>{'correct contact','contact','set callback', 'Success'};
		List<Task> updlstTasks = new List<Task>();
		for(Sobject s : scope)
        { 
	        System.Debug('User1 scope size#'+scope.size());
	       Task obj = (Task)s;
		
		 	if ( obj.Subject!=null && obj.Type!=null &&
                ( obj.Type.equalsIgnoreCase('Email') 
             		&& (obj.Subject.startsWith('←') || obj.ToutApp__Tout_Replied__c == true )
            	)
          		||  ( obj.Type.equalsIgnoreCase('Call') && obj.CallDisposition!=null 
          		      && setCallResult.contains(obj.CallDisposition.toLowerCase()) )
              )
              	{                      
 					updLstTasks.add(obj);
		    	}
		  }

		  TaskHandler.validActivityUpdate(updlstTasks);
    } 
    
    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process  Update Account Activity Completed');
        mail.setPlainTextBody('Batch Process has completed');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}