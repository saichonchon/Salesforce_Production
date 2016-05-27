global class  UpdateLeadOwners implements Database.Batchable<sObject>, Database.Stateful
{
    global Boolean Flag;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
        Flag =false;     
        //Prepare Query to query all leads where owner is not Queue or partner prospect record type
        string query ='Select Id, Name, OwnerId, Owner_Team__c, Owner.Name, CreatedDate, LastModifiedDate, CreatedById from Lead Where IsConverted = false and  CreatedDate < LAST_N_DAYS:90 and RecordTypeId <> \'012a0000001NQQF\' and Owner.Type = \'User\'  and OwnerId <> \'005a000000AsxToAAJ\'  ';
        query = query + Label.ROE_Lead_Criteria;
		if(Test.isRunningTest()){   query = query + ' limit 50';}
        system.Debug('#query# '+query); 
        return Database.getQueryLocator(query);     
    }

    //Method where business logic gets executed
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        //Delete existing records in custom table
        purgeReportTable();

        //Collect LeadS where ownerId is equal and not equal to createdById
        Map<String,String> mapOwnerSameAsCreatedBy = new Map<String,String>();
        Map<String,String> mapOwnerDiffAsCreatedBy = new Map<String,String>();
        Map<String,DateTime> mapLeadOwnerAssignDate = new Map<String,DateTime>();
 
	    for(Sobject s : scope)
        { 
            System.Debug('User1 scope size#'+scope.size());
            Lead obj = (Lead)s;

//                 mapLeadOwner.put(obj.Id, obj.OwnerId); 
			//if ownerId is not same as Created User
			if(obj.CreatedById != obj.OwnerId)
			{
				mapOwnerDiffAsCreatedBy.put(obj.Id,obj.OwnerId);
			}
			else
			{
				mapOwnerSameAsCreatedBy.put(obj.Id,obj.OwnerId);
				mapLeadOwnerAssignDate.put(obj.Id,obj.CreatedDate);
			} 
            
        }
 //           System.Debug('Map Having Same Owner and Created By:'+mapOwnerSameAsCreatedBy);
 //           System.Debug('Map Having Different Owner and Created By:'+mapOwnerDiffAsCreatedBy);

            //Query Lead History Table for Owner Change Date 
            Map<String,DateTime> mapLeads = new Map<String,DateTime>();
          
            if(!mapOwnerDiffAsCreatedBy.keyset().isEmpty())
            {
                for(LeadHistory obj:[SELECT CreatedById,CreatedDate,Field,Id,LeadId,NewValue,OldValue FROM LeadHistory WHERE Field = 'Owner' and LeadId IN:mapOwnerDiffAsCreatedBy.keyset() and CreatedDate < LAST_90_DAYS order by CreatedDate DESC])
                {
 //                   System.Debug('Lead History:'+obj);
 				  if (obj.NewValue == mapOwnerDiffAsCreatedBy.get(obj.LeadId))	
 				  {
                    if(!mapLeadOwnerAssignDate.containsKey(obj.LeadId))
                    {
                        mapLeadOwnerAssignDate.put(obj.LeadId, obj.CreatedDate);
                    }
 				  }
                } 
            }
   //         System.Debug('Lead Map with Created/Owner change date:'+mapLeadOwnerAssignDate);

            //Collect all Lead Ids
            List<String> lstLeadIds = new List<String>();
            lstLeadIds.addAll(mapOwnerDiffAsCreatedBy.keyset());
            lstLeadIds.addAll(mapOwnerSameAsCreatedBy.keyset());
    //        System.Debug('Lead Ids:'+lstLeadIds+'---'+'Size:'+lstLeadIds.size());

	/*
            //Collect all Owner Ids
            List<String> lstLeadOwnerIds = new List<String>();
            lstLeadOwnerIds.addAll(mapOwnerDiffAsCreatedBy.values());
            lstLeadOwnerIds.addAll(mapOwnerSameAsCreatedBy.values());
    //        System.Debug('Lead Ids'+lstLeadOwnerIds+'---'+'Size'+lstLeadOwnerIds.size());

*/
            //Query for Tasks for all the Leads
            Map<String,List<Task>> mapTaskForLeads = new Map<String,List<Task>>();
            Map<String,Boolean> mapInboundEmailForLeads = new Map<String,Boolean>();
            Set<String> setCallResult = new Set<String>{'correct contact','contact','set callback', 'Success'};
            if(!mapOwnerDiffAsCreatedBy.keyset().isEmpty())
            {
                for(Task obj:[SELECT WhoId,ActivityDate,CallDisposition, CreatedDate,Description,Id,IsClosed,Subject,Type, ToutApp__Tout_Replied__c FROM Task where WhoId IN:lstLeadIds and CreatedDate = LAST_90_DAYS])
                {
   //                 System.Debug('Tasks:'+obj);
                    if(obj.Subject!=null && (obj.Subject.startsWith('←') || obj.ToutApp__Tout_Replied__c == true))
                    {
                        mapInboundEmailForLeads.put(obj.WhoId,true);
                    }
                    
                    if(obj.Type!=null && obj.Type.equalsIgnoreCase('Call') && obj.CallDisposition!=null && setCallResult.contains(obj.CallDisposition.toLowerCase()))
                    {   
                        List<Task> tsk = new List<Task>();
                        if(!mapTaskForLeads.containsKey(obj.WhoId))
                        {
                            tsk.add(obj);
                            mapTaskForLeads.put(obj.WhoId,tsk);
                        }
                        else
                        {
                            tsk.addAll(mapTaskForLeads.get(obj.WhoId));
                            tsk.add(obj);
                            mapTaskForLeads.put(obj.WhoId,tsk);
                        }
                    }  
                }
            }
  //          System.Debug('InboundEmail for Leads:'+mapInboundEmailForLeads);
  //          System.Debug('Tasks for Leads:'+mapTaskForLeads);
