@isTest(seeAllData=true) 
private class TestRoundRobin 
{
    static testMethod void testRoundRobin() 
    {
    	string strQueueName = 'RoundRobinTestQueue';
    	
		// Create Test Data
		TestDataGenerator td = new TestDataGenerator();
		
		// Ensure there is a row in the Robin Robin Custom setting for the new queue
		Round_Robin_Settings__c rrs = new Round_Robin_Settings__c();
		rrs.Name = 'RoundRobinQueueTest';
		rrs.Object_API_Name__c = 'Lead';
		rrs.Queue_Name__c = strQueueName;
		rrs.Last_Number_Used__c = 0;
		insert rrs;
		
		// Create an actual Queue
		Group g = new Group();
		g.Name = strQueueName;
		g.Type = 'Queue';
		insert g;
		
		QueueSobject q = new QueueSobject();
		q.QueueId = g.Id;
		q.SobjectType = 'Lead';
		insert q;
		
		// Create new users
		list<User> lstUsers = td.getUsers(null);
		system.debug('***TestRoundRobin - lstUsers: ' + lstUsers);
		
		list<User_Status__c> lstUStatus = new list<User_Status__c>();
		
		// Create a User Status record for the new users
		for (User u : lstUsers)
		{
			User_Status__c us = new User_Status__c(OwnerId = u.Id);
			us.Round_Robin_Queue__c = strQueueName;
			us.Status__c = 'In the Office';
			lstUStatus.add(us);
		}
		insert lstUStatus;
		
		test.startTest();
		
		// Create leads
		list<Lead> lstLeads = td.getLeads(true);
		
		set<id> stLeadIds = new set<id>();		
		integer x = 0;
		
		// Now update leads to the new queue and ensure they are assigned to the new users
		for (Lead objLead : lstLeads)
		{
			objLead.OwnerId = q.QueueId;
			if (x < 3)
				objLead.No_Assign__c = false;
			else
				objLead.No_Assign__c = true;
				
			stLeadIds.add(objLead.Id);
			
			x++;
		}
		
		system.debug('***TestRoundRobin - Updating Leads: ' + lstLeads);		
		update lstLeads;

		// Run the Round Robin on the new lead		
		RoundRobin.RoundRobinForLead(lstLeads);
		
		test.stopTest();
		
		// Pull back the leads
		list<Lead> lstUpdatedLeads = [SELECT Id, OwnerId, Name, Owner.Name 
									FROM Lead
									WHERE Id IN :stLeadIds];
					
		system.debug('***Leads are now: ' + lstUpdatedLeads);
		x = 0;
		
		for (Lead objLead : lstUpdatedLeads)
		{
			system.debug('***Lead OwnerId: ' + objLead.OwnerId + '; QueueId: ' + q.QueueId + '; User Id: ' + lstUsers[x].Id);
			
			if (x < 3)
			{
				// Verify the lead is now assigned to the correct user
				system.assertNotEquals(objLead.OwnerId, q.QueueId);
			}
			else
			{
				// Verify lead is still assigned to the queue
				system.assertequals(objLead.OwnerId, q.QueueId);
			}
			x++;
		}
    }
    
    static testMethod void testRRAccount() 
    {
    	TestDataGenerator td = new TestDataGenerator();
        
	 	list<Account> lstAcct = td.getAccounts(true);
	  
	    InvokeRoundRobin instance = new InvokeRoundRobin();
    
 //       lstAcct[0].Projected_Annual_Revenue__c = 'Less than $100,000';
 		 lstAcct[0].Assign_To_Team__c = 'Enterprise';
        
        update lstAcct;
        
        PageReference pageRef = Page.RoundRobin;
        Test.setCurrentPage(pageRef);      
       
        System.currentPageReference().getParameters().put('id', lstAcct[0].Id);
        
    	Test.startTest();
    	
    	instance.autoRun();
    	
    	Test.stopTest();
    }
    static testMethod void testQualifyAccount() 
    {
    	TestDataGenerator td = new TestDataGenerator();
        
	 	list<Account> lstAcct = td.getAccounts(true);
	  
	    InvokeRoundRobin instance = new InvokeRoundRobin();
        
        PageReference pageRef = Page.QualifyButton;
        Test.setCurrentPage(pageRef);      
       
        System.currentPageReference().getParameters().put('id', lstAcct[0].Id);
        
    	Test.startTest();
    	
    	instance.autoRun();
    	
    	Test.stopTest();
    }
}