@isTest
private class UpdateOwnerTest {

  @testSetup static void setup() {
        // Create 
        List<Lead_Update_Owner__c > rules = new List<Lead_Update_Owner__c >();
        Lead_Update_Owner__c ruleis = new Lead_Update_Owner__c (
        				Name = Label.Outbound_Sales,
        				Update__c = false,
        				SLA__c =90,
        				Queue_Owner__c = Label.BCT_ID);
        rules.add(ruleis);
        Lead_Update_Owner__c ruleo = new Lead_Update_Owner__c (
        				Name = Label.Inbound_Sales,
        				Update__c = false,
        				SLA__c =90,
        				Queue_Owner__c = Label.BCT_ID);
        rules.add(ruleo);
        insert rules;   
        
        List<RollupConfigs__c > rrules = new List<RollupConfigs__c >();
        RollupConfigs__c opprule = new RollupConfigs__c (
        				Name = 'Account - Opportunity Active',
        				Parent_Object__c = 'Account',
        				Child_Object_Name__c = 'Opportunity',
        				queryField_parentRelationshipName__c ='Channel_Partner__c',
        				parentQueryField1__c ='PAR_Total_Active_MRR__c',
        				Criteria__c ='',
        				queryField1__c = 'MonthlyRecurringRevenue__c');
  //      rules.add(ruleis);
        insert opprule;  
        
        List<String > ProfileName = new List<String>();
        ProfileName.add('Sales Rep');
         
        TestDataGenerator td = new TestDataGenerator();
        List<User> usrs = td.getUsers(ProfileName);
         
    }
 
 public static testMethod void testBatch_Trial(){
   
    	
   	Id trialRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
    User usr1 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Inbound_Sales LIMIT 1];
   		User usr2 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Outbound_Sales LIMIT 1];
   		System.Debug('#usr1#'+usr1);
   		System.Debug('#usr2#'+usr2);  
   
 //  System.runAs(usr1){
     TestDataGenerator td = new TestDataGenerator();
      
      list<Contact> lstCon = td.getContacts(true);
      
      Opportunity obj = new Opportunity();
        obj.Name = 'Test ';
        obj.CloseDate = Date.today().addDays(1);
        obj.StageName = 'Trial';
        obj.OwnerId = usr1.Id;
        obj.AccountId = lstCon[0].AccountId;
        obj.RecordTypeId = trialRecordTypeId;
        obj.Status__c = 'Active';
        insert obj;
  
    Opportunity obj1 = new Opportunity();
        obj1.Name = 'Test ';
        obj1.CloseDate = Date.today().addDays(1);
        obj1.StageName = 'Trial';
        obj1.OwnerId = usr2.Id;
        obj1.AccountId = lstCon[1].AccountId;
        obj.RecordTypeId = trialRecordTypeId;
        obj.Status__c = 'Active';
        insert obj1;
 
       
   Lead_Retrieved__c objRec = new Lead_Retrieved__c();
   objRec.Owner_ID__c = usr1.Id;
   objRec.Lead_ID__c = obj.Id;
   objRec.Lead_Owner_Assign_Date__c = System.Today();
   objRec.Processed__c =false;  
   insert objRec;
  
   Lead_Retrieved__c objRec1 = new Lead_Retrieved__c();
   objRec1.Owner_ID__c = usr1.Id;
   objRec1.Lead_ID__c = obj1.Id;
   objRec1.Lead_Owner_Assign_Date__c = System.Today().addDays(-1);
   objRec1.Processed__c =false;  
   insert objRec1;
   
   Task tskPast = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-30),Subject='Test Task');
   insert tskPast;
   System.Debug('#Task#'+tskPast);
   Task tskPast1 = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-45),Subject='Test Task');
   insert tskPast1;
   
   Task tskPast2 = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-60),Subject='Test Task');
   insert tskPast2;
   
   Task tskPast3 = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-90),Subject='Test Task');
   insert tskPast3;
   
   Task tskPresent = new Task(WhatId = obj.AccountId,ActivityDate=System.today(),Subject='Test Task');
   insert tskPresent;
   
   Test.StartTest();
 
     string queryTrial ='Select Id, Name, PurchaseDate__c, AccountId, OwnerId, StageName, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c,Status__c from Opportunity Where  RecordTypeId = :trialRecordTypeId  ' ;
 		queryTrial = queryTrial + Label.ROE_Trial_Query;
   	   queryTrial = queryTrial + ' limit 1';
   	
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryTrial;
      database.executebatch(b);
      
   Test.StopTest();
   
 
}

