@isTest(seeAllData=true) 
public class TestMBAStagingSubscription 
{
	static testMethod void testStagingSubscription() 
	{
		// Create Test Data
		TestDataGenerator td = new TestDataGenerator();
		
		// List of Staging Contact Records
		list<MBA_Staging_Contact__c> stgConList = new list<MBA_Staging_Contact__c>();
		set<string> stgConSet = new set<string>();
					 	
		// Create Map of Contacts Associated with a Staging Account Record
		map<string, Contact> ConMap = new map<string, Contact>();
		map<string, MBA_Staging_Contact__c> stgConMap = new map<string, MBA_Staging_Contact__c>();  
					 	
		// Start Test
		test.startTest();
					 	
		// Initialize the Custom Setting Map    
		td.getStagingToTableMappingSettings();
		
		// Create Staging Account Records 
		td.getAccountMBAs(true, true);
				    	 
		// Create Staging Contact Records 
		td.getContactMBAs(true, true);
		
		// Create Staging Subscription Records
		td.getStagingSubscriptions(true, false, td.AccountMBAs[0].MBAAccountID__c, 99999980);
		
		// Capture all the Subscription Ids
		set<string> stSubIds = new set<string>();
		
		for (MBA_Staging_Subscription__c sub : td.lstStagingSubscriptions)
		{
			stSubIds.add(sub.MBASubscriptionID__c);
		}
		
		// Validate that actual subscriptions were created
		system.assertEquals(stSubIds.size(), [SELECT count() FROM Subscription__c WHERE MBASubscriptionID__c IN : stSubIds]);	         	
		   
        test.stopTest();
	}
}