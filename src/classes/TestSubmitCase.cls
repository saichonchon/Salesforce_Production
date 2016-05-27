@isTest(seeAllData=true)
private class TestSubmitCase {
/**
    static testMethod void validatePINTest1() {
	// Test with Valid URL/PIN
        String testcsse = 'Web2Case';
    	TestDataGenerator_SubscriptionValidation td = new TestDataGenerator_SubscriptionValidation();
        
        PageReference pg = Page.LiveAgentPreChatSupport;
        Test.setCurrentPage(pg);

        ApexPages.currentPage().getParameters().put('csse', testcsse);      
        
        SubmitCaseController scc = new SubmitCaseController();
    	list<Subscription__c> lstSubs = td.getSubscriptions(true);

        scc.formURL = lstSubs[0].StoreURL__c;
        scc.formPIN = lstSubs[0].Support_PIN__c;
        
        scc.validatePIN();

    }

/*    static testMethod void submitCaseTest1() {
        scc.ct.FirstName = 'John';
        scc.ct.LastName = 'Smith';
        scc.ct.Email = 'johnsmith@test.com';
        scc.ct.Description = 'This some text';
    } */
}