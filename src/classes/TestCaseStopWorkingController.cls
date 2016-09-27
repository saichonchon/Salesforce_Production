@isTest(SeeAllData=true)
private class TestCaseStopWorkingController
{	
	static testMethod void testStopWorking3() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, '', true);
    	
    	// Make sure the case is associated to the correct account and user
    	c.AccountId = lstAcct[0].Id;
    	c.OwnerId = UserInfo.getUserId();
    	update c;
    	  	
    	Test.startTest();
    	
		PageReference pageRef = Page.CaseStopWorking;
		Test.setCurrentPage(pageRef);      
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(c);
		      
		CaseStopWorkingController cont = new CaseStopWorkingController(sc);
		
		cont.setCaseToAPI();
		cont.setCaseToLegal();
		cont.setCaseToBilling();
		cont.setCaseToMgrCallback();
		cont.setCaseToEscalated1();
		cont.setCaseToSupport();
		cont.setCaseTier2Actions();
		cont.setCaseToTrash();
		cont.setCaseToDesignSupport();
		cont.setCaseToTier2();
		cont.setCaseToMigSp();
		cont.setCaseToDesignApproved();
		cont.setCaseToDesignOOscope();
		
    }	
		
}