/***********************************************************************
* File                  : BatchUpDateSurveys  
* API Version           : 29.0
* Created by            : Maggie Frederick
* Created Date          : 4/10/2014
* Description           : This class will update the data passed to the 
*                         DataUpdate class This class also allows for the
*                         process to be scheduled using the APEX scheduler.
***********************************************************************/


global class BatchUpDateSurveys implements Schedulable 
{
  global void execute(SchedulableContext SC) 
  {
    DataUpdateSurvey dbu = new DataUpdateSurvey();
    Database.executeBatch(dbu,90);
  }
}