/**
 * GACalloutsTest
 * Author: Steve O'Neal
 * Purpose: For testing GAUtility and GARequestMock
 * Ticket: BAP-3444
 *
 * Updates:
 * *********
 * 
 */
@isTest
public class GACalloutsTest {

    /**
     * Test leads
     * @author Steve O'Neal
     * @date   2016-05-25
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3444
     * @return nothing
     */
	static testmethod void testLeadHits() 
    {
    	Test.setMock(HttpCalloutMock.class, new GARequestMock());
        Test.startTest();

        // Create a bevy of leads to test with
        List<lead> testLeads = TestDataFactory.createTestLeads(4, true, TestDataFactory.LeadRecordType.Client_Prospect);


        ////////////////////////////////////////////////////////
        // Convert lead to an account with a Google Analytics //
        ////////////////////////////////////////////////////////
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        List<Database.LeadConvert> leadConversions = new List<Database.LeadConvert>();
        Database.LeadConvert lc = new database.LeadConvert();
    	lc.setLeadId( testLeads[0].id );
    	lc.setConvertedStatus( convertStatus.MasterLabel );
    	leadConversions.add( lc );
     
    	List<Database.LeadConvertResult> results = Database.convertLead( leadConversions );
    	System.assert(results[0].isSuccess());

        // get the account and contact from the converted lead  	
    	Contact testContact = [SELECT Id, AccountId, Email, GAClientID__c FROM Contact WHERE GAClientID__c = :testLeads[0].GAClientID__c];     
    	 
    	Account testAcct = [SELECT Id, GAClientID__c FROM Account WHERE Id = :testContact.AccountId];     
        system.debug(testAcct.GAClientID__c);
		

        /////////////////////////////////////////////
        // Convert a lead into an existing Account //
        /////////////////////////////////////////////
		Database.LeadConvert lc2 = new  database.LeadConvert();
		lc2.setLeadId(testLeads[1].Id);

   		lc2.setConvertedStatus(convertStatus.MasterLabel);
		lc2.setAccountId(testContact.AccountId);
		
		Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
		System.assert(lcr2.isSuccess());
		
		List<Contact> testContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testContact.AccountId];     
 	

        ////////////////////////////////
        // Create MBA Staging Records //
        ////////////////////////////////
        List<MBA_Staging_Subscription__c> mbaSubs = TestDataFactory.createTestMBAStagingSubscriptionsAccountsContacts(1);
        System.debug(mbaSubs.size());
        System.debug(mbaSubs[0].MBAAccountID__c);
 		mbaSubs[0].Status__c = 'Terminated';
 		mbaSubs[0].MonthlyRecurringRevenue__c = 0.00;
 		update mbaSubs;
        test.stoptest();
    }
    

    /**
     * Test leads
     * @author Steve O'Neal
     * @date   2016-05-25
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3444
     * @return nothing
     */
    static testmethod void testLeadHits2() 
    {
    	Test.setMock(HttpCalloutMock.class, new GARequestMock());
        test.startTest();
        
        List<lead> testLeads = TestDataFactory.createTestLeads(1, true, TestDataFactory.LeadRecordType.Client_Prospect);
		
		testLeads[0].Status = 'Qualified';
		update testLeads[0];
		
		testLeads[0].Status = 'Unqualified';
		update testLeads[0];
		
		testLeads[0].Status = 'Open';
		update testLeads[0];

        test.stoptest();
    }
    
    
    /**
     * Test negative results for greater code coverage
     * @author Steve O'Neal
     * @date   2016-05-25
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3444
     * @return nothing
     */
    static testMethod void testExceptions()
    {
    	Test.setMock(HttpCalloutMock.class, new GARequestMock());
    	// make sure that the settings are reset
    	GAUtility.APISettings = null;
    	
    	try
    	{
    		List<String> httpRequests = GAUtility.getGARequestStrings(null, null);
	    	// make sure that the settings are reset
	    	GAUtility.APISettings = null;
	    	GAUtility.GARequest(httpRequests);
    	}
    	catch(Exception e)
    	{
    		
    	}

    	try
    	{
	    	GAUtility.GARequest(GAUtility.getGARequestStrings(GAUtility.GAAction.subscription_termination, null));
	    	// if an exception was not thrown, we want to fail the test
	    	System.assert(false);
    	}
    	catch(Exception e)
    	{
    		
    	}

    	try
    	{
            User currentUser = [Select Id from User where Id = :UserInfo.getUserId()];
	    	GAUtility.GARequest(GAUtility.getGARequestStrings(GAUtility.GAAction.subscription_termination, currentUser));
    	}
    	catch(Exception e)
    	{
    		
    	}
    }



}