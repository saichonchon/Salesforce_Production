trigger LeadTrigger on Lead (before insert, before update) 
{
    system.debug('@@@ Lead Trigger Start');                 
    system.debug('***LeadTrigger: - lookUpRollUpIsRunning: ' + SObjectUtils.lookUpRollUpIsRunning);
    system.debug('***LeadTrigger: - SubscriptionLogicRunning: ' + SObjectUtils.SubscriptionLogicRunning);
    
    // Ensure the neither the Rollup logic or Subscription Integration Logic is currently running causing the update
    if (SObjectUtils.lookUpRollUpIsRunning == false && SObjectUtils.SubscriptionLogicRunning == false)
    {   
//check if it is a duplicate
       if (trigger.isBefore)
        {
        	Lead_TriggerHandler.changePRMLeadOwner(trigger.New);
        	DatanyzeLeadHandler.beforeInsertDatanyze(trigger.New);
        	if (trigger.isInsert) Lead_TriggerHandler.checkForDuplicates(Trigger.new);
			if (trigger.isUpdate) Lead_TriggerHandler.updatePhoneNumbers(Trigger.New, Trigger.Old);
//		    if (trigger.isUpdate && !system.isFuture()) Lead_TriggerHandler.changeLeadOwner(Trigger.New, Trigger.Old);

        }
        if (trigger.isBefore)
        {
            list<Lead> lstLeads4RoundRobin = new list<Lead>();
            
            // String variables to grab lead fields that need to be checked in the assignment rules
            string strExperience;
            string strCurrentOwnerId;
            string strNewOwnerId;
            
            // Map of Users that may be needed
            map<string, User> mpNameToUser = SObjectUtils.mpUserRecordsByName(new set<string>{'API User',  'Joy Wallis'});
            
            // Build a map of available lead queues
            map<string, Id> mpLeadQueueNameToId = new map<string, Id>();
            
            for (QueueSobject q : SObjectUtils.lstQueues4Object('Lead'))
            {
                mpLeadQueueNameToId.put(q.Queue.Name, q.QueueId);   
            }
                
            system.debug('***LeadTrigger: - mpLeadQueueNameToId: ' + mpLeadQueueNameToId);
            
            // Check each lead in the trigger to see if it can be assigned and if it needs to be sent through round robin
            for (Lead l : trigger.new)
            {
                if (l.OwnerId == null) l.ownerId = Label.Lead_Default_Owner;
                strNewOwnerId = strCurrentOwnerId = l.OwnerId;
                                    
                system.debug('***LeadTrigger: - Before Assignment OwnerId: ' + strCurrentOwnerId);
                
                strExperience = l.Experience__c == null ? '' : l.Experience__c;
                
                system.debug('***LeadTrigger: - No_Assign__c: ' + l.No_Assign__c);
                system.debug('***LeadTrigger: - Assign_Now__c: ' + l.Assign_Now__c);
                
                // If the lead can be assigned
                if (l.No_Assign__c == false && l.IsConverted == false)
                {
                    // Check if the lead can run through assignment rules
                    if (l.Assign_Now__c == true)
                    {
                        l.Assign_Now__c = false;
                        
                        system.debug('***LeadTrigger: - CreatedById: ' + l.CreatedById);
                        
                        // Drop the lead through the assignment rules
                        if (trigger.isInsert && (UserInfo.getUserId() == mpNameToUser.get('API User').Id) //|| UserInfo.getUserId() == mpNameToUser.get('Maggie Frederick').Id)  || UserInfo.getUserId() == mpNameToUser.get('Joy Wallis').Id)
                            || (trigger.isUpdate && (l.OwnerId == mpNameToUser.get('API User').Id )))   //|| l.OwnerId == mpNameToUser.get('Maggie Frederick').Id))) || l.OwnerId == mpNameToUser.get('Joy Wallis').Id)))
                        {
                            if(  l.email <> null && l.email.contains('@bigcommerce.com'))
                            {
                                strNewOwnerId = l.OwnerId = Label.Lead_Default_Owner;
                            }
                            else if (l.LeadSource == 'Partner Request Form' && strCurrentOwnerId != mpLeadQueueNameToId.get('Partner Request Queue'))
                            {
                                // Assign the lead to the Partner Request Queue
                                strNewOwnerId = l.OwnerId = mpLeadQueueNameToId.get('Partner Request Queue');
                            }
                            else if (strExperience.contains('I\'m setting up a store for a client') && strCurrentOwnerId != mpLeadQueueNameToId.get('Designer Queue') && strCurrentOwnerId != mpLeadQueueNameToId.get('Designer AU Queue'))
                            {
                                if (l.Country == 'Australia' || l.Country == ' New Zealand' || l.Country == 'AU' || l.Country == 'NZ' || l.Country == 'NZD' || l.Country == 'AUS')
                                {
                                    // Assign the lead to the Designer AU Queue
                                    strNewOwnerId = l.OwnerId = mpLeadQueueNameToId.get('Designer AU Queue');
                                }
                                else
                                {
                                    // Assign the lead to the Designer Queue
                                    strNewOwnerId = l.OwnerId = mpLeadQueueNameToId.get('Designer Queue');
                                }
                            }
                            else if (strCurrentOwnerId != mpLeadQueueNameToId.get('Direct AU Queue') 
                                    && (l.Country <> null)
                                    && (l.Country == 'Australia' || l.Country == ' New Zealand' || l.Country == 'AU' || l.Country == 'NZ' || l.Country == 'NZD' || l.Country == 'AUS'
                                        || l.Country.equalsIgnoreCase('Hong Kong') || l.Country.equalsIgnoreCase('South Africa') ||  l.Country.equalsIgnoreCase('Singapore') 
                                        || l.Country.equalsIgnoreCase('HK') || l.Country.equalsIgnoreCase('SG') || l.Country.equalsIgnoreCase('ZA')
                                    ))
                            {
                                // Assign the lead to the Direct AU Queue
                                strNewOwnerId = l.OwnerId = mpLeadQueueNameToId.get('Direct AU Queue');
                            }
 /*                           else if (strExperience.contains('Switching from a Competitor') )
                            {
                            	strNewOwnerId = l.OwnerId = Label.Lead_Acq_Owner;
                            }
 */                           
                            else if (l.Email != 'unknown@example.com'  && strCurrentOwnerId != mpLeadQueueNameToId.get('Direct Sales Queue'))
                            {
                                // Assign the lead to the Direct AU Queue
                                strNewOwnerId = l.OwnerId = mpLeadQueueNameToId.get('Direct Sales Queue');
                            }
                        }
                    }
                    
                    // If the lead is currently owned by a Queue then it needs to go through Round Robin
                    if (strNewOwnerId.startsWith('00G'))
                    {
                        // Since it was assigned to a queue at it the Round Robin list
                        lstLeads4RoundRobin.add(l);
                    }
                }
                
                system.debug('***LeadTrigger: - After Assignment OwnerId: ' + strNewOwnerId);   
            }
                
            system.debug('***LeadTrigger: Sending to Run Round Robin - ' + lstLeads4RoundRobin);
            
            if (!lstLeads4RoundRobin.isEmpty())
            {
                // Check if the Leads needs to be assigned using Round Robin
                RoundRobin.RoundRobinForLead(lstLeads4RoundRobin);
                
                system.debug('@@@ Round Robin Finished: lstLeads: ' + lstLeads4RoundRobin);
                system.debug('***LeadTrigger: Round Robin Assigned Lead to new Owner: ' + lstLeads4RoundRobin[0].OwnerId);
            }
        }
        
        /*
        if (trigger.isAfter && trigger.isUpdate && SObjectUtils.ResetSubOwnersForLeadOwnerChanges == true)
        {
            set<Id> stLeadId = new set<Id>();
            list<Subscription__c> lstSubsForOwnerChange = new list<Subscription__c>();
            
            for(Lead l : trigger.new)
            {
                // Check if the owner has changed
                if (l.OwnerId != trigger.oldMap.get(l.Id).OwnerId)
                {
                    stLeadId.add(l.Id);
                }
            }
            
            if (!stLeadId.isEmpty())
            {
                try
                {
                    // Find all the subscriptions associated to these leads where no Partner ID exist
                    for (Subscription__c s : [SELECT Id, Lead__c, OwnerId, MBAPartnerID__c
                                                FROM Subscription__c
                                                WHERE Lead__c IN :stLeadId
                                                    AND MBAPartnerID__c = null])
                    {
                        s.OwnerId = trigger.newMap.get(s.Lead__c).OwnerId;
                        lstSubsForOwnerChange.add(s);
                    }
                    
                    if (!lstSubsForOwnerChange.isEmpty())
                    {
                        database.update(lstSubsForOwnerChange, Subscription_Utility.blnAllOrNone);
                    }
                }
                catch (Exception exc)
                {
                    system.debug('***LeadTrigger: After Event Error.....Error trying to Update Subscription with Lead Id');
                    ErrorEmailHelper.notifyOnError('LeadTrigger', 'LeadTrigger After Event Error', 'LeadTrigger: After Event Error trying to Update Subscription with Lead Id', exc.getMessage());
                }
            }
        }
        */
    }
    
    system.debug('@@@ Lead Trigger End');
    /*
    // Trigger code when trying to run Round Robin after Standard Assignment Rules fire
    
    system.debug('***LeadTrigger: - lookUpRollUpIsRunning: ' + SObjectUtils.lookUpRollUpIsRunning);
    system.debug('***LeadTrigger: - SubscriptionLogicRunning: ' + SObjectUtils.SubscriptionLogicRunning);
    system.debug('***LeadTrigger: - SentToRoundRobinFuture: ' + SObjectUtils.SentToRoundRobinFuture);
    
    system.debug('@@@ Lead Trigger Start');
    
    list<Lead> lstLeads = new list<Lead>();
    
    if (!SObjectUtils.lookUpRollUpIsRunning)
    {   
        // If this is a before trigger for an update caused by the SetupForRoundRobin future class
        if (trigger.isBefore)
        {
            system.debug('***LeadTrigger - Before Event');  
            
            if (trigger.isUpdate)
            {
                lstLeads = new list<Lead>();
                
                for (Lead l : trigger.new)
                {
                    string strOwnerId = string.valueOf(l.OwnerId);
                    if (l.No_Assign__c == false && l.IsConverted == false && strOwnerId.startsWith('00G') && SObjectUtils.RoundRobinLogicRunning == true)
                    {
                        lstLeads.add(l);
                    }       
                }
                
                system.debug('***LeadTrigger: Sending to Run Round Robin - ' + lstLeads);
                
                if (!lstLeads.isEmpty())
                {
                    system.debug('@@@ Calling Round Robin: lstLeads: ' + lstLeads[0].OwnerId);
    
                    // Check if the Leads needs to be assigned using Round Robin
                    RoundRobin.RoundRobinForLead(lstLeads);
                    
                    system.debug('@@@ Round Robin Finished: lstLeads: ' + lstLeads[0].OwnerId);
                }
            }
        }
        // If this is an after trigger NOT caused by a future method then send to future for round robin
        else if (trigger.isAfter)
        {
            system.debug('***LeadTrigger - After Event');
            
            if (!System.isFuture() && SObjectUtils.SubscriptionLogicRunning == false && SObjectUtils.RoundRobinLogicRunning == false && SObjectUtils.SentToRoundRobinFuture == false)
            {
                set<Id> stIds = new set<Id>(); 
                
                for (Lead l : trigger.new)
                {
                    if (!l.No_Assign__c && l.IsConverted == false)
                    {
                        stIds.add(l.Id);
                    }
                }
                
                system.debug('***LeadTrigger: Sending to Set up For Round Robin - ' + stIds);
                
                if (!stIds.isEmpty())
                {
                    system.debug('@@@ Setup for Round Robin called with Leads: ' + stIds);
                    SObjectUtils.SentToRoundRobinFuture = true;
                    RoundRobin.SetupForRoundRobin(stIds); 
                }
            }
        }
    }
    */
}