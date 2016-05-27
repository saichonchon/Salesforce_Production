@isTest
private class BatchPartnerCommissionsTest {
	
	@testSetup static void setup() 
    {
      TestDataGenerator td = new TestDataGenerator();
      list<Account> lstAcc = td.getAccounts(true);
      list<Subscription__c> subs = td.getSubscriptions(true);
      // Create a new opportunity for the account
      Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
	  rvpe__RVAccount__c  rva = new rvpe__RVAccount__c (Name = 'Test Partner', rvpe__ExtAccountId__c = 912345, Commission__c = 20);
	  insert rva;
	  
      Opportunity o = new Opportunity();
        o.Name = 'Test RV';
        o.RecordTypeId = StoreRecordTypeId;
        o.CloseDate = Date.today().addDays(1);
        o.StageName = 'Purchased';
        o.rvpe__RVAccount__c = rva.Id;
        o.BillingCycle__c = 'Monthly';
        o.AccountId = lstAcc[0].Id;
        //o.Pricebook2Id = getPricebook(true).Id;
        insert o;
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'Test RV Annual';
        o2.RecordTypeId = StoreRecordTypeId;
        o2.CloseDate = Date.today().addDays(10);
        o2.StageName = 'Purchased';
        o2.rvpe__RVAccount__c = rva.Id;
        o2.BillingCycle__c = 'Annually';
        o2.AccountId = lstAcc[0].Id;
        //o.Pricebook2Id = getPricebook(true).Id;
        insert o2;
        
        BI_Data__c bi = new BI_Data__c (Lifetime_GMV__c =1000.00, Opportunity__c = o.Id, Subscription__c = subs[0].Id, Last_Payment_Amount__c =20.00, Last_Payment_Date__c = Date.Today() );
  		insert bi;
  		
  		date nextdate = Date.Today().addmonths(-3);
  		
  		BI_Data__c bia = new BI_Data__c (Lifetime_GMV__c =2000.00, Opportunity__c = o2.Id, Subscription__c = subs[1].Id, Last_Payment_Amount__c =2000.00, Last_Payment_Date__c = nextDate );
  		insert bia;
        
        Id detailRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Detail').getRecordTypeId();
		
      	Partner_Commission__C newc = new Partner_Commission__C(Name = 'Test past', Opportunity__c = o.id, 
																		BIData__c = bi.Id,
																		RVAccount__c = rva.Id,
																		Payment_Date__c = nextDate,
																		RecordTypeId = detailRecordTypeId,
																		IncludeInCurrentMonth__c = true,
																		Payment__c = 200);
      	insert newc;
    }
    
   @isTest static void testUpdateCurrent() 
   {
   	  
   	  List<Partner_Commission__c>  pc = [select Name from Partner_Commission__c ];
   	  
   	  //Start the Testing! 
 //      Test.startTest(); 

       BatchSetCurrentMonthCommissions bc= new BatchSetCurrentMonthCommissions(); 
       bc.execute(null);
  //     Test.stopTest();

    
   		
   } 
   
   @isTest static void testBatchSummary() 
   {
   	  
 //  	  List<Partner_Commission__c>  pc = [select Name from Partner_Commission__c ];
   	  
   	  //Start the Testing! 
       Test.startTest(); 

       BatchPartnerCommissions bc= new BatchPartnerCommissions(); 
       bc.execute(null);
       Test.stopTest();

    
   		
   }
      
   @isTest static void testBatchUpdateStatus() 
   {
   	  
   	  
   	  //Start the Testing! 
       Test.startTest(); 
		String q = 'Select Id, Commission_Payment_Status__c from rvpe__RVAccount__c  ';
		String e = 'rvpe__RVAccount__c';
		String f = 'Commission_Payment_Status__c';
		String v = 'Completed';
		Id batchInstanceId = Database.executeBatch(new UpdateFields(q,e,f,v), 95); 
       
       Test.stopTest();

    
   		
   }
   
}