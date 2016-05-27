/***********************************************************************
  File          : DataUpdateSurvey 
  API Version      : 29.0
  Created by      : Maggie Frederick
  Created Date      : 4/10/14

  Description      : This class will update the data passed to it 

***********************************************************************/

global class DataUpdateSurvey implements Database.Batchable<sObject>{
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
 global void execute(Database.BatchableContext BC, List<sObject> surveys){
 
    Map<String, Support_Survey__c> mpKeyToChat = new map<String, Support_Survey__c>();
	Map<String,Id> mpChatToCase = new map<String, Id>();
	
	List <Support_Survey__c> updsurveys = new List <Support_Survey__c>();
                  
    for(sObject sobj : surveys)
    {
      Support_Survey__c ss  = (Support_Survey__c)sobj;
      if ((ss.Case__c == null || ss.Live_Chat_Transcript__c == null) && ss.Chat_Key__c <> null)
       { mpKeyToChat.put(ss.Chat_Key__c, ss); }
     }
 /*  
 // Now loop through all the cases for these chat keys and update the ss accordingly    
    for (Case c : [SELECT Id, Chat_Key__c
            		FROM Case
            		WHERE  Chat_Key__c IN :mpKeyToChat.keySet()])
    {
        mpChatToCase.put(c.Chat_Key__c, c.Id);
        
        system.debug('  test case' +c.Id);
      
    }
*/

// Now loop through all the transcripts for these chat keys and update the ss accordingly    
    for (LiveChatTranscript l : [SELECT Id, ChatKey, CaseId FROM LiveChatTranscript l
            						WHERE  ChatKey IN :mpKeyToChat.keySet()])
    {
      if (mpKeyToChat.containsKey(l.ChatKey))
      {
        Support_Survey__c upd = mpKeyToChat.get(l.ChatKey);
        upd.Live_Chat_Transcript__c = l.Id;
        if (l.CaseId <> null) upd.Case__c = l.CaseId;
 //       else
 //       { if (mpChatToCase.get(l.ChatKey) <> null) upd.Case__c = mpChatToCase.get(l.ChatKey);}
        updSurveys.add(upd);
       system.debug('  test  l ' +upd.Name);
      }
    }

	 update updSurveys;


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
   mail.setSubject('Apex Data Update Survey' + a.Status);
   mail.setPlainTextBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.');
//   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}