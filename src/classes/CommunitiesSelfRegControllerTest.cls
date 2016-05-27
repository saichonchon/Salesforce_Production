/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {

       CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
//        controller.firstName = 'FirstName';
//        controller.lastName = 'LastName';
//        controller.email = 'testmail@bigcommerce.com';
        controller.formurl = 'http://testingStore1bigcommerce.com'; 
        controller.supportpin = '12345';
 //       controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
/*        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
 */       
        TestDataGenerator td = new TestDataGenerator();
        
        list<Account> lstAcct = td.getAccounts(true);
        lstAcct[0].SupportPin__c = '12345';
        update lstAcct; 
         
         Contact c = new Contact();
                        c.FirstName = 'First ' ;
                        c.LastName = 'Last ' ;
                        c.MailingCountry ='US';
                        c.Email = 'testmail@bigcommerce.com';
                        c.AccountId = lstAcct[0].Id;
                        c.Primary_MBA_Contact__c = true;
         insert c;
        
        Subscription__c sub = new Subscription__c( 
 //           RecordTypeId = recType,
            RecordTypeId = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId(),
            ProductType__c = 'Store',
            StoreURL__c = 'testingStore1bigcommerce.com',         
            Purchase_Team__c = 'Sales Operations',
            Source__c = 'Direct Trial',
            Upgrade_Stage__c = 'New',
            Account__c = lstAcct[0].Id,
            Sales_Stage__c = 'New',          
            Status__c = 'Active',
            IsTrial__c = true,
            Was_Trial__c = true,
            
            Product__c = 'Silver Plan');
          
         insert sub;
        
        Account testAccount = lstAcct[0];
        Subscription__C testSub = [SELECT Id, Account__c, Contact__c,StoreURL__c,Support_PIN__c FROM Subscription__c WHERE Id =: Sub.Id];
        
        System.assertEquals(testAccount.Id, testSub.Account__c);
        System.assertEquals(testAccount.SupportPin__c, testSub.Support_Pin__c);
        
        controller.formurl = 'http://www.testingStore1bigcommerce.com'; 
        controller.supportpin = '12345';
       
        controller.authenticateUser();
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';
        controller.registerUser();
 //       System.assert(controller.registerUser() <> null);  
    }    
}