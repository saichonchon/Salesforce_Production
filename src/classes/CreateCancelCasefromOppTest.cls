/***
@Author: Maria Huemmer
@Description: Test Class to test Cancellation Case Creation from Opportunity
@History: July-21-2015 Maria Huemmer 
***/

@isTest

private class CreateCancelCasefromOppTest {
    static testMethod void testAutoRun(){
   
               
    //Create the stuff we need for the test
    //Insert user...WHEW!....
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'standt', Email='standarduser@bigcommercetestorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@bigcommercetestorg.com');
    String userid = u.id;
   
  
        //Make the Test Stuff
        
        TestDataGenerator td = new TestDataGenerator();
        
                 
        list<Account> lstAcct = td.getAccounts(true);
        ApexPages.StandardController a = new ApexPages.Standardcontroller(lstAcct[0]);
        AccountButtonController abc = new AccountButtonController(a);       
        
        list<Contact> lstCon = td.getContacts(true);
        ApexPages.StandardController c = new ApexPages.Standardcontroller(lstCon[0]);
        
        
        list<Opportunity> lstOpp = td.getOpportunities(true);
        
        //Start Test
        Test.startTest();
        
        Opportunity o = new Opportunity(CloseDate=Date.today(), StageName = 'Closed Won', AccountId = lstAcct[0].id, Name = 'Test Opp', BillingAmount__c = 10, Contact__c = lstCon[0].id, MBASubscriptionID__c = '7', ProductId__c = '7', Product__c = '7');
       
        insert o;
        System.debug(o.id);
        PageReference pageRef = Page.CreateCancelCaseFromOpp;
        Test.setCurrentPage(pageRef);      
        pageRef.getParameters().put('Id', o.Id);
        ApexPages.StandardController sc = new ApexPages.Standardcontroller(o);
     
        CreateCancelCasefromOpp def = new CreateCancelCasefromOpp(sc);
        
        def.autorun();
        
        PageReference pageNull = Page.CreateCancelCaseFromOpp;
        Test.setCurrentPage(pageNull);
        def.autorun();
        
        Test.stopTest(); 
   }
}