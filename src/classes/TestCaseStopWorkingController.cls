@isTest(SeeAllData=true)
private class TestCaseStopWorkingController
{	
 /*
    static testMethod void testStopWorking1() 
    {
    	
    	TestDataGenerator td = new TestDataGenerator();
    	
    	Profile p = [SELECT id 
                        FROM profile
                        WHERE name = 'System Administrator'
                        LIMIT 1];
        
        UserRole role;
        for (UserRole r : [SELECT Name, Id 
        					FROM UserRole 
        					WHERE Name LIKE '%Client Success%'])
        {
        	role = r;
        	break;
        }
        
        String testemail = 'puser000@amamama.com';

        User pu = td.getUser(p, 'testingSG1234');
        pu.UserRoleId = role.Id;
        
        insert pu;
        
        list<Account> lstAcct = td.getAccounts(true);
                
        system.RunAs(pu)
        {	    	
	    	Case c = td.createCase(lstAcct[0].Id, 'Support', true);
	    	
	    	// Make sure the case is associated to the correct account
	    	c.AccountId = lstAcct[0].Id;
	    	update c;
	    	set<Id> csId = new set<Id>();
	    	csId.add(c.Id);
	    	
	    	// Update the case to start working
	    	CaseHandle_Helper.case_StartWorking(csId);
	    	
	    	// Check that a case time worked record was generated
	    	list<Case_Time_Worked__c> lstCTW = [SELECT Id, Case__c, Owner_from_ID__c, Owner_from_Name__c, Owner_to_ID__c, Owner_to_Name__c, Start_Time__c, Stop_Time__c
	    										FROM Case_Time_Worked__c
	    										WHERE Case__c = :c.Id];
	    	
	    	system.debug('@@@ TestCaseStopWorkingController:testStopWorking1 - lstCTW: ' + lstCTW); 
	    	system.assertNotEquals(0, lstCTW.size());
	    	
	    	Test.startTest();
	    	
			PageReference pageRef = Page.CaseStopWorking;
			Test.setCurrentPage(pageRef);      
			      
			ApexPages.StandardController sc = new ApexPages.Standardcontroller(c);
			      
			CaseStopWorkingController cont = new CaseStopWorkingController(sc);
			
			system.assertEquals(cont.objCase.Id, c.Id);
			system.assertEquals(cont.objCaseId, c.Id);
			
			pageReference pr = cont.setCaseToQueue();
			
			// Ensure the case time worked record has been successfully updated and the user returned to the case page
			system.debug('@@@ TestCaseStopWorkingController:testStopWorking1 - pr for setCaseToQueue Test: ' + pr);
			system.assertNotEquals(null, pr);
			
			Test.stopTest();
        }
	}
	
	static testMethod void testStopWorking2() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, '', true);
    	
    	// Make sure the case is associated to the correct account and user
    	c.AccountId = lstAcct[0].Id;
    	c.OwnerId = UserInfo.getUserId();
    	update c;
    	
    	// Create a Case Time Worked record
    	Case_Time_Worked__c ctw = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	insert ctw;
    	
    	// Now update to ensure it is correctly associated to the case
    	ctw.Case__c = c.Id;
    	update ctw;
    	
    	Test.startTest();
    	
		PageReference pageRef = Page.CaseStopWorking;
		Test.setCurrentPage(pageRef);      
		      
		ApexPages.StandardController sc = new ApexPages.Standardcontroller(c);
		      
		CaseStopWorkingController cont = new CaseStopWorkingController(sc);
		
		system.assertEquals(cont.objCase.Id, c.Id);
		system.assertEquals(cont.objCaseId, c.Id);
		
		pageReference pr = cont.setCaseToQueue();
		
		// Ensure the case time worked record was NOT successfully updated and the user returned to vf page
		system.debug('@@@ TestCaseStopWorkingController:testStopWorking2 - pr for setCaseToQueue Test 1: ' + pr);
//		system.assertEquals(null, pr);
		
		boolean showErr = cont.getshowError();
		boolean showQueue = cont.getshowQueueSelection();
		for (SelectOption opt : cont.lstCaseQueues)
		{
			if (opt.getValue() != '')
			{
				//system.debug('@@@ TestCaseStopWorkingController:testStopWorking2 - selected queue value: ' + opt.getValue());
				//system.debug('@@@ TestCaseStopWorkingController:testStopWorking2 - selected queue label: ' + opt.getLabel());
				cont.selectedQueue = opt.getValue();
				break;
			}
		}
		
		system.assertNotEquals(null, cont.selectedQueue);
		
		system.debug('@@@ TestCaseStopWorkingController:testStopWorking2 - setting case back to queue from Selected: ' + cont.selectedQueue);
		
		// Now submit the stop working again and ensure it works properly
		pr = cont.setCaseToQueue();
		
		// Ensure the case time worked record was successfully updated and the user returned to case page
		system.debug('@@@ TestCaseStopWorkingController:testStopWorking2 - pr for setCaseToQueue Test 2: ' + pr);
		system.assertNotEquals(null, pr);
				
		Test.stopTest();
	}
*/	
	static testMethod void testStopWorking3() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, '', true);
    	
    	// Make sure the case is associated to the correct account and user
    	c.AccountId = lstAcct[0].Id;
    	c.OwnerId = UserInfo.getUserId();
    	update c;
    	
 /*   	// Create a Case Time Worked record
    	Case_Time_Worked__c ctw = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	insert ctw;
    	
    	// Now update to ensure it is correctly associated to the case
    	ctw.Case__c = c.Id;
    	update ctw;
 */   	
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