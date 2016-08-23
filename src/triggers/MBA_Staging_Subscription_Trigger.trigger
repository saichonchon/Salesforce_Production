trigger MBA_Staging_Subscription_Trigger on MBA_Staging_Subscription__c (before insert, after insert, before update, after update) 
{

    /*Modified By:-Laxmikant Kurmi.
    Modified Date:-05/08/2014.
    */
    if(Trigger.isBefore )
    {
        for(MBA_Staging_Subscription__c obj:trigger.new)
        {
// if purchased
            if(!obj.IsTrial__c )
            {
// coming in as purchase
				if (Trigger.isInsert) obj.Direct_Purchase__c=true;
// 2/17/16 change no purchase date
				if (obj.PurchaseDate__c == null && (Trigger.isInsert ||  trigger.oldMap.get(obj.Id).PurchaseDate__c == null))
				    obj.PurchaseDate__c = System.date.Today();
// has purcahse date but overriding existing one and api user is updating				
				if (Trigger.isUpdate 
					&& obj.PurchaseDate__c <> null && trigger.oldMap.get(obj.Id).PurchaseDate__c <> null  &&  obj.PurchaseDate__c != trigger.oldMap.get(obj.Id).PurchaseDate__c 
					&& UserInfo.getProfileId()==Label.API_User_Profile
					)
				{
				    system.debug(' prev date '+trigger.oldMap.get(obj.Id).PurchaseDate__c);
				    obj.PurchaseDate__c = trigger.oldMap.get(obj.Id).PurchaseDate__c;
				}
            }
            
            
        }
    }
    /* Modification Ends Here */

    else if (Trigger.isAfter) 
    {

   string soqlWHERE_SubIDs = '';
        
    // Set to hold MBA Subscription Ids
    set<string> stMBASubId = new set<string>();
    
    // Set to hold MBA Account Ids
    set<string> stMBAAccountId = new set<string>();
        
    // Map to hold existing Subscription Records by MBA Subscription Id
    map<string, Subscription__c> mpSub = new map<string, Subscription__c>();
    
    // Map to hold the Staging Record to the Existing Record
    map<SObject, SObject> mpStagingToExisting = new map<SObject, SObject>();
        
    ///////////////////////////////////////////////////////////////////////////
    // First try and match to existing Subscriptions
    ///////////////////////////////////////////////////////////////////////////
    // Loop through all staging records
    for (MBA_Staging_Subscription__c mba : trigger.new)
    {
        // Grab all the MBA Subscription Ids
        if (mba.MBASubscriptionID__c != null)
        {
            if (stMBASubId.add(mba.MBASubscriptionID__c))
            {
                soqlWHERE_SubIDs += (soqlWHERE_SubIDs.length() == 0 ? '' : ', ') + '\'' + mba.MBASubscriptionID__c + '\'';
            }
        }
    }
    
    // Build the SOQL to query for existing Subscriptions using the custom setting to retrieve all needed fields    
    string soql_Sub = SObjectUtils.SubscriptionSelect + ' WHERE MBASubscriptionID__c IN (' + soqlWHERE_SubIDs + ')';
    system.debug('**** Subscription Query: ' + soql_Sub);
        
    // Grab all the subscriptions that match the subscription id
    for (Subscription__c s : database.query(soql_Sub))
    {
        mpSub.put(s.MBASubscriptionID__c, s);
    }
    ///////////////////////////////////////////////////////////////////////////
    

    ///////////////////////////////////////////////////////////////////////////
    // Build map for Syncing
    ///////////////////////////////////////////////////////////////////////////
    Subscription__c sub;
    
    // Find all the subscriptions being inserted/updated
    for (MBA_Staging_Subscription__c mba : trigger.new)
    {
        // Check if a Subscription record exists already
        if (mpSub.containsKey(mba.MBASubscriptionID__c))
        {
            sub = mpSub.get(mba.MBASubscriptionID__c);
            
            // Add to the map of the staging record to the existing subscription
            mpStagingToExisting.put(mba, sub);
            
            // Check if the existing subscription is not already associated to an Account and if it is for a Paid Sub
            if (sub.Account__c == null && mba.IsTrial__c == false)
            {
                stMBAAccountId.add(mba.MBAAccountID__c);
            }
        }
        // Subscription does not already exist so it is a new record
        else
        {
            // Create a new Subscription record
            sub = new Subscription__c();
            
            // Add to the map of the staging record to the existing subscription
            mpStagingToExisting.put(mba, sub);
            
            // Check if the staging subscription is for a Paid Sub
            if (mba.IsTrial__c == false)
            {
                stMBAAccountId.add(mba.MBAAccountID__c);
            }
        }
    }
        
    // Call the Utility class to do the syncing
    database.Dmloptions dml = new database.Dmloptions();
    dml.assignmentRuleHeader.useDefaultRule = false;
    dml.emailHeader.triggerUserEmail = false;
    dml.optAllOrNone = Subscription_Utility.blnAllOrNone;
    
    SObjectUtils.SyncObjects('MBA_Staging_Subscription__c', 'Subscription__c', mpStagingToExisting, dml);
    
    system.debug('*** Completed Subscription Staging Handling: ' + trigger.new);

/* /////////////////////////////////////////////////////////////////////////////////////////////////
        
    Maggie Change for Opportunity
    ///////////////////////////////////////////////////////////////////////////////////////////////   
 */
     
    // List to collect All mba Account Id.
    List<String> mbaaccId = new List<String>();
            
    // List to collect all MBASubscriptionID.
    Set<String> MBASubID =new Set<String>();
    
    // Map to collect MBA Account Id as a key and Account as a Value.
     Map<String, Account> mpmbaIdAcc = new Map<String, Account>();
            
    // Grab All MBAAccountIDs and MBASubscriptionIDs.
        for(MBA_Staging_Subscription__c s : trigger.new)
            {
             mbaaccId.add(s.MBAAccountID__c);
            }
           
    // Map to hold existing Opportunity Records by MBA Subscription Id
    map<string, Opportunity> mpmbasubOpp = new map<string, Opportunity>();
    
    // Map to hold the Staging Record to the Existing Record
    map<SObject, SObject> mpStagingToOpp = new map<SObject, SObject>();
        
    ///////////////////////////////////////////////////////////////////////////
    // First try and match to existing Opportunities
    ///////////////////////////////////////////////////////////////////////////
    
    Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
    Id TrialRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
    Id ProductRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_OneTimeProduct).getRecordTypeId();        
                           

    // Build the SOQL to query for existing Opportunities using the custom setting to retrieve all needed fields    
    string soql_Opp = SObjectUtils.OpportunitySelect + ' WHERE MBASubscriptionID__c IN (' + soqlWHERE_SubIDs + ')';
           soql_Opp = soql_Opp + ' and ( RecordTypeId = :StoreRecordTypeId or RecordTypeId = :TrialRecordTypeId or RecordTypeId = :ProductRecordTypeId)';
    system.debug('**** Opportunities Query: ' + soql_Opp);
        
    // Grab all the Opportunities that match the subscription id
    for (Opportunity o : database.query(soql_Opp))
    {
        mpmbasubOpp.put(o.MBASubscriptionID__c, o);
    }

// map of exisitng opportunities

   Map<String, Opportunity> mapMBAACCOpp = new Map<String, Opportunity>();

   for(Account a : [SELECT Id,MBAAccountID__c, OwnerId, Name, Count_Of_MBA_SUbs__c,
             (SELECT Id, MBAAccountID__c, RecordTypeId from Opportunities
              where MBASubscriptionId__c = null order by CreatedDate desc  limit 1) 
                    FROM Account WHERE MBAAccountID__c IN :mbaaccId])
    {  
        mpmbaIdAcc.put(a.MBAAccountID__c,a);    
        if (a.Opportunities.size()>0)
        {
          for (Opportunity opp :a.Opportunities)
          {
            if (opp.RecordTypeId == TrialRecordTypeId 
                || opp.RecordTypeId == StoreRecordTypeId)
                mapMBAACCOpp .put(a.MBAAccountID__c, opp);
          }
        }  
    }
    system.debug('User1:-mbaAccId###'+mbaAccId);
    ///////////////////////////////////////////////////////////////////////////
    

    ///////////////////////////////////////////////////////////////////////////
    // Build map for Syncing
    ///////////////////////////////////////////////////////////////////////////
    Opportunity opp;
    
    // Find all the subscriptions being inserted/updated
    for (MBA_Staging_Subscription__c mba : trigger.new)
    {
        // Check if a Opportunity record exists already
        if (mpmbasubOpp.containsKey(mba.MBASubscriptionID__c))
        {
            opp = mpmbasubOpp.get(mba.MBASubscriptionID__c);
            
            // Add to the map of the staging record to the existing subscription
            mpStagingToOpp.put(mba, opp);
            
            
        }
        else if (mapMBAACCOpp.get(mba.MBAAccountID__c) <> null)
        {
           opp = mapMBAACCOpp.get(mba.MBAAccountID__c);
            
            // Add to the map of the staging record to the existing subscription
            mpStagingToOpp.put(mba, opp);
          
        }
        // Opportunity does not already exist so it is a new record
       else
        {
 // if the account has been in the opportunity flow                           
            if(mpmbaIdAcc.get(mba.MBAAccountID__c)!=null  )
            // Create a new Opportunity record
             {
  //              if (!mba.isTrial__c  ||   
   //                  mpmbaIdAcc.get(mba.MBAAccountID__c).Count_of_MBA_subs__c >0   )
                
                 {   system.debug('*** opp logic: ' + mba.MBAAccountID__c);
                    opp = new Opportunity();
                    opp.Name= mba.MBASubscriptionID__c ;
                    opp.Source__c = mba.Source__c;
                    opp.AccountId = mpmbaIdAcc.get(mba.MBAAccountID__c).Id;
                    opp.OwnerId = mpmbaIdAcc.get(mba.MBAAccountID__c).OwnerId;
                    opp.MBASubscriptionID__c =mba.MBASubscriptionID__c;
                    opp.MBAAccountID__c = mba.MBAAccountID__c;
                    if (!mba.isTrial__c) 
                    {
                        opp.StageName ='Purchased';
                        opp.CloseDate=system.today();
                    }
                    else 
                    {
                        opp.StageName = label.Opportunity_Trial_FirstStage;
                        if (mba.ExpirationDate__C <> null)
                           { opp.CloseDate=mba.ExpirationDate__C;}
                          else opp.CloseDate=system.today();
                    }
                    mpStagingToOpp.put(mba, opp);
                 }
              }
                         
            
            // Add to the map of the staging record to the Opportunity
          //  mpStagingToOpp.put(mba, opp);
            
        }
    }
        
    // Call the Utility class to do the syncing
    database.Dmloptions dmlo = new database.Dmloptions();
    dmlo.assignmentRuleHeader.useDefaultRule = false;
    dmlo.emailHeader.triggerUserEmail = false;
    dmlo.optAllOrNone = Subscription_Utility.blnAllOrNone;
    
    if (!mpStagingToOpp.isEmpty())
    Try {
            SObjectUtils.SyncObjects('MBA_Staging_Subscription__c', 'Opportunity', mpStagingToOpp, dmlo);
         }
    catch (Exception e)
        {
            ErrorEmailHelper.notifyOnError('Staging Subscription Trigger', 'Opportunity Sync', 'Error in Opportunity Sync', 'Error With Opportunity: ' +  mpStagingToOpp.Values() + '; Error Message: ' + e.getMessage());
        }
    
    system.debug('*** Completed Subscription Staging Handling: ' + trigger.new);


        //////////////////////////////////////////////////////////
        // Communicate back to BMP with the new opportunity IDs //
        //////////////////////////////////////////////////////////
        List<RESTAPICallouts.BMPSalesforceIDCallout> bmpIdsToUpdate = new List<RESTAPICallouts.BMPSalesforceIDCallout>();
        for(SObject sObjOpportunity : mpStagingToOpp.values())
        {
            Opportunity bmpOpp = (Opportunity)sObjOpportunity;
            if (bmpOpp.Source__c == 'BMP')
            {
                bmpIdsToUpdate.add(new RESTAPICallouts.BMPSalesforceIDCallout('subscription', bmpOpp.MBASubscriptionID__c, bmpOpp.Id));
            }

        }

        // Send the message to BMP API
        if (!bmpIdsToUpdate.isEmpty())
        {
            System.debug('Making opportunity callouts to BMP:' + bmpIdsToUpdate);
            RESTAPICallouts.BMPSendSalesforceIDs(bmpIdsToUpdate);
        }
        else
        {
            System.debug('No BMP opportunity callouts needed');
        }

    }
}