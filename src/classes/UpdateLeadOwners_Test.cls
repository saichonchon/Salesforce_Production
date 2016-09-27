@isTest(SeeAllData=true)
public class UpdateLeadOwners_Test{


public static testMethod void testBatch_TestCase1(){
  
   User usr1 = [Select Id,Name,Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.ROE_Team_3 LIMIT 1];
   User usr2 = [Select Id,Name,Department, UserRoleId,UserRole.Name from User Where IsActive=true and Department =:Label.ROE_Team_2 LIMIT 1];
   System.Debug('#usr1#'+usr1);
   System.Debug('#usr2#'+usr2);
   
   
   
   System.runAs(usr1){
   Lead obj = new Lead(FirstName='Test',LastName='Lead',OwnerId=usr1.Id,Company='Test 90 Day');
   insert obj;
   System.Debug('#Insert#'+obj);
   
   Lead obj1 = new Lead(FirstName='Test1',LastName='Lead1',OwnerId=usr2.Id,Company='Test 90 Day');
   insert obj1;
   System.Debug('#Insert1#'+obj1);
   
   Lead obj2 = new Lead(FirstName='Test2',LastName='Lead1',OwnerId=usr1.Id,Company='Test 90 Day');
   insert obj2;
   System.Debug('#Insert1#'+obj1);
   obj2.OwnerId = usr2.Id;
   update obj2;
       
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
   
   Task tskPast = new Task(WhoId = obj.Id, ActivityDate=System.today().addDays(-30),Subject='Test Task');
   insert tskPast;
   System.Debug('#Task#'+tskPast);
   Task tskPast1 = new Task(WhoId = obj.Id, ActivityDate=System.today().addDays(-45),Subject='Test Task');
   insert tskPast1;
   
   Task tskPast2 = new Task(WhoId = obj.Id, ActivityDate=System.today().addDays(-60),Subject='Test Task');
   insert tskPast2;
   
   Task tskPast3 = new Task(WhoId = obj.Id, ActivityDate=System.today().addDays(-90),Subject='Test Task');
   insert tskPast3;
   
   Task tskPresent = new Task(WhoId = obj.Id,ActivityDate=System.today(),Subject='Test Task');
   insert tskPresent;
   
   Test.StartTest();
   UpdateLeadOwners reassign = new UpdateLeadOwners();
   ID batchprocessid = Database.executeBatch(reassign);
   Test.StopTest();
   
 }
 
}

}