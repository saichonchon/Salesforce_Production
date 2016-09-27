/**
* @Bigcommerce 
* Class Name: TestUtilityBox_Test
* Object Name: 
* Developed By: CG
* Date: 10/16/103
* Version: 1.0
* Purpose: Test class for TestUtilityBox class
* History: 
***/


@isTest(seeAllData = false)
private class TestUtilityBox_Test { 
    
    static testMethod void myTestUtilityBoxTest() {         
            
        User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');     
        insert testUser;
                    
        if(Test.isRunningTest()){
            system.RunAs(testUser){             
                
                List<Account> testAccount = TestUtilityBox.getTestAccounts('Client Record Type',10);
                insert testAccount;                 
        
                List<Contact> testContact = TestUtilityBox.getTestContacts(testAccount, 'bigcommerce@email.com');
                insert testContact;
                                
                List<Subscription__c> testSub = TestUtilityBox.getTestSubscriptions('MBA Subscription',null, 10);
                insert testSub;  
                
                List<Subscription__c> testSub1 = TestUtilityBox.getTestSubscriptions('MBA Subscription',testAccount, 10);
                insert testSub1;

                List<Lead> testLead = TestUtilityBox.getTestLeads('Client Prospect','bigcommerce@email.com',400);
                insert testLead;                                          
             
                system.assertEquals(true, testLead != null);
                system.assertEquals(true, testSub != null); 
                system.assertEquals(true, testAccount != null);
                system.assertEquals(true, testContact != null);                                 
            }        
        }       
        system.assertEquals(true, testUser != null);            
    }    
}