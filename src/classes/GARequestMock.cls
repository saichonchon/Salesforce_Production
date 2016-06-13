/*
	Name: GARequestMock
	Author: Steve O'Neal
	Created: 5/10/2016
	Purpose: To test the http callouts to Google Analytics
	Ticket: BAP-3444
*/
@isTest
global class GARequestMock implements HttpCalloutMock {
	API_Connection_Setting__c APISettings;
	
	global GARequestMock()
	{
		APISettings = API_Connection_Setting__c.getValues('GoogleAnalytics');
	}
	
    global HTTPResponse respond(HTTPRequest req)
    {
    	// verify that this is ONLY used for testing Google Analytics endpoint
    	System.assertEquals(APISettings.URL__c, req.getEndPoint());
    	
    	// create a fake response.  Currently we do not consume the response, so it can be null
    	HttpResponse retVal = new HttpResponse();
    	retVal.setBody('Successfully stubbed');
    	return retVal;
    }
}