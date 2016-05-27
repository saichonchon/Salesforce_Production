@isTest
private class AccountActivityTest {

  
 public static testMethod void testBatch(){
 
     User usr1 = [Select Id,Name, Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.Inbound_Sales LIMIT 1];
   	 System.Debug('#usr1#'+usr1);
   		
 
     TestDataGenerator td = new TestDataGenerator();
      
      list<Account> lstAcct = td.getAccounts(true);
  
 //     objRec.Owner_ID__c = usr1.Id;
   
 //    insert objRec;
  
      
   Task tskPast = new Task(WhatId = lstAcct[0].Id, ActivityDate=System.today().addDays(-30),Subject='Test Task', Type = 'Call');
   insert tskPast;
   System.Debug('#Task#'+tskPast);
   Task tskPast1 = new Task(WhatId = lstAcct[2].Id, ActivityDate=System.today().addDays(-45),Subject='Test Task', Type = 'Email', ToutApp__Tout_Replied__c = true );
            
   insert tskPast1;
   
   Task tskPast2 = new Task(WhatId = lstAcct[0].Id, ActivityDate=System.today().addDays(-60),Subject='Test Task');
   insert tskPast2;
   
   Task tskPast3 = new Task(WhatId = lstAcct[0].Id, ActivityDate=System.today().addDays(-90),Subject='Test Task');
   insert tskPast3;
   
   Task tskPresent = new Task(WhatId = lstAcct[0].Id,ActivityDate=System.today(),Subject='Test Task');
   insert tskPresent;
   
   Test.StartTest();
 //  UpdateOwner reassign = new UpdateOwner();
 //  ID batchprocessid = Database.executeBatch(reassign);
 
        string query ='SELECT AccountId, WhoId,ActivityDate, Subject, CallDisposition, Type, OwnerId, ToutApp__Tout_Replied__c  FROM Task where AccountID <> null and (CreatedDate = LAST_90_DAYS)  ' ;
// 		query = query + Label.ROE_AccountActivity_Query;
 		if(Test.isRunningTest()){   query = query + ' limit 20';}
        //CreatedDate < LAST_N_DAYS:90 and Owner_Team__c = \'Outbound\'  limit 100 ';
        system.Debug('#query# '+query); 
      
      
	      AccountActivityUpdate b = new AccountActivityUpdate(); 
	      b.query = query;
	      database.executebatch(b);
      
   Test.StopTest();
   
 
}

}