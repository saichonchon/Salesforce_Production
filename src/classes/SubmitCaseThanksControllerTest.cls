@isTest
private class SubmitCaseThanksControllerTest { 
	static SubmitCaseThanksController sct { get; set; }

	static testMethod void SubmitCaseThanksControllerTest() {
		PageReference pg = Page.SubmitCaseThanks;
    Test.setCurrentPage(pg);

    // create a test case and supporting objects
    List<Account> testAccounts = TestDataFactory.createTestAccounts(1, false, TestDataFactory.AccountRecordType.Client_Record_Type);
    List<Contact> testContacts = TestDataFactory.createTestContacts(1, testAccounts);
    List<Case> testCases = TestDataFactory.createTestCases(1, testContacts);

    ApexPages.currentPage().getParameters().put('caseNum', testCases[0].CaseNumber); 

    sct = new SubmitCaseThanksController();

    System.assertEquals(sct.caseNum, testCases[0].CaseNumber);
	}

}