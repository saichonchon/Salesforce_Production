trigger Subscription_Trigger on Subscription__c (before update, before insert, after update, after insert, after delete) 
{
    // Valid Record Type Id
    Id idSubRecordType =  Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();
    boolean isValidRecordType = false;
    
    system.debug('*** Subscription_Trigger: SubscriptionLogicComplete: ' + SObjectUtils.SubscriptionLogicComplete);
 // add here  to calculate revenue fields - execute always 

 /*   if (trigger.isBefore )
    {               
 //      Subscription_TriggerHandler.UpdateCalcFields(trigger.new, trigger.newmap, trigger.old);
  //      if(trigger.isInsert )
 //        Subscription_TriggerHandler.UpdateMktTest(trigger.New);
 //        Subscription_TriggerHandler.updateStrategicPartner(trigger.New);

    }
*/
    if (trigger.isBefore && !system.isFuture() && SObjectUtils.SubscriptionLogicComplete == false && SObjectUtils.ManualLeadConvert == false)
    {               
        system.debug('*** Subscription_Trigger - Before Starting');
        
        system.debug('*** Before Enter'+SObjectUtils.SubscriptionLogicComplete);
        
        system.debug('*** Subscription_Trigger - RoundRobinisRunning: ' + SObjectUtils.SubscriptionLogicRunning);
        
        SObjectUtils.SubscriptionLogicRunning = true; 
        
        //------------------------------------------------------------------------
        // Set the Start Month and Start Year Month fields for all Subscriptions
        //------------------------------------------------------------------------
        string strMonthName = '';
        string strMonth = '';
        string strMonthYear = '';
        decimal decMonthYear = 0; 
        
        // Set the Start Month and Start Month Year fields
        for (Subscription__c s : trigger.new)
        {
            if (s.StartDate__c != null)
            {
                // Capture the proper month value for the start date
                strMonthName = SObjectUtils.MonthNameFromVal(s.StartDate__c.Month());
                strMonth = string.valueOf(s.StartDate__c.Month());
                strMonthYear = string.valueOf(s.StartDate__c.Year()) + (strMonth.length() == 1 ? '0' : '') + strMonth;
                
                // Set the values
                s.Start_Month__c = strMonthName;
                s.Start_Year_Month__c = strMonthYear;
            }
            else
            {
                s.Start_Month__c = null;
                s.Start_Year_Month__c = null;
            }
        }
        //------------------------------------------------------------------------
        
        // Make sure Round Robin is not updating the lead
        //if (SObjectUtils.RoundRobinisRunning == false)
        //{
            system.debug('*** Subscription_Trigger - Before Working: ' + trigger.new);
            
            string soqlWHERE_SubIDs = '';
            string soqlWHERE_MBAAcctIDs = '';
            string soqlWHERE_IDevPartnerIDs = '';
            string soqlWHERE_Email = '';        
            string soqlWHERE_SBDStoreIDs = '';
            string soqlWHERE_AccountID ='';
            
            // Set to hold MBA Subscription Ids
            set<string> stMBASubId = new set<string>();
            
            // Set to hold MBA Account Ids
            set<string> stMBAAcctId = new set<string>();
            
            // Set to hold MBA Partner Ids
            set<string> stMBAPartnerId = new set<string>();
            
            // Set to hold SBD Store Ids
            set<string> stSBDStoreId = new set<string>();
            
            // Set to hold unique list of Emails
            set<string> stEmail = new set<string>();
            
            // List to hold all new Trial subscriptions
            list<Subscription__c> lstNeedLead = new list<Subscription__c>();
        
            // List to hold all new Paid subscriptions  
            list<Subscription__c> lstNeedAccount = new list<Subscription__c>();
            
            // List to hold all existing Trials moving to Paid
            list<Subscription__c> lstConvertLead = new list<Subscription__c>();
                
            ///////////////////////////////////////////////////////////////////////////
            // First find all MBA Account Ids and MBA Subscription Ids
            ///////////////////////////////////////////////////////////////////////////
            // Loop through all staging records
            for (Subscription__c sub : trigger.new)
            {   
               // Only operate on Subs with the correct record type
                if (sub.RecordTypeId == idSubRecordType)
                {   
                    isValidRecordType = true;
                    // Grab all the MBA Subscription Ids
                    if (sub.MBASubscriptionID__c != null)
                    {
                        if (stMBASubId.add(sub.MBASubscriptionID__c) && sub.MBASubscriptionID__c.trim().length() > 0)
                        {
                            soqlWHERE_SubIDs += (soqlWHERE_SubIDs.length() == 0 ? '' : ', ') + '\'' + sub.MBASubscriptionID__c + '\'';
                        }
                    }
                    
                    // Grab all the MBA Account Ids
                    if (sub.MBAAccountID__c != null)
                    {
                        if (stMBAAcctId.add(sub.MBAAccountID__c) && sub.MBAAccountID__c.trim().length() > 0)
                        {
                            soqlWHERE_MBAAcctIDs += (soqlWHERE_MBAAcctIDs.length() == 0 ? '' : ', ') + '\'' + sub.MBAAccountID__c + '\'';
                        }
                    }
                    
                    // Grab all the MBA Partner Ids
                    if (sub.MBAPartnerID__c != null && sub.MBAPartnerID__c.trim().length() > 0)
                    {
                        if (stMBAPartnerId.add(sub.MBAPartnerID__c))
                        {
                            soqlWHERE_IDevPartnerIDs += (soqlWHERE_IDevPartnerIDs.length() == 0 ? '' : ', ')  + sub.MBAPartnerID__c;
                        }
                    }
                     // Grab all the SBD Store Ids
                    if (sub.SBD_Store_ID__c != null && sub.SBD_Store_ID__c.trim().length() > 0)
                    {
                        if (stSBDStoreId.add(sub.SBD_Store_ID__c))
                        {
                            soqlWHERE_SBDStoreIDs += (soqlWHERE_SBDStoreIDs.length()  == 0 ? '' : ', ') + '\'' + sub.SBD_Store_ID__c + '\'';
                        }
                    }   
                }  
            }

            if (isValidRecordType)
            {  
                // Load maps that are needed
                try
                {       
                    Subscription_Utility.LoadLeadByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                    Subscription_Utility.LoadAcctByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                    Subscription_Utility.LoadAcctStagingByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                    Subscription_Utility.LoadContactStagingByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                    Subscription_Utility.LoadAcctByIDevPartnerIdMap(soqlWHERE_IDevPartnerIDs);  
                    
                    // Loop through the staging contacts received for each subscription and capture the unique set of emails
                    for (list<MBA_Staging_Contact__c> lst : Subscription_Utility.mpContactStagingByMBAAcctId.values())
                    {
                        for (MBA_Staging_Contact__c c : lst)
                        {               
                            system.debug('*** IN SUB LOOP... ' + c.Email__c);
                            if (stEmail.add(c.Email__c))
                            {
                                soqlWHERE_Email += (soqlWHERE_Email.length() == 0 ? '' : ', ') + '\'' + String.escapeSingleQuotes(c.Email__c) + '\'';
                            }
                        }
                    }
                    system.debug('*** IN SUB LOOP.email query.. ' + soqlWHERE_Email);
                    Subscription_Utility.LoadLeadByEmailMap(soqlWHERE_Email);
                    Subscription_Utility.LoadLeadByStoreId(soqlWHERE_SBDStoreIDs);  
                    system.debug('*** IN SUB LOOP..store id. ' + soqlWHERE_SBDStoreIDs);
// Maggie uncommenting the below - 7/16/14
                    Subscription_Utility.LoadContactByEmailMap(soqlWHERE_Email);
                    system.debug('User12 LoadContactByEmailMap'+Subscription_Utility.mpContactByEmail);
 
                }
                catch (Exception e)
                {   
                    ErrorEmailHelper.notifyOnError('Subscription_Trigger', 'Load Subscription Maps', 'Error in Subscription_Trigger Loading Maps', e.getMessage());         
                }
                ///////////////////////////////////////////////////////////////////////////
                
                boolean blnFoundAcct = false;
                boolean blnFoundLead = false;
                Lead objLead;
                list<Lead> lstLeadsToUpdate = new list<Lead>();
/*
Modified By:-Laxmikant Kurmi.
Modified Date:- 17/07/2014.
  */          
                list<Account> lstAccountToUpdate = new List<Account>();
                list<Contact> lstContactToUpdate = new List<Contact>();
   
                Map<String, Account> mpstAccAccountToUpdate = new Map<String, Account>();
                Map<String, Contact> mpstAccContactToUpdate = new Map<String, Contact>();
 //               Map<Id, Id> mapAcctSubIds  = new Map <ID, ID>();
                
                ///////////////////////////////////////////////////////////////////////////
                // Categorize all Staging records into 1 of 3 categories:
                //  1. Need Lead
                //  2. Need Account
                //  3. Existing Trial to Paid (Need to convert Lead)
                ///////////////////////////////////////////////////////////////////////////
                // Find all the subscriptions being inserted/updated
                for (Subscription__c sub : trigger.new)
                {       
                    // Only operate on Subs with the correct record type
                    if (sub.RecordTypeId == idSubRecordType)
                    {
                        blnFoundAcct = false;
                        blnFoundLead = false;
                        
                        system.debug('*** IN SUB LOOP... ' + sub);
                        // Check that sub is not already associated to an account
                        if (sub.Account__c == null)
                        {  
                            // Check if sub is not already associated to a Lead
                            if (sub.Lead__c == null)
                            {  
                                // Check if the sub is associated to an existing account via MBA Account ID
                                if (Subscription_Utility.mpAcctByMBAAcctId.containsKey(sub.MBAAccountID__c))
                                {
                                    blnFoundAcct = true;
                                    
                                    // Associate the subscription to the found account and set the owner of the subscription to the owner of the existing account
                                    sub.Account__c = Subscription_Utility.mpAcctByMBAAcctId.get(sub.MBAAccountID__c).Id;
                                    sub.OwnerId = Subscription_Utility.mpAcctByMBAAcctId.get(sub.MBAAccountID__c).OwnerId;
                                    // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                                    if (sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                                    {
                                        sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
                                        sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                                    }
                                    if (sub.Marketing_Test_Group__c == Label.Marketing_Test_Group
                                        && sub.OwnerId == Label.Account_Default_Owner
                                        ) 
                                    {
                                           sub.OwnerId = Label.Marketing_Test_Queue;
                                           Account obj =  Subscription_Utility.mpAcctByMBAAcctId.get(sub.MBAAccountID__c);
                                           obj.OwnerId = Label.Marketing_Test_Queue;
                                           obj.Marketing_Test__c = Label.Marketing_Test_Group;
                                           lstAccountToUpdate.add(obj); 
                                    }
                                }
                                // Check if the sub is associated to an existing lead
                                else if (Subscription_Utility.mpLeadByMBAAcctId.containsKey(sub.MBAAccountID__c))
                                {
                                    blnFoundLead = true;
                                    
                                    // Associate the subscription to the found lead and set the owner of the subscription to the owner of the existing lead
                                    sub.Lead__c = Subscription_Utility.mpLeadByMBAAcctId.get(sub.MBAAccountID__c).Id;
                                    sub.OwnerId = Subscription_Utility.mpLeadByMBAAcctId.get(sub.MBAAccountID__c).OwnerId;
                                    if (sub.Marketing_Test_Group__c == Label.Marketing_Test_Group
                                        && sub.OwnerId == Label.Account_Default_Owner
                                        ) 
                                           sub.OwnerId = Label.Marketing_Test_Queue;
                                    // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                                    if (sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                                    {
                                        sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
                                        sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                                    }
                                    
                                    // Sub has a Lead so needs to be converted to Account
                                        lstConvertLead.add(sub);
                                    
                                }
                                // Orion - check by Store Id
                                if (!blnFoundAcct && !blnFoundLead)
                                { 
                                // Check if the sub is associated to an existing SBD Store Id
                                     if (sub.SBD_Store_ID__c <> null && Subscription_Utility.mpLeadByStoreId.containsKey(sub.SBD_Store_ID__c))
                                            {
                                               // Grab the lead record
                                                objLead = Subscription_Utility.mpLeadByStoreId.get(sub.SBD_Store_ID__c);
                                                
                                                // Ensure the matching lead does NOT already contain an MBA Account ID
                                                if (objLead.MBAAccountID__c == null || objLead.MBAAccountID__c.trim().length() == 0)
                                                {           
                                                    blnFoundLead = true;
                                                
                                                    // If a match to an existing lead occurs, set the lead and owner of the sub to the owner of the lead
                                                    sub.Lead__c = objLead.Id;
                                                    sub.OwnerId = objLead.OwnerId;
                                                    
                                                    // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                                                    if (sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                                                    {
                                                        sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
                                                        sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                                                    }
                                                    
                                                    // Sub has a Lead so needs to be converted to Account
                                                        //sub.Lead__c = null;
                                                        lstConvertLead.add(sub);
                                                    
            
                                                    // Update the lead to contain the MBA Account ID of the subscription as well as the client id
                                                    objLead.MBAAccountID__c = sub.MBAAccountID__c;
                                                    objLead.MBAClientID__c  = sub.MBAClientID__c;
                                                    objLead.SupportPin__c = Subscription_Utility.mpAcctStagingByMBAAcctId.get(sub.MBAAccountID__c).SupportPin__c;
                                                    lstLeadsToUpdate.add(objLead);
                                                    
                                                    break;
                                                }  
                                            }
                                }
                                // Orion end
                                // If no account or lead has been found yet, start checking by email address of the staging contacts associated
                                if (!blnFoundAcct && !blnFoundLead)
                                {   system.debug('User12 no account and no lead found and enter in this');
                                    // If a list of staging contacts exist for this subscription
                                    if (Subscription_Utility.mpContactStagingByMBAAcctId.containsKey(sub.MBAAccountID__c))
                                    {   
                                        // Loop through the staging contact records associated to the same MBA Account Id as the subscription
 
                                        for (MBA_Staging_Contact__c c : Subscription_Utility.mpContactStagingByMBAAcctId.get(sub.MBAAccountID__c))
                                        {
               
                                            system.debug('*** IN SUB LOOP email... ' +c.Email__c);
                                            // Check for lead matches by Email                      
                                            if (Subscription_Utility.mpLeadByEmail.size()>0  && Subscription_Utility.mpLeadByEmail.containsKey(c.Email__c))
                                            {
                                                // Grab the lead record
                                                objLead = Subscription_Utility.mpLeadByEmail.get(c.Email__c);
                                                
                                                // Ensure the matching lead does NOT already contain an MBA Account ID
                                                if (objLead.MBAAccountID__c == null || objLead.MBAAccountID__c.trim().length() == 0)
                                                {           
                                                    blnFoundLead = true;
                                                
                                                    // If a match to an existing lead occurs, set the lead and owner of the sub to the owner of the lead
                                                    sub.Lead__c = objLead.Id;
                                                    sub.OwnerId = objLead.OwnerId;
                                                    
                                                    // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                                                    if (sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                                                    {
                                                        sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
                                                        sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                                                    }
                                                    
                                                    // Sub has a Lead so needs to be converted to Account
 //                                                       sub.Lead__c = null;
                                                        lstConvertLead.add(sub);
                                                                                                    
                                                    // Update the lead to contain the MBA Account ID of the subscription as well as the client id
                                                    objLead.MBAAccountID__c = sub.MBAAccountID__c;
                                                    objLead.MBAClientID__c = c.MBAClientID__c;
                                                    objLead.MBA_Partner_ID__c = sub.MBAPartnerID__c;
                                                    //need to add support pin from staging account
                                                    if (objLead.Phone == null) {objLead.Phone = c.Phone__c;}
                                                    objLead.SupportPin__c = Subscription_Utility.mpAcctStagingByMBAAcctId.get(sub.MBAAccountID__c).SupportPin__c;
                                                    lstLeadsToUpdate.add(objLead);
                                                       
                                                    break;
                                                }
                                            }
                                            // Maggie uncommenting the below - 7/16/14
                                            //// Check to see if an existing contact matches by email
                                            if (c.Email__c <> null && Subscription_Utility.mpContactByEmail.containsKey(c.Email__c)
                                               ) 
                                               
                                            {
                                            //  // If a match to an account occurs, set the account from the contact and immediately break out of the loop and look no further
                                                Contact objcon = new Contact();
                                                objcon=Subscription_Utility.mpContactByEmail.get(c.Email__c); 
 
                                                if ( (objcon.MBAAccountID__c == null || (objcon.MBAAccountID__c <> null && objcon.MBAAccountID__c== c.MBAAccountID__c ))
                                                    && (objcon.Account.MBAAccountID__c == null || (objcon.Account.MBAAccountID__c <> null && objcon.Account.MBAAccountID__c== c.MBAAccountID__c ))
                                                )
                                                {
                                            //  // If a match to an account occurs, set the account from the contact and immediately break out of the loop and look no further
                                                    
                                                    blnFoundAcct = true;
/*  
Modified By:- Laxmikant Kurmi.
Modified Date:-07/17/07/2014.
*/ 
                                                  system.debug('Contact to Update' );   
                                                  
                                                  objcon.MBAAccountID__c=sub.MBAAccountID__c;
                                                  objcon.MBAClientID__c=c.MBAClientID__c;
                                                  lstContactToUpdate.add(objcon);
                                                  mpstAccContactToUpdate.put(objcon.MBAAccountID__c, objcon);
                                                  sub.Account__c = objCon.AccountId;
                                                  sub.Lead__c = null;
                                                  sub.Contact__c = objCon.Id;
                                                  sub.OwnerId = objCon.Account.OwnerId;
                                                  // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                                                  if (sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                                                    {
                                                        sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
                                                        sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                                                    }
                                                  system.debug('Account to Update' + sub.Account__c); 
                                                  // Creating Account Instance To Update The Account.
                                                  Account obj= new Account(ID=objCon.AccountId);
                                                  obj.MBAAccountID__c=sub.MBAAccountID__c;
                                                  lstAccountToUpdate.add(obj);
                                                  mpstAccAccountToUpdate.put(obj.MBAAccountID__c, obj);
     //                                           mapAcctSubIds.put(obj.Id, sub.MBASubscriptionID__c);
                                             
/* Modification Ends Here.*/  
                                                    break;
                                                }   
                                            }
                                            
                                 
                                        }
                                    }
                                }
               
                                system.debug('*** Found Account Value: ' + blnFoundAcct);
                                system.debug('*** Found Lead Value: ' + blnFoundLead);
                                
                                // If no account or lead has been found yet figure out what it needs
                                if (!blnFoundAcct && !blnFoundLead)
                                {
                                    system.debug('*** No Existing Lead or Account');
                                     // Sub needs an Account
                                        lstNeedAccount.add(sub);
                                    
                                }
                            }
                            else
                            {
                                // Sub has a Lead so see if it needs to be converted to Account
                                
                                    system.debug('*** Added to Convert Lead');
                                    lstConvertLead.add(sub);
                               
                                
                            }
                        }
                    }
                }
                
                // Check if any leads need to be updated
                if (!lstLeadsToUpdate.isEmpty())
                {
                    database.update(lstLeadsToUpdate, Subscription_Utility.blnAllOrNone);
                }