/*
            //Collect all Lead Owner Role Ids for a batch
            Map<String,String> mapRoleIds = new Map<String,String>();
            for(User obj:[SELECT Id,UserRoleId FROM User Where Id IN:lstLeadOwnerIds])
            {
                mapRoleIds.put(obj.Id,obj.UserRoleId);
            }
  
              
            //Collect all Lead Owner Role Name for a batch
            Map<String,String> mapRoleName = new Map<String,String>();
            for(UserRole obj:[SELECT Id,Name FROM UserRole Where Id IN:mapRoleIds.values()])
            {
                mapRoleName.put(obj.Id,obj.Name);
            }
  */         

            //Retrieve custom settings to roles and there SLA
            Map<String, Lead_Update_Owner__c> ownerRoles = Lead_Update_Owner__c.getAll();

            //Process the Leads
            List<Lead> lstLeadsToUpdate = new List<Lead>();
            List<Lead_Retrieved__c> lstLeadsToRetreive = new List<Lead_Retrieved__c>();
            for(Sobject s : scope)
            {  
                Lead obj = (Lead)s;
                if(mapTaskForLeads.get(obj.Id) == null && mapInboundEmailForLeads.get(obj.Id) == null )
                {
                    if(mapLeadOwnerAssignDate.get(obj.Id) <= System.today().addDays(- Integer.valueof(ownerRoles.get(obj.Owner_Team__c).SLA__c)))
                    {
						Lead_Retrieved__c sObj = new Lead_Retrieved__c();
						sObj.Lead_ID__c = obj.Id;
						sObj.Lead__c = obj.Id;
						sObj.Owner_ID__c = obj.OwnerId ;
						sObj.Owner_Team__c = obj.Owner_Team__c;
						sObj.Owner_Name__c = obj.Owner.Name;
						sObj.New_Owner__c = ownerRoles.get(obj.Owner_Team__c).Queue_Owner__c;
						if(mapLeadOwnerAssignDate.get(obj.Id)!=null)
						{
						   sObj.Lead_Owner_Assign_Date__c = Date.valueOf(mapLeadOwnerAssignDate.get(obj.Id));
			
						}
						else
						{
							sObj.Lead_Owner_Assign_Date__c = Date.valueOf(obj.CreatedDate);
			
						} 
						
						//If processes is true then update else retrieve
						if(ownerRoles.get(obj.Owner_Team__c).Update__c)

						{
						  obj.OwnerId = ownerRoles.get(obj.Owner_Team__c).Queue_Owner__c;
						  obj.Stage__c = 'Closed Lost';
						  obj.Closed_Lost_Reason__c = 'Auto Closed Lost';
						  lstLeadsToUpdate.add(obj);
						  sObj.Processed__c = true;
						}
						else
						{
							sObj.Processed__c = false;
						}
						lstLeadsToRetreive.add(sObj);
                    }
                     
                }
            }

            if(!lstLeadsToUpdate.isEmpty())
            {
                 update lstLeadsToUpdate;
            }
                   
            if(!lstLeadsToRetreive.isEmpty())
            {
                insert lstLeadsToRetreive;
            }

    }

    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Lead Update Owners Completed');
        mail.setPlainTextBody('Batch Process has completed');
//        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    private void purgeReportTable()
    {
        System.Debug('#Flag# start purge'+Flag);
        if(!Flag)
        {   
            // Query the Lead Data From Lead Retrieved Object.
            List<Lead_Retrieved__c> lstRetData = new List<Lead_Retrieved__c>([Select Id from Lead_Retrieved__c Where Processed__c = false and Lead__c <> null LIMIT 10000]);
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