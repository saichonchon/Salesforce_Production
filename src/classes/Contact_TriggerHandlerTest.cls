@isTest(SeeAllData = false)
private class Contact_TriggerHandlerTest {

    static testmethod void testContactTZUpdate()
    {
        test.startTest();
        
        //Insert Test Custom Settings Records
        Area_Codes__c areaCode = new Area_Codes__c();
        areaCode.Name = '1';
        areaCode.Area_code__c = '410';
        areaCode.Location__c = 'Maryland';
        areaCode.Timezone__c = 'Eastern';
        insert areaCode;
        
        //Insert Test Lead Record
        
        TestDataGenerator td = new TestDataGenerator();
      
        list<Contact> lstCon = td.getContacts(true);
      
        Contact ContactObj = lstCon[0];
        
        ContactObj.Phone = '(410) 894-5314';
       
        
        update ContactObj;
       
        test.stopTest();
        
        //Compare State and Time zone
        Contact cObj = [Select id, US_Time_Zone__c, MailingState from Contact where id = :ContactObj.Id];
        
        system.assertEquals(cObj.US_Time_Zone__c, 'Eastern');
        system.assertEquals(cObj.MailingState, 'Maryland');
    }
    
    static testMethod void testPhoneUpdates() 
    {
		
        TestDataGenerator td = new TestDataGenerator();
    	
    	list<Contact> lstCon = td.getContacts(true);
      
        Contact ContactObj = lstCon[0];
        
        ContactObj.Phone = '4108945314';
         
        update ContactObj;
        
         ContactObj.Phone = '5128945314';
         update ContactObj;
		
	 	 Contact cObj = [Select id, MBA_Phone_1__c, Phone from Contact where id = :ContactObj.Id];
        
	 	// System.assertEquals('4108945314' , cObj.MBA_Phone_1__c);
	 	System.assertEquals('5128945314' , cObj.Phone);	
    }     
    
    static testMethod void testAcctAppContactUpd() 
    {
	    Id partnerRecordTypeId  = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Channel Partner Record Type').getRecordTypeId();
		
        TestDataGenerator td = new TestDataGenerator();
    	
    	list<Account> lstAcct = td.getAccounts(false);
      	lstAcct[0].RecordTypeId = partnerRecordTypeId ;
      	insert lstAcct;
      	
        Contact ContactObj = new Contact(AccountId= lstAcct[0].Id,lastName = 'Test');
        insert ContactObj;
        Account a = [select Id, AppDeveloperContact__c from Account where Id = :ContactObj.AccountId];
        
        System.assertEquals(a.AppDeveloperContact__c, ContactObj.Id);
    }  
}