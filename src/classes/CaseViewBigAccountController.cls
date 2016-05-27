// ==================================================================================
//   Object: CaseViewBigAccountController
//  Company: BigCommerce
//   Author: Mohan Kumar (Sales Optimizer)
// Comments: Invokes a http callout with required parameter and when the http call is
//			 successful parse the response to retrieve the new link where the user
//			 needs to be redirected.
// ==================================================================================
//  Changes: 2012-10-02 Initial version.
// ==================================================================================

public with sharing class CaseViewBigAccountController {
	
	private String cId = '';
	
	public CaseViewBigAccountController(Apexpages.StandardController sc) {
		cId = sc.getId();
	}
	
	public Pagereference autoRun() {
		try{
			Case c = [Select Id, Account.MBAHostingID__c, Account.Converted_LeadId__c From Case 
	        						Where Id =: cId];
	        HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('GET');
            String url = 'https://account.bigcommerce.com/bigcommerce/salesforce/account_history.php?';
            url += '&hostingId=' + c.Account.MBAHostingID__c;
            url += '&leadId=' + c.Account.Converted_LeadId__c;
            req.setEndPoint(url);
            String output;
            HTTPResponse resp = http.send(req);
            output = resp.getBody();
            System.debug('output: '+ output);
            String newURL = fetchNewURL(output);
            if(newURL != null && newURL != '') return new Pagereference(newURL);
            /*if(output != null && output.contains('View in MyBigAccount')) {
            	List<String> tempList = output.split('window.open');
            	String tmp = tempList[1];
            	tmp = tmp.substring(2);
            	tmp = tmp.substring(0, tmp.indexOf(')'));
            	System.debug('tmp: '+ tmp);
            	return new Pagereference(tmp);
            }*/
        }catch(Exception e){ System.debug('error message : '+ e.getMessage()); }
        return new Pagereference('/'+cId);
	}
	
	public String fetchNewURL(String output) {
		String tmp;
		if(output != null && output.contains('View in MyBigAccount')) {
        	List<String> tempList = output.split('window.open');
        	tmp = tempList[1];
        	tmp = tmp.substring(2);
        	tmp = tmp.substring(0, tmp.indexOf(')'));
        	System.debug('tmp: '+ tmp);
        	//return new Pagereference(tmp);
        }
        return tmp;
	}
}