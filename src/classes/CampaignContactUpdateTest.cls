@isTest
public class CampaignContactUpdateTest {

	
  @testSetup static void setup() {
        // Create 
		Campaign cam = new Campaign(name ='!0K GMV');
		insert cam;
		system.debug(cam.Id);
		Campaign camRet = new Campaign(name ='Retention Campaign');
		insert camRet;
		
		CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId=camRet.Id, HasResponded=false, Label='Not Sent', SortOrder=3);	
		CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId=camRet.Id, HasResponded=false, Label='Sent', SortOrder=4); 
		CampaignMemberStatus cms3 = new CampaignMemberStatus(CampaignId=camRet.Id, HasResponded=false, Label='Attended', SortOrder=5);
 
		insert new List<CampaignMemberStatus>{cms1, cms2, cms3};
////		CampaignMemberStatus  cms2 = [select Id, Label, isDefault from CampaignMemberStatus where  CampaignId = :camRet.Id ];
//		if (cms2.isDefault ==true)   cms2.isDefault=false;                   
		
//		update cms2;
//		CampaignMemberStatus  cms1 = new CampaignMemberStatus ( SortOrder=2,
//		                           Label = 'Not Sent', IsDefault = true, CampaignId = camRet.Id );
	
//		insert cms1;
        List<CampaignRules__c > rules = new List<CampaignRules__c >();
        CampaignRules__c ruleg = new CampaignRules__c (
        				Name = '1000',
        				Starting_GMV__c =0.00,
        				Ending_GMV__c=10000,
        				Rule_Name__c = 'GMV',
        				Campaign_ID__c  = cam.Id);
        
        rules.add(ruleg);
        CampaignRules__c rulezero = new CampaignRules__c (
        				Name = 'zero',
        				Starting_GMV__c =0.00,
        				Ending_GMV__c=0.01,
        				Rule_Name__c = 'GMV',
        				Campaign_ID__c  = cam.Id);
        
        rules.add(rulezero);
 // retention       
        CampaignRules__c rulerc = new CampaignRules__c (
        				Name = 'Retention Campaign',
        				Starting_GMV__c =0.00,
        				Ending_GMV__c=100.00,
        				Rule_Name__c = 'Retention Campaign',
        				Campaign_ID__c  = camRet.Id);
        
        rules.add(rulerc);
        
        insert rules;
        
        String zeroCamId = CampaignUtility.getCampaignId(0);
        
        system.debug('zero '+zerocamid);
        system.debug('100'+CampaignUtility.getCampaignId(0));
        
        Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
    	TestDataGenerator td = new TestDataGenerator();
      
      	list<Contact> lstCon = td.getContacts(true);
      	list<Opportunity> lstOpps = new List<Opportunity>();
      	List<BI_Data__c> lstbi = new List<BI_Data__c>();
      	list<Subscription__c> subs = td.getSubscriptions(true);
      // Create a new opportunity for the account
      
        for (Contact a :lstCon)
        {
	        Opportunity obj = new Opportunity();
	        obj.Name = 'Test ';
	        obj.CloseDate = Date.today().addDays(1);
	        obj.StageName = 'Purchased';
	        obj.Contact__c = a.Id;
	        obj.AccountId = a.AccountId;
	        obj.PurchaseDate__c = Date.today().addMonths(-2);
	        obj.RecordTypeId = storeRecordTypeId;
	        obj.Status__c = 'Active';
        //o.Pricebook2Id = getPricebook(true).Id;
        	lstOpps.add(obj);
        	a.Primary_MBA_Contact__c = true;
        	
        	BI_Data__c bi = new BI_Data__c (Lifetime_GMV__c =80.00, Opportunity__c = obj.Id, Subscription__c = subs[0].Id, Previous_Months_GMV__c = 100.00, Previous_Month_GMV_Date__c = Date.Today() );
			lstbi.add(bi);
        }
        update lstCon;
        insert lstOpps;  
        insert lstbi;  
  }     
    
     public static testmethod void test_batchAddCampaign() {
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        Test.startTest();
// Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BatchAddToCampaign());
        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same 
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run  
        
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run  
        
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        
        //Test the actual code run
        CampaignContactsUpdate opps = new CampaignContactsUpdate();
     
        Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
        String query1 = 'Select contact__r.Id, contact__r.Primary_MBA_Contact__c, RecordTypeId, AccountId, bi_Data__r.Previous_months_GMV__c, bi_Data__r.Previous_Month_GMV_Date__c  From Opportunity where RecordTypeId = :storeRecordTypeId ';
 		query1 = query1 + ' limit 2';
        
        opps.query = query1;
        Database.executeBatch(opps,90);      
        
        Test.StopTest();
    }
     
 
    public static testmethod void test_updateCamStatus() 
    {
    	
    	List<Contact> cons = [Select Id from Contact limit 1];
    	CampaignRules__c camrule = CampaignUtility.getCampaignByName('Retention Campaign');
    	
    	String retCamId = camrule.Campaign_Id__c;

    	CampaignMember cm = new CampaignMember(contactId = cons[0].Id, CampaignId = retCamId, Status ='Not Sent' );
   		insert cm;
    	Task tsk = new Task(WhoId = cons[0].Id,ActivityDate=System.today(),Subject='Mass Email Test', Status = 'Completed');
   		insert tsk;
   		
    	String msg = UpdateCampaignStatus.updateRecords(retCamId);
    }
    	
    	
    
}