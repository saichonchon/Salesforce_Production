// ==================================================================================
//   Object: TestCaseViewBigAccountController
//  Company: BigCommerce
//   Author: Mohan Kumar (Sales Optimizer)
// Comments: Testing of CaseViewBigAccountController class.
// ==================================================================================
//  Changes: 2012-10-18 Initial version.
// ==================================================================================

@isTest
private class TestCaseViewBigAccountController {

    static testMethod void caseViewBigAccountController_Test1() {
        // TO DO: implement unit test
        Account a = new Account();
        a.Name = 'Test Account';
        a.MBAHostingID__c = '341726';
        insert a;
        
        Case c = new Case();
        c.AccountId = a.Id;
        c.Status = 'New';
        c.Origin = 'Email';
        insert c;
        
        CaseViewBigAccountController cba = new CaseViewBigAccountController(new Apexpages.Standardcontroller(c));
        cba.autoRun();
        cba.fetchNewURL('<p style="text-align: center; margin-top: 0;"><input type="button" class="btn" value="View in MyBigAccount" onclick="window.open(\'https://account.bigcommerce.com/admin/clientssummary.php?userid=273987\');" /></p>');
    }
}