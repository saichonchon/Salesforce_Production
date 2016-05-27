@isTest
private class TestCaseRollupForCaseHandle
{
	static Task createCallTask (Id whatId, string subject, integer durationSec)
	{
		Task t = new Task();
    	t.WhatId = whatId;
    	t.Subject = subject;
    	t.Type = 'Call';
    	t.Status = 'Completed';
    	t.CallType = 'Inbound';
    	t.CallDurationInSeconds = durationSec;
    	
    	return t;
	}
	
	static LiveChatTranscript createLiveChatTrans (Id caseId, DateTime dtStartTime, DateTime dtEndTime)
	{
		LiveChatTranscript l = new LiveChatTranscript();
		LiveChatVisitor visit = new LiveChatVisitor();
		insert visit;
		
		l.CaseId = caseId;
		l.Status = 'Completed';
		l.StartTime = dtStartTime;
		l.EndTime = dtEndTime;		
		l.LiveChatVisitorId = visit.Id;
		
		return l;
	}
	
    static testMethod void testCaseActivityTaskCount() 
    {
    	// Create test data
    	TestDataGenerator td = new TestDataGenerator();
   	    Id idCSCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
     	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, 'Support', true);
    	c.AccountId = lstAcct[0].Id;
    	c.RecordTypeId = idCSCaseRecordType;
    	update c;
    	
    	list<Task> lstTask = new list<Task>();
    	
    	Task t1 = createCallTask(c.Id, 'Call 9/24/2013 3:59 PM', 120);
    	Task t2 = createCallTask(c.Id, 'Call 9/25/2013 3:59 PM', 120);
    	
    	lstTask.add(t1);
    	lstTask.add(t2);
    	
    	Test.startTest();
    	
    	insert lstTask;
    	
    	// Ensure the task is associated to the case
    	t1.WhatId = c.Id;
    	t2.WhatId = c.Id;
    	update t1;
    	update t2;
    	
    	// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(4, c.Total_Case_Handle_Time__c);
		
		delete t1;
		
		// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(2, c.Total_Case_Handle_Time__c);
		
    	Test.stopTest(); 
    }
    
    static testMethod void testLiveChatTranscriptTrigger()
    {
    	// Create test data
    	TestDataGenerator td = new TestDataGenerator();
   	    Id idCSCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, 'Support', true);
    	c.AccountId = lstAcct[0].Id;
    	c.RecordTypeId = idCSCaseRecordType;
    	update c;
    	
    	list<LiveChatTranscript> lstLCT = new list<LiveChatTranscript>();
    	
    	LiveChatTranscript l1 = createLiveChatTrans(c.Id, System.now().addMinutes(-6), System.now().addMinutes(-4));
    	LiveChatTranscript l2 = createLiveChatTrans(c.Id, System.now().addMinutes(-2), System.now());
    	
    	lstLCT.add(l1);
    	lstLCT.add(l2);
    	
    	Test.startTest();
    	
    	insert lstLCT;
    	
    	// Ensure the Transcript is associated to the case
    	l1.CaseId = c.Id;
    	l2.CaseId = c.Id;
    	update l1;
    	update l2;
    	
    	// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(4, c.Total_Case_Handle_Time__c);
		
		delete l1;
		
		// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(2, c.Total_Case_Handle_Time__c);
		
    	Test.stopTest(); 
    }
