public class CaseOwnerUpdate {
	
	private static final Id USERID = UserInfo.getUserId();
    private static final User CURUSER = [SELECT Id, Name, UserRole.Name, Profile.Name, Division FROM User WHERE Id = :UserInfo.getUserId()];
	
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
    private Map<String, String> mapOwnerQueue
    {
        get
        {
            if (mapOwnerQueue == null)
            {
                mapOwnerQueue = new map<String, String>();
                for (CaseOwnerQueue__mdt s :[select ChangeOwner_Value__c, Queue_Name__c from CaseOwnerQueue__mdt ])
				{
					mapOwnerQueue.put(s.ChangeOwner_Value__c, s.Queue_Name__c);
				}
                
            }
            
            return mapOwnerQueue;
        }
        set;
    }
       		    
    public CaseOwnerUpdate(){
    
    }
    
    public void setCaseOwner(List<Case> caseList)
    {
	   for (Case objCase :caseList) 
	   { 
         string selectedQueue = mapOwnerQueue.get(objCase.Change_Owner__c);
         
         if(objCase.Change_Owner__c == 'Support Queue')
         {
		    objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
       		objCase.Department__c = 'Support';
//		 	selectedQueue = 'Support';
         }
         else if(objCase.Change_Owner__c == 'Billing')
         {
		     objCase.Department__c = 'Billing';
		     objCase.Escalation_Date__c = System.now();  
		     objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
//		     selectedQueue = 'Billing Queue';
         }
		 else if(objCase.Change_Owner__c == 'Cancellations')
         {
		    objCase.Department__c = 'Cancellations';
       		objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Cancellations').getRecordTypeId();
 //    		selectedQueue = 'Cancellation Queue';
         }
		 else if(objCase.Change_Owner__c == 'Trash')
         {
		    objCase.Do_Not_Send_Survey__c = true;
       		objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Trash').getRecordTypeId();
 //    		selectedQueue = 'Support - Trash';
         }
         else if(objCase.Change_Owner__c == 'Legal')
         {
         	objCase.Do_Not_Send_Survey__c = true;
     		objCase.Department__c = 'Legal/Abuse';
 //           selectedQueue = 'Support - Legal/Abuse';
         }
         else if(objCase.Change_Owner__c == 'Design Support')
         {
        	if (objCase.Design_Escalated_By__c == null)
		     {
		       objCase.Design_Escalated_By__c = UserInfo.getName();
		       objCase.Design_Escalation_Date__c = System.now();
		     }
 //       	selectedQueue ='Design Support';
         }
         else if(objCase.Change_Owner__c == 'Design Approved')
         { 
         	if (objCase.Design_Approved_By__c == null)
		     {
		       objCase.Design_Approved_By__c= UserInfo.getName();
		       objCase.Design_Approved_Date__c = System.now();    
		     }
		     
  //   		selectedQueue ='Support - Design Support Approved';
         
         }
         else if(objCase.Change_Owner__c == 'Design Out Of Scope')
         { 
         	if (objCase.Design_Denied_By__c == null)
		     {
		       objCase.Design_Denied_By__c= UserInfo.getName();
		       objCase.Design_Denied_Date__c = System.now();    
		     }
 //    		selectedQueue ='Support - Design Support Out Of Scope';
         
         }
         else if(objCase.Change_Owner__c == 'API Support')
         {
         	if (objCase.Escalated_By__c == null)
		     {
		       objCase.Escalated_By__c = UserInfo.getName();
		       objCase.Escalation_Date__c = System.now();  
		     }
//     objCase.Do_Not_Send_Survey__c = true;

 //    		selectedQueue ='Support - API';
         }
         else if(objCase.Change_Owner__c == 'Tier 2')
         {
	          if (objCase.Tier_2_Requested_By__c == null)
		     {
		       objCase.Tier_2_Requested_By__c = UserInfo.getName();
		       objCase.Tier_2_Request_Date__c = System.now();    
		     }
 //      		selectedQueue ='Tier 2 Support Queue';
         }
         else if(objCase.Change_Owner__c == 'Escalation')
         {
          if (objCase.Escalated_By__c == null)
		     {
		       objCase.Escalated_By__c = UserInfo.getName();
		       objCase.Escalation_Date__c = System.now();  
		     }
     
     		objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
      		objCase.Department__c = 'Support';

//     objCase.Do_Not_Send_Survey__c = true;
     		objCase.Escalated__c = true;

  //   		selectedQueue = 'Support - Escalated Level 1';
         }
         else if(objCase.Change_Owner__c == 'Manager Callback')
         {
         	if (objCase.Manager_Callback_Requestor__c == null)
		     {
		       objCase.Manager_Callback_Requestor__c = UserInfo.getName();
		       objCase.Manager_Callback__c = true;
		       objCase.Manager_Callback_Date__c = System.Now();  
		     }

//     objCase.Do_Not_Send_Survey__c = true;
  //       	selectedQueue ='Support - Manager Callback';
         }
		 else if(objCase.Change_Owner__c == 'Migrations Specialists')
         {
		      //Check if the profile name contains Client success
	         if(!Label.Support_Escalation_Profiles.contains(CURUSER.Profile.Name))
	         {  
//	           showError = true;
	           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please request your manager to reassign Case to Migration Specialist.');
	      		ApexPages.addMessage(myMsg);
             }
      		objCase.RecordTypeId =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration Specialist').getRecordTypeId();
      		objCase.Status = 'Open Unsolved';
//		    selectedQueue = 'Migrations Specialists';
         }
         
 	     if (mpQName2Queue.containsKey(selectedQueue))
                {
                  system.debug('***CaseOwner - user selected Queue');
                    objCase.OwnerId = mpQName2Queue.get(selectedQueue).QueueId;         
                    
                } 
//	     changeOwner('Billing Queue');
	   }
    }
 /*
    public void changeOwner(String SelectedQueue)
    {
        // Ensure a case exists
        if (objCaseId != null)
        {   
                               
                // Check if user selected a queue
                if (selectedQueue != null && mpQName2Queue.containsKey(selectedQueue))
                {
                  system.debug('***CaseOwner - user selected Queue');
                    objCase.OwnerId = mpQName2Queue.get(selectedQueue).QueueId;         
                    
                }
                else
                {
                  system.debug('***CaseStopWorkingController:changeOwner - User not previously with queue and no queue selected');
                }
      	 }
   
    }

 */   

}