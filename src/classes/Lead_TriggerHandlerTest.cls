@isTest(SeeAllData = true)
private class Lead_TriggerHandlerTest { 
	 
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
    	update lstLead[0];
		lstLead[0].Phone = '1234567890' ;
		update lstLead[0];
		
	 	List<Lead> test = [SELECT Id, Phone, MBA_Phone_1__c FROM Lead WHERE Id = :lstLead[0].Id];	 	
	 		
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