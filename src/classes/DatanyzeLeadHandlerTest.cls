@isTest
public  class DatanyzeLeadHandlerTest {
	
	@testSetup static void setup() {
        // Create 
		Campaign cam = new Campaign(name ='Datnyze Phone');
		insert cam;
		system.debug(cam.Id);
		
        List<CampaignRules__c > rules = new List<CampaignRules__c >();
        CampaignRules__c ruleg = new CampaignRules__c (
        				Name = 'Datanyze Phone',
        				Campaign_ID__c  = cam.Id);
        
        rules.add(ruleg);
        CampaignRules__c rulezero = new CampaignRules__c (
        				Name = 'Datanyze Email',
        				
        				Campaign_ID__c  = cam.Id);
        
        rules.add(rulezero);
        insert rules;
	}
	static testMethod void testLeadDatanyzeUpdate() 
	{
          
       TestDataGenerator td = new TestDataGenerator();
        
       list<Lead> lstLead = td.getLeads(false);
       
       
       for (Lead l :lstLead)
       {
       	 l.LeadSource = 'Datanyze';
       	 l.Datanyze_Employee_No__c = '25 - 100';
       	 l.Datanyze_Revenue__c = '$0 - 10M';
       	 l.Datanyze_Industry__c = 'Beauty Products';
       	 l.Datanyze_Phone__c = '512 345 6578';
       	 l.Datanyze_Country__c = 'USA';
       	 
       }
       
       lstLead[3].Datanyze_Revenue__c = '$1B';
       lstLead[3].Datanyze_Phone__c =' 512 344 5566 ext 9';
       insert lstLead;
      
       List<Lead> test = [SELECT Id, Phone, NumberOfEmployees, Datanyze_Employee_No__c, Datanyze_Industry__c FROM Lead WHERE LeadSource = 'Datanyze'];     
  
       System.assertEquals(25,test[0].NumberOfEmployees);
        
    }     

}