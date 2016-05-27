@isTest(seeAllData=false) 
public class TestBatch {

    public static testmethod void test_batch() {
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        Test.startTest();
// Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BatchDataUpdate());
        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same 
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run  
        
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run  
        
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        //Test the actual code run
        DataUpdatev2 sCons = new DataUpdatev2();
 //        sCons.query = 'Select s.Contact__c, Contact__r.Email, Contact__r.Phone, s.Email__c, s.Phone__c from Subscription__c s where Contact__c <> null limit 1';
         sCons.query = 'Select c.Status, c.RecordTypeId, c.CaseNumber, c.AccountId From Case c where RecordTypeId = \'012a0000001NV9N\' limit 1';
        
        Database.executeBatch(sCons);
        Test.StopTest();
    }

    public static testmethod void test_batchupdSurvey() {
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        Test.startTest();
// Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BatchUpDateSurveys());
        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same 
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run  
        
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run  
        
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        //Test the actual code run
        DataUpdateSurvey dbu = new DataUpdateSurvey();
        String query1 = 'select Id, Name, chat_key__c,Case__c, Live_Chat_Transcript__c from Support_Survey__c where Live_Chat_Transcript__c = null and chat_key__c  <> null limit 1';
 
        dbu.query = query1 ;
        Database.executeBatch(dbu,90);        
        
        Test.StopTest();
    }
    

}