global class JIRAConnectorWebserviceCallout {
    @future (callout=true)
    WebService static void createIssue( String jiraType, String objectId ) {
 // get all values for this call

        JiraSettings__c settings = JiraSettings__c.getValues(jiraType);
        
        //Set your username and password here
        String username = settings.UserName__c;
        String password = settings.Credentials__c;
        String jiraURL  = settings.Jira_URL__c;
        String systemId = settings.System_Id__c;
        String objectType = 'Case';
        String projectKey = settings.Project_Key__c;
        String issueType =settings.Issue_Type__c;
        
        //Construct HTTP request and response
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
 
        //Construct Authorization and Content header
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
 
        //Construct Endpoint
        String endpoint = jiraURL+'/rest/customware/connector/1.0/'+systemId+'/'+objectType+'/'+objectId+'/issue/create.json';
        system.debug(' end point' +endpoint);
        //Set Method and Endpoint and Body
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody('{"project":"'+projectKey+'", "issueType":"'+issueType+'"}');
 
        try {
           //Send endpoint to JIRA
           res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug(res.toString());
        }
    }
    
    @future (callout=true)
    WebService static void syncIssue( String jiraType, String objectId ) {
 // get all values for this call

        JiraSettings__c settings = JiraSettings__c.getValues(jiraType);
        
        //Set your username and password here
        String username = settings.UserName__c;
        String password = settings.Credentials__c;
        String jiraURL  = settings.Jira_URL__c;
        String systemId = settings.System_Id__c;
        String objectType = 'Case';
        String projectKey = settings.Project_Key__c;
        String issueType =settings.Issue_Type__c;
        
        //Construct HTTP request and response
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
 
        //Construct Authorization and Content header
        Blob headerValue = Blob.valueOf(username+':'+password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json');
 
        //Construct Endpoint
        String endpoint = jiraURL+'/rest/customware/connector/1.0/'+systemId+'/'+objectType+'/'+objectId+'/issue/synchronize.json';
        system.debug(' end point' +endpoint);
        //Set Method and Endpoint and Body
        req.setMethod('PUT');
        req.setEndpoint(endpoint);
        req.setBody('{"project":"'+projectKey+'", "issueType":"'+issueType+'"}');
 
        try {
           //Send endpoint to JIRA
           res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug(res.toString());
        }
    }
}