@isTest(SeeAllData=true)
private class TestOpportunityTrigger
{

    static testMethod void testCreateCaseFromOpp() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Contact> lstCon = td.getContacts(true);
    	
    	// Create a new opportunity for the account
    	
    	Opportunity o = new Opportunity();
        o.Name = 'Test ';
        o.CloseDate = Date.today().addDays(1);
        o.StageName = 'Purchased';
       
        o.AccountId = lstCon[0].AccountId;
        insert o;
	
    	Test.startTest();
    	    
		 OpportunityHelper oh = new OpportunityHelper();
         Opportunity opp = oh.createOppProfFromCon(lstCon[0].Id);  
         PriceBookEntry pb = [select Id, Name from PriceBookEntry where 
                                          Pricebook2.Name ='BigCommerce' and isActive = true 
                                          and Name like '%Mig%' limit 1]   ;
         OpportunityLineItem oli = new OpportunityLineItem(OpportunityId =opp.Id,
                                       PricebookEntryId= pb.Id,       
                                       TotalPrice =100, Quantity =1);
		 insert oli;
		 opp.StageName = 'Closed Won';
		 opp.Store_Opportunity__c = o.Id;
		 opp.Migration_Platform__c = 'Test';
		 opp.Current_Store_URL__c = 'http://test.com';
		 update opp;
		Test.stopTest();
	}
	
	static testMethod void testOppTeamRetention() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	list<Opportunity> lstOpp = td.getOpportunities(true);
    	
    	List<OpportunityTeamMember> otms = [select Id from OpportunityTeamMember where OpportunityId in :lstOpp];

		System.assertEquals(otms.size(), lstOpp.size());
		
		User usr1 = [Select Id,Name, Department from User Where IsActive=true and Department =:Label.Inbound_Sales LIMIT 1];
		
  		lstOpp[0].OwnerId = usr1.Id;
  		update lstOpp[0];
  		   	
  		List<OpportunityTeamMember> otmsa = [select Id from OpportunityTeamMember where OpportunityId in :lstOpp];
  		system.debug(lstOpp.size()+1);
  		System.assertEquals(otmsa.size(), lstOpp.size()+1);
  		
    }
}