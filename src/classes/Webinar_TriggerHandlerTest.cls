@isTest(SeeAllData = false)
private class Webinar_TriggerHandlerTest {

    static testMethod void myUnitTest() {
    	
		User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');  	
    	insert testUser; 
    	
    	if(Test.isRunningTest()){
	 		system.RunAs(testUser){	
                
                List<Lead> testLead = TestUtilityBox.getTestLeads('Client Prospect','bigcommerce@email.com',10);
		     	insert testLead;
                
                List<Lead> testLead1 = TestUtilityBox.getTestLeads('Client Prospect','bigcommerce1@email.com',10);
		     	insert testLead1;
	 			
	 			List<Account> testAccount = TestUtilityBox.getTestAccounts('Client Record Type', 10);
	 			insert testAccount;
	 			
	 			List<Contact> testContact = TestUtilityBox.getTestContacts(testAccount,'bigcommerce1@email.com');
	 			insert testContact; 			
	 			
 				List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
 				insert testWebinar; 				
	 			
	 			testWebinar = [SELECT lead__c, contact__c, account__c  FROM Webinar__c WHERE id IN : testWebinar];	 			
	 			
                system.assertEquals(testLead[1].Id,testWebinar[1].lead__c);
	 			system.assertEquals(null,testWebinar[0].account__c);
	 			system.assertEquals(null,testWebinar[0].contact__c);		     	
		     	
		     	List<Webinar__c> testWebinar1 = TestUtilityBox.getTestWebinars('bigcommerce1@email.com',10);
		     	insert testWebinar1;
		     	
		     	testWebinar1 = [SELECT lead__c, contact__c, account__c FROM Webinar__c WHERE id IN : testWebinar1];
		     	
		     	system.assertEquals(null, testWebinar1[1].lead__c); 
                system.assertEquals(testAccount[0].Id,testWebinar1[0].account__c);
	 			system.assertEquals(testContact[0].Id,testWebinar1[0].contact__c);        		                  
            }        
        }          
    }

    static testMethod void myUpdateWebinartEmailTest(){

		User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');  	
	    insert testUser; 
	    	
    	if(Test.isRunningTest()){
	 		System.RunAs(testUser){

	 			List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('big@email.com',10);
 				insert testWebinar;
	 			
	 			List<Account> testAccount = TestUtilityBox.getTestAccounts('Client Record Type', 10);
	 			insert testAccount;
	 			
	 			List<Contact> testContact = TestUtilityBox.getTestContacts(testAccount,'bigcommerce@email.com');
	 			insert testContact;	 			

	 			testWebinar[1].Registrant_Email__c = '1bigcommerce@email.com';
			 	update testWebinar;

			 	testWebinar = [SELECT  Contact__c, Account__c, Registrant_Email__c  FROM Webinar__c WHERE Id IN : testWebinar];
			 	testContact = [SELECT Id, AccountId FROM Contact WHERE Id IN : testContact];	 	

			 	System.assertEquals(testContact[1].AccountId,testWebinar[1].Account__c);
			 	System.assertEquals(testContact[1].Id,testWebinar[1].Contact__c);			 			   
            }        
        } 	    
	}	
}