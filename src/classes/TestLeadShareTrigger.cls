@isTest
private class TestLeadShareTrigger {

    static testMethod void LeadShareTrigger() {
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        insert acc1;
        
        Contact con = new Contact(LastName='Test Name', AccountId=acc1.Id);
        insert con;

        Id partnerProfileId = '00e30000001UPDe';
        
        User u = new User();
        u.FirstName = 'Test fn';
        u.LAstName = 'Test ln';
        u.ContactId = con.Id;
        //u.AccountId = acc1.Id;
         u.email = 'test@gmail.com';
         u.username='testmail@gmail.com';
         u.profileId = partnerProfileId;
         u.alias = 'tst';
         u.TimeZoneSidKey = '(GMT-05:00) Central Daylight Time (America/Mexico_City)';
         u.LocaleSidKey = 'English (United States)';
         u.EmailEncodingKey = 'General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
         u.LanguageLocaleKey = 'English';
        //insert u;
        
        Account acc2 = new Account();
        acc2.Name = 'TestAccount2';
        acc2.State__c = 'Pending';
        insert acc2;
        
        Lead newLead = new Lead();
        newLead.LastName = 'Test';
        newLead.Company = 'Arxxus'; 
        newLead.Status = 'Open';
        newLead.Partner_Account__c = acc1.id;
        insert newLead;
        newLead.Partner_Account__c = acc2.id;
        update newLead;
        newLead.Partner_Account__c = null ;
        update newLead;
    }
}