@isTest(SeeAllData = true)
private class Lead_TriggerHandlerTest { 
	
/*	    	
	static testMethod void getWebinarTest() {
		
		List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
		insert testWebinar; 

		List<Lead> testLead = TestUtilityBox.getTestLeads('Client Prospect','bigcommerce@email.com',10);
		insert testLead;

		List<Webinar__c> dbWebinar = [SELECT Lead__c FROM Webinar__c];	 
		System.assertEquals(testLead[0].Id, dbWebinar[0].Lead__c); 
    }

    static testMethod void myUpdateLeadEmailTest() {
		
		List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
		insert testWebinar; 

		List<Lead> testLead = TestUtilityBox.getTestLeads('Client Prospect','big@email.com',10);
		insert testLead;

		testLead[1].Email = '1bigcommerce@email.com';
	 	update testLead;

	 	testWebinar = [SELECT  Contact__c, Account__c,Lead__c, Registrant_email__c  FROM Webinar__c WHERE Id IN : testWebinar];
	 	testLead = [SELECT Id FROM Lead WHERE Id IN : testLead];	 	

	 	System.assertEquals(testLead[1].Id,testWebinar[1].Lead__c);
	 		
    }

    static testMethod void newLeadIsConvertedTest(){

    	List<Webinar__c> testWebinar = TestUtilityBox.getTestWebinars('bigcommerce@email.com',10);
		insert testWebinar; 
  
    	List<Lead> testLead = TestUtilityBox.getTestLeads('Client Prospect','bigcommerce@email.com',10);
		insert testLead;

		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		
		List<Database.LeadConvert> leadConversions = new List<Database.LeadConvert>();
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId( testLead[0].id );
		lc.setConvertedStatus( convertStatus.MasterLabel );
		leadConversions.add( lc );

		lc = new database.LeadConvert();
		lc.setLeadId( testLead[1].id );
		lc.setConvertedStatus( convertStatus.MasterLabel );
		leadConversions.add( lc );
		
		List<Database.LeadConvertResult> results = Database.convertLead( leadConversions );
		System.assert(results[0].isSuccess());
		System.assert(results[1].isSuccess());

		List<Lead> testLeadCoverted = [SELECT Id, ConvertedContactId, ConvertedAccountId FROM Lead WHERE IsConverted = true];
		System.debug('newLeadIsConvertedTest : ' + testLeadCoverted.size());
		System.assertEquals(2,testLeadCoverted.size());

		System.debug('newLeadIsConvertedTest : lead ID ' + testLead[0].Id);
		System.debug('newLeadIsConvertedTest : lead ID ' + testLead[1].Id);

		List<Webinar__c> dbTestWebinar = [SELECT Contact__c, Account__c FROM Webinar__c WHERE Account__c != null];

		System.debug('newLeadIsConvertedTest : ' + dbTestWebinar);
		System.assertEquals(2, dbTestWebinar.size());

		System.assertEquals(testLeadCoverted[0].ConvertedAccountId,dbTestWebinar[0].Account__c);
		System.assertEquals(testLeadCoverted[0].ConvertedContactId,dbTestWebinar[0].Contact__c);
    }  
    

    static testMethod void myUpdateLeadOwnerTest() {
		
        TestDataGenerator td = new TestDataGenerator();
    	
    	list<Lead> lstLead = td.getLeads(true);
    	
    	list<Subscription__c> lstSubs = td.getSubscriptions(true);
    	List<String> profileNames = new List<String>();
    	profileNames.add('Sales Leader');
    	User ao = td.getUsers(profileNames)[0];
	    for (Subscription__c s :lstSubs)
	    {
	    	s.Lead__c = lstLead[0].Id;
	    	s.OwnerId = ao.Id;
	    }
	    update lstSubs;

        lstLead[0].OwnerId = Label.Lead_Default_owner;
    	update lstLead[0];
		
	 	List<Subscription__c> test = [SELECT Id, OwnerId FROM Subscription__c WHERE Id IN : lstSubs];	 	

	 	System.assertEquals(Label.Lead_Default_owner,test[0].OwnerId);
	 		
    }  
   */   
    static testMethod void testLeadDuplicates() {
		System.runAs(BCSettings.apiUser)
		{
	        TestDataGenerator td = new TestDataGenerator();
	    	
	    	list<Lead> lstLead = td.getLeads(true);
			
	        Lead newLead = new Lead(LastName  = 'Test', Company ='Test', Phone ='555-555-5552');

            insert newLead;
			
		 	List<Lead> test = [SELECT Id, Email, duplicate__c, Phone, phone_match__c FROM Lead WHERE Id = :newLead.Id];	 	
	
		 	System.assertEquals(true,test[0].phone_match__c);
		}		
    }     
 
    static testMethod void testLeadPhones() {
		
        TestDataGenerator td = new TestDataGenerator();
    	
    	list<Lead> lstLead = td.getLeads(true);

        lstLead[0].Phone = '0110123456789' ;
        lstLead[0].Bad_Phone_Number__c = true;
//        lstLead[0].Sales_Phone__c = '1234567890' ;
    	update lstLead[0];
		lstLead[0].Phone = '1234567890' ;
		update lstLead[0];
		
	 	List<Lead> test = [SELECT Id, Phone, MBA_Phone_1__c FROM Lead WHERE Id = :lstLead[0].Id];	 	

	 	System.assertEquals('0110123456789' ,test[0].MBA_Phone_1__c);
	 		
    }     
    
 
   static testMethod void testLeadEmailDuplicates() {
		System.runAs(BCSettings.apiUser)
		{
	        TestDataGenerator td = new TestDataGenerator();
	    	
	    	list<Lead> lstLead = td.getLeads(true);
	    	lstLead[0].email = 'email2@test.com';
	    	update lstlead[0];
						
	        Lead newLead = new Lead(LastName  = 'Test', Company ='Test', Phone ='555-555-5566');
	        newLead.Email = 'email2@test.com';
	    	insert newLead;
			
		 	List<Lead> test = [SELECT Id, Email, is_duplicate__c, Phone, phone_match__c FROM Lead WHERE Id = :newLead.Id];	 	
	
		 	System.assertEquals(true,test[0].is_Duplicate__c);
		}		
    }     
}