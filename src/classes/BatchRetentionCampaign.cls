/***********************************************************************
  File                  : BatchAddToCampaign 
  Created by            : Maggie Frederick
  Created Date          : 1/2016
  Description           : This class  also allows for the
                          process to be scheduled using the APEX scheduler.
***********************************************************************/

global class BatchRetentionCampaign  implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        RetentionCampaignUpdate opps = new RetentionCampaignUpdate();
 //       String criteria = Label.Query_Criteria;
       
       Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
        String query1 = 'Select contact__r.Id, contact__r.Primary_MBA_Contact__c, AccountId, bi_Data__r.Lifetime_GMV__c From Opportunity where RecordTypeId = :storeRecordTypeId and Status__c = \'Active\'  ';
        query1 += ' and purchaseDate__c = LAST_N_DAYS:180  and purchasedate__c < LAST_N_DAYS:30 ';
		query1 += ' and contact__r.MailingCountry like \'US%\' and MonthlyRecurringRevenue__c > 0 and contact__r.HasOptedOutOfEmail=false and Contact__r.Email <> null ';
 		query1 += ' and BA_Testing_Opportunity__c = false and Account.Testing_Account__c = false ';
 		
 		if(Test.isRunningTest()){   query1 = query1 + ' limit 2';}
         
        opps.query = query1;
        Database.executeBatch(opps,90);
    }
 

}