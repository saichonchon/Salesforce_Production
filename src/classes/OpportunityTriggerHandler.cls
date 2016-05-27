/**********************************************************************
Name:  Professional Opportunity Updates
======================================================
 Purpose: Perform Professional Opportunity updates.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 9/1/2013  Initial development
2.0 Maggie Frederick 2/17/2015 Prevent recursive action
3.0 Maggie Frederick 3/17/2015 Store opportunity for PS Opps
4.0 Maggie Frederick 9/27/2015 RemoveConsulting services opps
 
***********************************************************************/

public class OpportunityTriggerHandler {

 private static  Id idOppRecordType =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
// private static  Id idCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
 private static  Id idMigCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
 
  
    public void OnAfterUpdate(Opportunity[] newList, Map<ID, Opportunity> OpportunityMap, Opportunity[] oldList)
    {
	    if (!TriggerRecursionController.casesCreatedFromPSOpp)	
	    {    
	        Set <Id> closedwonOpps = new Set <Id>();
	       
	        for (integer i =0; i < newList.size(); i++)
	        {
	// add for is changed....
	            if (newList[i].StageName == 'Closed Won' && 
	                oldList[i].StageName <>'Closed Won' && 
	               newList[i].RecordTypeId == idOppRecordType)
	                {
	                    closedwonOpps.add(newList[i].Id);
	                }
	        }
         
        	if (!closedwonOpps.isEmpty()) 
	        {
        		createCases(closedwonOpps);
	           	TriggerRecursionController.casesCreatedFromPSOpp = true;
	        }
    	}
 
    }
    
 
    private void createCases(Set<Id> oppIds)
    
    {
 		
		List<Case> newCases = new List<Case>();
        
        Map<id, Opportunity> opps = new Map<Id, Opportunity> ([select Id, AccountId, Subscription__r.Id,
                                                              Account.Ssc__r.Id, OwnerId,
                                                              Account.Ltc__r.Id, Sales_Notes__c,
                                                              Store_Opportunity__r.Id,  Store_Opportunity__r.New_Product_Plan__c,
                                                              Current_Store_URL__c, Migration_Platform__c,
                                                              Account.SBD_Segment__c
                                                              from Opportunity
                                                              where Id in :oppIds
                                                              ]);
        Map<id, Id> oppcontact = OpportunityHelper.getContactFromRole(oppIds,'Professional Services Contact');
                                                              
                                                             
        Map<Id, OpportunityLineItem> oppItems = new Map<Id,OpportunityLineItem>([Select Id, TotalPrice, 
                                                        PricebookEntry.Product2.Name, Consulting_Services__c,
                                                        PricebookEntry.Name, PricebookEntry.Product2.Family,                                                      
                                                        OpportunityId
                                                        From OpportunityLineItem  where OpportunityId in :opps.keySet()]);
        
        
        for (Id itemId :oppItems.KeySet())
        {
            OpportunityLineItem item = oppItems.get(itemId);
            Opportunity opp = opps.get(item.OpportunityId);
            Case newCase = new Case();
            newCase.Origin = 'Internal Request';
            newCase.Reason = 'New client purchase';
            newCase.Subject = 'Client purchase of product';
            newCase.Description = 'Client has purchased ' + item.PricebookEntry.Product2.Name;
            newCase.Department__c = 'Professional Services';
            newCase.AccountId = opp.AccountId;
            if (opp.Subscription__r.Id <> null) newCase.Subscription__c = opp.Subscription__r.Id;
            if (opp.Store_Opportunity__r.Id <> null) newCase.Opportunity__c = opp.Store_Opportunity__r.Id;
            if (oppContact.get(opp.Id) <> null) newCase.ContactId = oppContact.get(opp.Id);
            newCase.Price__c = item.TotalPrice;
            newCase.Product_Sold__c = item.PricebookEntry.Product2.Name;
            newCase.Sold_by__c = opp.OwnerId;
            newCase.RecordTypeId = idMigCaseRecordType;
 
            if (opp.Sales_Notes__c <> null) newCase.Sales_Notes__c = opp.Sales_Notes__c;
            system.debug(' ***' +item.PricebookEntry.Product2.Family);

            if (item.PricebookEntry.Product2.Family.contains('Migration'))
            {
            	If (opp.Current_Store_URL__c == null ||
            	    opp.Migration_Platform__C == null)
            	{
// throw error     
//				 ErrorEmailHelper.notifyOnError('Opportunity Trigger Handler', 'Create Case', 'Error in Opportunity Trigger Handler - Migration', 'Error Creating case for: ' + opp.Id);
				 
                 return;
		        }
            	newCase.Current_Store_URL__c = opp.Current_Store_URL__c;
            	newCase.Migration_Platform__c = opp.Migration_Platform__c;
            	newCase.OwnerId = Label.Migration_Case_Queue;
            	newCase.Subject = 'Your Bigcommerce Migration';
 				newCases.add(newCase);
         	}
 			
        }
        
        if (newCases.size() > 0)
        {
            Try{
                insert newCases;
            }
            catch(Exception e) {
 //              ErrorEmailHelper.notifyOnError('Opportunity Trigger Handler', 'Create Case', 'Error in Opportunity Trigger Handler - Create Case', 'Error Creating case for: ' + opp.Id);
                system.debug('Error in Opportunity Trigger Handler - Create Case');
                }   
        
        
        }
        
    }
/*
	public static Id checkOwner(List<Opportunity> opps)
	{
		for(OpportunityFieldHistory obj:[SELECT CreatedById,CreatedDate,Field,Id,OpportunityId,NewValue,OldValue FROM OpportunityFieldHistory WHERE Field = 'Owner' and OpportunityId IN:mapOwnerDiffAsCreatedBy.keyset()   order by CreatedDate DESC])
               {
 				  if (obj.NewValue == mapOwnerDiffAsCreatedBy.get(obj.OpportunityId))	
 				  {
                    if(!mapOwnerAssignDate.containsKey(obj.OpportunityId))
                    {
                        mapOwnerAssignDate.put(obj.OpportunityId, obj.CreatedDate);
                    }
 				  }
                } 
            
   //Query History Table for Stage Change Date 
            Map<String,DateTime> mapOppStages = new Map<String,DateTime>();
  			
            for(OpportunityFieldHistory obj:[SELECT CreatedById,CreatedDate,Field,Id,OpportunityId,NewValue,OldValue FROM OpportunityFieldHistory WHERE Field = 'StageName' and OpportunityId IN:mapTrialOppOwner.keyset()   order by CreatedDate DESC])
                {
 				  if (obj.CreatedById == mapTrialOppOwner.get(obj.OpportunityId))	
 				  {
                    if(!mapOppStages.containsKey(obj.OpportunityId))
                    {
                        mapOppStages.put(obj.OpportunityId, obj.CreatedDate);
                    }
 				  }
                } 
            
	}
*/
}