public without sharing class Subscription_Utility
{
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // Public Static Variables
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    public static boolean blnAllOrNone = true;
    public static string soqlWHERE_MBAAcctIDs = '';
    public static string soqlWHERE_Email = '';
    public static string soqlWHERE_SubIDs = '';
    public static string soqlWHERE_IDevPartnerIDs = '';
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // Public Maps
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Map to hold existing Lead records by MBA Account Id
    public static map<string, Lead> mpLeadByMBAAcctId;
    
    // Map to hold existing Lead records by Lead Email address
    public static map<string, Lead> mpLeadByEmail;
    
    // Map to hold existing Lead records by SBD Store ID
    public static map<string, Lead> mpLeadByStoreId;
    
    // Map to hold existing Staging Subscription records by MBA Subscription Id
    public static map<string, MBA_Staging_Subscription__c> mpSubStagingBySubId;
    
    // Map to hold existing Account records by MBA Account Id
    public static map<string, Account> mpAcctByMBAAcctId;   
    
    // Map to hold existing Account records by MBA Partner Id
    public static map<string, Account> mpAcctByIDevPartnerId;
    
    // Map to hold existing Staging Account records by MBA Account Id
    public static map<string, MBA_Staging_Account__c> mpAcctStagingByMBAAcctId;
    
    // Map to hold existing Contact records by Contact Email
    public static map<string, Contact> mpContactByEmail;
    
    // Map to hold existing Contact records by MBA Account Id
    public static map<string, list<Contact>> mpContactByMBAAcctId;
    
    // Map to hold existing Staging Contact records by MBA Account Id
    public static map<string, list<MBA_Staging_Contact__c>> mpContactStagingByMBAAcctId;
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
   /////////////////////////////////////////////////////////////////////////////////////////////////////
     // Public methods to load the static map variables
   /////////////////////////////////////////////////////////////////////////////////////////////////////
 
    public static void LoadLeadByMBAAcctIdMap (string soqlMBAAcctIDs)
    {       
        mpLeadByMBAAcctId = new map<string, Lead>();
        
        if (soqlMBAAcctIDs.trim().length() > 0)
        {
            string strSOQL = SObjectUtils.LeadSelect + ' WHERE MBAAccountID__c IN (' + soqlMBAAcctIDs + ') AND IsConverted = false ORDER BY MBAAccountID__c';
                    
            // Grab all the leads that match the account id
            for (Lead l : database.query(strSOQL))
            {
                mpLeadByMBAAcctId.put(l.MBAAccountID__c, l);
            }
        }
        
    }
    
    public static void LoadLeadByEmailMap (string soqlEmail)
    {
        mpLeadByEmail = new map<string, Lead>();
        
        if (soqlEmail.trim().length() > 0)
        {       
            string strSOQL = SObjectUtils.LeadSelect + ' WHERE Email IN (' + soqlEmail + ') AND IsConverted = false AND (MBAAccountID__c = null OR MBAAccountID__c = \'\') ORDER BY MBAAccountID__c';
            
            system.debug('**** Lead By Email Query: ' + strSOQL);
                    
            // Grab all the leads that match the account id
            for (Lead l : database.query(strSOQL))
            {
                mpLeadByEmail.put(l.Email, l);
            }
        }
        
    }
    
    public static void LoadLeadByStoreId (string soqlStoreId)
    {
        mpLeadByStoreId = new map<string, Lead>();
        
        if (soqlStoreId.trim().length() > 0)
        {       
            string strSOQL = SObjectUtils.LeadSelect + ' WHERE SBD_Store_ID_EXT__c IN (' + soqlStoreId + ') AND IsConverted = false AND (MBAAccountID__c = null OR MBAAccountID__c = \'\') ORDER BY MBAAccountID__c';
            
            system.debug('**** Lead By Store Id: ' + strSOQL);
                    
            // Grab all the leads that match the account id
            for (Lead l : database.query(strSOQL))
            {
                mpLeadByStoreId.put(l.SBD_Store_ID_EXT__c, l);
            }
        }
       
    }
    public static void LoadSubStagingBySubIdMap (string soqlSubIDs)
    {
        mpSubStagingBySubId = new map<string, MBA_Staging_Subscription__c>();
        
        if (soqlSubIDs.trim().length() > 0)
        {
            string strSOQL = SObjectUtils.SubscriptionStagingSelect + ' WHERE MBASubscriptionID__c IN (' + soqlSubIDs + ')';
                    
            // Grab all the Staging Subscription records that match the subscription id
            for (MBA_Staging_Subscription__c s : database.query(strSOQL))
            {
                mpSubStagingBySubId.put(s.MBASubscriptionID__c, s);
            }
        }
        
    }
    
    public static void LoadAcctByMBAAcctIdMap (string soqlMBAAcctIDs)
    {
        mpAcctByMBAAcctId = new map<string, Account>();
        
        if (soqlMBAAcctIDs.trim().length() > 0)
        {
            string strSOQL = SObjectUtils.AccountSelect + ' WHERE MBAAccountID__c IN (' + soqlMBAAcctIDs + ') ORDER BY MBAAccountID__c';        
            
            // Grab all the accounts that match the account id
            for (Account a : database.query(strSOQL))
            {
                mpAcctByMBAAcctId.put(a.MBAAccountID__c, a);
            }
        }
        
    }
    
    public static void LoadAcctByIDevPartnerIdMap (string soqlIDevPartnerIDs)
    {
        mpAcctByIDevPartnerId = new map<string, Account>();
        
        if (soqlIDevPartnerIDs.trim().length() > 0)
        {
            string strSOQL = SObjectUtils.AccountSelect + ' WHERE iDev_Partner_ID__c IN (' + soqlIDevPartnerIDs + ') ORDER BY iDev_Partner_ID__c';      
        
            system.debug('**** Account by iDev Partner Id Query: ' + strSOQL);
            
            // Grab all the accounts that match the iDev partner id
            for (Account a : database.query(strSOQL))
            {
                mpAcctByIDevPartnerId.put(string.valueOf(a.iDev_Partner_ID__c), a);
            }
        }
        
    }
    
    public static void LoadAcctStagingByMBAAcctIdMap (string soqlMBAAcctIDs)
    {
        mpAcctStagingByMBAAcctId = new map<string, MBA_Staging_Account__c>();
        
        if (soqlMBAAcctIDs.trim().length() > 0)
        {
            string strSOQL = SObjectUtils.AccountStagingSelect + ' WHERE MBAAccountID__c IN (' + soqlMBAAcctIDs + ') ORDER BY MBAAccountID__c';
                    
            // Grab all the staging accounts that match the account id
            for (MBA_Staging_Account__c a : database.query(strSOQL))
            {
                mpAcctStagingByMBAAcctId.put(a.MBAAccountID__c, a);
            }
        }
        
    }
    
    public static void LoadContactByEmailMap (string soqlEmail)
    {
        mpContactByEmail = new map<string, Contact>();
        
        if (soqlEmail.trim().length() > 0)
        {       
            string strSOQL = SObjectUtils.ContactSelect + ' WHERE Email IN (' + soqlEmail + ') ORDER BY MBAAccountID__c';       
            
            // Grab all the contacts that match the emails
            for (Contact c : database.query(strSOQL))
            {
                if (c.Account.Type == 'Client' || c.Account.Type == 'Prospect')
                mpContactByEmail.put(c.Email, c);
            }
        }
        system.debug('User5 mpContactByEmail'+mpContactByEmail);
    }
    
    public static void LoadContactByMBAAcctIdMap (string soqlMBAAcctIDs)
    {
        mpContactByMBAAcctId = new map<string, list<Contact>>();
        
        if (soqlMBAAcctIDs.trim().length() > 0)
        {           
            string strSOQL = SObjectUtils.ContactSelect + ' WHERE MBAAccountID__c IN (' + soqlMBAAcctIDs + ') ORDER BY MBAAccountID__c, CreatedDate DESC';
                    
            string prevMBAID = '';
            list<Contact> lstContact = new list<Contact>();
            
            // Grab all the staging contacts that match the account id
            for (Contact c : database.query(strSOQL))
            {
                if (c.MBAAccountID__c != prevMBAID)
                {
                    // If any items exist in the list and the previous MBA ID is not empty
                    if (prevMBAID.trim().length() > 0 && !lstContact.isEmpty())
                    {
                        mpContactByMBAAcctId.put(prevMBAID, lstContact);
                    }
                    
                    // Reset the MBA Account ID variable
                    prevMBAID = c.MBAAccountID__c;
                                    
                    // Clear the list and add the new record    
                    lstContact = new list<Contact>();
                    lstContact.add(c);
                }
                else
                {
                    // Add the record to the list
                    lstContact.add(c);
                }
            }
            
            // If any items exist in the list and the previous MBA ID is not empty
            if (prevMBAID.trim().length() > 0 && !lstContact.isEmpty())
            {
                mpContactByMBAAcctId.put(prevMBAID, lstContact);
            }
        }
    }
    
    public static void LoadContactStagingByMBAAcctIdMap (string soqlMBAAcctIDs)
    {
        mpContactStagingByMBAAcctId = new map<string, list<MBA_Staging_Contact__c>>();
        
        if (soqlMBAAcctIDs.trim().length() > 0)
        {           
            string strSOQL = SObjectUtils.ContactStagingSelect + ' WHERE MBAAccountID__c IN (' + soqlMBAAcctIDs + ') ORDER BY MBAAccountID__c, CreatedDate DESC';
                
            system.debug('**** Contact Staging by MBA Account Id Query: ' + strSOQL);
                    
            string prevMBAID = '';
            list<MBA_Staging_Contact__c> lstContactStaging = new list<MBA_Staging_Contact__c>();
            
            // Grab all the staging contacts that match the account id
            for (MBA_Staging_Contact__c c : database.query(strSOQL))
            {
                if (c.MBAAccountID__c != prevMBAID)
                {
                    // If any items exist in the list and the previous MBA ID is not empty
                    if (prevMBAID.trim().length() > 0 && !lstContactStaging.isEmpty())
                    {
                        mpContactStagingByMBAAcctId.put(prevMBAID, lstContactStaging);
                    }
                    
                    // Reset the MBA Account ID variable
                    prevMBAID = c.MBAAccountID__c;
                                    
                    // Clear the list and add the new record    
                    lstContactStaging = new list<MBA_Staging_Contact__c>();
                    lstContactStaging.add(c);
                }
                else
                {
                    // Add the record to the list
                    lstContactStaging.add(c);
                }
            }
            
            // If any items exist in the list and the previous MBA ID is not empty
            if (prevMBAID.trim().length() > 0 && !lstContactStaging.isEmpty())
            {
                mpContactStagingByMBAAcctId.put(prevMBAID, lstContactStaging);
            }
        }
        
    }
   
    public static void HandleStagingSubscriptions(list<Subscription__c> lstNeedLead, list<Subscription__c> lstNeedAccount, list<Subscription__c> lstConvertLead, string soqlMBAAcctIDs, string soqlSubIDs, string soqlIDevPartnerIDs)
    {
        try
        {
            // Capture the where clauses in the static variables
            soqlWHERE_MBAAcctIDs = soqlMBAAcctIDs; 
            soqlWHERE_SubIDs = soqlSubIDs;
            soqlWHERE_IDevPartnerIDs = soqlIDevPartnerIDs;
                
            // Load all private maps if needed
            if (mpLeadByMBAAcctId == null || mpLeadByMBAAcctId.isEmpty())
                LoadLeadByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                
            if (mpAcctByMBAAcctId == null || mpAcctByMBAAcctId.isEmpty())
                LoadAcctByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
    
            if (mpAcctByIDevPartnerId == null || mpAcctByIDevPartnerId.isEmpty())
                LoadAcctByIDevPartnerIdMap(soqlWHERE_IDevPartnerIDs);
    
            if (mpAcctStagingByMBAAcctId == null || mpAcctStagingByMBAAcctId.isEmpty())
                LoadAcctStagingByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
            
            if (mpContactByMBAAcctId == null || mpContactByMBAAcctId.isEmpty())
                LoadContactByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                
            if (mpContactStagingByMBAAcctId == null || mpContactStagingByMBAAcctId.isEmpty())
                LoadContactStagingByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                
            if (mpSubStagingBySubId == null || mpSubStagingBySubId.isEmpty())
                LoadSubStagingBySubIdMap(soqlWHERE_SubIDs);
            
            // Handle Subscriptions that need a new Account
            if (!lstNeedAccount.isEmpty())
                Subscription_NeedAccount(lstNeedAccount);
            
            // Handle Subscriptions that need a Lead Converted
            if (!lstConvertLead.isEmpty())
                Subscription_ConvertLead(lstConvertLead);
        }
        catch (Exception e)
        {
            ErrorEmailHelper.notifyOnError('Subscription_Utility', 'HandleStagingSubscriptions', 'Error in HandleStagingSubscriptions', e.getMessage());
        }
    }
  
	private static void Subscription_NeedAccount (list<Subscription__c> lstMBASub)
    {       
        system.debug('*** In Subscription_NeedAccount Method');
        
        set<string> stMBAAccountIds = new set<string>();
        Boolean lastTime = false;
        
        stMBAAccountIds = updateAccounts(lstMBASub, lastTime);
        
        // Now check if any staging accounts need to be updated and then update them so Accounts are created
        if (!stMBAAccountIds.isEmpty())
        {
            MarkAccountsAndContactsAsPaid(stMBAAccountIds);
        }
            
        // Reload the account and Contact maps
        LoadAcctByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
        //LoadContactByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
        
        lastTime = true;
        stMBAAccountIds = updateAccounts(lstMBASub, lastTime);
        
    }
 
    private static void Subscription_ConvertLead (list<Subscription__c> lstMBASub)
    {
        system.debug('*** In Subscription_ConvertLead Method');
        
        try
        {
            list<database.Leadconvert> lstLeadConvert = new list<database.Leadconvert>();
            database.Leadconvert lc;
            list<database.LeadConvertResult> lstLCR;
            
            string LeadConvertStatus = SObjectUtils.LeadConvertStatus;
            
            map<string, Contact> mpAToC = new map<string, Contact>();
            set<string> stAcctId = new set<string>();
            set<id> stSubId = new set<id>();
            map<string, Id> mpMBAAcctIdTOAccountId = new map<string, Id>();
            map<string, Id> mpMBAAcctIdTOContactId = new map<string, Id>();
            map<Id, Subscription__c> mpLeadIdToSub = new map<Id, Subscription__c>();
            set<Id> stLeadId = new set<Id>();
            map<Id, Lead> mpLeadIDToLead = new map<Id, Lead>();
            
            Account objAcct;
            list<Account> lstAcctUpdates = new list<Account>();
            
            Contact objContact;
            list<Contact> lstContactUpdates = new list<Contact>();
            
            set<string> stMBAAccountIds = new set<string>();
            
 			map<Id, Id> mapqueueowner = new map<id, Id>();
 			for (LeadQueueOwner__c lq  :LeadQueueOwner__c.getAll().values())
 			{
 //				 = LeadQueueOwner__c.getInstance(lqname);
 				mapqueueowner.put(lq.Queue_Id__c, lq.Owner_Id__c);
 			}
 
            // Find all the unique MBA Account Ids where an actual Account record already exists for the subscription
            for (Subscription__c sub : lstMBASub)
            {
                if (mpAcctByMBAAcctId.containsKey(sub.MBAAccountID__c))
                    stAcctId.add(sub.MBAAccountID__c);
                    
                // Capture the lead ids
                stLeadId.add(sub.Lead__c);
                
                system.debug('*** Lead Ids for Convert: ' + sub.Lead__c);
            }
            
            // Query all the contacts that exist already for each account and add them to the Account Id to Contact map
            for (Contact c : [SELECT Id, MBAAccountID__c, AccountId
                                FROM Contact 
                                WHERE MBAAccountID__c IN :stAcctId
                                ORDER BY MBAAccountID__c, LastModifiedDate DESC])
            {
                if (!mpAToC.containsKey(c.MBAAccountID__c))
                    mpAToC.put(c.MBAAccountID__c, c);
            }
            
            // Capture all the lead records
            for (Lead l : [SELECT Id, OwnerId, Owner.Type, rvpe__RVAccount__c
                            FROM Lead
                            WHERE Id IN :stLeadId])
                                //AND OwnerId NOT LIKE '00G%'])  // If you wanted to ensure the lead was not owned by a queue
            {
                mpLeadIDToLead.put(l.Id, l);
            }
            
            // Loop through the subscriptions to create the lead convert object and add to list

            for (Subscription__c sub : lstMBASub)
            {
                // Track each subscription Id so you don't try and update the subscriptions being sent in through an update call later on
                stSubId.add(sub.Id);
                
                lc = new database.Leadconvert();
                lc.setDoNotCreateOpportunity(false);
                lc.setLeadId(sub.Lead__c);
                String oppname = 'MBA Sub :'+ sub.MBASubscriptionID__c;
                lc.setOpportunityName(oppname);
                
                lc.setConvertedStatus(LeadConvertStatus);  
               //   Set the owner, if the lead is owned by queue set it to running user 
                Id newOwnerId = mpLeadIDToLead.get(lc.getLeadId()).OwnerId;
 				If (sub.MBAPartnerID__c <> null && mpLeadIDToLead.get(lc.getLeadId()).rvpe__RVAccount__c == null)
 				{
 					newOwnerId = sub.OwnerId;
 				}
                else if ( newOwnerId == Label.Lead_Default_Owner
                     && sub.Marketing_Test_Group__c == Label.Marketing_Test_Group)
                {
                	newOwnerId = Label.Marketing_Test_Queue;
                }
                else if (mpLeadIDToLead.get(lc.getLeadId()).Owner.Type == 'Queue')
                {
					if (mapqueueowner.containsKey(newOwnerId)) 
					    newOwnerId = mapqueueowner.get(newOwnerId);
					 else
                 	    newOwnerId =Label.Lead_Default_Owner ;
                 }
                 
                 lc.setOwnerId(newOwnerId);
                // Track the Lead Id to subscription
                mpLeadIdToSub.put(sub.Lead__c, sub);
                    
                if (mpAcctByMBAAcctId.containsKey(sub.MBAAccountID__c))
                {
                    lc.setAccountId(mpAcctByMBAAcctId.get(sub.MBAAccountID__c).Id);
                    
                    // Set the account Id on the subscription record
                    sub.Account__c = mpAcctByMBAAcctId.get(sub.MBAAccountID__c).Id;
                }
                
                if (mpAToC.containsKey(sub.MBAAccountID__c))
                {
                    lc.setContactId(mpAToC.get(sub.MBAAccountID__c).Id);
                    
                    // Set the contact Id on the subscription record
                    sub.Contact__c = mpAToC.get(sub.MBAAccountID__c).Id;
                }
                            
                // Check how many lead convert records are created as the governor is set to 100 at a time
                if (lstLeadConvert.size() == 99)
                {
                    lstLCR = database.convertLead(lstLeadConvert, blnAllOrNone);
                    
                    // Loop through the results
                    for (database.Leadconvertresult lcr : lstLCR)
                    {
                        // If the convert was successfuly
                        if (lcr.isSuccess())
                        {
                            // Add the MBA Account Id of the converted lead to the set to update all subscriptions with that MBA Account ID to the new account
                            mpMBAAcctIdTOAccountId.put(mpLeadIdToSub.get(lcr.getLeadId()).MBAAccountID__c, lcr.getAccountId());
                            
                            // Associate the subscription to the new Account and Contact
                            mpLeadIdToSub.get(lcr.getLeadId()).Account__c = lcr.getAccountId();
                            mpLeadIdToSub.get(lcr.getLeadId()).Contact__c = lcr.getContactId();
    
                            // Capture the subscription id to ensure the Account and Contacts are updated for syncing
                            stMBAAccountIds.add(mpLeadIdToSub.get(lcr.getLeadId()).MBAAccountID__c);

							if (mpLeadIdToSub.get(lcr.getLeadId()).Marketing_Test_group__c == Label.Marketing_Test_Group)
							{
								objAcct = new Account(id=lcr.getAccountId()) ;                            
	                        	objAcct.Marketing_Test__c =  Label.Marketing_Test_Group;                                      
								objAcct.OwnerId = Label.Marketing_Test_Queue;
	                        	lstAcctUpdates.add(objAcct);
							}
			            }

                        else
                        {
                            //TODO: error handling
                             system.debug('***Subscription_Utility: LeadConvert Error.....with Error: ' +lcr );
                             ErrorEmailHelper.notifyOnError('Subscription_Utility', 'Subscription_ConvertLead', 'Lead Convert Error', 'Error converting Leads with Error: ' + lcr);
                            
                        }
                    }
                    
                    lstLeadConvert = new list<database.Leadconvert>();
                }
                lstLeadConvert.add(lc);
            }
            
            if (lstLeadConvert.size() > 0)
            {
                system.debug('*** Last Lead Convert Call: ' + lstLeadConvert);
                
                lstLCR = database.convertLead(lstLeadConvert, blnAllOrNone);
                
                // Loop through the results
                for (database.Leadconvertresult lcr : lstLCR)
                {
                    system.debug('*** Lead Convert Results: ' + lcr);
                    
                    // If the convert was successfuly
                    if (lcr.isSuccess())
                    {
                        // Add the MBA Account Id of the converted lead to the set to update all subscriptions with that Account ID to the new account
                        mpMBAAcctIdTOAccountId.put(mpLeadIdToSub.get(lcr.getLeadId()).MBAAccountID__c, lcr.getAccountId());
                        
                        // Associate the subscription to the new Account and Contact
                        mpLeadIdToSub.get(lcr.getLeadId()).Account__c = lcr.getAccountId();
                        mpLeadIdToSub.get(lcr.getLeadId()).Contact__c = lcr.getContactId();
                        
                        // Capture the subscription id to ensure the Account and Contacts are updated for syncing
                        stMBAAccountIds.add(mpLeadIdToSub.get(lcr.getLeadId()).MBAAccountID__c);
               
   						if (mpLeadIdToSub.get(lcr.getLeadId()).Marketing_Test_group__c == Label.Marketing_Test_Group)
							{
								objAcct = new Account(id=lcr.getAccountId()) ;                            
	                        	objAcct.Marketing_Test__c =  Label.Marketing_Test_Group;                                      
								objAcct.OwnerId = Label.Marketing_Test_Queue;
	                        	lstAcctUpdates.add(objAcct);
							}
                    }
                    else
                    {
                        //TODO: error handling
                        system.debug('***Subscription_Utility: LeadConvert Error.....with Error: ' +lcr );
                             ErrorEmailHelper.notifyOnError('Subscription_Utility', 'Subscription_ConvertLead', 'Lead Convert Error', 'Error converting Leads with Error: ' + lcr);
                            
                    }
                }
            }
            
            // Now update all other subscriptions associated to the leads that were just converted to be associated to the correct accounts
            list<Subscription__c> lstSubsToUpdate = new list<Subscription__c>();
            for (Subscription__c sub : [SELECT Account__c, Contact__c, Id, MBAAccountID__c 
                                        FROM Subscription__c
                                        WHERE MBAAccountID__c IN :mpMBAAcctIdTOAccountId.keySet()
                                            AND Id NOT IN :stSubId])
            {
                sub.Account__c = mpMBAAcctIdTOAccountId.get(sub.MBAAccountID__c);
                //sub.Contact__c = mpMBAAcctIdTOContactId.get(sub.MBAAccountID__c);
                lstSubsToUpdate.add(sub);
            }
            
            if (!lstSubsToUpdate.isEmpty())
            {
                database.update(lstSubsToUpdate, blnAllOrNone);
            }       
            
            // If there are any account updates needed
            if (!lstAcctUpdates.isEmpty())
            {
                database.update(lstAcctUpdates, blnAllOrNone);
            }
            
            // If there are any contact updates needed
            if (!lstContactUpdates.isEmpty())
            {
                database.update(lstContactUpdates, blnAllOrNone);
            }
            
            // Now check if any staging accounts need to be updated and then update them so Accounts / Contacts are created / synced
            if (!stMBAAccountIds.isEmpty())
            {
                MarkAccountsAndContactsAsPaid(stMBAAccountIds);
            }
        }
        catch (Exception e)
        {
            ErrorEmailHelper.notifyOnError('Subscription_Utility', 'Subscription_ConvertLead', 'Error in Subscription_ConvertLead', 'Error With Subs: ' + lstMBASub + '; Error Message: ' + e.getMessage());
        }
        
        system.debug('*** Completed Subscription_ConvertLead Method');
    }
    
    private static void MarkAccountsAndContactsAsPaid(set<string> stMBAAccountIDs)
    {
        if (!stMBAAccountIDs.isEmpty())
        {
            list<MBA_Staging_Account__c> lstStagingAcct = new list<MBA_Staging_Account__c>();
            list<MBA_Staging_Contact__c> lstStagingCntct = new list<MBA_Staging_Contact__c>();
            
            for (MBA_Staging_Account__c a : [SELECT Id, IsPaid__c, MBAAccountID__c
                                                FROM MBA_Staging_Account__c 
                                                WHERE MBAAccountID__c IN :stMBAAccountIDs])
            {
                a.IsPaid__c = true;
                lstStagingAcct.add(a);
            }
            
            if (!lstStagingAcct.isEmpty())
                database.update(lstStagingAcct, blnAllOrNone);
            
            for (MBA_Staging_Contact__c c : [SELECT Id, IsPaid__c, MBAAccountID__c
                                                FROM MBA_Staging_Contact__c 
                                                WHERE MBAAccountID__c IN :stMBAAccountIDs])
            {
                c.IsPaid__c = true;
                lstStagingCntct.add(c);
            }
            
            if (!lstStagingCntct.isEmpty())
                database.update(lstStagingCntct, blnAllOrNone);     
        }
    }
 
 // Sync Account and Contacts   
    public static void SyncAccountContacts( Map<String, Account> mpAccountToSync,  Map<String, Contact> mpContactToSync  )
    {
        // Map to hold the Staging Record to the Existing Record
        map<SObject, SObject> mpStagingToExistingAcc = new map<SObject, SObject>();
        // Map to hold the Staging Record to the Existing Contact Record
        map<SObject, SObject> mpStagingToExistingC = new map<SObject, SObject>();
        String soqlWHERE_MBAAcctID = '';
		list<MBA_Staging_Contact__c> lstStagingCntct = new list<MBA_Staging_Contact__c>();
           

     if (!mpAccountToSync.isEmpty())
     {
     	for (String s :mpAccountToSync.KeySet() )
      	{  
     	   // Grab all the MBA Account Ids
            if (s != null && s.trim().length() > 0)
            {
               soqlWHERE_MBAAcctID += (soqlWHERE_MBAAcctID.length() == 0 ? '' : ', ') + '\'' + s + '\'';
              
            }
     	 }
      	  
        string strSOQLA = SObjectUtils.AccountStagingSelect + ' WHERE MBAAccountID__c IN (' + soqlWHERE_MBAAcctID  +' ) ORDER BY MBAAccountID__c';
                
        // Grab all the staging accounts that match the account id
        for (MBA_Staging_Account__c mba : database.query(strSOQLA))     
        
        {
          mpStagingToExistingAcc.put(mba, mpAccountToSync.get(mba.MBAAccountID__C));  
        }
 
     } 
     if (!mpContactToSync.isEmpty())
        {
           
       
       		string strSOQLC = SObjectUtils.ContactStagingSelect + ' WHERE MBAAccountID__c IN (' + soqlWHERE_MBAAcctID  + ') ORDER BY MBAAccountID__c, CreatedDate DESC';
                
            system.debug('**** Contact Staging by MBA Account Id Query: ' + strSOQLC);
                    
             Map <String,Id> mapAcctCont = new Map<String, Id>();
            // Grab all the staging contacts that match the account id
            for (MBA_Staging_Contact__c mba :database.query(strSOQLC))     
       
            {
 				if (!mapAcctCont.containsKey(mba.MBAAccountID__C))
                {
                	mpStagingToExistingC.put(mba, mpContactToSync.get(mba.MBAAccountID__C)); 
                	mapAcctCont.put(mba.MBAAccountID__C, mba.Id);
                }
               else
                {   mba.IsPaid__c = true;
                    lstStagingCntct.add(mba);
                }
            }
            
        }
      database.Dmloptions dml = new database.Dmloptions();
      dml.assignmentRuleHeader.useDefaultRule = false;
      dml.emailHeader.triggerUserEmail = false;
      dml.optAllOrNone = Subscription_Utility.blnAllOrNone;

      if (!mpStagingToExistingAcc.isEmpty())
          {
         	SObjectUtils.SyncObjects('MBA_Staging_Account__c', 'Account', mpStagingToExistingAcc, dml);
          }
      if (!mpStagingToExistingC.isEmpty())
          {
         	SObjectUtils.SyncObjects('MBA_Staging_Contact__c', 'Contact', mpStagingToExistingC, dml);
          }
          
      if (!lstStagingCntct.isEmpty())
                database.update(lstStagingCntct, dml);   
            
    }

	private static  set<string> updateAccounts(List<Subscription__c> lstMBASub, Boolean lastTime)
	{
       system.debug('**** Subscription Staging by MBA Subscription Id Query: ' + lstMBASub);
       
      Account objAcct;
      list<Account> lstAcctUpdates = new list<Account>();
        
      Contact objContact;
      list<Contact> lstContactUpdates = new list<Contact>();
      
      set<string> stMBAAccountIds = new set<string>();  
      
      Id partnerOwnerID;
	  for (Subscription__c sub : lstMBASub)
        {
 
 			if (sub.Account__c == null)
            { 
              // find owner of partner sub  
				 system.debug('**** Subscription Staging' +sub.Marketing_Test_Group__c);
				if (sub.MBAPartnerID__c != null && sub.MBAPartnerID__c.trim().length() > 0)
				{
					if( mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
					{
						partnerOwnerID = mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
					}
					else
					{
						partnerOwnerID = Label.Partner_Default_Owner;
					}
                }
                if (mpAcctByMBAAcctId.containsKey(sub.MBAAccountID__c))
                {
                    sub.Account__c = mpAcctByMBAAcctId.get(sub.MBAAccountID__c).Id;
                    sub.OwnerId = mpAcctByMBAAcctId.get(sub.MBAAccountID__c).OwnerId;
                    // If Contacts already exist for the account
                    if (mpContactByMBAAcctId.get(sub.MBAAccountID__c) != null)
                    {
                        sub.Contact__c = mpContactByMBAAcctId.get(sub.MBAAccountID__c)[0].Id;
                    }
                    
                    // Set the Owner of the Account record if the subscription has a Partner Id
                    if (sub.MBAPartnerID__c != null && sub.MBAPartnerID__c.trim().length() > 0)
                    {
                    	
                        // Set the Owner of the sub
                        sub.OwnerId = partnerOwnerID;
                        sub.Channel_Partner__c = mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                        
                        // Set the owner of the account
                        objAcct = mpAcctByMBAAcctId.get(sub.MBAAccountID__c);
                        objAcct.OwnerId = partnerOwnerID;
                        
                        lstAcctUpdates.add(objAcct);
					}
                    
                   else if (sub.Marketing_Test_Group__c == Label.Marketing_Test_Group)
                	{
                				 
								// Set the Owner of the sub
                        		sub.OwnerId = Label.Marketing_Test_Queue;
                        		
                        		// Set the owner of the account
                        		objAcct = mpAcctByMBAAcctId.get(sub.MBAAccountID__c);
                        		objAcct.OwnerId = Label.Marketing_Test_Queue;
                        		objAcct.Marketing_Test__c = sub.Marketing_Test_Group__c;
								lstAcctUpdates.add(objAcct);
                	}
                    
                }
                // Since current account does not exist check if staging account exists
                else if (mpAcctStagingByMBAAcctId.containsKey(sub.MBAAccountID__c))
                {
                    // Add the MBA Account Id to the set
                    stMBAAccountIds.add(sub.MBAAccountID__c);               
                }
                else
                {
                    if (lastTime)
                    // Raise error about missing staging account
                    	ErrorEmailHelper.notifyOnError('Subscription_Utility', 'Subscription_NeedAccount', 'Error in Subscription_NeedAccount - Missing Staging Account', 'MBA Staging Account Missing For Subscription: ' + sub.MBASubscriptionID__c);
                }   
            }
        }     
            
        if(lasttime)
        {
        // If there are any account updates needed
            if (!lstAcctUpdates.isEmpty())
            {
                database.update(lstAcctUpdates, blnAllOrNone);
            }
               
       
        }
        return stMBAAccountIds;
    }         
}