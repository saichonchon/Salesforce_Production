/**********************************************************************
 
Name:  CaseAutoSyncWithJira
  
========================================================
 Purpose:                                                           
 
After Trigger to autosync case with Jira on insert and update.
========================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick  9/1/2013  Initial development
 
***********************************************************************/
trigger CaseAutoSyncWithJira on Case (after insert, after update) {
 
 // 10/11/2013 - Ensure this is not being called by a future class
 if (!system.isFuture())
 {
        Id migRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
        
        
        //Identify profile name to be blocked from executing this trigger
        String JIRAAgentProfileName = Label.Jira_Agent_Profile;
        List<Profile> p = [SELECT Id FROM Profile WHERE Name=:JIRAAgentProfileName];
 
        //Check if specified Profile Name exist or not
        if(!p.isEmpty())
        {
            //Check if current user's profile is catergorized in the blocked profile
            if(UserInfo.getProfileId()!= String.valueOf(p[0].id))
            {
              if (Trigger.isInsert)
              { 
                   for (Case c : Trigger.new) 
                   {     
                      if (c.RecordTypeId == migRecordType && c.Migration_Partner__c == 'EIG')       
                      {
                          String objectId = c.id;
                          String jiraType = 'Jira for EIG';   
                             
                            //Execute the callout
                            JIRAConnectorWebserviceCallout.createIssue(jiraType, objectId);
                       }
 /* Comment out below until Sydney instance is ready
                       else  if (c.RecordTypeId == migRecordType )       
                      {
                          String objectId = c.id;
                          String jiraType = 'Jira for AUS';   
                             
                            //Execute the callout
                            JIRAConnectorWebserviceCallout.createIssue(jiraType, objectId);
                       }
*/
                    }
               }
               else if (Trigger.isUpdate)
               {
                 for (Case c : Trigger.new) 
                   {     
                      if (c.RecordTypeId == migRecordType && c.Migration_Partner__c == 'EIG')       
                      {
                          String objectId = c.id;
                          String jiraType = 'Jira for EIG';   
                             
                            //Execute the callout
                            JIRAConnectorWebserviceCallout.syncIssue(jiraType, objectId);
                       }
                       else if (c.RecordTypeId == migRecordType )       
                      {
                          String objectId = c.id;
                          String jiraType = 'Jira for AUS';   
                             
                            //Execute the callout
                            JIRAConnectorWebserviceCallout.syncIssue(jiraType, objectId);
                       }
                    }
               
               }
            }
         }
 }
      
}