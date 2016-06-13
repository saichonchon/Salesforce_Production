global class RESTAPICallouts {

@future(callout=true) 
    public static void BMPRequest (string strEndPointMethod, string bmpid, string strBody)
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
//      return response;
    }
 /*   
    public static HttpResponse JSONRequestSetup (string strEndPointMethod, string strAction, string strBody)
    {
        HttpResponse response;
        
        Http httpProtocol = new Http();
        
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        
        JiraSettings__c settings = JiraSettings__c.getValues(strAction);
        
        //Set your username and password here
        String username = settings.UserName__c;
 //       String password = settings.Credentials__c;
        String password = '8de162a672efb0bc2049072a4fe67057';
        system.debug('password ' +password);
        system.debug('credd '+settings.Credentials__c);
        String jiraURL  = settings.Jira_URL__c;

//      Blob headerValue = Blob.valueOf(username+':'+settings.Credentials__c);
        Blob headerValue = Blob.valueOf(username+':'+ password);
        string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Set the endpoint URL.        
//      request.setEndPoint(strEndPoint + strEndPointMethod + '/');
        request.setEndPoint(jiraURL +  strEndPointMethod + '/');
        
        // Set the HTTP verb to POST.
        request.setMethod(strAction);
    
        // If a body exists
        if (strBody != null && strBody <> '')
        {
            request.setBody(strBody);
        }
        if(test.isRunningTest())
        {
            response = new HttpResponse();  
        }
        else
        {
            system.debug('*** SubscriptionREST:JSONRequestSetup - API Request Made with: ' + request.toString());
            response = httpProtocol.send(request);
        }
        
        return response;
    }
    
  public static void testcall()      
{               
    string sfid ='00119000004WiUP';
    
    // Create a JSON generator object
        JSONGenerator gen = JSON.createGenerator(true);
        // open the JSON generator
      
      gen.writeStartObject();
      gen.writeFieldName('data');
      gen.writeStartObject();
      gen.writeStringField('salesforce_id', sfId);
      gen.writeEndObject();
      gen.writeEndObject();
        // close the JSON generator
      
    // create a string from the JSON generator
      String json2 = gen.getAsString();
      system.debug(json2);
    
    string strEndPointMethod = 'account';
    string strAction= 'PUT';
    string strBody = json2;
    
        HttpResponse response;
        
        Http httpProtocol = new Http();
        
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
    
        
        JiraSettings__c settings = JiraSettings__c.getValues('account');
        // Use actual username / password values for real       
        
        //Blob headerValue = Blob.valueOf('username:password');
        //Set username and password here
        String username = settings.UserName__c;
        String password = settings.Credentials__c;
        String jiraURL  = settings.Jira_URL__c;
        Blob headerValue = Blob.valueOf(username+':'+settings.Credentials__c);
        string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the endpoint URL.        
        //  request.setEndPoint('callout:BMP/00e60c4a-ae32-46aa-9ca7-02a444ee6742');
        string sendid = 'b87cb696-d3a5-4d8e-a7da-0080598553e5';
        //system.debug(sendid); 
        request.setEndPoint(jiraURL + sendid);
        
        // Set the HTTP verb to POST.
        request.setMethod('PUT');
    
        // If a body exists
        if (strBody != null && strBody <> '')
        {
            request.setBody(strBody);
        }
        
        system.debug('*** API Request Made with: ' + request.toString());
        response = httpProtocol.send(request);
    //SONParser parser = JSON.createParser(response.getBody());
            system.debug('***'+response.getBody());
          
}     
 */      
}