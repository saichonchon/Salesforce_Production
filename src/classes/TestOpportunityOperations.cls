@isTest(SeeAllData=true)
private class TestOpportunityOperations{

   
   static testMethod void testOppmethods(){
   	
   	     // Variables to use in testing
        MBA_Staging_Account__c objMBAAcct;
        MBA_Staging_Subscription__c objMBASub;
        MBA_Staging_Contact__c objMBAContact;
        Subscription__c objSub;
        Id acctId;
        
        // Create Test Data
        TestDataGenerator td = new TestDataGenerator();
        
        // Initialize the Custom Setting Map    
        td.getStagingToTableMappingSettings();
        
        // Create Staging Account records as not Paid and grab one of them
        td.getAccountMBAs(true, false);
        objMBAAcct = td.AccountMBAs[0]; 
        
        // Create Staging Contact records as not Paid
        td.getContactMBAs(true, false);
                
        // Create Staging Subscription records as paid
        td.getStagingSubscriptions(false, false, objMBAAcct.MBAAccountID__c, 9898119);
        objMBASub = td.lstStagingSubscriptions[0];
        
        // Start Test
        test.startTest();
        
        insert objMBASub;
        
        // Capture the Subscription that should have just been created
        objSub = [SELECT Id, IsTrial__c, MBAAccountID__c, Lead__c, Account__c, RecordTypeId, MBASubscriptionID__c
                    FROM Subscription__c 
                    WHERE MBAAccountID__c = :objMBASub.MBAAccountID__c];
        
        // Ensure an account id exists on the sub
        system.assertNotEquals(null, objSub.Account__c);
                
        acctId = objSub.Account__c;
        
        // Now capture the Account that was just created
        Account objAcct = [SELECT Id, Name, MBAAccountID__c, OwnerId
                            FROM Account
                            WHERE Id = :acctId];
                            
        system.assertEquals(objAcct.MBAAccountID__c, objSub.MBAAccountID__c);
   	
   	    Opportunity opp = new Opportunity (AccountId = acctId,
   	    									name = 'New Opp', StageName= 'Purchase',
   	    									closeDate= System.Today(),
   	                                       MBAAccountId__c = objMBASub.MBAAccountID__c,
   	                                       MostRecentSubscription__c =objSub.Id); 
   	
 		insert opp;
 		objMBASub.ProductID__c = '24';
 		update objMBASub;
 		test.stopTest();
   }
   
  
   static testMethod void testConvertLead() {
   
   		test.starttest();
       // Variables to use in testing
        MBA_Staging_Account__c objMBAAcct;
        MBA_Staging_Subscription__c objMBASub;
        MBA_Staging_Contact__c objMBAContact;
     
        Opportunity objOpp;
        Subscription__c objsub;
        List<Opportunity_Product__c> lstOppProduct;
        List<MBA_Staging_Subscription__c> lstmbasubup = new List<MBA_Staging_Subscription__c>();
        
        
        TestDataGenerator td = new TestDataGenerator();
        // Initialize the Custom Setting Map   
        td.getStagingToTableMappingSettings();
        
       //creating a lead for converting it      
        Lead objlead=new Lead();
        objlead.LastName='test125';
        objlead.Company='testcompany';
        objlead.Stage__c ='New';
        objlead.Email='testopp@gmail.com';
           
       
        Database.SaveResult saveResults = Database.Insert(objlead);

        // Create a LeadConvert instance to be used  
        Database.LeadConvert leadsToConvert = new Database.LeadConvert();
        
        leadsToConvert.setConvertedStatus('Qualified');
        leadsToConvert.setLeadId(saveResults.getId());
      
        // Convert the leads
        Database.LeadConvertResult lcResults = Database.convertLead(leadsToConvert);
        System.debug('testclass'+lcResults);
       
      
        // Create Staging Account records as not Paid and grab one of them
        objMBAAcct = new  MBA_Staging_Account__c();
        objMBAAcct.MBAAccountID__c='1251256';
        objMBAAcct.CompanyName__c='companytest';
        insert objMBAAcct;
        system.debug('testclass'+objMBAAcct);
       
        // Create Staging Contact records as  Paid
       
        objMBAContact=new MBA_Staging_Contact__c();
        objMBAContact.MBAAccountID__c=objMBAAcct.MBAAccountID__c;
        objMBAContact.Email__c='testopp@gmail.com';
        objMBAContact.MBAClientID__c='clienttest125';
        objMBAContact.FirstName__c='Firstname';
        objMBAContact.LastName__c='lastname';
        insert objMBAContact;
        System.debug('testclass'+objMBAContact);
       
       
               
        // Create Staging Subscription  as not Paid
       
        objMBASub = new MBA_Staging_Subscription__c();
        objMBASub.MBASubscriptionID__c='subtestmgs1215';
        objMBASub.MBAAccountID__c = objMBAAcct.MBAAccountID__c;
        objMBASub.isTrial__c=true;
        objMBASub.SubscriptionType__c ='Store';
        objMBASub.Status__c='Active';
        objMBASub.ProductID__c='33';
        objMBASub.ExpirationDate__c=System.Today();
        objMBASub.MonthlyRecurringRevenue__c=0.00;
        insert objMBASub;
        System.debug('testclass'+objMBASub);
          // Start Test
        test.stoptest();
        objMBASub.isTrial__c=false;
        objMBASub.SubscriptionType__c ='Store';
        objMBASub.Status__c='Active';
        objMBASub.ProductID__c='24';
        objMBASub.MonthlyRecurringRevenue__c=24.95;
        update objMBASub;
       
 
        //checking values of Subscription
  
       objsub=[SELECT Id FROM Subscription__c WHERE MBASubscriptionID__c =: objMBASub.MBASubscriptionID__c ];
       
        //checking values of created opportunity
        objOpp=[SELECT Id,MBASubscriptionID__c,Name ,Subscription__c,ProductID__c ,StageName,ExpirationDate__c ,MBA_Account_ID__c,MonthlyRecurringRevenue__c FROM Opportunity WHERE 
                MBAAccountID__c = :objMBAAcct.MBAAccountID__c];
        //Contact_Email__c  =:objMBAContact.Email__c];
        
        // Check For MonthlyRecurringRevenue.
        System.assertEquals(objMBASub.MonthlyRecurringRevenue__c,objOpp.MonthlyRecurringRevenue__c );
        
        // Check For MBAAccountID.
        System.assertEquals(objMBAAcct.MBAAccountID__c,objOpp.MBA_Account_ID__c );
        
        // Check For MBASubscriptionID.
        System.assertEquals(objMBASub.MBASubscriptionID__c,objOpp.MBASubscriptionID__c );
        
        // Check For StageName.
        System.assertEquals( 'Purchased',objOpp.StageName );
        
        // Check For Subscription.
        System.assertEquals(objsub.Id,objOpp.Subscription__c );
        
        // Check For ProductID.
        System.assertEquals(objMBASub.ProductID__c,objOpp.ProductID__c );
       
        
        //checking values of created Opportunity Product. 
        lstOppProduct=[SELECT RevenueChange__c,Name,ExpirationDate__c,MonthlyRecurringRevenue__c,ProductID__c FROM Opportunity_Product__c WHERE OpportunityID__c =: objOpp.Id ORDER BY CreatedDate DESC];
        Opportunity_Product__c obj = lstOppProduct[0];
        
        // Check For Opportunity Product ExpirationDate.
        System.assertEquals(objOpp.ExpirationDate__c,obj.ExpirationDate__c );
        
        // Check For Opportunity Product ProductID__c.
        System.assertEquals(objMBASub.ProductID__c,obj.ProductID__c );
        
        // Check For Opportunity Product MonthlyRecurringRevenue.
        System.assertEquals(objOpp.MonthlyRecurringRevenue__c,obj.MonthlyRecurringRevenue__c );
        
        // Check For Opportunity Product RevenueChange.
        System.assertEquals(obj.MonthlyRecurringRevenue__c-lstOppProduct[1].MonthlyRecurringRevenue__c,obj.RevenueChange__c );
        
        // Check For Opportunity Product Name.
 //       System.assertEquals(objOpp.Name,obj.Name );
   
   
    } 
     
