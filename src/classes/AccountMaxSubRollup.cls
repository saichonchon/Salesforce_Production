public with sharing class AccountMaxSubRollup {

//Class to rollup highest subscription fields to the account level for use in HubSpot
    @future
    public static void rollUp(Set<String> accountIds) {
        if (accountIds.size() == 0) {
            return;
        }
        
        //Retrieve list of fields from custom setting
        AccountMaxSubRollup__c amsr = AccountMaxSubRollup__c.getInstance('Fields');
        String fieldlist = amsr.FieldList1__c;
        if (!String.isBlank(amsr.FieldList2__c)) {
            fieldList += amsr.FieldList2__c;
        }
        system.debug(fieldlist);
        
        //Compile mapped fields
        List<String> mappedFields = fieldlist.split(',');
        if (mappedFields.size() == 0) {
            return;
        }
        
        //Compile subscription query fields
        String subscriptionFields = fieldlist + ',id, productType__c, account__c';
        system.debug(subscriptionFields);
        
        //Compile account query fields
        String accountFields = '';
        for (String fieldname : mappedFields) {
            accountFields += 'MaxSub_' + fieldname + ',';
        }
        accountFields += 'id';
        system.debug(accountFields);
        
        //Convert incoming accountIds into string
        String accountIdQuery = '';
        for (String aId : accountIds) {
            accountIdQuery += '\'' + aId + '\',';
        }
        accountIdQuery = '(' + accountIdQuery.substring(0,accountIdQuery.length()-1) + ')';
        system.debug(accountIdQuery);
        
        //Retrieve incoming accounts
        String accountQuery = 'SELECT ' + accountFields + ' FROM account WHERE id in ' + accountIdQuery;
        system.debug(accountQuery);
        List<Account> accounts = Database.query(accountQuery);
        
        if (accounts.size() == 0) {
            return;
        }
        
        //Retrieve subscriptions for incoming accounts
        String subscriptionQuery = 'SELECT ' + subscriptionFields + ' FROM subscription__c WHERE product__c != null and MonthlyRecurringRevenue__c > 0 and account__c in ' + accountIdQuery;
        List<Subscription__c> subscriptions = Database.query(subscriptionQuery);
        
        if (subscriptions.size() == 0) {
            return;
        }
        
        //Store subscriptions in list by account
        Map<String, List<Subscription__c>> subsByAccount = new Map<String,List<Subscription__c>>();
        for (Subscription__c sub : subscriptions) {
            if (subsByAccount.containsKey(sub.account__c)) {
                List<Subscription__c> subs = subsByAccount.get(sub.account__c);
                if (sub.Product__c.contains('Plan') || sub.ProductType__c == 'Store') {
                    subs.add(sub);
                    subsByAccount.put(sub.account__c,subs);
                }
            } else if(sub.Product__c.contains('Plan') || sub.ProductType__c == 'Store' ){
                List<Subscription__c> subs = new List<Subscription__c>();
                subs.add(sub);
                subsByAccount.put(sub.account__c,subs);
            }
        }
        
        //Find highest subscription for account and store in map by account id
        Map<String, Subscription__c> highestSubsByAccount = new Map<String, Subscription__c>();
        for (String s : subsByAccount.keySet()) {
            List<Subscription__c> accountSubs = subsByAccount.get(s);
            Boolean hasActive = false;
            Double topActiveMRR = 0;
            Subscription__c maxActiveSub = new Subscription__c();
            Double topInactiveMRR = 0;
            Subscription__c maxInactiveSub = new Subscription__c();
            for (Subscription__c aSub : accountSubs) {
                if ((aSub.status__c == 'Active')||(aSub.status__c=='Suspended')) {
                    hasActive = true;
                    if (aSub.MonthlyRecurringRevenue__c > topActiveMRR) {
                        topActiveMRR = aSub.MonthlyRecurringRevenue__c;
                        maxActiveSub = aSub;
                    }
                } else {
                    if (aSub.MonthlyRecurringRevenue__c > topInactiveMRR) {
                        topInactiveMRR = aSub.MonthlyRecurringRevenue__c;
                        maxInactiveSub = aSub;
                    }
                }
            }
            if (hasActive) {
                highestSubsByAccount.put(s,maxActiveSub);
            } else {
                highestSubsByAccount.put(s,maxInactiveSub);
            }
        }
        
        //Go through accounts and map subscription fields to account fields
        for (Account acc : accounts) {
            if (highestSubsByAccount.containsKey(acc.Id)) {
                Subscription__c finalSub = highestSubsByAccount.get(acc.Id);
                for (String mapField : mappedFields) {
                    acc.put('MaxSub_' + mapField, finalSub.get(mapField));
                }
                acc.MaxSub_Subscription__c = finalSub.Id;   
            }
        }
        
        //Finally, update accounts
        update accounts;    
    }
    
    @isTest(seeAllData=true)
    public static void testIt() {
        //Create a test account
        Account a1 = new Account();
        a1.name = 'test1';
        insert a1;
        
        //Create a second test account
        Account a2 = new Account();
        a2.name = 'test2';
        insert a2;
        
        //Create subscriptions for the accounts
        Subscription__c s1 = new Subscription__c();
        s1.Account__c = a1.id;
        s1.Product__c = 'Diamond Plan';
        s1.MonthlyRecurringRevenue__c = 99;
        s1.PurchaseDate__c = date.today();
        s1.IsTrial__c = true;
        s1.Status__c = 'Active';
        s1.Purchase_Team__c = 'Contractor';
        s1.StartDate__c = date.today();
        s1.ExpirationDate__c = date.today();
        s1.BillingCycle__c = 'Monthly';
        s1.BillingAmount__c = 99;
        insert s1;
        
        Subscription__c s2 = new Subscription__c();
        s2.Account__c = a1.id;
        s2.Product__c = 'Bronze Plan';
        s2.MonthlyRecurringRevenue__c = 49;
        s2.PurchaseDate__c = date.today();
        s2.IsTrial__c = true;
        s2.Status__c = 'Active';
        s2.Purchase_Team__c = 'Contractor';
        s2.StartDate__c = date.today();
        s2.ExpirationDate__c = date.today();
        s2.BillingCycle__c = 'Monthly';
        s2.BillingAmount__c = 49;
        insert s2;
        
        Subscription__c s3 = new Subscription__c();
        s3.Account__c = a2.id;
        s3.Product__c = 'Diamond Plan';
        s3.MonthlyRecurringRevenue__c = 99;
        s3.PurchaseDate__c = date.today();
        s3.IsTrial__c = true;
        s3.Status__c = 'Expired';
        s3.Purchase_Team__c = 'Contractor';
        s3.StartDate__c = date.today();
        s3.ExpirationDate__c = date.today();
        s3.BillingCycle__c = 'Monthly';
        s3.BillingAmount__c = 99;
        insert s3;
        
        Subscription__c s4 = new Subscription__c();
        s4.Account__c = a2.id;
        s4.Product__c = 'Bronze Plan';
        s4.MonthlyRecurringRevenue__c = 49;
        s4.PurchaseDate__c = date.today();
        s4.IsTrial__c = true;
        s4.Status__c = 'Active';
        s4.Purchase_Team__c = 'Contractor';
        s4.StartDate__c = date.today();
        s4.ExpirationDate__c = date.today();
        s4.BillingCycle__c = 'Monthly';
        s4.BillingAmount__c = 49;
        insert s4;
        
        //Execute Test
        Set<String> accountIds = new Set<String>();
        accountIds.add(a1.id);
        accountIds.add(a2.id);
        
        Test.startTest();
        AccountMaxSubRollup.rollUp(accountIds);
        Test.stopTest();
        
        //Pull accounts
        AccountMaxSubRollup__c amsr = AccountMaxSubRollup__c.getInstance('Fields');
        String fieldlist = amsr.FieldList1__c;
        if (!String.isBlank(amsr.FieldList2__c)) {
            fieldList += amsr.FieldList2__c;
        }
        //Compile mapped fields
        List<String> mappedFields = fieldlist.split(',');
        
        //Compile account query fields
        String accountFields = '';
        for (String fieldname : mappedFields) {
            accountFields += 'MaxSub_' + fieldname + ',';
        }
        accountFields += 'id';
        
        //Compile subscription query fields
        String subscriptionFields = fieldlist + ',id,account__c';
        
        //Verify a1
        String accountQuery = 'SELECT ' + accountFields + ' FROM account WHERE id = \'' + a1.Id + '\'';
        a1 = (Account)Database.query(accountQuery)[0];
        
        String subscriptionQuery = 'SELECT ' + subscriptionFields + ' FROM subscription__c WHERE id = \'' + s1.Id + '\'';
        s1 = (Subscription__c)Database.query(subscriptionQuery)[0];
        
        for (String mapField : mappedFields) {
            system.assertEquals(s1.get(mapField), a1.get('MaxSub_' + mapField));
        }
        
        
        //Verify a2
        String accountQuery2 = 'SELECT ' + accountFields + ' FROM account WHERE id = \'' + a2.Id + '\'';
        a2 = (Account)Database.query(accountQuery2)[0];
        
        String subscriptionQuery2 = 'SELECT ' + subscriptionFields + ' FROM subscription__c WHERE id = \'' + s4.Id + '\'';
        s4 = (Subscription__c)Database.query(subscriptionQuery2)[0];
        
        for (String mapField : mappedFields) {
            system.assertEquals(s4.get(mapField), a2.get('MaxSub_' + mapField));
        }

    }

}