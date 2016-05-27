@isTest(seeAllData = true)
private class SupportLiveAgentPreChatControllerTest {
	
	@isTest static void test_chat() {
		String testEndpoint = 'https%3A%2F%2F1.la1a1.salesforceliveagent.com';
        String testcsse = 'LiveAgent';
        
        PageReference pg = Page.SupportLiveAgentPreChatpage;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('endpoint', testEndpoint);      
        ApexPages.currentPage().getParameters().put('csse', testcsse);      
        
        SupportLiveAgentPreChatController lacc = new SupportLiveAgentPreChatController();
        
        lacc.theContact.FirstName = 'John';
        lacc.theContact.LastName = 'Smith';
        lacc.theContact.Email = 'johnsmith@test.com';
        lacc.theContact.Description = 'This some text';
        
        lacc.clickChat();
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}