    public static testMethod void testConvertLeadManualy() {
      
        test.starttest();
        MBA_Staging_Account__c objMBAAcct;
        MBA_Staging_Subscription__c objMBASub;
        MBA_Staging_Contact__c objMBAContact;
//        Lead objlead;
        
        Opportunity objOpp;
        Subscription__c objSub;
        List<Opportunity_Product__c> lstOppProduct;
        
        objMBAAcct = new  MBA_Staging_Account__c();
        objMBAAcct.MBAAccountID__c='a341234';
        objMBAAcct.CompanyName__c='companytest';
        insert objMBAAcct;
        System.debug('testclass'+objMBAAcct);
       
        // Create Staging Contact records 
       
        objMBAContact=new MBA_Staging_Contact__c();
        objMBAContact.MBAAccountID__c=objMBAAcct.MBAAccountID__c;
        objMBAContact.Email__c='Usertest123@gmail.com';
        objMBAContact.MBAClientID__c='c567123';
        objMBAContact.FirstName__c='Firstname';
        objMBAContact.LastName__c='lastname';
        insert objMBAContact;
        System.debug('testclass'+objMBAContact);

 //creating a lead 
    
        Lead objlead=new Lead();
        objlead.LastName='test125';
        objlead.Company='testcompany';
        objlead.Stage__c ='New';
        objlead.Email='Usertest123@gmail.com';
           
       
        Database.SaveResult saveResults = Database.Insert(objlead); 
            
        System.debug('testclass Subs Data Creation');
        objMBASub = new MBA_Staging_Subscription__c();
        objMBASub.MBASubscriptionID__c='s345123';
        objMBASub.MBAAccountID__c = objMBAAcct.MBAAccountID__c;
        objMBASub.isTrial__c=true;
        objMBASub.SubscriptionType__c ='Store';
        objMBASub.Status__c='Active';
        objMBASub.ProductID__c='33';
        objMBASub.ExpirationDate__c=System.Today();
        objMBASub.MonthlyRecurringRevenue__c=0.00;
        insert objMBASub;
        System.debug('testclass'+objMBASub);
        test.stoptest();
  /*     
       // query Subscription.
       objSub=[SELECT Id,Lead__c FROM Subscription__c WHERE MBASubscriptionID__c =: objMBASub.MBASubscriptionID__c ];
       
       //quering created lead 
       objlead=[select Id,Most_Recent_Trial__c From Lead Where Email =: objMBAContact.Email__c];
       system.debug('objlead'+objlead);
       // system.assertEquals(objlead.Most_Recent_Trial__c,objSub.Lead__c); 
       //converting created lead
       Database.LeadConvert leadsToConvert = new Database.LeadConvert();
        
           
       leadsToConvert.setConvertedStatus('Qualified');
       leadsToConvert.setLeadId(objlead.Id);
            
        Database.LeadConvertResult lcResults = Database.convertLead(leadsToConvert);
        System.debug('testclass'+lcResults ); 
  */     
         
         //updating MBASubscription 
        objMBASub.isTrial__c=false;
        objMBASub.SubscriptionType__c ='Store';
        objMBASub.Status__c='Pending';
        objMBASub.ProductID__c='24';
        objMBASub.MonthlyRecurringRevenue__c=49.95;
        update objMBASub;
        //querying created Subscription
        objSub=[SELECT Id FROM Subscription__c WHERE MBASubscriptionID__c =: objMBASub.MBASubscriptionID__c ];
       
        //checking values of created opportunity
        objOpp=[SELECT Id,MBASubscriptionID__c,Name ,Subscription__c ,StageName ,MBA_Account_ID__c,MonthlyRecurringRevenue__c FROM Opportunity WHERE MBASubscriptionID__c  =:objMBASub.MBASubscriptionID__c];
        System.assertEquals(objMBASub.MonthlyRecurringRevenue__c,objOpp.MonthlyRecurringRevenue__c );
        System.assertEquals(objMBAAcct.MBAAccountID__c,objOpp.MBA_Account_ID__c );
        System.assertEquals(objMBASub.MBASubscriptionID__c,objOpp.MBASubscriptionID__c );
        System.assertEquals('Pending',objOpp.StageName );
        System.assertEquals(objSub.Id,objOpp.Subscription__c );
       
        //checking values of created Opportunity Product 
        lstOppProduct=[SELECT RevenueChange__c,Name,ExpirationDate__c,MonthlyRecurringRevenue__c,ProductID__c FROM Opportunity_Product__c WHERE OpportunityID__c =: objOpp.Id ORDER BY CreatedDate DESC];
        Opportunity_Product__c obj = lstOppProduct[0];
        System.assertEquals(System.Today(),obj.ExpirationDate__c );
        System.assertEquals(objMBASub.ProductID__c,obj.ProductID__c );
        System.assertEquals(objOpp.MonthlyRecurringRevenue__c,obj.MonthlyRecurringRevenue__c );
        //System.assertEquals(obj.MonthlyRecurringRevenue__c-lstOppProduct[1].MonthlyRecurringRevenue__c,obj.RevenueChange__c );
//        System.assertEquals(objOpp.Name,obj.Name );
		
    }
    
