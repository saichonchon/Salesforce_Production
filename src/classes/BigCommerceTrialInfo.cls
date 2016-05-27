public with sharing class BigCommerceTrialInfo
{
    public String output { get;set;}
    private final Lead thisLead;

   public BigCommerceTrialInfo(ApexPages.StandardController stdController)
    {
    	try {
	        this.thisLead = (Lead)stdController.getRecord();
	        Lead QueryLead = [Select l.Id, l.MBAHostingID__c, l.Time_Zone__c from Lead l WHERE l.Id = :this.thisLead.Id];
	
	        HttpRequest req = new HttpRequest();
	        Http http = new Http(); 
	        req.setMethod('GET');
	        String url = 'https://account.bigcommerce.com/bigcommerce/salesforce/trial_progress.php?';
	        url += '&hostingId=' + QueryLead.MBAHostingID__c;
	        url += '&timezone=' + QueryLead.Time_Zone__c;
	        url += '&leadId=' + QueryLead.Id;
	        req.setEndPoint(url);
	        HTTPResponse resp = http.send(req);
	        output = resp.getBody();
    	}catch(Exception e){}
    }
    public static testMethod void mytest(){
  
	   
		Lead l=new Lead(FirstName = 'Test',LastName = 'Student', Company = 'Student',Status = 'Open', Time_Zone__c = -4.0, MBAHostingID__c = '999999999999');
		insert l; 
		ApexPages.StandardController controller = new ApexPages.StandardController(l); 
		BigCommerceTrialInfo b = new BigCommerceTrialInfo(controller);
	 
    }	
}