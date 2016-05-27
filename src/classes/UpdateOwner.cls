global class  UpdateOwner implements Database.Batchable<sObject>, Database.Stateful
{ 
    public String query;
    
    global Boolean Flag;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
        Flag =false;   
 		Id upgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
	    Id trialRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
        Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();
 		
        return Database.getQueryLocator(query);     
    }

    //Method where business logic gets executed
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        //Delete existing records in custom table
        purgeReportTable();
	    Id upgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
	    Id trialRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
        Id storeRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_StorePurchase).getRecordTypeId();

        //Collect where ownerId is equal and not equal to createdById
        Map<String,String> mapOwnerSameAsCreatedBy = new Map<String,String>();
        Map<String,String> mapOwnerDiffAsCreatedBy = new Map<String,String>();
        Map<Id, Id> mapAccOwner = new Map<Id, Id>();
        Map<Id, Id> mapTrialOppOwner = new Map<Id, Id>();
        Map<String,DateTime> mapOwnerAssignDate = new Map<String,DateTime>();
 		
 		List<String> lstAcctIds = new List<String>();
 		
        for(Sobject s : scope)
        { 
	        System.Debug('User1 scope size#'+scope.size());
	        Opportunity obj = (Opportunity)s;
	        System.Debug('User1 scope '+obj.Id);
 			if (obj.RecordTypeId == storeRecordTypeId || obj.CreatedById == obj.OwnerId)
 			{
               mapOwnerSameAsCreatedBy.put(obj.Id,obj.OwnerId);
               mapOwnerAssignDate.put(obj.Id,obj.PurchaseDate__c);
 			}  
             else
			 {  
               //if ownerId is not same as Created User
                if(obj.CreatedById != obj.OwnerId)
                {
                    mapOwnerDiffAsCreatedBy.put(obj.Id,obj.OwnerId);
                }
                          
 			}
 			if (obj.RecordTypeId == trialRecordTypeId)
 			{
 				mapTrialOppOwner.put(obj.Id,obj.OwnerId);
 			}
			lstAcctIds.add(obj.AccountId);
            mapAccOwner.put(obj.AccountId, obj.OwnerId);
        }

            //Query History Table for Owner Change Date 
            Map<String,DateTime> mapOpps = new Map<String,DateTime>();
          
            if(!mapOwnerDiffAsCreatedBy.keyset().isEmpty())
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
            }
   //Query History Table for Stage Change Date 
            Map<String,DateTime> mapOppStages = new Map<String,DateTime>();
  			if(!mapTrialOppOwner.keyset().isEmpty())
            {
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
 //          System.Debug('Opportunity Map with Created/Owner change date:'+mapOppOwnerAssignDate);
// if it was not created by user or it does not have opp field history - done before 12/14 add the date.
			Date olddate = system.today().addDays(-150);
			for (Id idmiss :mapOwnerDiffAsCreatedBy.KeySet())
			{
				if (!mapOwnerAssignDate.containsKey(idmiss))
				mapOwnerAssignDate.put(idmiss, olddate);
			}

//			mapOppOwner.putAll(mapOwnerDiffAsCreatedBy);
//			mapOppOwner.putAll(mapOwnerSameAsCreatedBy);
			
            //Collect all  Ids
            List<String> lstOppIds = new List<String>();
            lstOppIds.addAll(mapOwnerDiffAsCreatedBy.keyset());
            lstOppIds.addAll(mapOwnerSameAsCreatedBy.keyset());
 
            //Collect all Owner Ids
            List<String> lstOppOwnerIds = new List<String>();
            lstOppOwnerIds.addAll(mapOwnerDiffAsCreatedBy.values());
            lstOppOwnerIds.addAll(mapOwnerSameAsCreatedBy.values());
 

            //Query for Tasks for all the Opps
            Map<Id,List<Task>> mapAccTasks = new Map<Id,List<Task>>();
            Map<String,List<Task>> mapTaskForOpps = new Map<String,List<Task>>();
            Map<String,Boolean> mapInboundEmailForOpps = new Map<String,Boolean>();
            Set<String> setCallResult = new Set<String>{'correct contact','contact','set callback', 'Success'};
            if(!mapOwnerAssignDate.keyset().isEmpty())
            {
                for(Task obj:[SELECT AccountId, WhoId,ActivityDate,CallDisposition, ToutApp__Tout_Replied__c, ToutApp__Tout_Replied_At__c, CreatedDate,Description,Id,IsClosed,Subject,Type, OwnerId FROM Task where AccountId IN:lstAcctIds and ( CreatedDate = LAST_90_DAYS OR ToutApp__Tout_Replied_At__c  = LAST_90_DAYS) ])
                {
   //                 System.Debug('Tasks:'+obj);
 					Id oppOwner = mapAccOwner.get(obj.AccountId);
                    if(obj.OwnerId == oppOwner && obj.Subject!=null && obj.Type.equalsIgnoreCase('Email') && (obj.Subject.startsWith('←') || obj.ToutApp__Tout_Replied__c == true ))
                    {
                        if(!mapInboundEmailForOpps.containsKey(obj.AccountId))
                        mapInboundEmailForOpps.put(obj.AccountId,true);
                    }
                     
                    if(obj.OwnerId == oppOwner && obj.Type!=null && obj.Type.equalsIgnoreCase('Call') && obj.CallDisposition!=null && setCallResult.contains(obj.CallDisposition.toLowerCase()))
                    {   
                        List<Task> tsk = new List<Task>();
                        if(!mapTaskForOpps.containsKey(obj.AccountId))
                        {
                            tsk.add(obj);
                            mapTaskForOpps.put(obj.AccountId,tsk);
                        }
                        else
                        {
                            tsk.addAll(mapTaskForOpps.get(obj.AccountId));
                            tsk.add(obj);
                            mapTaskForOpps.put(obj.AccountId,tsk);
                        }
                    }  
                }
            }
  //          System.Debug('InboundEmail for Opps:'+mapInboundEmailForOpps);
            System.Debug('Tasks for Opps:'+mapTaskForOpps);

            //Retrieve custom settings to roles and there SLA
            Map<String, Lead_Update_Owner__c> ownerRoles = Lead_Update_Owner__c.getAll();

            //Process the Opps
            List<Opportunity> lstOppsToUpdate = new List<Opportunity>();
            List<Lead_Retrieved__c> lstOppsToRetreive = new List<Lead_Retrieved__c>();
            for(Sobject s : scope)
            {  
                Opportunity obj = (Opportunity)s;
              
                if(mapTaskForOpps.get(obj.AccountId) == null && mapInboundEmailForOpps.get(obj.AccountId) == null )
                {
 					system.debug(' assign date'+mapOwnerAssignDate.get(obj.Id));
                    system.debug(' role '+obj.Owner_Team__c);
                    if(mapOwnerAssignDate.get(obj.Id) <= System.today().addDays(- Integer.valueof(ownerRoles.get(obj.Owner_Team__c).SLA__c))
                    	&& mapOppStages.get(obj.Id) <= System.today().addDays(- Integer.valueof(ownerRoles.get(obj.Owner_Team__c).SLA__c))
                       )
                    {
                     //If processes is true then update else retrieve
 						Lead_Retrieved__c sObj = new Lead_Retrieved__c();
						sObj.Opportunity__c = obj.Id;
						sObj.Owner_ID__c = obj.OwnerId ;
						sObj.Owner_Team__c = obj.Owner_Team__c;
						sObj.Owner_Name__c = obj.Owner.Name;
						sObj.New_Owner__c = ownerRoles.get(obj.Owner_Team__c).Queue_Owner__c;
						
                         if(ownerRoles.get(obj.Owner_Team__c).Update__c)

                                {
                                  obj.OwnerId = ownerRoles.get(obj.Owner_Team__c).Queue_Owner__c;
                                  if (obj.RecordTypeId == trialRecordTypeId)
						 		  {
						 			 obj.StageName = 'Closed Lost';
						 			 obj.Closed_Lost_Reason__c = 'Auto Closed Lost';
						 		   }
                                   lstOppsToUpdate.add(obj);
								   sObj.Processed__c = true;
                                }
                         else
                                {
                                    if(mapOwnerAssignDate.get(obj.Id)!=null)

                                    {
                                        sObj.Lead_Owner_Assign_Date__c = Date.valueOf(mapOwnerAssignDate.get(obj.Id));

                                    }
                                    else
                                    {
                                        sObj.Lead_Owner_Assign_Date__c = Date.valueOf(obj.CreatedDate);

                                    }
                                   
                                    
									sObj.Processed__c = false;
                                }
                          lstOppsToRetreive.add(sObj);
                     }
               }
                    
                
            }

            if(!lstOppsToUpdate.isEmpty())
            {
                 update lstOppsToUpdate;
            }
                   
            if(!lstOppsToRetreive.isEmpty())
            {
                insert lstOppsToRetreive;
            }

    }

    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Opp Update Owners Completed');
        mail.setPlainTextBody('Batch Process has completed');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    private void purgeReportTable()
    {
        System.Debug('#Flag# start purge'+Flag);
        if(!Flag)
        {   
            // Query the Lead Data From Lead Retrieved Object.
            List<Lead_Retrieved__c> lstRetData = new List<Lead_Retrieved__c>([Select Id from Lead_Retrieved__c Where Processed__c = false and Opportunity__c <> null LIMIT 50000]);
/*            for(Lead_Retrieved__c obj:[Select Id from Lead_Retrieved__c Where Processed__c = false LIMIT 50000])
            {
  //              obj.Processed__c = true;
                lstRetData.add(obj);
            }
 */           
            // Update the Lead List.
            if(!lstRetData.isEmpty() && !Test.isRunningTest())delete lstRetData;
                  
            Flag = true;
        }
        System.Debug('#Flag# end'+Flag);
    }
    
}