   public static testMethod void testContacts() { 
   	
   
    TestDataGenerator td = new TestDataGenerator();
  
      list<Contact> lstCon = td.getContacts(false);
      Account a = new Account(Name = 'Test');
      insert a;  
                  for(contact c:lstCon) {
                        
                        c.AccountId = a.Id;
                        c.Primary_MBA_Contact__c = false;
                        
                  }
                   insert lstCon;   
                     
       lstCon[1].Primary_MBA_Contact__c = true;   
        lstCon[2].Primary_MBA_Contact__c = true; 
         lstCon[2].Type__c = 'Primary Contact';  
         lstCon[3].Primary_MBA_Contact__c = true;   
         lstCon[3].Type__c = 'Billing_Contact';          
                update lstCon;     
      // Create a new opportunity for the account
      Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 
      Opportunity obj = new Opportunity();
        obj.Name = 'Test O';
        obj.CloseDate = Date.today().addDays(1);
        obj.StageName = 'Purchased';
        obj.SBD_Store_ID__c = '683074';
        obj.AccountId = a.Id;
        
        obj.RecordTypeId = storeRecordTypeId;
        obj.Status__c = 'Active';
        
        insert obj;
        
        Opportunity o = [Select Id, Contact__c from Opportunity where Accountid = :a.Id];
        system.debug(' opp contact '+o.contact__c);
         system.debug('Primary '+ lstCon[2].Id);
   }  
   
