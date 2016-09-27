@isTest(SeeAllData=true)
private class TestSupportSurveyTrigger {


	static testmethod void testsurveytrigger()
	
	{
		
// Create test data
	TestDataGenerator td = new TestDataGenerator();
	  
	  list<Account> lstAcct = td.getAccounts(true);
	  Case c = td.createCase(lstAcct[0].Id, 'Support', true);
	  c.AccountId = lstAcct[0].Id;
	  update c;
      
      
    LiveChatTranscript l = new LiveChatTranscript();
    LiveChatVisitor visit = new LiveChatVisitor();
    l.chatkey = 'abcdefghji';
    l.CaseId = c.Id;
    insert visit;
    l.Status = 'Completed';
    
    l.StartTime = System.now().addMinutes(-6);
    l.EndTime = System.now().addMinutes(-4);    
    l.LiveChatVisitorId = visit.Id;
    insert l;
    
    Support_Survey__c  ss = new Support_Survey__c();
    ss.chat_key__c = 'abcdefghji';
    insert ss;
    
     // Pull back the survey
     Support_Survey__c  s = [SELECT Id, Case__c, chat_key__c  FROM Support_Survey__c   WHERE Id = :ss.Id];
    system.debug('test chat key '+s.Chat_Key__c);
    // Validate that the total case time is accurate
    system.assertEquals(s.Case__c ,c.Id);
    
	}

	static testmethod void testMigsurveytrigger()
	
	{
		
// Create test data
	TestDataGenerator td = new TestDataGenerator();
	  
	List<Account> lstAcct = td.getAccounts(true);
	Case c = td.createCase(lstAcct[0].Id, 'Migration', true);
	c.AccountId = lstAcct[0].Id;
	 
	update c;
   
    Support_Survey__c  Verified = new Support_Survey__c(Case__c = c.Id,
                                   	Redirect_301_transfer_successful__c = 'YES',
                                  	Survey_Name__c = 'Migration Verification Checklist' ,
                                 	Product_image_transfer_successful__c = 'YES' ,
            						Product_details_transfer_successful__c = 'YES',
           							Product_Options_transfer_successful__c = 'YES',
            						Design_transfer_successful__c = 'YES',
           							Customer_Info_transfer_successful__c = 'YES',
           							Content_transfer_successful__c ='YES',
            						Category_Structure_transfer_successful__c = 'Yes',
            						Category_Name_transfer_successful__c = 'YES');
    insert Verified;
    
     // Pull back the survey
     Case cs = [SELECT Id, Migration_Verified_Clicktools__c  FROM Case  WHERE Id = :c.Id];
    
    // Validate that the total case time is accurate
    system.assertEquals(cs.Migration_Verified_Clicktools__c ,'Yes');
    
	}
		
	
	static testmethod void testPhonesurveytrigger()
	
	{
		
// Create test data
	TestDataGenerator td = new TestDataGenerator();
	  
	List<Account> lstAcct = td.getAccounts(true);
	 Case c = td.createCase(lstAcct[0].Id, 'Support', true);
	 c.origin = 'Phone';
	c.AccountId = lstAcct[0].Id;
	 
	update c;
   
    Support_Survey__c  Verified = new Support_Survey__c(Case__c = c.Id,
                                    Survey_Completion_Date__c = Date.Today(),
                                  	Survey_Name__c = 'Support NPS Phone Survey' ,
                                  	Satisfaction__c = 10,
                                  	Recommend__c = 10
                                 	);
    insert Verified;
    
     // Pull back the survey
     Case cs = [SELECT Id, Satisfaction__c FROM Case  WHERE Id = :c.Id];
    
    // Validate that the total case time is accurate
    system.assertEquals(cs.Satisfaction__c ,10);
    
	}
}