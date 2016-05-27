@isTest
public class TestPartnerHomeController
{
    static Id RTID_MBASub = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();
    
    static testMethod void testPartnerHome1() 
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
            pageReference pageRef = Page.PartnerHome;
            test.setCurrentPage(pageRef);
    
            // Instantiate a new controller      
            PartnerHome controller = new PartnerHome();
            
            // Call all the methods
            pageReference pr1 = controller.PartnerStart();
        }
        
        test.stopTest();
    }
    
    static testMethod void testPartnerHome2() 
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
        
        list<Terms_Conditions__c> lstTC = td.getTermsConditions(true);      
        Terms_Conditions__c tc1 = lstTC[0];
        
        // Now agree to the terms
        Partner_T_C_Agreement__c tc = new Partner_T_C_Agreement__c();
        tc.Account__c = objA.Id;
        tc.Terms_Conditions__c = tc1.Id;
        tc.Accepted_By__c = objC.Id;
        tc.Accepted_Date__c = system.now();
        insert tc;
        
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
        
        // Create Subscriptions for this new account    
        list<Subscription__c> lstSub = new list<Subscription__c>();
        Subscription__c objSub;
        
        for (integer x = 0; x < 202; x++)
        { 
            objSub = new Subscription__c();
            objSub.MBAAccountID__c = td.getAccounts(true)[1].Id;
            objSub.MBAPartnerID__c = string.valueOf(objA.iDev_Partner_ID__c);
            objSub.MBASubscriptionID__c = '123990' + string.valueOf(x);
            objSub.RecordTypeId = RTID_MBASub;
            objSub.Status__c = 'Active';
            objSub.ProductType__c = 'Store';
            
            if (x < 50)
            {
                objSub.isTrial__c = true;
                objSub.StartDate__c = System.today() - 10;
                objSub.Product__c = '15 Free Trial';
            }
            else if (x >= 50 && x < 100)
            {
                objSub.isTrial__c = true;
                objSub.StartDate__c = System.today() - 35;
                objSub.Product__c = '15 Free Trial';
            }
            else if (x >= 100 && x < 150)
            {
                objSub.isTrial__c = false;
                objSub.StartDate__c = System.today() - 10;
                objSub.Product__c = 'Gold Package';
            }
            else if (x >= 150 && x < 200)
            {
                objSub.isTrial__c = false;
                objSub.StartDate__c = System.today() - 35;
                objSub.Product__c = 'Silver Package';
            }
            
            lstSub.add(objSub);
        }
        
        insert lstSub;
        
        test.startTest();
        
        system.RunAs(pu)
        {
            pageReference pageRef = Page.PartnerHome;
            test.setCurrentPage(pageRef);
    
            // Instantiate a new controller      
            PartnerHome controller = new PartnerHome();
            
            // Call all the methods
            pageReference pr1 = controller.PartnerStart();
            list<PartnerHome.SubByProduct> lstStoresByProd = controller.PurchasedStoresByProduct;
            list<PartnerHome.SubByMonth> lstSubsByMonth = controller.SubsByMonth;           
            
            // Client Store Controller properties and methods
            list<Subscription__c> lstClientStored = controller.ClientStores;
            string storePgSize = controller.getClientStores_PageSize();
            controller.setClientStores_PageSize('10');
            list<SelectOption> lstStorePgOpts = controller.ClientStores_PageNumber_All;
            integer storePgNum = controller.ClientStores_PageNumber_Total;
            string storeCurPg = controller.ClientStores_PageNumber_Cur;
            controller.ClientStores_PageNumber_Cur = '2';
            integer storeTotal = controller.ClientStores_TotalRecords;
            boolean storeHasNext = controller.ClientStores_HasNext;
            controller.ClientStores_Next();
            boolean storeHasPrev = controller.ClientStores_HasPrevious;
            controller.ClientStores_Previous();
            controller.ClientStores_Last();
            controller.ClientStores_First();
            controller.ClientStores_SortedBy = 'CreatedDate';
            controller.ClientStores_SortDir = 'DESC';
            controller.ClientStores_Sort();
            
            // Active Trials Controller properties and methods
            list<Subscription__c> lstTrials = controller.ActiveTrials;
            string trialPgSize = controller.getActiveTrials_PageSize();
            controller.setActiveTrials_PageSize('10');
            list<SelectOption> lstTrialPgOpts = controller.ActiveTrials_PageNumber_All;
            integer trialPgNum = controller.ActiveTrials_PageNumber_Total;
            string trialCurPg = controller.ActiveTrials_PageNumber_Cur;
            controller.ActiveTrials_PageNumber_Cur = '2';
            integer trialTotal = controller.ActiveTrials_TotalRecords;
            boolean trialHasNext = controller.ActiveTrials_HasNext;
            controller.ActiveTrials_Next();
            boolean trialHasPrev = controller.ActiveTrials_HasPrevious;
            controller.ActiveTrials_Previous();
            controller.ActiveTrials_Last();
            controller.ActiveTrials_First();
            controller.ActiveTrials_SortedBy = 'CreatedDate';
            controller.ActiveTrials_SortDir = 'DESC';
            controller.ActiveTrials_Sort();
            
            // Check the variables
            boolean isValidUser = controller.InvalidUser;
            decimal storeCnt = controller.PurchasedStoresCount_Total;
            decimal MRRTotal = controller.PurchasedStoresMRR_Total;
            decimal MRRAvg = controller.PurchasedStoresMRR_Avg;
        }
        
        test.stopTest();
    }
}