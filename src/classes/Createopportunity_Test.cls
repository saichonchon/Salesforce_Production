@isTest
Class Createopportunity_Test
{
Private Static testmethod void TestOpportunityCreation(){
CreateopportunityController instance = new CreateopportunityController();
	
    PageReference ref = Page.CreateOpportunity;
    Test.setCurrentPageReference(ref);
    
    AccountMaxSubRollup__c ams = new AccountMaxSubRollup__c();
    ams.Name = 'Fields';
    ams.FieldList1__c = 'product__c,monthlyrecurringrevenue__c,purchasedate__c,istrial__c,status__c,purchase_team__c,startdate__c,expirationdate__c,billingcycle__c,billingamount__c';
    insert ams;
    
  Account objacc=new Account();
  objacc.Name='testaccount';
  insert objacc;
    
  Subscription__c objSub = new Subscription__c();
  objSub.Account__c =objacc.Id;
  objSub.MBASubscriptionID__c ='tempmbasub';
  insert objSub;
  
  System.currentPageReference().getParameters().put('id', objSub.Id);
    
  System.debug('Acccount '+objacc);
  System.debug('ID'+objSub);

	test.startTest();
	
	instance.autoRun();
     
    System.currentPageReference().getParameters().put('id', objacc.Id);
    instance.autoRun();
    
    Opportunity o = [select Id from Opportunity where AccountId = :objacc.Id limit 1];
    System.currentPageReference().getParameters().put('id', o.Id);
    instance.autoRun();
    
    PageReference ref2 = Page.CreatePSOpportunity;
    Test.setCurrentPageReference(ref2);
    System.currentPageReference().getParameters().put('id', o.Id);
    instance.autoRun();
    
  
test.stopTest();

}
}