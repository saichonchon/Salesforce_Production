@isTest()
public class TestEmailMessageTrigger {
 
  static testMethod void testEmailTrigger() 
  {   
    // Create test data
      TestDataGenerator td = new TestDataGenerator();
      Id idCSCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();

      list<Account> lstAcct = td.getAccounts(true);
      List<Case> caseList = new List<Case>();
      Case c1 = td.createCase(lstAcct[0].Id, 'Support', true);
 	  caseList.add(c1);
      Case ctwo = td.createCase(lstAcct[1].Id, 'Support', true);
      ctwo.AccountId = lstAcct[1].Id;
      ctwo.RecordTypeId = idCSCaseRecordType;
      update ctwo;
      caseList.add(ctwo);
      
      EmailMessage[] newEmail = new EmailMessage[0];
 
	 	newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', ToAddress= 'maggie.frederick@bigcommerce.com', Subject = 'Test email', Incoming = false, TextBody = '23456 ', ParentId = c1.Id)); 
 	
		newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', ToAddress= 'maggie.frederick@bigcommerce.com', Subject = 'Test 2 email', Incoming = false, TextBody = '23456 789 ', ParentId = ctwo.Id)); 
 
		insert newEmail;
		
		
		List<CaseComment> comments = [Select Id, ParentId from CaseComment ];
       
        system.assertEquals(2, comments.size());
       
  }
}