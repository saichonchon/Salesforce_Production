@isTest
private class SubmitCaseThanksControllerTest { 
	static SubmitCaseThanksController sct { get; set; }

	static testMethod void SubmitCaseThanksControllerTest() {
		PageReference pg = Page.SubmitCaseThanks;
    Test.setCurrentPage(pg);

    ApexPages.currentPage().getParameters().put('caseNum', '1234'); 
    ApexPages.currentPage().getParameters().put('contactEmail', 'test@bigcommerce.com'); 
    ApexPages.currentPage().getParameters().put('storeUrl', 'teststore.bigcommerce.com'); 

    sct = new SubmitCaseThanksController();

    System.assertEquals(sct.caseNum, '1234');
    System.assertEquals(sct.contactEmail, 'test@bigcommerce.com');
    System.assertEquals(sct.storeUrl, 'teststore.bigcommerce.com');
	}

}