   static testMethod void testMergeOppmethods(){
   	
   	     // Variables to use in testing
        MBA_Staging_Account__c objMBAAcct;
        MBA_Staging_Subscription__c objMBASub;
        MBA_Staging_Contact__c objMBAContact;
        Subscription__c objSub;
        Id acctId;
        
        // Create Test Data
        TestDataGenerator td = new TestDataGenerator();
        
        // Initialize the Custom Setting Map    
        td.getStagingToTableMappingSettings();
        
        // Create Staging Account records as not Paid and grab one of them
        td.getAccountMBAs(true, false);
        objMBAAcct = td.AccountMBAs[0]; 
        MBA_Staging_Account__c objMBAAcct2 = td.AccountMBAs[1]; 
        
        // Create Staging Contact records as not Paid
        td.getContactMBAs(true, false);
                
        // Create Staging Subscription records as paid
        td.getStagingSubscriptions(false, false, objMBAAcct.MBAAccountID__c, 9898119);
        objMBASub = td.lstStagingSubscriptions[0];
        
        MBA_Staging_Subscription__c objMBASub2 =   td.getStagingSubscriptions(false, false, objMBAAcct2.MBAAccountID__c, 9899119)[1];
        
        // Start Test
        test.startTest();
        system.debug(' sub1 '+objMBASub.MBAAccountID__c);
        system.debug(' sub2 '+objMBASub2.MBAAccountID__c);
        insert objMBASub;
        
        insert objMBASub2;
        
        
   	    List<Opportunity> opps = [Select Id, MBAAccountID__c from Opportunity where MBAAccountId__c= :objMBAAcct.MBAAccountID__c];
 //		system.assertEquals(opp1.MBAAccountID__c, objMBAAcct.MBAAccountID__c);
		system.debug(' opp1 '+opps[0].MBAAccountID__c);
		system.debug(' opp1 '+opps.size());
//		MergeOpportunity.mergeOpp(opps[0].Id, opps[1].Id);
		MergeOppController.mergeOpp(opps[0].Id, opps[1].Id);

 		test.stopTest();
   }
   
      
}