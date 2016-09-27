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
      String query1 = 'Select c.Status, c.RecordTypeId, c.CaseNumber, c.AccountId From Case c where RecordTypeId = \'012a0000001NV9N\'';
 
        dbu.query = query1 + criteria;
        Database.executeBatch(dbu,90);
    }  
}