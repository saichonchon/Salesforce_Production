// changing to use cronsights
public class CaseStopWorkingController 
{
    private static final Id USERID = UserInfo.getUserId();
    private static final User CURUSER = [SELECT Id, Name, UserRole.Name, Profile.Name, Division FROM User WHERE Id = :UserInfo.getUserId()];
    private ApexPages.StandardController controller;
 //   private Case_Time_Worked__c objCTW;
    private boolean showQueueSelection = false;
    private boolean showError = false;
    private final Case thiscase ;
    
    
    private map<String, QueueSobject> mpQName2Queue
    {
        get
        {
            if (mpQName2Queue == null)
            {
                mpQName2Queue = new map<String, QueueSobject>();
                
                for (QueueSobject q : [SELECT SobjectType, Queue.Name, QueueId, Id 
                                            FROM QueueSobject
                                            WHERE SobjectType = 'Case'
                                            ORDER BY Queue.Name])
                {
                    mpQName2Queue.put(q.Queue.Name, q);
                }
            }
            
            return mpQName2Queue;
        }
        set;
    }
    
    public Case objCase;
    public Id objCaseId;
    
    public boolean getshowQueueSelection()
    {
        return showQueueSelection;
    }
    
    public boolean getshowError()
    {
    	return showError;
    }
    
    public string selectedQueue {get; set;} 
    
    public list<SelectOption> lstCaseQueues
    {
        get
        {
            list<SelectOption> lstOpt = new list<SelectOption>();
            lstOpt.add(new SelectOption('', '-- Select Queue --'));
            // Query for the available case queues
            for (QueueSobject q : mpQName2Queue.values())
            {
                lstOpt.add(new SelectOption(q.Queue.Name, q.Queue.Name));
            }
            
            return lstOpt;
        }
    }
    
