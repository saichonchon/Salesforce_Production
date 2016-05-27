@isTest(seeAllData=true)
private class TestLiveAgentChatController {
    static testMethod void doTest() {   
        String testEndpoint = 'https%3A%2F%2F1.la1a1.salesforceliveagent.com';
        String testcsse = 'LiveAgent';
        
        PageReference pg = Page.LiveAgentPreChatSupport;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('endpoint', testEndpoint);      
        ApexPages.currentPage().getParameters().put('csse', testcsse);      
        
        LiveAgentChatController lacc = new LiveAgentChatController();
        
        lacc.theContact.FirstName = 'John';
        lacc.theContact.LastName = 'Smith';
        lacc.theContact.Email = 'johnsmith@test.com';
        lacc.theContact.Description = 'This some text';
        
        lacc.clickChat();
    }
}