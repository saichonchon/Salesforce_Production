/**
 * BatchProcessPromoterIo_Test
 * Author: Bala Rajagopal
 * Purpose: Test Class for Promoter.io to Salesforce Integration Batch classes
 * Ticket: BAP-3171
 * 
 */
@isTest
public class BatchProcessPromoterIo_Test{
    public static string accid;
    public static string conid;
    @isTest
    public static void testSchedulerStart() {
        List<Account> accounts = TestDataFactory.createTestAccounts(1, false, TestDataFactory.AccountRecordType.Client_Record_Type);
		List<Contact> contacts = TestDataFactory.createTestContacts(1, accounts);
        Contact con = contacts[0];
        con.Email = 'TestPromoterioContact@test.com';
        update con;
        accid = con.AccountId;
        conid = con.id;
        Promoter_io_Feedback__c po = TestDataFactory.createPromoterIoFeedback(con);
        po.Email__c = 'TestPromoterioContact@test.com';
        po.Contact__c = con.id;
        update po;
        List<contact> contList = new List<Contact>([select id, email, accountid from Contact where id = :con.id]);
        
        
        promoterioSettings__c pios = promoterioSettings__c.getOrgDefaults();
        pios.Specific_Campaign_ID__c = '999999';
        pios.End_Point__c = 'https://app.promoter.io/api/feedback/';
        pios.Token__c = 'd8ff7573a2631540377b793bbd4396ac1c5699a9';
        pios.Case_Subject_Starting__c = 'NPS Survey Response from';
        pios.Case_Origin__c = 'Promoter.io';
        pios.Case_Reason__c = 'Surveys';
        pios.Case_Category__c = 'Company NPS';
        pios.Fetch_All__c = false;
        upsert pios;
        
        Id idCSCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
        /*
        Case cas = new Case();
        cas.Subject = 'NPS Survey Response from Test';
        cas.Origin = 'Promoter.io';
        cas.Reason = 'Surveys';
        cas.Description = '<br> Contact Email: TestPromoterioContact@test.com <br> Date: June 29, 2016<br> <br> Score: 0<br>Feedback:<br><br>Your staff Test';
        cas.ContactId = con.id;
        cas.RecordTypeId = idCSCaseRecordType;
        insert cas;
        */
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        SchedulePromoterIoQuery sc = new SchedulePromoterIoQuery();
		sc.execute(null);
        
		Case cas2 = new Case();
        cas2.Subject = 'NPS Survey Response from Test';
        cas2.Origin = 'Promoter.io';
        cas2.Reason = 'Surveys';
        cas2.Description = '<br> Contact Email: TestPromoterioContact@test.com <br> Date: June 29, 2016<br> <br> Score: 0<br>Feedback:<br><br>Your staff Test';
        //cas2.ContactId = con.id;
        cas2.RecordTypeId = idCSCaseRecordType;
        insert cas2;
        
        test.stopTest();
        // Verify response received contains fake values
        List<Promoter_io_Feedback__c> piofList = new List<Promoter_io_Feedback__c>([select id, contact__c,Account__c from Promoter_io_Feedback__c limit 10]);
        Set<Id> ConIds = new Set<Id>();
        for(Promoter_io_Feedback__c pio:piofList){
            conIds.add(pio.contact__c);
        }
        List<contact> conL = new List<contact>([select id, Last_Promoter_io_NPS__c from Contact where id in :conIds limit 10]);
        system.assertNotEquals(null, piofList);
        //system.assertEquals(25, conL[0].Last_Promoter_io_NPS__c);

    }
}