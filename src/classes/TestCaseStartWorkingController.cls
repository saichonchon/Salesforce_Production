@isTest(SeeAllData=true)
private class TestCaseStartWorkingController
{
    static testMethod void testStartWorking1() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	
    	// Create a new case for the account
    	Case c = td.createCase(lstAcct[0].Id, 'Support', true);
    	
    	// Make sure the case is associated to the correct account
    	c.AccountId = lstAcct[0].Id;
    	update c;
    	
    	Test.startTest();
    	
		PageReference pageRef = Page.CaseStartWorking;
		Test.setCurrentPage(pageRef);      
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(c);
		      
		CaseStartWorkingController cont = new CaseStartWorkingController(sc);
		
		system.assertEquals(cont.objCase.Id, c.Id);
		system.assertEquals(cont.objCaseId, c.Id);
		
		cont.initPage();
		
		Test.stopTest();
	}
}