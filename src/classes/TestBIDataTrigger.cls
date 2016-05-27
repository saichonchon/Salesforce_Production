@isTest(SeeAllData=true)
private class TestBIDataTrigger {
	
	static testMethod void testTrigger() 
    {
      TestDataGenerator td = new TestDataGenerator();
      Test.startTest();
      list<Account> lstAcc = td.getAccounts(true);
      list<Subscription__c> subs = td.getSubscriptions(true);
      // Create a new opportunity for the account
      Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
	  rvpe__RVAccount__c  rva = new rvpe__RVAccount__c (Name = 'Test Partner', rvpe__ExtAccountId__c = 912345);
	  insert rva;
	  
      Opportunity o = new Opportunity();
        o.Name = 'Test ';
        o.RecordTypeId = StoreRecordTypeId;
        o.CloseDate = Date.today().addDays(1);
        o.StageName = 'Purchased';
        o.rvpe__RVAccount__c = rva.Id;
       
        o.AccountId = lstAcc[0].Id;
        //o.Pricebook2Id = getPricebook(true).Id;
        insert o;
        
        BI_Data__c bi = new BI_Data__c (Lifetime_GMV__c =1000.00, Opportunity__c = o.Id, Subscription__c = subs[0].Id, Last_Payment_Amount__c =20.00, Last_Payment_Date__c = Date.Today() );
  		insert bi;
      	
      	BI_Data__c objbid =[SELECT Id, Account__c, Lifetime_GMV__c FROM BI_Data__c WHERE 
                id  =:bi.Id ];
        
		// Check For Account
        System.assertEquals(objbid.Account__c, o.AccountId );
        
        Account acc = [select Id, Total_Active_Store_GMV__c from Account where Id = :objbid.Account__c];
         
//        System.assertEquals(objbid.Lifetime_GMV__c, acc.Total_Active_Store_GMV__c);
		
		Test.stopTest();
    }
}