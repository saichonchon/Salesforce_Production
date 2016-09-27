@isTest(SeeAllData=true)
private class TestVFButtons
{
    static testMethod void testCreateOppFromAccount() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	
    	// Create a new opportunity for the account
	
    	Test.startTest();
    	    
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(lstAcct[0]);
		      
		AccountButtonController abc = new AccountButtonController(sc);		
		abc.createOpp();
		
		Test.stopTest();
	}

    static testMethod void testCreateOppFromContact() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Contact> lstCon = td.getContacts(true);
    	
    	// Create a new opportunity for the account
	
    	Test.startTest();
    	    
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(lstCon[0]);
		      
		ContactButtonController cbc = new ContactButtonController(sc);		
		cbc.createOpp();
		
		Test.stopTest();
	}

   static testMethod void testChangeAccountOwner() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
        lstAcct[0].OwnerId = Label.Account_Default_Owner;
    	update lstAcct[0];
    		
    	Test.startTest();
    	    
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(lstAcct[0]);
		      
		ChangeownerController abc = new ChangeOwnerController(sc);		
		abc.changeOwner();
		abc.back();
		Test.stopTest();
	}
	
	static testMethod void testChangeLeadOwner() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Lead> lstLead = td.getLeads(true);

        lstLead[0].OwnerId = Label.Lead_Default_Owner;
    	update lstLead[0];
    		
    	Test.startTest();
    	    
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(lstLead[0]);
		      
		ChangeownerController abc = new ChangeOwnerController(sc);		
		abc.changeLeadOwner();
		abc.back();
		Test.stopTest();
	}

}