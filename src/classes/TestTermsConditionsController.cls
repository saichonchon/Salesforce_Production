@isTest
public class TestTermsConditionsController
{
    static Id RTID_MBASub = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();
    
    static testMethod void test1() 
    {
        TestDataGenerator td = new TestDataGenerator();
        
        // Create a test account
        list<Account> lstAcct = td.getAccounts(false);
        Account objA = lstAcct[0];
        objA.iDev_Partner_ID__c = 9990055;
        insert objA;
        
        // Create a contact
        list<Contact> lstContact = td.getContacts(false);
        Contact objC = lstContact[0];
        objC.AccountId = objA.Id;
        insert objC;
        
        // Create T&C record
        list<Terms_Conditions__c> lstTC = td.getTermsConditions(true);
        
        // Turn the contact into a portal user
        Profile p = [SELECT id 
                        FROM profile
                        WHERE name = 'PRM Portal User'
                        LIMIT 1];  
        
        String testemail = 'puser000@amamama.com';

        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                            emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                            languagelocalekey = 'en_US', timezonesidkey = 'America/Chicago',
                            alias='cspu', lastname='lastname', firstname='firstname', contactId = objC.id);

        insert pu;
        
        test.startTest();
        
        system.RunAs(pu)
        {
            pageReference pageRef = Page.TermsConditions;
            pageRef.getParameters().put('id', lstTC[0].Id);
            pageRef.getParameters().put('partId', objA.Id);
            test.setCurrentPage(pageRef);
    
            // Instantiate a new controller      
            TermsConditionsController controller = new TermsConditionsController();
            
            // Call all the methods
            Terms_Conditions__c tc = controller.getTC();
            
            pageReference pr = controller.AgreeToTerms();
            pr = controller.Cancel();
        }
        
        test.stopTest();
    }
}