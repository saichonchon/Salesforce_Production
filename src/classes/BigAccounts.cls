public with sharing class BigAccounts
{
    public String output { get;set;}
    private final Account thisAccount; 

    public BigAccounts(ApexPages.StandardController stdController)
    {
        try{
        this.thisAccount = (Account)stdController.getRecord();
        Account QueryAccount = [Select l.Id, l.MBAHostingID__c,l.Converted_LeadId__c from Account l WHERE l.Id = :this.thisAccount.Id];
        
        
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('GET');
            String url = 'https://account.bigcommerce.com/bigcommerce/salesforce/account_history.php?';
            url += '&hostingId=' + QueryAccount.MBAHostingID__c;
            url += '&leadId=' + QueryAccount.Converted_LeadId__c;
            req.setEndPoint(url);
            HTTPResponse resp = http.send(req);
            output = resp.getBody(); 
            system.debug('==========================================='+output); 
        }catch(Exception e){}
    }
     public static testMethod void myTest() {
        
        Account l=new Account(Name = 'Test');
        insert l;
        ApexPages.StandardController controller = new ApexPages.StandardController(l); 
        BigAccounts b = new BigAccounts(controller);
        
     }
     
}