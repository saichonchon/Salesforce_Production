trigger RVAccount on rvpe__RVAccount__c (after insert, after update, before insert, 
before update)
{

// Set the owner of the RV Account
    if (trigger.isBefore)
    {
        Map <Id, rvpe__RVAccount__c > mapRVacct = new Map <Id, rvpe__RVAccount__c >();
        List<String> lstRVAcctOwner = new List<String>();
        Map<String, Id> mpUserName = new Map<String, Id> ();
        
        for(rvpe__RVAccount__c  rvacc : trigger.new)
        {
            
            if(rvacc.Account_Owner__c <> null 
            	&& (rvacc.OwnerId == Label.Lead_PRM_Owner 
            		|| ( trigger.isUpdate && rvacc.Account_Owner__c  <> trigger.oldMap.get(rvacc.id).Account_Owner__c )          
                   ))
            {      
              mapRVacct.put(rvacc.Id, rvacc);
              lstRVAcctOwner.add(rvacc.Account_Owner__c);
            }
                  
        }
        if (mapRVacct.size() > 0) 
        {
            mpUserName = RVAccountHelper.fetchUserNames(lstRVacctowner);
        }
        
       for(rvpe__RVAccount__c  rvacc : trigger.new)
        {
            
            if( mpUserName.get(rvAcc.Account_Owner__c) <> null)
            {      
               rvacc.OwnerId = mpUserName.get(rvAcc.Account_Owner__c);
            }
            else if (rvacc.Account_Owner__c == Label.RV_Account_Owner)   
            {
            	rvacc.OwnerId =  Label.Lead_PRM_Owner ;
            }   
        }
         
   }
    
    if (trigger.isUpdate && trigger.isAfter)
    {
        Map <Id, rvpe__RVAccount__c > mapacct = new Map <Id, rvpe__RVAccount__c >();
        Map <Id, Id> mapacctowner = new Map <Id, Id>();
 
        for(rvpe__RVAccount__c  acc : trigger.new)
        {
            
            if(acc.OwnerId!= trigger.oldMap.get(acc.id).OwnerId)
            {      
              mapacct.put(acc.Id, acc);  
              mapacctowner.put(acc.Id, trigger.oldMap.get(acc.id).OwnerId);
                                    
            }
                  
        }
    if (mapacctowner.size() > 0) RVAccountHelper.UpdatePartnerOppOwner(mapacct, mapacctowner);
    if (mapacctowner.size() > 0) RVAccountHelper.UpdateRVMember(mapacct, mapacctowner);
   }
}