public static testMethod void testBatch_Upsell(){
   
   	User usr1 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Inbound_Sales LIMIT 1];
   	User usr2 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Outbound_Sales LIMIT 1];
   	
    Id upgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
	    
 //  System.runAs(usr1){
     TestDataGenerator td = new TestDataGenerator();
      
      list<Contact> lstCon = td.getContacts(true);
      
      // Create a new opportunity for the account
      
      Opportunity obj = new Opportunity();
        obj.Name = 'Test ';
        obj.CloseDate = Date.today().addDays(1);
        obj.StageName = 'Demo';
        obj.OwnerId = usr1.Id;
        obj.AccountId = lstCon[0].AccountId;
        obj.RecordTypeId = upgradeRecordTypeId;
        insert obj;
  
    Opportunity obj1 = new Opportunity();
        obj1.Name = 'Test ';
        obj1.CloseDate = Date.today().addDays(1);
        obj1.StageName = 'Demo';
        obj1.OwnerId = usr2.Id;
        obj1.AccountId = lstCon[1].AccountId;
        obj.RecordTypeId = upgradeRecordTypeId;
        insert obj1;
  
   Task tskPast = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-30),Subject='Test Task', OwnerId = usr1.Id);
   insert tskPast;
   System.Debug('#Task#'+tskPast);
 
   
   Test.StartTest();
   string queryUpsell ='Select Id, Name, AccountId, OwnerId, StageName, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c from Opportunity Where  RecordTypeId = :upgradeRecordTypeId  ' ;
   queryUpsell= queryUpsell + ' limit 1';
   
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryUpsell;
      database.executebatch(b);
      
   Test.StopTest();
   
 
}

public static testMethod void testBatch_Purchase(){
   
  	
    Id storeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
	  User usr1 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Inbound_Sales LIMIT 1];
   		User usr2 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Outbound_Sales LIMIT 1];
   		System.Debug('#usr1#'+usr1);
   		System.Debug('#usr2#'+usr2);  
     TestDataGenerator td = new TestDataGenerator();
      
      list<Contact> lstCon = td.getContacts(true);
      
      // Create a new opportunity for the account
      
      Opportunity obj = new Opportunity();
        obj.Name = 'Test ';
        obj.CloseDate = Date.today().addDays(-180);
        obj.StageName = 'Purchased';
        obj.OwnerId = usr1.Id;
        obj.PurchaseDate__c = Date.today().addDays(-180);
        obj.AccountId = lstCon[0].AccountId;
        obj.RecordTypeId = storeRecordTypeId;
        insert obj;
  
    Opportunity obj1 = new Opportunity();
        obj1.Name = 'Test ';
        obj1.CloseDate = Date.today().addDays(1);
        obj1.StageName = 'Demo';
        obj1.OwnerId = usr2.Id;
        obj1.AccountId = lstCon[1].AccountId;
        obj.PurchaseDate__c = Date.today().addDays(-180);
        obj.RecordTypeId = storeRecordTypeId;
        insert obj1;
  
     Task tskPast = new Task(WhatId = obj.AccountId, ActivityDate=System.today().addDays(-30),Subject='Test Task', OwnerId = usr1.Id);
   		insert tskPast;
   		System.Debug('#Task#'+tskPast);
 
   
   Test.StartTest();
   string queryPurchase ='Select Id, Name, AccountId, OwnerId, StageName, CreatedDate, CreatedById, RecordTypeId, Owner_Team__c from Opportunity Where  RecordTypeId = :upgradeRecordTypeId  ' ;
    queryPurchase= queryPurchase + ' limit 1';
   
      UpdateOwner b = new UpdateOwner(); 
      b.query = queryPurchase;
      database.executebatch(b);
      
   Test.StopTest();
   
 
}

}