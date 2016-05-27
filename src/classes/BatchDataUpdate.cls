/***********************************************************************
  File                  : BatchDataUpdate 
  API Version           : 29.0
  Created by            : Maggie Frederick
  Created Date          : 4/10/2014
  Description           : This class will update the data passed to the 
                          DataUpdate class This class also allows for the
                          process to be scheduled using the APEX scheduler.
***********************************************************************/


global class BatchDataUpdate  implements Schedulable {
    global void execute(SchedulableContext SC) {
        
        DataUpdatev2 dbu = new DataUpdatev2();
        String criteria = Label.Query_Criteria;
 //       String query1 = 'Select Name, s.Contact__c, Contact__r.Email, Contact__r.Phone, s.Email__c, s.Phone__c from Subscription__c s where Contact__c <> null ';
 //		String query1 = 'Select Name,s.Account__c, s.Account__r.Id, s.Account__r.Launch_Team_Commando__c, s.Account__r.Ltc__c, s.Account__r.SSC__c, s.Account__r.Success_Squad_Consultant__c, s.LastModifiedDate, s.Launch_Team_Commando__c, s.Success_Squad_Consultant__c from Subscription__c s  where s.Launch_Team_Commando__c <> null and  s.Success_Squad_Consultant__c <> null order by Account__r.Id asc ';
 		String query1 = 'Select c.Status, c.RecordTypeId, c.CaseNumber, c.AccountId From Case c where RecordTypeId = \'012a0000001NV9N\'';
 
        dbu.query = query1 + criteria;
        Database.executeBatch(dbu,90);
    }
    

    

}