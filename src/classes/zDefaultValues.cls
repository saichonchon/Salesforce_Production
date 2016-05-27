global class zDefaultValues extends zqu.CreateQuoteController.PopulateDefaultFieldValuePlugin{ 
   global override void populateDefaultFieldValue
      (SObject record, zqu.PropertyComponentController.ParentController pcc)
   {   
 	  super.populateDefaultFieldValue(record, pcc);   
 	      
 	  record.put('zqu__InitialTerm__c', 15);   
      record.put('zqu__RenewalTerm__c', 12);   
      record.put('zqu__ValidUntil__c', Date.today().addDays(30));   
      record.put('zqu__StartDate__c', Date.today());  
      record.put('zqu__Service_Activation_Date__c',  Date.today());
      record.put('zqu__PaymentMethod__c', 'Credit Card'); 
      record.put('zqu__Currency__c', 'USD'); 
      record.put('zqu__PaymentTerm__c', 'Due Upon Receipt');
      
 // Retrieve the account ID from the quote        
      Id accountId = (Id) record.get('zqu__Account__c');        
       
      // Find the contacts associated with the account        

		Contact BillingContact = ContactUtility.getBillContact(accountId);
		Contact PrimaryContact = ContactUtility.getPrimaryContact(accountId);
		
         record.put('zqu__BillToContact__c', BillingContact.Id);            
         record.put('zqu__SoldToContact__c', PrimaryContact.Id);            
       
         // Beforeretrieving  the lookup  options, needs to populate the map first            
         super.setLookupOptions(pcc);            
       
         // Now retrieve the lookup component options            
         zqu.LookupComponentOptions billToOptions = super.getLookupOption('zqu__BillToContact__c');            
         if (BillingContact <> null)
         {
	         billToOptions.targetId = BillingContact.Id;            
	         billToOptions.targetName = BillingContact.Name;    
         }        
         zqu.LookupComponentOptions soldToOptions  = super.getLookupOption('zqu__SoldToContact__c');            
         if (PrimaryContact <> null)
         {
	         soldToOptions.targetId = PrimaryContact.Id;            
	         soldToOptions.targetName = PrimaryContact.Name;  
         }
 /*        else if (BillingContact <> null)
         {
         	soldToOptions.targetId = BillingContact.Id;            
	        soldToOptions.targetName = BillingContact.Name; 
         } 
  */     
  
 /*
      Opportunity op;
      Object sop = record.get('zqu__Opportunity__c');
      Id opId = (Id)sop;
      Opportunity o = [Select Id, AccountId from Opportunity where id =:opId];
 
      List<Zuora__CustomerAccount__c> zcalist = [Select Id, Zuora__Zuora_Id__c, Zuora__PaymentMethod_Type__c 
													from Zuora__CustomerAccount__c 
      												where Zuora__Account__c = :accountId];
 		Zuora__CustomerAccount__c zca = zcaList[0];
 */ 
      Zuora__CustomerAccount__c zca = ZuoraUtility.getBillingAccount(accountId);
   
      
 //     record.put('zqu__Account__c',o.AccountId);
      if (zca <> null ) 
      {
      	 record.put('zqu__ZuoraAccountID__c', zca.Zuora__Zuora_Id__c);
		 if (zca.Zuora__PaymentMethod_Type__c == 'Credit Card' 
		     || zca.Zuora__PaymentMethod_Type__c == 'ACH')
		     record.put('zqu__ProcessPayment__c', true);
      }
      
     
   }
}