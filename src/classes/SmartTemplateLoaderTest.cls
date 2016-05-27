@isTest(SeeAllData=true)
private class SmartTemplateLoaderTest {

@isTest
    static void LoadEmailTemplates_SuccesfulScenario_ReturnsTemplateId() {
 
        Id templateId;
    
        User thisUser = [SELECT Id FROM User WHERE profile.name ='System Administrator' LIMIT 1];
                
        Id caseId = insertCase();
        
        SmartTemplateLoader smt = new SmartTemplateLoader();

        Id result = smt.getDefaultEmailTemplateId(caseId);
        
   //     System.assertEquals(templateId, result);
        
    }


    private static Id insertCase() {
 
        Id idCSCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
  
		TestDataGenerator td = new TestDataGenerator();
	      
	    list<Account> lstAcct = td.getAccounts(true);
	    Case c = td.createCase(lstAcct[0].Id, '', true);
	      
// Make sure the case is associated to the correct account and user
		c.AccountId = lstAcct[0].Id;
		c.RecordTypeId = idCSCaseRecordType;
	    c.OwnerId = UserInfo.getUserId();
	    update c;
       
        return c.Id;    
    }
    


}