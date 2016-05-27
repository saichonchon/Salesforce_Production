@isTest
private class TestAppRevShareAcctUpdate {

    static testmethod void test() {
        // The query used by the batch job.
        Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
        
             // Create some test opportunities to be deleted
       // by the batch job.
	   TestDataGenerator td = new TestDataGenerator();
	   list<Contact> lstCon = td.getContacts(true); 
        //test
	   Opportunity[] ml = new List<Opportunity>();
       for (Integer i=0;i<10;i++) {
           Opportunity m = new Opportunity(
               Name='Test App Opportunity ' + i,
               StageName = 'Published',
               AccountId = lstCon[0].AccountId,
               CloseDate = date.Today(),
               RecordTypeId = AppRecordTypeId); 
           ml.add(m);
       }
       insert ml;

       //Start the Testing! 
       Test.startTest(); 
       AppRevShareAcctUpdate c = new AppRevShareAcctUpdate(); 
       Database.executeBatch(c);
       Test.stopTest();

    }
}