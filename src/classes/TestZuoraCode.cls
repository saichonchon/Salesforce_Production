@isTest(SeeAllData=true)
	
private class TestZuoraCode {
 
 @isTest
 private static void testZuora260() 

 {
   
    Account acct = new Account(Name = 'TestAccount');
    
    insert acct;
    
    Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c(Name = acct.Name,
                				Zuora__Account__c = acct.Id);
    insert    billingAccount; 
    
    Contact[] cons = new List<Contact>();
    Contact prim = new Contact(LastName = 'Primary Contact',  AccountId = acct.Id,
                                email = 'primarycontact@bigcommercetest.com',
    							Type__c = 'Primary Contact');			
  
    Contact bill = new Contact(LastName = 'Billing Contact',  AccountId = acct.Id,
                                email = 'billcontact@bigcommercetest.com',
    							Type__c = 'Billing Contact');			
    cons.add(prim);
    cons.add(bill);
    insert cons;
    Opportunity oppty = new Opportunity(Name = 'TestOppty', AccountId = acct.Id, StageName = 'Prospect', CloseDate = Date.parse('12/8/2013'));
    insert oppty;  
     Zuora__Subscription__c ZuoraSub=new Zuora__Subscription__c(
             Zuora__Account__c = acct.Id,
             Zuora__CustomerAccount__c =billingAccount.Id,
             Zuora__MRR__c = 300.00,
             Zuora__Zuora_Id__c='2008uit065',
             Zuora__Status__c='Active',
 //            crmId__c = oppty.Id,
             Zuora__InitialTerm__c='Initial Term'
             );
      insert ZuoraSub;     
      
      Zuora__Product__c zprd = new Zuora__Product__c(
      								Zuora__SKU__c = 'STORE-ENTERPRISE-TRIAL',
      								Zuora__External_Id__c ='erere45454546767',
      								Type__c = 'STORE');
      	insert zprd;
      
      Zuora__SubscriptionProductCharge__c subprd = new Zuora__SubscriptionProductCharge__c(
      												 	Zuora__Account__c = acct.Id,
             							 				Zuora__Price__c = 300.00,
             											Zuora__Zuora_Id__c='22008uit065',
             											Zuora__Subscription__c = ZuoraSub.Id,
             											Zuora__Product__c = zprd.Id,
             											Zuora__MonthlyRecurringRevenue__c = 300.00,
      													Zuora__External_Id__c ='rtrtrioio67676'
      												);
      	insert subprd;
      	
      	ZuoraSub.crmId__c = oppty.Id;
      	update zuoraSub;
      	
      	delete subprd;
      	
  }
/*
	public static Zuora__CustomerAccount__c[] generateBillingAccounts(Account[] fromAccounts)
	 {
        Zuora__CustomerAccount__c[] billingAccounts = new List<Zuora__CustomerAccount__c>();
        for (Account acc : fromAccounts) {
            billingAccounts.add(new Zuora__CustomerAccount__c(Name = acc.Name,
                Zuora__Account__c = acc.Id));
        }
        return billingAccounts;
    } 
*/
@isTest
  private static void setupZquote() {
	
	
    Account acct = new Account(Name = 'TestAccount');
    insert acct;
    Zuora__CustomerAccount__c billingAccount = new Zuora__CustomerAccount__c(Name = acct.Name,
                				Zuora__Account__c = acct.Id);
    insert    billingAccount; 
    
    Contact[] cons = new List<Contact>();
    Contact primc = new Contact(LastName = 'Primary Contact',  AccountId = acct.Id,
                                email = 'primarycontact@bigcommercetest.com',
    							Type__c = 'Primary Contact');			
  
    Contact billc = new Contact(LastName = 'Billing Contact',  AccountId = acct.Id,
                                email = 'billcontact@bigcommercetest.com',
    							Type__c = 'Billing Contact');			
    cons.add(primc);
    cons.add(billc);
    insert cons;
    List<Contact> bmpcs = ContactUtility.getBMPContacts(acct.Id);
	Opportunity opp = new Opportunity(Name = 'TestOppty1', AccountId = acct.Id, StageName = 'Prospect', CloseDate = Date.parse('12/8/2013'));
    insert opp;  
	Contact bill = ContactUtility.getBillContact(acct.Id);
	Contact p    = ContactUtility.getPrimaryContact(acct.Id);
	Zuora__CustomerAccount__c billacct = ZuoraUtility.getBillingAccount(acct.Id);
	
	zqu__Quote__c quote = new zqu__Quote__c(Name = 'TestQuote', zqu__Opportunity__c = opp.Id, 
											zqu__Account__c = acct.Id, zqu__BillToContact__c = bill.Id, zqu__SoldToContact__c = p.Id,
											zqu__Currency__c = 'USD', zqu__StartDate__c = Date.today());
    insert quote;
 /*   
    zqu__ZProduct__c product = ZuoraTestDataSetup.prepareProductCatalog();
    Id productId = product.Id;
    
//    Zuora__CustomerAccount__c  zcas = generateBillingAccounts(accts);
    
    sObject sobj  = (sObject)quote;
    zqu.PropertyComponentController.ParentController cq = new zqu.PropertyComponentController.ParentController();
 //   PageReference pg = Page.zqu__quoteEnhancement;
 	PageReference pg = Page.zqu__CreateQuote;
    Test.setCurrentPage(pg);
    ApexPages.currentPage().getParameters().put('oppId', opp.Id); 
     // Set quote id
    ApexPages.currentPage().getParameters().put('id', quote.Id);
 	ApexPages.currentPage().getParameters().put('quoteType', 'Subscription'); 
 	ApexPages.currentPage().getParameters().put('stepNumber', '2'); 
 //	zqu. zcc = new zqu.CreateQuoteController();
    zqu.CreateQuoteController.PopulateDefaultFieldValuePlugin pp=new zqu.CreateQuoteController.PopulateDefaultFieldValuePlugin();
 //   pp.populateDefaultFieldValue(sobj,cq);
   //     zDefaultValues.populateDefaultFieldValue(sobj,cq);
 */
 	
  }
 
}