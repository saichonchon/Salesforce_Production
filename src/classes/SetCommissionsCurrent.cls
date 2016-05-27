global class  SetCommissionsCurrent  implements Database.Batchable<sObject>, Database.Stateful
{
    public String query;
    global Boolean Flag;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
        return Database.getQueryLocator(query);     
    }

    //Method where business logic gets executed
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
 		
 		list<Partner_Commission__c> lstCurParComs = new list<Partner_Commission__c>();
 		list<Partner_Commission__c> lstPastParComs = new list<Partner_Commission__c>();
 		
 		Integer cyy = Date.Today().year();
        Integer cmm = Date.Today().month();
  		
        for (Integer i = 0, cnt = scope.size(); i < cnt; i++) 
        
        { 
	        System.Debug('User1 scope size#'+scope.size());
	        Partner_Commission__c obj = ( Partner_Commission__c) scope[i];
	        System.Debug('User1 scope '+obj.Id);
			if (obj.IncludeInCurrentMonth__c == false  
				&& obj.Current_Month__c == true)	
			{
				obj.IncludeInCurrentMonth__c = true;
				lstCurParComs.add(obj);
			}
         	else if (obj.IncludeInCurrentMonth__c == true  
	  			&& obj.Current_Month__c == false)
         	{
				lstPastParComs.add(obj);
			}
         	
         	 		
       }
        system.debug(' size of current '+lstCurParComs.size());
        system.debug(' size of past '+lstpastParComs.size());
        if(!lstCurParComs.isEmpty()) updateCurrComm(lstCurParComs);   
        if(!lstPastParComs.isEmpty()) updatePastComm(lstPastParComs);  
    }

    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
 
 	private void updateCurrComm(List<Partner_Commission__c> lstUpdData)
    {
		       
        
            for(Partner_Commission__c obj:lstUpdData)
            {
                obj.IncludeInCurrentMonth__c =  true;
               
            }
            
            // Update the  List.
            if(!lstUpdData.isEmpty()){
               update lstUpdData;
            }     
           
        
    }
  	private void updatePastComm(List<Partner_Commission__c> lstUpdData)
    {
		
        
            for(Partner_Commission__c obj:lstUpdData)
            {
                obj.IncludeInCurrentMonth__c =  false;
                
            }
            
            // Update the  List.
            if(!lstUpdData.isEmpty()){
               update lstUpdData;
            }     
           
        
    }
}