/**********************************************************************
Name:  OpportunityTrigger 
======================================================
 Purpose: Perform action on updates.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 3/5/2014  Initial development
2.0 Maggie Frederick 6/15/2015  Opp team capture
3.0 Maggie Frederick 7/1/2015   BMP callout
4.0 Maggie Frederick 8/7/2015   RV Rollup
 
***********************************************************************/

trigger Opportunity on Opportunity (after insert, after update, before insert, before update, after delete, after undelete) 
{
	String userName = UserInfo.getname();
	if (!Label.Skip_Users.containsIgnoreCase(username) ) 
	{
	    Id idProfOppRecordType =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
	    Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
	    Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
	 	Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
//	 	Id TrialRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
	 	Id ThemeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Theme').getRecordTypeId();
	 	
	    Set<Id> notSubRecIds = new Set<Id>();
	    notSubRecIds.add(AppRecordTypeId);
	    notSubRecIds.add(idProfOppRecordType);
	    notSubRecIds.add(ThemeRecordTypeId);
/*	    Set<Id> SubRecIds = new Set<Id>();
	    SubRecIds.add(StoreRecordTypeId);
	    SubRecIds.add(UpgradeRecordTypeId);
	    SubRecIds.add(TrialRecordTypeId);
*/	  
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
	//            if( opp.RecordTypeId <> idProfOppRecordType )
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
	           //      || (opp.MBA_Account_ID__c!=null && opp.MBASubscriptionID__c!=null))
	                   {
	                   // most recent sub on manual conversion?           
	//                   opp.StageName = 'Prospect';
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
	         List<Opportunity> lstNew = new List<Opportunity>();
	         List<Opportunity> lstOld = new List<Opportunity>();
	         List<Opportunity> lstPart = new List<Opportunity>();
	   
	         for(Integer i=0;i<Trigger.new.size();i++)
	         {
	//            if (Trigger.New[i].RecordTypeId <> idProfOppRecordType 
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
	 //          if(opp.RecordTypeId <> idProfOppRecordType 
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
	//            if (Trigger.New[i].RecordTypeId <> idProfOppRecordType 
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
	//	                    && Trigger.New[i].MonthlyRecurringRevenue__C > 0
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
	
	//callout to bmp      
	if (trigger.isAfter && !trigger.isDelete)
	{
		Map<String, String> bmpsfIds = new Map<String, String>();
		for(Opportunity o : trigger.new)
        {
            
            if ((Trigger.isInsert && o.Source__c == 'BMP') ||
                (!Trigger.isInsert && o.Source__c == 'BMP' 
                	&& (trigger.oldMap.get(o.id).Source__c <> 'BMP'
                	     || o.MBASubscriptionID__c!= trigger.oldMap.get(o.id).MBASubscriptionID__c)
                	  )
               )
            {      
              
                 bmpsfIds.put(o.MBASubscriptionID__c, o.Id);                   
            }
                  
        }
        
        if (!bmpsfIds.isEmpty())
        {
	        Map<String, String> mapBmpIdBody = RESTAPIUtility.getJSONBody( bmpsfIds);
	        for (String sendbmpId :mapBmpIdBody.KeySet())
			{
			  RESTAPICallouts.BMPRequest('subscription', sendbmpId, mapBmpIdBody.get(sendbmpId));
			}
        }
	}
}