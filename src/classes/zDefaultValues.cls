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

		Contact BillingContact = null;
      Contact PrimaryContact = null;

      try
      {
         PrimaryContact = ContactUtility.getPrimaryContact(accountId);
      }
      catch (Exception e)
      {
      }

      try
      {
         BillingContact = ContactUtility.getBillContact(accountId);
      }
      catch (Exception e)
      {
         BillingContact = PrimaryContact;
      }
		
      // Beforeretrieving  the lookup  options, needs to populate the map first            
      super.setLookupOptions(pcc);            
    
      // Now retrieve the lookup component options            
      zqu.LookupComponentOptions billToOptions = super.getLookupOption('zqu__BillToContact__c');            
      if (BillingContact <> null)
      {
         record.put('zqu__BillToContact__c', BillingContact.Id);            
         billToOptions.targetId = BillingContact.Id;            
         billToOptions.targetName = BillingContact.Name;    
      }        
      zqu.LookupComponentOptions soldToOptions  = super.getLookupOption('zqu__SoldToContact__c');            
      if (PrimaryContact <> null)
      {
         record.put('zqu__SoldToContact__c', PrimaryContact.Id);
         soldToOptions.targetId = PrimaryContact.Id;            
         soldToOptions.targetName = PrimaryContact.Name;  
      }

      try
      {
         Zuora__CustomerAccount__c zca = ZuoraUtility.getBillingAccount(accountId);
         record.put('zqu__ZuoraAccountID__c', zca.Zuora__Zuora_Id__c);
         if (zca.Zuora__PaymentMethod_Type__c == 'Credit Card' 
          || zca.Zuora__PaymentMethod_Type__c == 'ACH')
         {
            record.put('zqu__ProcessPayment__c', true);
         }
      }
      catch (Exception e)
      {
         throw new ApplicationException('No billing account found for this account (' + accountId + ').  Please contact the Bizapps team to update the Zuora account with this Salesforce ID, then sync Zuora back to Salesforce.');
      }
   
      
     
   }
}