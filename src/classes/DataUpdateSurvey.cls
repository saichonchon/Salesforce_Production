/***********************************************************************
*  
*  File           : DataUpdateSurvey 
*  API Version    : 29.0
*  Created by     : Maggie Frederick
*  Created Date   : 4/10/14
*  Description    : This class will update the data passed to it 
*
************************************************************************/

global class DataUpdateSurvey implements Database.Batchable<sObject>
{
  public String query = 'select Id, Name, chat_key__c,Case__c, Live_Chat_Transcript__c from Support_Survey__c where Live_Chat_Transcript__c = null and chat_key__c <> null';

  global Database.QueryLocator start(Database.BatchableContext BC)
  {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<sObject> surveys)
  {

    Map<String, Support_Survey__c> mpKeyToChat = new map<String, Support_Survey__c>();
    Map<String,Id> mpChatToCase = new map<String, Id>();

    Map<Id, Support_Survey__c> updsurveys = new Map<Id, Support_Survey__c>();

    for(sObject sobj : surveys)
    {
      Support_Survey__c ss  = (Support_Survey__c)sobj;
      if ((ss.Case__c == null || ss.Live_Chat_Transcript__c == null) && ss.Chat_Key__c <> null)
      {
        mpKeyToChat.put(ss.Chat_Key__c, ss); 
      }
    }


    // Now loop through all the transcripts for these chat keys and update the ss accordingly    
    for (LiveChatTranscript l : [SELECT Id, ChatKey, CaseId FROM LiveChatTranscript l WHERE ChatKey IN :mpKeyToChat.keySet()])
    {
      if (mpKeyToChat.containsKey(l.ChatKey))
      {
        Support_Survey__c existingSupportSurvey = mpKeyToChat.get(l.ChatKey);
        existingSupportSurvey.Live_Chat_Transcript__c = l.Id;

        if (l.CaseId <> null)
        {
          existingSupportSurvey.Case__c = l.CaseId;
        }

        updSurveys.put(existingSupportSurvey.Id, existingSupportSurvey);
        system.debug('Existing Support Survey found: ' + existingSupportSurvey.Name + ' (' + existingSupportSurvey.Id + ')');
      }
    }

    List<Support_Survey__c> updSurveyList = updSurveys.values();
    update updSurveyList;
  }


  global void finish(Database.BatchableContext BC)
  {
  }
}