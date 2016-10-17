public class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        system.debug('>><< req.getEndpoint() = '+req.getEndpoint());
        /*
        System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        */
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"count":1,"next":null,"previous":null,"results":[{"id":909090,"href":"https://app.promoter.io/api/feedback/909090/","followup_href":"https://app.promoter.io/org/2163/campaign/999999/responses/all/response/909090/","contact":{"attributes":{"Aligned Plan":"Plus","Orders_QTD":"0","StorePlan":"Silver Plan","GMV_QTD":"$0","IndustryDesc":"Apparel & Clothing","SF_AccountID":"'+BatchProcessPromoterIo_Test.accid+'","SF_Contact_Id":"'+BatchProcessPromoterIo_Test.conid+'","Orders_YTD":"4","StoreID":"101010","Orders_MTD":"0","MRR":"$40","StoreCreationDate":"7/30/10","GMV_Lifetime":"$1,663","Visits_YTD":"238","LastLogin":"11/30/15","Country":"US","GMV_YTD":"$0","CP_Status":"CP1","Orders_Lifetime":"14","StoreAcctNum":"9090","GMV_MTD":"$0"},"first_name":"Mohammad","last_name":"Deura","id":321321,"email":"TestPromoterioContact@test.com"},"campaign":999999,"score":0,"score_type":"detractor","comment":"Your staff has no sense of urgency and frankly they obviously want to be somewhere else. Start with them.","posted_date":"2016-06-29T20:48:54Z","comment_updated_date":"2016-06-29T20:48:43Z"}]}');
        res.setStatusCode(200);
        return res;
    }
}