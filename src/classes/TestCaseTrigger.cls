@isTest
private class TestCaseTrigger {
	
	private static testMethod void testEIGCase()	
	{
	 TestDataGenerator td = new TestDataGenerator();
      
      list<Contact> lstCon = td.getContacts(true);
      
      // Create a new opportunity for the account
      Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
      Opportunity obj = new Opportunity();
        obj.Name = 'Test ';
        obj.CloseDate = Date.today().addDays(1);
        obj.StageName = 'Purchased';
        obj.SBD_Store_ID__c = '683074';
        obj.AccountId = lstCon[0].AccountId;
        
        obj.RecordTypeId = storeRecordTypeId;
        obj.Status__c = 'Active';
        
        insert obj;
        
        Subscription__c s = new Subscription__c (SBD_Store_ID__c = '683074', Account__c = lstCon[0].AccountId );
		insert s;
        
        Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        
        Case eigCase = new Case (recordTypeId = idCaseRecordType,
                                 Description = 'REQUEST_TYPE: Cancellation' + '\n' +
 								 ' STORE_ID: 683074 '+ '\n' +
								 ' CANCELLATION_REASON: Personal Reason' + '\n',
                                 Subject = 'EIG - Homestead Store Cancellation Request',
                                 Origin = 'EIG Billing'
                                 );
 		insert  eigCase;
 		
 		Case newCase = [select Id, Opportunity__c from Case where origin = 'EIG Billing'];
		System.assertEquals(obj.Id, newCase.Opportunity__c);


		
	}
}