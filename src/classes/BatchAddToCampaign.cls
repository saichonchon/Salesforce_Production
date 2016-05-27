/***********************************************************************
  File                  : BatchAddToCampaign 
  API Version           : 34.0
  Created by            : Maggie Frederick
  Created Date          : 10/2015
  Description           : This class  also allows for the
                          process to be scheduled using the APEX scheduler.
***********************************************************************/

global class BatchAddToCampaign  implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        CampaignContactsUpdate opps = new CampaignContactsUpdate();
 //       String criteria = Label.Query_Criteria;
       
       Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
        String query1 = 'Select contact__r.Id, contact__r.Primary_MBA_Contact__c, RecordTypeId, AccountId, bi_Data__r.Previous_months_GMV__c, bi_Data__r.Previous_Month_GMV_Date__c  From Opportunity where RecordTypeId = :storeRecordTypeId and Status__c = \'Active\' and MonthlyRecurringRevenue__c > 0';
 		if(Test.isRunningTest()){   query1 = query1 + ' limit 2';}
        
        opps.query = query1; 
        Database.executeBatch(opps,90);
    }
 
}