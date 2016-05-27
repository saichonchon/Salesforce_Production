public with sharing class TestDataGenerator_SubscriptionValidation {

	//Always allow for the creation of one or more users
	public list<User> users;
	public map<String,list<User>> profileToUserMap;      
 
	public list<Account> accounts;
	public list<Contact> contacts;
	public list<Lead> leads;  
	public list<Subscription__c> lstSubscriptions;

	public Integer userNum;
	public Integer accountNum;
	public Integer contactNum;
	public Integer leadNum;      
	public Integer subscriptionNum;

	public TestDataGenerator_SubscriptionValidation()
	{
		userNum = 5;
		accountNum = 5;
		contactNum = 5;  // Contacts count should be equal to opptynum size
		leadNum = 5;
		subscriptionNum = 5;
        
	}

      public list<Account> getAccounts(Boolean xCommit) 
      {
            if(accounts == null) {
                  accounts = new list<Account>();
                  for(Integer i = 0; i < accountNum; i++) {
                        Account a = new Account();
                        a.Name = 'Test ' + i;
                        a.SupportPin__c = '0000'+i;
                        a.BillingStreet='Main St';
                        a.BillingCity='Dallas';
                        a.BillingState = 'TX';      
                        a.BillingPostalCode='70000';
                        a.BillingCountry = 'US';
                        accounts.add(a);
                  }
                  if(xCommit) insert accounts;
            }
            
            if(xCommit && accounts.size() > 0 && accounts[0].Id == null) insert accounts;                                            
            
            return accounts;
      }

	public list<Subscription__c> getSubscriptions (boolean xCommit)  
    {
		if(lstSubscriptions == null) 
		{
			lstSubscriptions = new list<Subscription__c>();
			for(Integer i = 0; i < subscriptionNum; i++) 
			{
				Subscription__c sub = new Subscription__c();
				sub.RecordTypeId = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();
				sub.MBASubscriptionID__c = '12345-' + i;
				sub.Status__c = 'Active';
				sub.ProductType__c = 'Store';
				sub.Product__c = 'Silver Store';
				sub.StoreURL__c = 'http://www.testingthis.com';
                Integer j = Math.mod(i,getAccounts(true).size());
				sub.Account__c = getAccounts(true)[j].Id;
							
				lstSubscriptions.add(sub);
			}
  			
  			if(xCommit) insert lstSubscriptions;
		}

		if(xCommit && lstSubscriptions.size() > 0 && lstSubscriptions[0].Id == null) insert lstSubscriptions;
		system.debug('***** lstSubs: '+lstSubscriptions);
		
		
		list<Subscription__c> lstSubscriptionsFinal = [SELECT Id, Account__r.Id, Account__r.OwnerId, Lead__r.Id, Support_PIN__c, StoreURL__c 
					FROM Subscription__c WHERE Id IN :lstSubscriptions];
		
		system.debug('***** subsFinal: '+lstSubscriptionsFinal);
		return lstSubscriptionsFinal;
	}

}