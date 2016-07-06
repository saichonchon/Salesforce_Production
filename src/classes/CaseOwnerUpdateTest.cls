@isTest
private  class CaseOwnerUpdateTest {
	
	static testMethod void testCaseOwnerUpdate() 
    {
		Test.startTest();
		Id idCSCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
  
		TestDataGenerator td = new TestDataGenerator();
	      
	    list<Account> lstAcct = td.getAccounts(true);
	    Case c = td.createCase(lstAcct[0].Id, '', true);
	      
// Make sure the case is associated to the correct account and user
		c.AccountId = lstAcct[0].Id;
		c.RecordTypeId = idCSCaseRecordType;
	    c.OwnerId = UserInfo.getUserId();
	    update c;
		
		Map <String, String> caseOwnerQueue = new Map<String, String>();
		for (CaseOwnerQueue__mdt s :[select ChangeOwner_Value__c, Queue_Name__c from CaseOwnerQueue__mdt ])
		{
			caseOwnerQueue.put(s.ChangeOwner_Value__c, s.Queue_Name__c);
		}
			 
		
		for (String sname :caseOwnerQueue.KeySet())
		{
			c.Change_Owner__c = sname;
		}
		update c;

		Test.stopTest();
		
    }
}