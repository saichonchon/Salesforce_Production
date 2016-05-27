@isTest(SeeAllData=true)
private class TestRVlogic {

	private static testMethod void partnerLeadTest()
{		
		TestDataGenerator td = new TestDataGenerator();  
		List<string> profiles = new List<String>();
		
		User treeUser = [select Id from User where Id=:Label.Lead_PRM_Owner];
		 
		Profiles.add('Sales Rep');
		List<User> salesusers = td.getUsers(Profiles);
		integer counter = 1;
		for (user u:salesusers)
		{
			u.firstName = u.firstName + counter;
			u.lastName = u.lastName + counter;
			system.debug('user '+u.lastName);
			counter = counter + 1;
		}
		update salesusers;
		
		list <User> newUsers = [select Id, full_name__c from User where Id in :salesusers];
		system.debug(' user name '+newusers[0].Full_Name__c);
//		System.RunAs(treeUser)
		{
			rvpe__RVAccount__c  rva = new rvpe__RVAccount__c (Name = 'Bigcommerce Partner', 
															rvpe__ExtAccountId__c = 933611,
															OwnerId = treeUser.Id,
															rvpe__PartnerLevel__c = 'Solutions',
															Account_Owner__c = 'Justin Platt');
			insert rva;
			rvpe__RVMember__c rvm = new rvpe__RVMember__c (Name = 'Member', OwnerId = treeUser.Id, 
															rvpe__ExtMemberId__c = 963611,
															rvpe__FirstName__c = 'First',
															rvpe__LastName__c = 'Last',
															rvpe__UserName__c = 'Test',
															rvpe__RVAccount__c = rva.Id);
			insert rvm;
		}
		
		rvpe__RVAccount__c  rva1 = [select Id, OwnerId, Owner.Name from rvpe__RVAccount__c  rva 
    								where name = 'Bigcommerce Partner'];
		system.debug(' rv owner '+rva1.Owner.Name);
	
		   	List<Lead> lstLeads = td.getLeads(false); 
		   	
		   	for (Lead l:lstLeads)
		   	{
		   		l.rvpe__RVAccount__c = rva1.Id;
		   	}
		   	insert lstLeads;
		
		   	List<Opportunity> opps =  td.getOpportunities(false);
		   	for (Opportunity o:opps)
		   	{
		   		o.rvpe__RVAccount__c = rva1.Id;
		   		o.OwnerId = salesusers[0].Id;
		   	}
		   	insert opps;
		

 	    User u1  = [Select Id from User where lastname = 'Testing2'];
   	    system.debug('**  user name '+u1.Id);
   	    rva1.OwnerId = u1.Id;
    	update rva1;
    	
 //   	List<Opportunity> opps = [ select Id, OwnerId from Opportunity ];
		
		
		
	}

}