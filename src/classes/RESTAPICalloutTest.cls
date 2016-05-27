@isTest(SeeAllData=True)
public class RESTAPICalloutTest  {
  
  static testMethod void testBMPRequestAccount() 
  {    
    SingleRequestMock fakeResponse = new SingleRequestMock(200, 'Complete','[Status=OK, StatusCode=200]',null);
    Test.setMock(HttpCalloutMock.class, fakeResponse);
 
// create test data       
        Account a = new Account();
        a.Name = 'Test Account';
        a.Source__c = 'BMP';
        a.MBAAccountID__c = '341726';
        insert a;
  }
 
  
  static testMethod void testBMPRequestContact() 
  {    
    SingleRequestMock fakeResponse = new SingleRequestMock(200, 'Complete','[Status=OK, StatusCode=200]',null);
    Test.setMock(HttpCalloutMock.class, fakeResponse);
 
 // create test data       
      TestDataGenerator td = new TestDataGenerator();
      
      list<Contact> lstCon = td.getContacts(false);
      lstCon[0].MBAAccountID__c = '341726';
      lstCon[0].MBAClientID__c = '941726';
      lstCon[0].Source__c = 'BMP';
        
      insert lstCon;
      
      Opportunity opp = new Opportunity (AccountId = lstCon[0].AccountId,
                           name = 'New Opp', StageName= 'Trial',
                           Contact__c = lstCon[0].Id,
                           closeDate= System.Today(),
                           Source__c = 'BMP',
                           MBAAccountId__c = '341726',
                           MBASubscriptionID__c = '2233445');
      insert opp;
  }
  
}