/*    
    static testMethod void testCaseTimeWorked_Trigger()
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, '', true);
    	
    	// Make sure the case is associated to the correct account and user
    	c.AccountId = lstAcct[0].Id;
    	c.OwnerId = UserInfo.getUserId();
    	update c;
    	
    	// Create a Case Time Worked record
    	Case_Time_Worked__c ctw1 = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	insert ctw1;
    	
    	Case_Time_Worked__c ctw2 = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	insert ctw2;
    	
    	Test.startTest();
    	
    	// Now update to ensure it is correctly associated to the case and add stop times
    	ctw1.Case__c = c.Id;
    	ctw1.Start_Time__c = System.now().addMinutes(-6);
    	ctw1.Stop_Time__c = System.now().addMinutes(-4);
    	update ctw1;
    	
    	ctw2.Case__c = c.Id;
    	ctw2.Start_Time__c = System.now().addMinutes(-2);
    	ctw2.Stop_Time__c = System.now();
    	update ctw2;
    	
    	// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(4, c.Total_Case_Handle_Time__c);
		
		delete ctw1;
		
		// Pull back the case
    	c = [SELECT Id, CaseNumber, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
			FROM Case
			WHERE Id = :c.Id];
		
		// Validate that the total case time is accurate
		system.assertEquals(2, c.Total_Case_Handle_Time__c);
		
    	Test.stopTest();
    }
    
    static testMethod void testOverLapTime()
    {
    	TestDataGenerator td = new TestDataGenerator();
    	DateTime dtNow = System.now();
    	
    	list<Account> lstAcct = td.getAccounts(true);
    	Case c = td.createCase(lstAcct[0].Id, '', true);
    	
    	// Make sure the case is associated to the correct account and user
    	c.AccountId = lstAcct[0].Id;
    	c.OwnerId = UserInfo.getUserId();
    	update c;
    	
    	// Create a Case Time Worked record
    	Case_Time_Worked__c ctw1 = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	Case_Time_Worked__c ctw2 = CaseHandle_Helper.createTimeWorkedFromCase(c, true);
    	insert ctw1;
    	insert ctw2;
    	
    	// Now update to ensure it is correctly associated to the case and add stop times (20 minutes of work time)
    	ctw1.Case__c = c.Id;
    	ctw1.Start_Time__c = dtNow.addMinutes(-30);
    	ctw1.Stop_Time__c = dtNow.addMinutes(-20);
    	update ctw1;
    	ctw2.Case__c = c.Id;
    	ctw2.Start_Time__c = dtNow.addMinutes(-10);
    	ctw2.Stop_Time__c = dtNow;
    	update ctw1;
    	    	
    	// Create Chat Transcript records with overlapping time to the Case Handle Time record
    	list<LiveChatTranscript> lstLCT = new list<LiveChatTranscript>();
    	LiveChatTranscript l1 = createLiveChatTrans(c.Id, dtNow.addMinutes(-32), dtNow.addMinutes(-28)); // Adds 2 minute of actual work
    	LiveChatTranscript l2 = createLiveChatTrans(c.Id, dtNow.addMinutes(-25), dtNow.addMinutes(-23)); // Adds 0 minute of actual work
    	LiveChatTranscript l3 = createLiveChatTrans(c.Id, dtNow.addMinutes(-22), dtNow.addMinutes(-18)); // Adds 2 minute of actual work
    	
    	lstLCT.add(l1);
    	lstLCT.add(l2);
    	lstLCT.add(l3);
    	    	
    	insert lstLCT;
    	
    	// Ensure the Transcript is associated to the case
    	l1.CaseId = c.Id;
    	l2.CaseId = c.Id;
    	l3.CaseId = c.Id;
    	update l1;
    	update l2;
    	update l3;
    	
    	test.startTest();
    	
    	// Create Call records with overlapping time to the Case Handle Time record
    	list<Task> lstTask = new list<Task>();
    	    	    	    	
    	string subj1 = 'Call ' + dtNow.addMinutes(-12).format('MM/dd/yyyy hh:mm a'); // Adds 2 minute of actual work
    	string subj2 = 'Call ' + dtNow.addMinutes(-6).format('MM/dd/yyyy hh:mm a'); // Adds 0 minute of actual work
		string subj3 = 'Call ' + dtNow.addMinutes(-1).format('MM/dd/yyyy hh:mm a'); // Adds 2 minute of actual work
    	Task t1 = createCallTask(c.Id, subj1, 180);
    	Task t2 = createCallTask(c.Id, subj2, 120);
    	Task t3 = createCallTask(c.Id, subj3, 180);
    	
    	lstTask.add(t1);
    	lstTask.add(t2);
    	lstTask.add(t3);
    	
    	insert lstTask;
    	
    	// Ensure the task is associated to the case
    	t1.WhatId = c.Id;
    	t2.WhatId = c.Id;
    	t3.WhatId = c.Id;
    	update t1;
    	update t2;
    	update t3;
    	
    	test.stopTest();
    }
  */
}