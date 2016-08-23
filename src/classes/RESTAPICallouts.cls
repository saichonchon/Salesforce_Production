global class RESTAPICallouts {
    /**
     * Steve O'Neal
     * 2016-08-19
     * Used to contain a communication from Salesforce to BMP
     */
    public class BMPSalesforceIDCallout
    {
        // Which Rest api landing point should we hit
        public string EndPointMethod;
        // Which BMP record are we updating
        public string BMPId;
        // What Salesforce record to pass to BMP
        public string SFDCId;

        /**
         * Intantiates an instance of BMPSalesforceIDCallout
         * @author Steve O'Neal
         * @date   2016-08-19
         * @ticket link           https://jira.bigcommerce.com/browse/BRP-4144
         * @param  endPointMethod Endpoint to call
         * @param  bmpID          The BMP ID to update
         * @param  sfdcID         The Salesforce ID to associate with the BMP ID
         * @return                Instance of BMPSalesforceIDCallout
         */
        public BMPSalesforceIDCallout(string endPointMethod, string bmpID, string sfdcID)
        {
            this.EndPointMethod = endPointMethod;
            this.BMPId = bmpID;
            this.SFDCId = sfdcID;
        }
    }

    private static string delimiter = '|';
    private static string delimiterRegEx = '\\|';

    /**
     * Accepts a list of callouts to make to BMP for setting Salesforce IDs
     * @author Steve O'Neal
     * @date   2016-08-19
     * @ticket link        https://jira.bigcommerce.com/browse/BRP-4144
     * @param  bmpCallouts List of API callout requests to be made
     */
    public static void BMPSendSalesforceIDs(List<RESTAPICallouts.BMPSalesforceIDCallout> bmpCallouts)
    {
        System.debug(bmpCallouts);
        List<string> BMPFutureCalloutStringList = new List<string>();

        for (RESTAPICallouts.BMPSalesforceIDCallout bmpCallout : bmpCallouts)
        {
            BMPFutureCalloutStringList.add(bmpCallout.EndPointMethod + delimiter + bmpCallout.BMPId + delimiter + bmpCallout.SFDCId);
        }

        System.debug(BMPFutureCalloutStringList);
        BMPSendSalesforceIDsFuture(BMPFutureCalloutStringList);
    }

    /**
     * Because future callouts may only accept lists of primitive data types as parameters, this method is called indirectly from BMPSendSalesforceIDs
     * after converting the more complex data.
     * @author Steve O'Neal
     * @date   2016-08-19
     * @ticket link       https://jira.bigcommerce.com/browse/BRP-4144
     * @param  bmpCallouts    List of API callout requests to be made
     */
    @future(callout=true)
    private static void BMPSendSalesforceIDsFuture(List<string> BMPFutureCalloutStringList)
    {
        for (string callout : BMPFutureCalloutStringList)
        {
            List<string> calloutPieces = callout.Split(delimiterRegEx);
            System.debug('endPointMethod=' + calloutPieces[0] + ', BMPId=' + calloutPieces[1] + ', SFDCId=' + calloutPieces[2]);
            BMPRequest(calloutPieces[0], calloutPieces[1], RESTAPIUtility.getJSON(calloutPieces[2]));
        }
    }

    private static void BMPRequest (string strEndPointMethod, string bmpid, string strBody)
    {
        HttpResponse response;
        
        Http httpProtocol = new Http();
        
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        
        API_Connection_Setting__c settings = API_Connection_Setting__c.getValues('BMP');
        
        //Set your username and password here
        String username = settings.UserName__c;
        String password = settings.Password__c;
        system.debug('credd '+settings.Password__c);
        String jiraURL  = settings.URL__c;

        Blob headerValue = Blob.valueOf(username+':'+settings.Password__c);
        string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json');
        
        // Set the endpoint URL.        
       request.setEndPoint(jiraURL + strEndPointMethod + '/' + bmpid);
        
        // Set the HTTP verb to GET.
        string strAction = 'PUT';
        request.setMethod(strAction);
    
        // If a body exists
        system.debug('*** body '+request.getBody());
        if (strBody != null && strBody <> '')
        {
            request.setBody(strBody);
            
        }
        system.debug('*** body '+request.getBody());
        if(test.isRunningTest())
        {
            response = new HttpResponse();  
        }
        else
        {
        	try {
        	     system.debug('*** REST:BMPRequestSetup - API Request Made with: ' + request.toString());
            	 response = httpProtocol.send(request);
		         system.debug('***'+response.getBody());
            	}
				catch (Exception e)
				{
					System.debug('*** calling service failed: ' + e);
					ErrorEmailHelper.notifyOnError('BMP Callout', 'Service Error', 'Error Occured in calling BMP', ' Request: ' + request.toString() + ' Error Message: ' + e.getMessage());
        
					//EmailUtils.sendTextEmail(recipients, emailSubject, textBody);
				}
        }
    }

}