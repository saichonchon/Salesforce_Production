/* ============================================================
 * Contributor: Caleb Sidel
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
@IsTest
private class ErrorEmailHelper_Test {

    
    static testMethod void test_notifyOnErrorCurrentUser() {        
        Custom_Apex_Error_Handler__c setting = new Custom_Apex_Error_Handler__c();
        setting.Name = 'CurrentUser_CustomSettingNameTest';
        setting.Single_Apex_Class__c = 'testClasstest1234';
        insert setting;
        
        ErrorEmailHelper.notifyOnError(setting.Single_Apex_Class__c,'ExceptionName','subject','errorbody');
    }

    static testMethod void test_notifyOnErrorWithUserIds() {        
        Custom_Apex_Error_Handler__c setting = new Custom_Apex_Error_Handler__c();
        setting.Name = 'CustomSettingNameTest';
        setting.Email__c = 'testOne@TesterNoVoidWork.net';
        setting.Single_Apex_Class__c = 'testClasstest1234';
        insert setting;
        
        TestDataGenerator data = new TestDataGenerator();
        User u = data.getUsers(null)[0];
        Set<Id> userIds = new Set<Id>();
        System.assertNotEquals(null,u.Id);
        userIds.add(u.Id);
        ErrorEmailHelper.notifyOnError(setting.Single_Apex_Class__c,'exception','subject','errorbody',userIds);     
    }

    static testMethod void test_notifyOnError() {       
        Custom_Apex_Error_Handler__c setting = new Custom_Apex_Error_Handler__c();
        setting.Name = 'CustomSettingNameTest';
        setting.Email__c = 'testOne@TesterNoVoidWork.net';
        setting.Single_Apex_Class__c = 'testClasstest1234';
        insert setting;
        
        ErrorEmailHelper.notifyOnError(setting.Single_Apex_Class__c,'exp','subject','errorbody');
    }
    
    static testMethod void test_notifyOnError_HighVolume() {
        Custom_Apex_Error_Handler__c setting = new Custom_Apex_Error_Handler__c();
        setting.Name = 'CustomSettingNameTest';
        setting.Email__c = 'testVolume@TesterNoVoidWork.net';
        setting.Single_Apex_Class__c = 'testClasstest1234';
        insert setting;
                
        for(Integer i = 0; i < Limits.getLimitEmailInvocations() + 2; i++) {
            ErrorEmailHelper.notifyOnError(setting.Single_Apex_Class__c,'exp','subject','errorbody');
        }
    } 
    
    static testMethod void test_getEmailAddresses() {       
        Custom_Apex_Error_Handler__c setting = new Custom_Apex_Error_Handler__c();
        setting.Name = 'CustomSettingNameTest';
        setting.Email__c = 'test@testernovoidwork.net';
        insert setting;
        System.assert(ErrorEmailHelper.getEmailAddresses(null,null).contains(setting.Email__c),'Set of emails does not include the one we want');
        
        Custom_Apex_Error_Handler__c setting2 = new Custom_Apex_Error_Handler__c();
        setting2.Name = 'CustomSettingNameTest2';
        setting2.Email__c = 'test2@testernovoidwork.net';
        setting2.Single_Apex_Class__c = 'TestTestTest';
        insert setting2;
                
        System.assert(ErrorEmailHelper.getEmailAddresses('TestTestTest','Test').contains(setting.Email__c),'Set of emails does not include the one we want');
        System.assert(ErrorEmailHelper.getEmailAddresses('TestTestTest',null).contains(setting2.Email__c),'Set of emails does not include the one we want');
        System.assert(ErrorEmailHelper.getEmailAddresses(null,null).contains(setting.Email__c),'Set of emails does not include the one we want');   
    }
    
}