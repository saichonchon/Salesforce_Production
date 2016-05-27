@isTest(SeeAllData = false)
private class Contact_TriggerHandlerTest {

/*
    static testMethod void getWebinarTest(){

        User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');     
        insert testUser; 
            
        if(Test.isRunningTest()){
            System.RunAs(testUser){

                List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
                insert testWebinar;
                
                List<Account> testAccount = TestUtilityBox.getTestAccounts('Client Record Type', 10);
                insert testAccount;
                
                List<Contact> testContact = TestUtilityBox.getTestContacts(testAccount,'bigcommerce@email.com');
                insert testContact;
                
                testWebinar = [SELECT  Contact__c, Account__c  FROM Webinar__c WHERE Id IN : testWebinar];
                testContact = [SELECT Id, AccountId FROM Contact WHERE Id IN : testContact];                
                
                System.assertEquals(testContact[0].AccountId,testWebinar[0].Account__c);
                System.assertEquals(testContact[0].Id,testWebinar[0].Contact__c);

                testContact[1].Email = '1bigcommerce@email.com';
                update testContact;

                testWebinar = [SELECT  Contact__c, Account__c, Registrant_email__c  FROM Webinar__c WHERE Id IN : testWebinar];
                testContact = [SELECT Id, AccountId FROM Contact WHERE Id IN : testContact];        

                System.assertEquals(testContact[1].AccountId,testWebinar[1].Account__c);
                System.assertEquals(testContact[1].Id,testWebinar[1].Contact__c);

                testContact[1].Email = '1bigcommerce@email.com';
                update testContact;

                testWebinar = [SELECT  Contact__c, Account__c, Registrant_email__c  FROM Webinar__c WHERE Id IN : testWebinar];
                testContact = [SELECT Id, AccountId FROM Contact WHERE Id IN : testContact];        

                System.assertEquals(testContact[1].AccountId,testWebinar[1].Account__c);
                System.assertEquals(testContact[1].Id,testWebinar[1].Contact__c);              
            }        
        }       
    }

    static testMethod void myUpdateContactEmailTest(){

        User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');     
        insert testUser; 
            
        if(Test.isRunningTest()){
            System.RunAs(testUser){

                List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
                insert testWebinar;
                
                List<Account> testAccount = TestUtilityBox.getTestAccounts('Client Record Type', 10);
                insert testAccount;
                
                List<Contact> testContact = TestUtilityBox.getTestContacts(testAccount,'big@email.com');
                insert testContact;             

                testContact[1].Email = '1bigcommerce@email.com';
                update testContact;

                testWebinar = [SELECT  Contact__c, Account__c, Registrant_email__c  FROM Webinar__c WHERE Id IN : testWebinar];
                testContact = [SELECT Id, AccountId FROM Contact WHERE Id IN : testContact];        

                System.assertEquals(testContact[1].AccountId,testWebinar[1].Account__c);
                System.assertEquals(testContact[1].Id,testWebinar[1].Contact__c);                          
            }        
        }       
    }   
*/
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
        
	 	System.assertEquals('4108945314' , cObj.MBA_Phone_1__c);
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