    public CaseStopWorkingController(ApexPages.StandardController cntrl) 
    {
        controller = cntrl;
      
        objCaseId = cntrl.getId();
        objCase = (Case)cntrl.getRecord();
        thisCase = [Select Id, Status, Escalated_by__c, Design_Escalated_by__c, Design_Approved_by__c, Design_Denied_by__c, Tier_2_Requested_By__c, Manager_Callback_Requestor__c, Owner.Name, Owner.Type from Case where Id = :objCaseId];
        system.debug('case = '+thisCase);
        
    }
    
/*
    public pageReference setCaseToQueue()
    {
        pageReference pr = null;        
        boolean updateCase = false;
        
        system.debug('***CaseStopWorkingController:setCaseToQueue - objCaseId: ' + objCaseId);
        
        // Ensure a case exists
        if (objCaseId != null)
        {                   
        	// Ensure the case is currently owned by a user (not a queue)
        	Case cs = CaseHandle_Helper.getCaseList(new set<Id>{objCaseId})[0];
        	system.debug('***CaseStopWorkingController:setCaseToQueue - cs: ' + cs);
        	
 //       	if (cs.Owner.Type == 'User')
 //       	{
	            // Check if this case was assigned to a queue before this user owned it
	            objCTW = CaseHandle_Helper.findLastQueueForCase(objCaseId);
	            
	            system.debug('***CaseStopWorkingController:setCaseToQueue - objCTW: ' + objCTW);
	            system.debug('***CaseStopWorkingController:setCaseToQueue - selectedQueue: ' + selectedQueue);
	            
	            // If it was previously assigned to a valid queue and not currently assigned to a queue
	            if (cs.Owner.Type == 'User')
	            {
		            if (objCTW != null && objCTW.Owner_from_ID__c != null && mpQName2Queue.containsKey(objCTW.Owner_from_Name__c))
		            {
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - previously assigned to Queue');
		                objCase.OwnerId = objCTW.Owner_from_ID__c;          
		                updateCase = true;      
		            }
		            // Check if user selected a queue
		            else if (selectedQueue != null && mpQName2Queue.containsKey(selectedQueue))
		            {
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - user selected Queue');
		                objCase.OwnerId = mpQName2Queue.get(selectedQueue).QueueId;         
		                updateCase = true;
		            }
		            else
		            {
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - User not previously with queue and no queue selected');
		            }
	            }
	            else
	            {
	            	updateCase = true;
	            }
	            
	            if (updateCase)
	            {
	                try
	                {
	                	system.debug('***CaseStopWorkingController:setCaseToQueue - Updating Case');	                	
	                	
	                	// Make sure to set the DML Options to not send any emails
	                	database.Dmloptions dml = new database.Dmloptions();
	                	dml.emailHeader.triggerAutoResponseEmail = false;
	                	dml.emailHeader.triggerUserEmail = false;
	                	dml.emailHeader.triggerOtherEmail = false;
	                	
	                	list<Case> lstCaseToUpdate = new list<Case>();
	                	objCase.setOptions(dml);
	                	
	                	lstCaseToUpdate.add(objCase);
	                	
	                    database.update(lstCaseToUpdate, dml);
	                    
	                    CaseHandle_Helper.case_StopWorking(objCase);
	                    
	                    pr = controller.cancel();
	                }
	                catch(Exception exc)
	                {
	                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred returing Case to Queue....Please contact your support department');
	                    ApexPages.addMessage(myMsg);
	                    system.debug('***ERROR: CaseStopWorkingController:setCaseToQueue: ' + exc.getStackTraceString());
	                }
	            }
	            else
	            {
	                showQueueSelection = true;
	            }
        	}
        	else
        	{
        		showError = true;
        		
        		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, 'Cannot perform the action "Return To Queue" for a Case already owned by a Queue');
                ApexPages.addMessage(myMsg);
                system.debug('***WARNING: CaseStopWorkingController:setCaseToQueue: Cannot "Return To Queue" for Case already owned by a Queue: ' + objCaseId);
        	}
//        }
///        else
        {
        	// Return the user to the page which they came
 //           pr = controller.cancel();
        }
//        pr= new PageReference('/500)');
// /
//		pr = controller.cancel();
        return pr;
    }
    
    public pageReference setCaseToQueue()
    {
        pageReference pr = null;        
        boolean updateCase = false;
        
        system.debug('***CaseStopWorkingController:setCaseToQueue - objCaseId: ' + objCaseId);
        
        // Ensure a case exists
        if (objCaseId != null)
        {                   
        	// Ensure the case is currently owned by a user (not a queue)
        	Case cs = CaseHandle_Helper.getCaseList(new set<Id>{objCaseId})[0];
        	system.debug('***CaseStopWorkingController:setCaseToQueue - cs: ' + cs);
        	
        	if (cs.Owner.Type == 'User')
        	{
	            // Check if this case was assigned to a queue before this user owned it
	            
	            
	            // If it was previously assigned to a valid queue and not currently assigned to a queue
	            if (cs.Queue_Name__c <> null && mpQName2Queue.containsKey(cs.Queue_Name__c))
	            	{
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - previously assigned to Queue');
		                cs.OwnerId = mpQName2Queue.get(cs.Queue_Name__c).QueueId ;     
		                system.debug('***CaseStopWorkingController:setCaseToQueue - assigned to Queue' +cs.OwnerId);     
		                changeOwner(cs.Queue_Name__c);     
		                pr = new PageReference('/'+objCaseId);
		            }
		            // Check if user selected a queue
		        else if (selectedQueue != null && mpQName2Queue.containsKey(selectedQueue))
		            {
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - user selected Queue');
		                cs.OwnerId = mpQName2Queue.get(selectedQueue).QueueId;         
		                changeOwner(selectedQueue);    
		            }
		            else
		            {
		            	system.debug('***CaseStopWorkingController:setCaseToQueue - User not previously with queue and no queue selected');
		            }
	            }
	            
	        else
	        {
	            showQueueSelection = true;
	        }
        }
      
       return pr;
    }
    
    public pageReference setCaseToPrevQueue()
    {
    	pageReference pr = new PageReference('/'+objCaseId);  
    	if (objCase.Queue_Name__c <> null && mpQName2Queue.containsKey(objCase.Queue_Name__c))
    	{
        	system.debug('***CaseStopWorkingController:setCaseToQueue - previously assigned to Queue');
            objCase.OwnerId = mpQName2Queue.get(objCase.Queue_Name__c).QueueId ;     
            system.debug('***CaseStopWorkingController:setCaseToQueue - assigned to Queue' +objCase.OwnerId);     
 
            changeOwner(objCase.Queue_Name__c);     
             
        }
    	else
    	{
    		changeOwner('Support');
    	}
    	
    	return pr;
    }
 */   
    public pageReference setCaseToBilling()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
		 objCase.Department__c = 'Billing';
		 objCase.Escalation_Date__c = System.now();	
		 objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
 		 
		 changeOwner('Billing Queue');
		 
     	 return pr;

    }
     public pageReference setCaseToAPI()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
		 if (thisCase.Escalated_By__c == null)
		 {
			 objCase.Escalated_By__c = UserInfo.getName();
			 objCase.Escalation_Date__c = System.now();	
		 }