/*
Modification By:-Laxmikant Kurmi.
Modification Date:-07/17/2014.
 */              
                // Check if any Account need to be updated.
                if(!lstAccountToUpdate.isEmpty())
                {
                    update lstAccountToUpdate;
                }
                
                // Check if any Contact need to be Updated.
                if(!lstContactToUpdate.isEmpty())
                {
                    update lstContactToUpdate;
                }
               
                if (!mpstAccAccountToUpdate.isEmpty() && !mpstAccContactToUpdate.isEmpty())
                    Subscription_Utility.SyncAccountContacts(mpstAccAccountToUpdate, mpstAccContactToUpdate);
/* Modification Ends Here */
                
                system.debug('*** Here is the Need Lead List: ' + lstNeedLead);
                system.debug('*** Here is the Need Account List: ' + lstNeedAccount);
                system.debug('*** Here is the Convert List: ' + lstConvertLead);
                
                // Call the Utility class to do the necessary business logic
                Subscription_Utility.HandleStagingSubscriptions(lstNeedLead, lstNeedAccount, lstConvertLead, soqlWHERE_MBAAcctIDs, soqlWHERE_SubIDs, soqlWHERE_IDevPartnerIDs);
                
                system.debug('*** Completed Subscription Handling: ' + trigger.new);
                
 //               if (trigger.isInsert)
                {
                    for (Subscription__c s : lstConvertLead)
                    {
                        s.Lead__c = null;
                    }
                }
                
                // Ensure a contact is entered on the subscription if one is available
                if (trigger.isInsert || trigger.isUpdate)
                {
                    Subscription_Utility.LoadContactByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
                    
                    for (Subscription__c sub : trigger.new)
                    {
                        if (trigger.isInsert && sub.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(sub.MBAPartnerID__c))
                            {
                                sub.OwnerId = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).OwnerId;
 //                               sub.Channel_Partner__c = Subscription_Utility.mpAcctByIDevPartnerId.get(sub.MBAPartnerID__c).Id;
                            }
                        if (sub.Contact__c == null && Subscription_Utility.mpContactByMBAAcctId.containsKey(sub.MBAAccountID__c))
                        {
                            sub.Contact__c = Subscription_Utility.mpContactByMBAAcctId.get(sub.MBAAccountID__c)[0].Id;
                        }
                        
                        if ( trigger.isUpdate && 
                             (sub.MBAAccountID__c != trigger.OldMap.get(sub.Id).MBAAccountID__c)
                             || sub.Account_Mismatch__c )
                        {
                                if (Subscription_Utility.mpAcctByMBAAcctId <> null && Subscription_Utility.mpAcctByMBAAcctId.containsKey(sub.MBAAccountID__c))
                                  {
                                   // Associate the opportunity to the found account and set the owner?
                                    sub.Account__c = Subscription_Utility.mpAcctByMBAAcctId.get(sub.MBAAccountID__c).Id;
                                  
                                      if (Subscription_Utility.mpContactByMBAAcctId.containsKey(sub.MBAAccountID__c))
                                        {
                                            sub.Contact__c = Subscription_Utility.mpContactByMBAAcctId.get(sub.MBAAccountID__c)[0].Id;
                                        }
                                  }
                        }
                    }
                }
            }
                ///////////////////////////////////////////////////////////////////////////
        //}
            
     system.debug('*** Before Exit'+SObjectUtils.SubscriptionLogicComplete);   
 
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // Any After events fire here
    ///////////////////////////////////////////////////////////////////////////
 
    if (trigger.isAfter && !system.isFuture() && !system.isBatch() && SObjectUtils.SubscriptionLogicComplete == false)
    {
/*          system.debug('*** Beginning Subscription After Trigger');  
        if (!trigger.isDelete)
        {
// after insert or after update crete migraion cases for Orion
            List<Subscription__c> subList2 = new List<Subscription__c>();
            for(Subscription__c updateRecord : trigger.new)
            {        
        
                system.debug(' ***** test '+updateRecord.Requested_Migration__c);
                if( updateRecord.Requested_Migration__c <> null 
                    && updateRecord.Requested_Migration__c <> ''
                    && (trigger.isInsert
                        || updateRecord.Requested_Migration__c != trigger.OldMap.get(updateRecord.Id).Requested_Migration__c)
                   )
                {               
                    subList2.add(updaterecord);  
                }       
            } 
            
            if (subList2.size() >0) Subscription_TriggerHandler.insertCases(subList2); 
        }   
// Orion migration cases end

        SObjectUtils.SubscriptionLogicRunning = true;
            
        // Make sure Round Robin is not updating the lead
        if (!system.isFuture()) //SObjectUtils.RoundRobinisRunning == false)
        {
            // Map to hold all the fields in the Subscription object for reference to the field labels
            Map<String, Schema.SObjectField> mpFields = Schema.SObjectType.Subscription__c.fields.getMap();
                        
            /////////////////////////////////////////////////////////////////////////// 
            // Run the history tracking for all updates on the after trigger
            ///////////////////////////////////////////////////////////////////////////
         if (trigger.isUpdate)
            {
                try
                {                   
                    set<string> stFields = new set<string>();
                    
                    // Grab the map of fields to check for changes
                    for (History_Tracking__c s : History_Tracking__c.getall().values())
                    {
                        // Pull all Subscription fields
                        if (s.Active__c && s.Object_Name_API__c == 'Subscription__c')
                        {
                            stFields.add(s.Field_Name_API__c);              
                        }
                    }
                    
                    list<Subscription_History__c> lstHist = new list<Subscription_History__c>();
                    Subscription_History__c objHist;
                    
                    // Loop through the records in the trigger and see if any of the fields to track for history have changed
                    for (Subscription__c sub : trigger.new)
                    {
                        for (string s : stFields)
                        {
                            try
                            {
                                if (sub.get(s) != trigger.oldMap.get(sub.Id).get(s))
                                {
                                    objHist = new Subscription_History__c();
                                    objHist.Subscription__c = sub.Id;
                                    objHist.Field_Name__c = mpFields.get(s).getDescribe().getLabel();
                                    objHist.Old_Value__c = string.valueOf(trigger.oldMap.get(sub.Id).get(s));
                                    objHist.New_Value__c = string.valueOf(sub.get(s));
                                    
                                    lstHist.add(objHist);
                                }
                            }
                            catch(Exception e)
                            {
                                system.debug('***Error -- Subscription_Trigger - History Tracking: ' + e.getMessage());
                                ErrorEmailHelper.notifyOnError('Subscription_Trigger', 'Subscription History', 'Error in Subscription_Trigger For Subscription History Capture', e.getMessage());
                            }
                        }
                    }
                    
                    // If there are history records to save
                    if (!lstHist.isEmpty())
                    {
                        database.insert(lstHist, Subscription_Utility.blnAllOrNone);
                    }
                }
                catch (Exception e)
                {
                    system.debug('***Error -- Subscription_Trigger - History Tracking: ' + e.getMessage());
                    ErrorEmailHelper.notifyOnError('Subscription_Trigger', 'Subscription History', 'Error in Subscription_Trigger For Subscription History Capture', e.getMessage());
                }
            }       
  */          
            ///////////////////////////////////////////////////////////////////////////
            // Code to handle the Roll-Up logic
            ///////////////////////////////////////////////////////////////////////////         
  /*
            system.debug('*** In RollUp Trigger Code - Subscription');

            list<Subscription__c> subForAcctList = new list<Subscription__c>();
            list<Subscription__c> oldSubForAcctList = new list<Subscription__c>();
            list<Subscription__c> subForLeadList = new list<Subscription__c>();
            list<Subscription__c> oldSubForLeadList = new list<Subscription__c>();
            
            list<Subscription__c> lstSubs = new list<Subscription__c>();
            
            set<Id> stLeadIds = new set<Id>();
            set<string> stFields_Lead = new set<string>();
            set<string> stFields_Account = new set<string>();
            
            // Grab the map of fields from the Rollup Custom Setting to check for changes within each sub
            for (RollupConfigs__c r : RollupConfigs__c.getall().values())
            {
                // Pull all Subscription fields
                if (r.Parent_Object__c == 'Account' && r.Child_Object_Name__c == 'Subscription__c')
                {
                    if (r.queryField1__c != null && r.queryField1__c <> '')
                    {                       
                        stFields_Account.add(r.queryField1__c);
                    }
                    if (r.queryField2__c != null && r.queryField2__c <> '')
                    {
                        stFields_Account.add(r.queryField2__c);
                    }
                    if (r.queryField3__c != null && r.queryField3__c <> '')
                    {
                        stFields_Account.add(r.queryField3__c);
                    }
                    if (r.queryField4__c != null && r.queryField4__c <> '')
                    {
                        stFields_Account.add(r.queryField4__c);
                    }
                    if (r.queryField5__c != null && r.queryField5__c <> '')
                    {
                        stFields_Account.add(r.queryField5__c);
                    }
                    if (r.queryField6__c != null && r.queryField6__c <> '')
                    {
                        stFields_Account.add(r.queryField6__c);
                    } 
                    if (r.queryField_parentRelationshipName__c != null && r.queryField_parentRelationshipName__c <> '')
                    {
                        stFields_Account.add(r.queryField_parentRelationshipName__c);
                    } 
                }
                else if (r.Parent_Object__c == 'Lead' && r.Child_Object_Name__c == 'Subscription__c')
                {
                    if (r.queryField1__c != null && r.queryField1__c <> '')
                    {                       
                        stFields_Lead.add(r.queryField1__c);
                    }
                    if (r.queryField2__c != null && r.queryField2__c <> '')
                    {
                        stFields_Lead.add(r.queryField2__c);
                    }
                    if (r.queryField3__c != null && r.queryField3__c <> '')
                    {
                        stFields_Lead.add(r.queryField3__c);
                    }
                    if (r.queryField4__c != null && r.queryField4__c <> '')
                    {
                        stFields_Lead.add(r.queryField4__c);
                    }
                    if (r.queryField5__c != null && r.queryField5__c <> '')
                    {
                        stFields_Lead.add(r.queryField5__c);
                    }
                    if (r.queryField6__c != null && r.queryField6__c <> '')
                    {
                        stFields_Lead.add(r.queryField6__c);
                    }
                    if (r.queryField_parentRelationshipName__c != null && r.queryField_parentRelationshipName__c <> '')
                    {
                        stFields_Lead.add(r.queryField_parentRelationshipName__c);
                    } 
                }
            }
            
            if (trigger.isDelete)
            {
                lstSubs = trigger.old;
            }
            else
            {
                lstSubs = trigger.new;
            }
            
            boolean blnAddSubToAcctRollup = true;
            boolean blnAddSubToLeadRollup = true;
             
            if (trigger.isInsert)   system.debug('**** Insert');            
            for (Subscription__c sub : lstSubs)
            {               
                if (trigger.isUpdate)
                {
                    blnAddSubToAcctRollup = false;
                    blnAddSubToLeadRollup = false;
                    
                    // Check if any of the roll-up values have changed on the Subscription for Account Rollup
                    if (sub.Account__c != null)
                    {
                        for (string s : stFields_Account)
                        {
                            try
                            {
                                if (sub.get(s) != trigger.oldMap.get(sub.Id).get(s))
                                {
                                    blnAddSubToAcctRollup = true;
                                    break;
                                }
                            }
                            catch(Exception e)
                            {
                                system.debug('***Error -- Subscription_Trigger - Subscription Rollup - Invalid Field in Custom Setting: ' + e.getMessage());
                                ErrorEmailHelper.notifyOnError('Subscription_Trigger', 'Subscription Rollup', 'Error in Subscription_Trigger For Subscription Rollup - Invalid Field', e.getMessage());
                            }
                        }
                    }
                    else if (sub.Lead__c != null)
                    {
                        for (string s : stFields_Lead)
                        {
                            try
                            {
                                system.debug('*** '+sub.get(s));
                                system.debug('***  '+trigger.oldMap.get(sub.Id).get(s));
                                if (sub.get(s) != trigger.oldMap.get(sub.Id).get(s))
                                {
                                    blnAddSubToLeadRollup = true;
                                    break;
                                }
                            }
                            catch(Exception e)
                            {
                                system.debug('***Error -- Subscription_Trigger - Subscription Rollup - Invalid Field in Custom Setting: ' + e.getMessage());
                                ErrorEmailHelper.notifyOnError('Subscription_Trigger', 'Subscription Rollup', 'Error in Subscription_Trigger For Subscription Rollup - Invalid Field', e.getMessage());
                            }
                        }
                   }
                }
                
                if (sub.Account__c != null && blnAddSubToAcctRollup)
                {               
                    subForAcctList.add(sub);
                    if (trigger.isUpdate) 
                    {
                        oldSubForAcctList.add(trigger.oldMap.get(sub.Id));
                    }
                } 
                else if (sub.Lead__c != null)
                {                   
                    stLeadIds.add(sub.Lead__c);
                    
                    if (blnAddSubToLeadRollup)
                    {
                        subForLeadList.add(sub);
                        if (trigger.isUpdate)
                        { 
                            oldSubForLeadList.add(trigger.oldMap.get(sub.Id));
                        }
                    }
                }
            }
               
            if (!subForAcctList.isEmpty() && !SObjectUtils.lookUpRollUpIsRunning)
            {               
                system.debug('*** In RollUp Trigger Code - Subscription to Account Rollup');

                SObjectUtils.lookUpRollUpIsRunning = true;
                            
                //Pass in the name of the child record, in this case 'Subscription__c' and the name of the parent record, in this case 'Account';   
                LookupRollupHelper lh_Acct = new LookupRollupHelper('Subscription__c', 'Account');
                
                if(trigger.isUpdate) 
                {
                    lh_Acct.rollupSummary((list<sObject>)subForAcctList, (list<sObject>)oldSubForAcctList);   
                } 
                else 
                {
                    lh_Acct.rollupSummary((list<sObject>)subForAcctList, null);
                }
                
                SObjectUtils.lookUpRollUpIsRunning = false;
            }
            
            if (!subForLeadList.isEmpty() && !SObjectUtils.lookUpRollUpIsRunning)
            {
                system.debug('*** In RollUp Trigger Code - Subscription to Lead Rollup');

                SObjectUtils.lookUpRollUpIsRunning = true;
                
                //Pass in the name of the child record, in this case 'Subscription__c' and the name of the parent record, in this case 'Lead';
                LookupRollupHelper lh_Lead = new LookupRollupHelper('Subscription__c', 'Lead');
                
                if(trigger.isUpdate) 
                {
                    lh_Lead.rollupSummary((list<sObject>)subForLeadList, (list<sObject>)oldSubForLeadList);   
                } 
                else 
                {
                    lh_Lead.rollupSummary((list<sObject>)subForLeadList, null);
                }
                
                SObjectUtils.lookUpRollUpIsRunning = false;
            }
 //          
            if (!stLeadIds.isEmpty() && !SObjectUtils.lookUpRollUpIsRunning)
            {
                system.debug('*** In RollUp Trigger Code - Subscription Most Recent Being Called');

                SObjectUtils.lookUpRollUpIsRunning = true;
                
                Subscription_Utility.LeadMostRecentSubscription(stLeadIds);
                
                SObjectUtils.lookUpRollUpIsRunning = false;
            }
  //
        }
  */      
        //Handle max subscription rollups to the accounts
        Set<String> accountIds = new Set<String>();
        if (!trigger.isDelete) {
            for (Subscription__c s : trigger.new) {
                if (!String.isBlank(s.Account__c)) {
                    accountIds.add(s.Account__c);
                }
            }
        } else {
            for (Subscription__c s: trigger.old) {
                if (!String.isBlank(s.Account__c)) {
                    accountIds.add(s.Account__c);
                }
            }
        }
        if (accountIds.size()>0) {
            AccountMaxSubRollup.rollUp(accountIds);
        }
 /*       
    if(trigger.isInsert ){ 
                    
        Subscription_TriggerHandler.insertTotango(trigger.new);  
        
        System.debug('Calling class when record is created, possible totango record creation');      
    }
    

            
      if(trigger.isUpdate)
      {
      if(!Subscription_TriggerHandler.ALREADY_RAN)
        { 
           
            List<Subscription__c> subList = new List<Subscription__c>();
            for(Subscription__c updateRecord : trigger.new){        
            
                if(updateRecord.Status__c != trigger.OldMap.get(updateRecord.Id).Status__c || updateRecord.Product__c != trigger.OldMap.get(updateRecord.Id).Product__c){               
                    
                    
                    System.debug('Calling class when record is updated, possible totango record creation');         
                }       
            } 
//            Subscription_TriggerHandler.ALREADY_RAN = true;    
            Subscription_TriggerHandler.insertTotango(subList);   
       } 

       
            Subscription_TriggerHandler.ALREADY_RAN = true;             
      }
  */    
     SObjectUtils.SubscriptionLogicComplete = true;
        system.debug('*** Completed Subscription After Update Trigger');
    }
}