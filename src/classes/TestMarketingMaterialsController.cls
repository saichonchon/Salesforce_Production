@isTest
public class TestMarketingMaterialsController
{
    static testMethod void testMMController() 
    {
    	TestDataGenerator td = new TestDataGenerator();
    	
    	// Create a test account
    	list<Account> lstAcct = td.getAccounts(false);
    	Account objA = lstAcct[0];
    	objA.iDev_Partner_ID__c = 9990055;
    	insert objA;
    	
    	// Create a contact
    	list<Contact> lstContact = td.getContacts(false);
    	Contact objC = lstContact[0];
    	objC.AccountId = objA.Id;
    	insert objC;
    	
    	// Turn the contact into a portal user
		Profile p = [SELECT id 
						FROM profile
						WHERE name = 'PRM Portal User'
						LIMIT 1];  
		
		String testemail = 'puser000@amamama.com';

		User pu = new User(profileId = p.id, username = testemail, email = testemail,
							emailencodingkey = 'UTF-8', localesidkey = 'en_US',
							languagelocalekey = 'en_US', timezonesidkey = 'America/Chicago',
							alias='cspu', lastname='lastname', firstname='firstname', contactId = objC.id);

        insert pu;
    	    	
    	
    	// Create the Marketing Materials data    	
    	list<Marketing_Material__c> lstMM = td.getMarketingMaterials(true);
    	
    	set<string> stMMTypes = new set<string>();
    	for (Marketing_Material__c mm : lstMM)
    	{
    		stMMTypes.add(mm.Type__c);
    	}
    	
    	test.startTest();
    	
    	System.RunAs(pu)
    	{
	    	PageReference pageRef = Page.MarketingMaterials;
	        Test.setCurrentPage(pageRef);
	
	        // Instantiate a new controller with all parameters in the page      
	        MarketingMaterialsController controller = new MarketingMaterialsController();
	       	controller.LoadMaterials();
	       	system.assertNotEquals(0, controller.lstMaterials.size());
	       	
	       	for (string s : stMMTypes)
	       	{
	       		ApexPages.currentPage().getParameters().put('mmType', s);
	       		controller = new MarketingMaterialsController();       		
	       		controller.SelectMarketing();
	       		system.assertEquals(controller.MMType, s);
	       		system.assertNotEquals(0, controller.lstMaterials.size());
	       		system.assertNotEquals(0, controller.stTypes.size());
	       		
	       		system.debug('Current User: ' + PartnerPortalHelper.CurrentUserRecord);
	       		system.debug('Current Account: ' + PartnerPortalHelper.PartnerAccount);
	       		
	       		// Run through the properties of the sub class
	       		MarketingMaterialsController.clsMaterial m = controller.lstMaterials[0];

       			string m1 = m.MaterialType;
       			string m2 = m.MaterialName;
       			string m3 = m.TargetURL;
       			string m4 = m.Size;
       			string m5 = m.MaterialDesc;
       			string m6 = m.SourceCode;
       			string m7 = m.TextVersion;
       			boolean m8 = m.isActive;
       			string m10 = m.RecordID;
	       	}
    	}
    	
    	test.stopTest();
    }
}