//		 objCase.Do_Not_Send_Survey__c = true;

		 changeOwner('Support - API');
		 
		 
		 return pr;

    }
    
    public pageReference setCaseToTier2()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
		 if (thisCase.Tier_2_Requested_By__c == null)
		 {
			 objCase.Tier_2_Requested_By__c = UserInfo.getName();
			 objCase.Tier_2_Request_Date__c = System.now();		
		 }
  		 changeOwner('Tier 2 Support Queue');
		 
		 
		 return pr;

    }
    
     public pageReference setCaseToDesignSupport()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
		 if (thisCase.Design_Escalated_By__c == null)
		 {
			 objCase.Design_Escalated_By__c = UserInfo.getName();
			 objCase.Design_Escalation_Date__c = System.now();
		 }
		
		 changeOwner('Design Support');
		 
		 
		 return pr;

    }
    
    public pageReference setCaseToDesignApproved()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  

/*		 //Check if the division contains Tier 2 or Escalation
         if(CURUSER.Division <> null 
            && (CURUSER.Division.containsIgnoreCase ('Tier 2')
         		|| CURUSER.Division.containsIgnoreCase ('Escalation'))
         )
         {
         	changeOwner('Support - Design Support Approved');
         }
         else
         {	
         	showError = true;
         	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Only Tier 2/Escalation Team can perform this action.');
			ApexPages.addMessage(myMsg);
			return null;
         	
         }
*/		 
		if (thisCase.Design_Approved_By__c == null)
		 {
			 objCase.Design_Approved_By__c= UserInfo.getName();
			 objCase.Design_Approved_Date__c = System.now();		
		 }
		 
		 changeOwner('Support - Design Support Approved');
		 
		 return pr;

    }
    public pageReference setCaseToDesignOOscope()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
 /*
 //Check if the division contains Tier 2 or Escalation
         
         if(CURUSER.Division <> null 
            && (CURUSER.Division.containsIgnoreCase ('Tier 2')
         	|| CURUSER.Division.containsIgnoreCase ('Escalation'))
         )
         {
         	 changeOwner('Support - Design Support Out Of Scope');
         }
         else
         {	
         	showError = true;
         	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Only Tier 2/Escalation Team can perform this action.');
			ApexPages.addMessage(myMsg);
			return null;
         	
         }
*/		 
		if (thisCase.Design_Denied_By__c == null)
		 {
			 objCase.Design_Denied_By__c= UserInfo.getName();
			 objCase.Design_Denied_Date__c = System.now();		
		 }
		 
		 changeOwner('Support - Design Support Out Of Scope');
		 
		 return pr;

    }
    public pageReference setCaseToSupport()
    {
		 pageReference pr = new PageReference('/'+objCaseId);  
		 objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
 		  objCase.Department__c = 'Support';

		 changeOwner('Support');
		 
		 
		 return pr;

    }
	 public pageReference setCaseToCancel()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
/*		 if (thisCase.Escalated_By__c == null)
		 {
			 objCase.Escalated_By__c = UserInfo.getName();
			 objCase.Escalation_Date__c = Date.today();
		 }
*/		 
//		 objCase.Do_Not_Send_Survey__c = true;
		 objCase.Department__c = 'Cancellations';
	     objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Cancellations').getRecordTypeId();
 
		 changeOwner('Cancellation Queue');
		 
    	  return pr;

    }
 	 
 	 public pageReference setCaseToTrash()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
/*		 if (thisCase.Escalated_By__c == null)
		 {
			 objCase.Escalated_By__c = UserInfo.getName();
			 objCase.Escalation_Date__c = Date.today();
		 }
*/		  
		 objCase.Do_Not_Send_Survey__c = true;
		 
	     objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Trash').getRecordTypeId();
 
		 changeOwner('Support - Trash');
		 
    	  return pr;

    }
    public pageReference setCaseToMigSp()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
		 
		 //Check if the profile name contains Client success
         if(!Label.Support_Escalation_Profiles.contains(CURUSER.Profile.Name))
         {	
         	showError = true;
         	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please request your manager to reassign Case to Migration Specialist.');
			ApexPages.addMessage(myMsg);
			return null;
         	
         }
//		 objCase.Do_Not_Send_Survey__c = true;
		 
	     objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration Specialist').getRecordTypeId();
 		 objCase.Status = 'Open Unsolved';
		 
		 changeOwner('Migrations Specialists');
		 
    	  return pr;

    }
    
    public pageReference setCaseToCallbackDesign()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
		
		 changeOwner('Support - Design Callback');
		 
    	 return pr;

    }
    
    public pageReference setCaseToEscalated1()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
		 if (thisCase.Escalated_By__c == null)
		 {
			 objCase.Escalated_By__c = UserInfo.getName();
			 objCase.Escalation_Date__c = System.now();	
		 }
		 
		 objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
 		 objCase.Department__c = 'Support';

