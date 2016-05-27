public with sharing class BigAccountInformation
{
    public String output { get;set;}
    private final Lead thisLead; 

    public BigAccountInformation(ApexPages.StandardController stdController)
    {
    	try{	
        	this.thisLead = (Lead)stdController.getRecord();
        	Lead QueryLead = [Select l.Id, l.MBAHostingID__c from Lead l WHERE l.Id = :this.thisLead.Id];
		
	        HttpRequest req = new HttpRequest();
	        Http http = new Http();
	        req.setMethod('GET');
	        String url = 'https://account.bigcommerce.com/bigcommerce/salesforce/account_history.php?';
	        url += '&hostingId=' + QueryLead.MBAHostingID__c;
	        url += '&leadId=' + QueryLead.Id;
	        req.setEndPoint(url);
	        HTTPResponse resp = http.send(req);
	        output = resp.getBody(); 
		}catch(Exception e){}
    }
     public static testMethod void myTest() {
     	
     	Lead l=new Lead(FirstName = 'Test',LastName = 'Student', Company = 'Student',Status = 'Open');
		insert l;
		ApexPages.StandardController controller = new ApexPages.StandardController(l); 
		BigAccountInformation b = new BigAccountInformation(controller);
     	
     }
     
}