@isTest(SeeAllData=true)
private class TestChatPostTrigger
{
    static testMethod void testChatforCase() 
    {
      TestDataGenerator td = new TestDataGenerator();
      
      list<Account> lstAcct = td.getAccounts(true);
      
      // Create a new case for the account
      Case c = td.createCase(lstAcct[0].Id, 'Support', true);
      
      // Make sure the case is associated to the correct account
      c.AccountId = lstAcct[0].Id;
      update c;
      
      Test.startTest();
      
// Create a feed post on the test case
    FeedItem fpost = new FeedItem();
	fpost.ParentId = c.Id;
	
	fpost.body = 'Test chatter on case';
    fpost.type = 'TextPost';
	insert fpost;   
    Test.stopTest();
  }
}