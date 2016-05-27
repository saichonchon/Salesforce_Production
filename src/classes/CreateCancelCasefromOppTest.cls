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
        
                
        
   // Account a = new Account(Name='My Account');
   // Contact c = new Contact(AccountId = a.id, LastName='Testerson');
 //Opportunity o = new Opportunity(CloseDate=Date.today(), StageName = 'Closed Won', AccountId = a.accountid, Name = 'Test Opp', BillingAmount__c = 10, Contact__c = c.id, MBASubscriptionID__c = '7', ProductId__c = '7', Product__c = '7');
       
       
     //Create a case with all the data
  //   Case TestCase = new Case(AccountId = o.AccountId, ContactId=o.Contact__c, Opportunity__c=o.id, Origin='Phone', OwnerId=userid,  Paused_plan_prior_price__c = o.BillingAmount__c, Plan_at_Pause_Offer__c = o.Product__c,Product_ID__c = o.ProductID__c, RecordTypeId = '012a0000001NYWL', Status = 'New', Subject = 'Cancellation ' + o.Name); 
 //    System.debug('Case created; id = ' + testCase.id);    
     
  //   Test.startTest();    
     
     //Use the PageReference Apex class to instantiate a page
   //  PageReference testPageRef = Page.CreateCancelCasefromOpp;
   //  Test.setCurrentPage(testPageRef);
   //     testPageRef.     System.assert(TestPageRef.getUrl() !=null);
    //  System.assertEquals(PageRef.getUrl(),testPageRef.testAutoRun().getURL());
     //In this case, the Visualforce page named 'success' is the starting point of this test method. 
    
    /* Test.setCurrentPage(pageRef);
        
        pageRef.autorun();
   
     //Instantiate and construct the controller class.  
     ApexPages.StandardController controller = new ApexPages.StandardController(o);
   
      //Example of calling an Action method. Same as calling any other Apex method. 
      //Normally this is executed by a user clicking a button or a link from the Visualforce
      //page, but in the test method, just test the action method the same as any 
      //other method by calling it directly.

     //The .getURL will return the page url the Save() method returns.
     //How do I get the method in ???!!! 
    //   String nextpage = controller.autorun().getUrl();

         String nextpage = controller.save().getUrl();
        
        //Check that the save() method returns a URL */
       // System.assert(nextpage !=null);
           
        //PageReference PageRef2 = new PageReference('/' + testCase.Id+'/e 
        
       // Test.stopTest();
     
   }
}