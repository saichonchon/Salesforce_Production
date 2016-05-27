@isTest()
public class UserUtilityTest {


    static testMethod void testCommunityUser() 
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
        
         
         Id pId = Label.Community_User_Profile;
         Profile p = [SELECT id 
                        FROM profile
                        WHERE Id =:pId
                        LIMIT 1];
         User cu = td.getUser(p, 'testingSG1234');
         cu.contactId = objC.Id;
         
         Test.startTest();
         insert cu;
         Test.stopTest();
      
     list<collaborationgroupmember> cgm = [select id from CollaborationGroupMember where memberid=:cu.ID];       
     //this assert happens after test.stoptest() because asynchrnous methods run when they hit test.stoptest()
     System.assertEquals(cgm.size(),2);
        
   }
}