//		 objCase.Do_Not_Send_Survey__c = true;
		 objCase.Escalated__c = true;

		 changeOwner('Support - Escalated Level 1');
		 
    	  return pr;

    }
     public pageReference setCaseToLegal()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
/*		 if (thisCase.Escalated_By__c == null)
		 {
			 objCase.Escalated_By__c = UserInfo.getName();
			 objCase.Escalation_Date__c = Date.today();
		 }
*/
		 objCase.Do_Not_Send_Survey__c = true;
		 objCase.Department__c = 'Legal/Abuse';

		 changeOwner('Support - Legal/Abuse');
		
		 return pr;

    }
     public pageReference setCaseToMgrCallback()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
		 if (thisCase.Manager_Callback_Requestor__c == null)
		 {
			objCase.Manager_Callback_Requestor__c = UserInfo.getName();
		 	objCase.Manager_Callback__c = true;
		 	objCase.Manager_Callback_Date__c = System.Now();	
		 }

//		 objCase.Do_Not_Send_Survey__c = true;

		 changeOwner('Support - Manager Callback');
		 
		 return pr;

    }
 
    public pageReference setCaseTier2Actions()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
		 objCase.Tier_2_Requested_By__c = thisCase.Owner.Name;
		 objCase.Tier_2_Agent__c = UserInfo.getName();
		 objCase.Tier_2_Request_Date__c = System.now();
		 
		 // Make sure to set the DML Options to not send any emails
	                	database.Dmloptions dml = new database.Dmloptions();
	                	dml.emailHeader.triggerAutoResponseEmail = false;
	                	dml.emailHeader.triggerUserEmail = false;
	                	dml.emailHeader.triggerOtherEmail = false;
		 list<Case> lstCaseToUpdate = new list<Case>();
	                	objCase.setOptions(dml);
	                	system.debug(' *** testing  '+objCase.Tier_2_Requested_By__c);
	                	lstCaseToUpdate.add(objCase);
	                    database.update(lstCaseToUpdate, dml);

		 return pr;

    }
    
    public void changeOwner(String SelectedQueue)
    {
               
		StaticVariables.caseOwnerButtonUpdate = true;
         
        system.debug('***CaseStopWorkingController:changeOwner - objCaseId: ' + objCaseId);
        boolean updateCase = false;
        // Ensure a case exists
        if (objCaseId != null)
        {   
		                  
		            updateCase = true;      
		            		           
		            // Check if user selected a queue
		            if (selectedQueue != null && mpQName2Queue.containsKey(selectedQueue))
		            {
		            	system.debug('***CaseStopWorkingController:changeOwner - user selected Queue');
		                objCase.OwnerId = mpQName2Queue.get(selectedQueue).QueueId;         
						CaseOwnerQueue__mdt caseOwner = [select ChangeOwner_Value__c, Queue_Name__c from CaseOwnerQueue__mdt where Queue_Name__c =:SelectedQueue limit 1];
						objCase.Change_Owner__c= caseOwner.ChangeOwner_Value__c;
		                updateCase = true;
		            }
		            else
		            {
		            	system.debug('***CaseStopWorkingController:changeOwner - User not previously with queue and no queue selected');
		            }
	     }
	           
	            
	            if (updateCase)
	            {
	                try
	                {
	                	system.debug('***CaseStopWorkingController: - Updating Case');	                	
	                	
	                	// Make sure to set the DML Options to not send any emails
	                	database.Dmloptions dml = new database.Dmloptions();
	                	dml.emailHeader.triggerAutoResponseEmail = false;
	                	dml.emailHeader.triggerUserEmail = false;
	                	dml.emailHeader.triggerOtherEmail = false;
	                	
	                	list<Case> lstCaseToUpdate = new list<Case>();
	                	objCase.setOptions(dml);
//	                	system.debug(' *** testing  '+objCase.Escalated_By__c);
	                	lstCaseToUpdate.add(objCase);
	                	
	                    database.update(lstCaseToUpdate, dml);
	                    
//	                    CaseHandle_Helper.case_StopWorking(objCase);
	                    
	                    
	                }
	                catch(Exception exc)
	                {
	                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred returing Case to Queue....Please contact your support department');
	                    ApexPages.addMessage(myMsg);
	                    system.debug('***ERROR: CaseStopWorkingController:changeOwner: ' + exc.getStackTraceString());
	                }
	            }
	 
    }
}