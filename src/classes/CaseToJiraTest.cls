@isTest(seeAllData=true) 
public class CaseToJiraTest{
    public static testmethod void testJiraCallout() {
 //       SingleRequestMock fakeResponse = new SingleRequestMock(200,
   //                                              'Complete',
    //                                             '[{"Name": "sForceTest1"}]',
    //                                             null);
        SingleRequestMock fakeResponse = new SingleRequestMock(200, 'Complete','[Status=OK, StatusCode=200]',null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
 
 // create test data       
        Account a = new Account();
        a.Name = 'Test Account';
        a.MBAHostingID__c = '341726';
        insert a;
        
        Id migRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
    
        Case c = new Case();
        c.AccountId = a.Id;
        c.Status = 'New';
        c.Origin = 'Email';
        c.RecordTypeId = migRecordType;
        c.of_Products__c = '<500';
        c.Migration_Platform__c  ='Test';
        c.Subject='Testing new case';
        c.Migration_Partner__c = 'EIG';
        
        insert c;
        String objectId = c.id;
        String jiraType = 'Jira for EIG';   
                             
         //Execute the callout
        JIRAConnectorWebserviceCallout.createIssue(jiraType, objectId);
        JIRAConnectorWebserviceCallout.syncIssue(jiraType, objectId);
 //       System.assertEquals(/*check for expected results here...*/);
    }
}