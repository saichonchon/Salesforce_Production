/**********************************************************************
Name:  OpportunityTrigger 
======================================================
 Purpose: Perform action on updates.
======================================================
 
History:   
                                                      
VERSION AUTHOR              DATE        DETAIL     
 
1.0     Maggie Frederick    3/5/2014    Initial development
2.0     Maggie Frederick    6/15/2015   Opp team capture
3.0     Maggie Frederick    7/1/2015    BMP callout
4.0     Maggie Frederick    8/7/2015    RV Rollup
5.0     Maggie Frederick    5/9/2016    Google Analytics -- Maria Huemmer commenting existing code
5.1		Steve O'Neal		5/10/2016	Google Analytics, changing method signature for GAUtility
6.0     Steve O'Neal        08/19/2016  Changed callout functionality to BMP
 
***********************************************************************/

trigger Opportunity on Opportunity (after insert, after update, before insert, before update, after delete, after undelete) 
{
    List<string> GAapiCalloutStrings = new List<string>();

    String userName = UserInfo.getname();
    if (!Label.Skip_Users.containsIgnoreCase(username) ) 
    {
        Id idProfOppRecordType =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
        Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
        Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
        Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
        Id ThemeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Theme').getRecordTypeId();
        
        Set<Id> notSubRecIds = new Set<Id>();
        notSubRecIds.add(AppRecordTypeId);
        notSubRecIds.add(idProfOppRecordType);
        notSubRecIds.add(ThemeRecordTypeId);
      
        OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
        
        if(Trigger.isUpdate && Trigger.isAfter && !Trigger.isDelete)
        {   
           handler.OnAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old);      
        }
    
        // Creating Instance Of A Class which Performs MBA store Logic. 
        OpportunityOperations operation= new OpportunityOperations();
        
        // Before Insert
        if(Trigger.isBefore && Trigger.isInsert)
        {
             system.debug('Before Insert Start'+trigger.new);
             List<Opportunity> lstOpp = new List<Opportunity>();
             
             for(Opportunity opp:Trigger.new)
             {
    
                 if (!notSubRecIds.contains(opp.RecordTypeId))
                {
                   // if the opportunity was created by sub trigger lead convert code
                   if(opp.Name.contains('MBA Sub :'))
                     {   
                        String [] ldata = opp.Name.Split(':');
                        system.debug('Split Data'+ldata);
                        opp.MBASubscriptionID__c = ldata[1];
                     }
                    
                     if (opp.Contact__c == null )
               
                       {
                         lstOpp.add(opp);
                       }
                }     
              }
         
            if(!lstOpp.isEmpty())
            {
                operation.BeforeInsert(lstOpp);
            }
         
                     
          
            system.debug('Before Insert End'+trigger.new);
        } // end before insert
    
    // before update
        if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
        {
    
            system.debug('Before Start'+trigger.new);

            // Steve O'Neal - adding code for BAP-3629 - add a random number to the opportunity
            for (Opportunity o : trigger.new)
            {
                if (o.Random_Sample_Number__c == null)
                {
                    o.Random_Sample_Number__c = MathUtility.RandomInteger(1, 100);
                }
            }

             List<Opportunity> lstNew = new List<Opportunity>();
             List<Opportunity> lstOld = new List<Opportunity>();
             List<Opportunity> lstPart = new List<Opportunity>();
       
             for(Integer i=0;i<Trigger.new.size();i++)
             {         
                 if (!notSubRecIds.contains(Trigger.New[i].RecordTypeId))
                 {    
                    if (Trigger.New[i].MBAAccountID__c <> null || Trigger.New[i].MBASubscriptionId__c <> null)
                    { 
                        lstNew.add(Trigger.new[i]);
                        if (Trigger.isUpdate) lstOld.add(Trigger.old[i]);
                    }
                        
                    if (Trigger.New[i].MBAPartnerID__c <> null && Trigger.New[i].rvpe__RVAccount__c == null)
                    {     
                        if ( Trigger.isInsert 
                            || (Trigger.isUpdate && Trigger.New[i].MBAPartnerID__c <> Trigger.Old[i].MBAPartnerID__c )
                            )
                            { 
                                lstPart.add(Trigger.new[i]);
                               
                            }
                         if (Trigger.isUpdate &&  Trigger.New[i].OwnerId <> Trigger.Old[i].OwnerId 
                             && UserInfo.getUserId() !=  Trigger.Old[i].OwnerId 
                             && Trigger.Old[i].OwnerId <> Label.BCT_Id)
                                {
                                    if (Trigger.New[i].Partner_Owner_Id__c <> null 
                                        && Userinfo.getProfileId() != Label.System_Admin_Profile
                                        && Userinfo.getProfileId() != Label.Sales_Leader_Profile
                                        &&  UserInfo.getUserId() != Trigger.New[i].Partner_Owner_Id__c )
                                        
                                        {Trigger.New[i].OwnerId = Trigger.Old[i].OwnerId;}
                                }
                    }

                                        
                }
             }
             if(!lstNew.isEmpty() ){
                operation.BeforeInsertUpdate(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, 
                                          lstNew,lstOld);
             }
     
             if(!lstPart.isEmpty() ){
                operation.updatePartnerAccount(lstPart);
             }                             
             system.debug('Before Update End'+trigger.new);
            
             
            if(trigger.isUpdate)
            {
                OpportunityHelper.storeOppTeamMembers(trigger.oldMap, trigger.newMap);
            }

    
        }
    
    // after insert 
        if(Trigger.isAfter && Trigger.isInsert)
        {
             system.debug('After Insert Opportunity'+trigger.new);
             List<Opportunity> lstOpp = new List<Opportunity>();
             
             for(Opportunity opp:Trigger.new){
                 if (!notSubRecIds.contains(opp.RecordTypeId)
                 && opp.RecordTypeId <> UpgradeRecordTypeId
                 && opp.MBA_Account_ID__c!=null 
                 && (( opp.MostRecentSubscription__c <> null && opp.MBASubscriptionID__c==null)
                       || opp.MBASubscriptionID__c <> null )
                       )
               {
                 lstOpp.add(opp);
               }
             }
             if(!lstOpp.isEmpty()){
                operation.AfterInsert(lstOpp);
             }
             system.debug('After Insert End'+trigger.new);
        }
    
    
        if(Trigger.isAfter && Trigger.isUpdate)
        {
           system.debug('After Update Start'+trigger.new);
           List<Opportunity> lstNew = new List<Opportunity>();
           List<Opportunity> lstOld = new List<Opportunity>();
           Set<Id> oppIds = new Set<Id>();
           Map <Id, String> oppProdPlan = new Map <Id, String>();
       
            for(Integer i=0;i<Trigger.new.size();i++)
             {
                if (!notSubRecIds.contains(Trigger.New[i].RecordTypeId))
                {
                    if ( Trigger.New[i].RecordTypeId <> UpgradeRecordTypeId
                        && Trigger.New[i].MBASubscriptionId__c <> null)
                    { 
                        lstNew.add(Trigger.new[i]);
                        lstOld.add(Trigger.old[i]);
                    }
                    
                     if (Trigger.New[i].RecordTypeId <> UpgradeRecordTypeId
                        && Trigger.New[i].OwnerId <> Trigger.Old[i].OwnerId )
                    { 
                        oppIds.add(Trigger.new[i].id);
                    
                    }
                    if( Trigger.New[i].RecordTypeId <> UpgradeRecordTypeId
                        && Trigger.New[i].Estimated_Product__c <>  null 
                        && (Trigger.Old[i].Estimated_Product__c== null
                        || Trigger.New[i].Estimated_Product__c <> Trigger.Old[i].Estimated_Product__c ))
                    {
                        String productPlan = '';
                        If (Trigger.New[i].Estimated_Product__c.contains('Silver')) productPlan =  'Esilvn';
                        else If (Trigger.New[i].Estimated_Product__c.contains('Gold')) productPlan =  'Egoldn';
                        else If (Trigger.New[i].Estimated_Product__c.contains('Platinum Plus')) productPlan =   'Eplatp';
                        else If (Trigger.New[i].Estimated_Product__c.contains('Platinum')) productPlan =  'Eplatn';
                        else If (Trigger.New[i].Estimated_Product__c.contains('Enterprise')) productPlan = 'Eenter9' ;
                        system.debug('**** '+productPlan);
                        
                        oppProdPlan.put(Trigger.New[i].Id,productPlan); 
                    } 
                }  
             }
           
           if(!lstNew.isEmpty() && !lstOld.isEmpty()){
                operation.afterUpdate(lstNew,lstOld);
           }
           
           if (oppIds.size()>0) operation.UpdateAccountOwner(oppIds);
           system.debug('After Update End'+trigger.new);
           
           if(oppProdPlan.size()>0) operation.createExpectedProd(oppProdPlan);    
       }
        
// After - do the rollups to account   

       if (!TriggerRecursionController.accountRollupFromOpp && trigger.isAfter)   
       {
          //Pass in the name of the child record, in this case 'Opportunity' and the name of the parent record, in this case 'Account';   
          LookupRollupHelper lh = new LookupRollupHelper( 'Opportunity', 'rvpe__RVAccount__c', 'RVAccount - Opportunity Active');

          if(!Trigger.isDelete)
          {
             List<Opportunity> rollupnew = new List<Opportunity>();
             List<Opportunity> rollupold = new List<Opportunity>();
             
             for(Integer i=0;i<Trigger.new.size();i++)
                 {
                        if ( Trigger.New[i].RecordTypeId == StoreRecordTypeId
                            && Trigger.New[i].MonthlyRecurringRevenue__C <> null 
                            )
                        { 
                            rollupnew.add(Trigger.new[i]);
                            if (!Trigger.isInsert)rollupnew.add(Trigger.old[i]);
                        }
    
                 }
                 if (!rollupnew.isEmpty()) lh.rollupSummary((List<sObject>)rollupnew, (List<sObject>)rollupold);
           }
           else 
           {    
                 lh.rollupSummary((List<sObject>)Trigger.Old, null);
           }        
           TriggerRecursionController.accountRollupFromOpp = true;
           
        }
    // add Opp team members
        
        if(trigger.isAfter)
        {   
            if(trigger.isInsert)
            {
                OpportunityHelper.setOppTeamMembers(null, trigger.newMap);
            }
            
            if(trigger.isUpdate)
            {
                OpportunityHelper.setOppTeamMembers(trigger.oldMap, trigger.newMap);
            }
        }
    }
    

    ///////////////////////////////////////////////////////////////////////////
    // *Google Analytics* Notify Google Analytics when an opportunity is won //
    ///////////////////////////////////////////////////////////////////////////
    if (trigger.isAfter && !trigger.isDelete)
    {
        List<Opportunity> gaWonOpportunities = new List<Opportunity>();
        
        for(Opportunity o: trigger.new)
        {
            // *Google Analytics* If Opportunity has a GAClientID and the opportunity is changed to won...   
            system.debug(' opp ga '+o.GA_Client_Id__c);      
            if (o.GA_Client_ID__c <> null && o.isWon
                && (Trigger.isInsert || !trigger.oldMap.get(o.id).isWon)  )           
            
            //Map the details needed to pass to the GAUtility method to generate the Request body
            {      
                gaWonOpportunities.add(o);                   
            }
                  
        }
        
        if (gaWonOpportunities.size() > 0)
        {
            for (Opportunity o : gaWonOpportunities)
            {
                GAapiCalloutStrings.addAll(GAUtility.getGARequestStrings(GAUtility.GAAction.purchase, o));
            }
        }        

    }

    
    // make the callout to google analytics
    if(GAapiCalloutStrings.size() > 0)
    {
        GAUtility.GARequest(GAapiCalloutStrings);
    }
}