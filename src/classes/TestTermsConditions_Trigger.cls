@isTest
public class TestTermsConditions_Trigger
{
    static testMethod void testTCTrigger() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Terms_Conditions__c> lstTC = new list<Terms_Conditions__c>();
    	
    	lstTC = td.getTermsConditions(true);    	
    	Terms_Conditions__c tc1 = lstTC[0];
    	
    	lstTC = new list<Terms_Conditions__c>();
    	
    	// Now create a few records that will overlap the previous one    	
    	Terms_Conditions__c tc2 = new Terms_Conditions__c();
    	tc2.Type__c = 'Testing This';
    	tc2.Active_Date__c = Date.today() + 1;
    	tc2.Expiration_Date__c = Date.today() + 30;
    	tc2.T_C_Text__c = 'Testing 1234';
    	lstTC.add(tc2);
    	
    	Terms_Conditions__c tc3 = new Terms_Conditions__c();
    	tc3.Type__c = 'Testing This';
    	tc3.Active_Date__c = Date.today() - 1;
    	tc3.Expiration_Date__c = Date.today() + 30;
    	tc3.T_C_Text__c = 'Testing 1234';
    	lstTC.add(tc3);
    	
    	test.startTest();
    	
    	// Now insert all the new records and expect to receive errors for each
		for (database.saveResult sr : database.insert(lstTC, false))
		{
			system.assertEquals(false, sr.success);
		}    		
    	
    	lstTC = new list<Terms_Conditions__c>();
    	
    	// Now update one to be successful
    	tc2.Active_Date__c = tc1.Expiration_Date__c + 1;
    	tc2.Expiration_Date__c = tc1.Expiration_Date__c + 30;
    	insert (tc2);
    	
    	// Now update it again to fail
    	tc2.Active_Date__c = tc1.Expiration_Date__c - 10;
    	lstTC.add(tc2);    	
    	
    	// Now update the records and expect to receive errors
		for (database.saveResult sr : database.update(lstTC, false))
		{
			system.assertEquals(false, sr.success);
		} 
    	
    	test.stopTest();
    }
}