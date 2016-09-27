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
		 objCase.Department__c = 'Cancellations';
	     objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Cancellations').getRecordTypeId();
 
		 changeOwner('Cancellation Queue');
		 
    	  return pr;

    }
 	 
 	 public pageReference setCaseToTrash()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
	  
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
		 objCase.Escalated__c = true;

		 changeOwner('Support - Escalated Level 1');
		 
    	  return pr;

    }
     public pageReference setCaseToLegal()
    {
		 pageReference pr = new PageReference('/'+objCaseId);    
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
	                	lstCaseToUpdate.add(objCase);
	                	
	                    database.update(lstCaseToUpdate, dml);	                    
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