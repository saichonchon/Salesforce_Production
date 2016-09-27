/**
 * This class contains unit tests for validating the Account triggers and 
 * other functionality.
 */
@isTest
private class TestAccountTrigger {
  
    static testMethod void testOwnerChange() 
    {
		Id idPartnerRecordType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Channel Partner Record Type').getRecordTypeId();
 		Id idClientRecordType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Record Type').getRecordTypeId();
		
		TestDataGenerator td = new TestDataGenerator();
	    	
	    list<Account> lstAcct = td.getAccounts(true);
	    User ao = td.getUsers(null)[0];
		lstAcct[0].OwnerId = ao.Id;
		lstAcct[0].RecordTypeId = idClientRecordType;
		
		
		User co = td.getUsers(null)[0];
		lstAcct[1].OwnerId = co.Id;
		lstAcct[1].RecordTypeId = idPartnerRecordType;
		lstAcct[1].Type = 'Agency Partner';
		lstAcct[1].iDev_Partner_ID__c = 1234;
		update lstAcct;
		
	    list<Subscription__c> lstSubs = td.getSubscriptions(true);
	    for (Subscription__c s :lstSubs)
	    {
	    	s.Account__c = lstAcct[0].Id;
	    }
	    
	    lstSubs[1].Channel_Partner__c = lstAcct[1].Id;
	    lstSubs[1].MBAPartnerID__c = '1234';
	    update lstSubs;
	    
	    list<Opportunity> lstOpps = td.getOpportunities(true);
	    for (Opportunity o :lstOpps)
	    {
	    	o.AccountId = lstAcct[0].Id;
	    	o.OwnerId = ao.Id;
	    }
	   
	    lstOpps[1].Channel_Partner__c = lstAcct[1].Id;
	    lstOpps[1].MBAPartnerID__c = '1234';
	    update lstOpps;
	    
	     Contact c = new Contact();
                        c.FirstName = 'First ' ;
                        c.LastName = 'Last ' ;
                        c.MailingCountry ='US';
                        c.Email = 'testmail' + '@bigcommerce.com';
                        c.AccountId = lstAcct[0].Id;
         insert c;
         
	    Test.startTest();
		User ao2 = td.getUsers(null)[0];
		lstAcct[0].OwnerId = ao2.Id;
		
		update lstAcct[0];
		User co2 = td.getUsers(null)[0];
		lstAcct[1].OwnerId = co2.Id;
		
		update lstAcct[1];
		Test.stopTest();
    }
}