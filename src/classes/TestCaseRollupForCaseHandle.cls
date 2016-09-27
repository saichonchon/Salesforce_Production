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
}