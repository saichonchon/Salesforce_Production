@isTest
private class editOverrideController_Test { 
        
        static testmethod void testCaseEditOverride(){
        
            // Create dummy data for test purposes.
            Case b = new Case(Reason = 'Account Merge',Origin = 'Email', Status = 'New',Requesting_Department__c = 'Client Success');
            insert b;
            
            //Run code as Client Success Rep profile    
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Client Success Rep']; 
            User u = new User(Alias = 'standt', Email='standarduser@bigcommerce.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@bigcommerce.com');
            
            System.runAs(u) {
                //Set the current page
                PageReference pageRef = Page.editOverride;
                Test.setCurrentPageReference(pageRef);
                //Put the parameter in the url
                ApexPages.CurrentPage().getparameters().put('id', b.id);
                //Initialize the standard controller
                ApexPages.StandardController sc = new ApexPages.standardController(b);
                editOverrideController con = new editOverrideController(sc);
                //Invoke the action method
                con.createLog();
                
            }
        }           
}