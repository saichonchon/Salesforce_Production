public class RVAccountHelper {
	
	public static Map<String, Id> fetchUserNames (List<String> lstaccowner)
	{
		string soqlWHERE = '';
		system.debug('list '+lstaccowner);
		for (string s :lstaccowner)
		{
			soqlWHERE += (soqlWHERE.length() == 0 ? '' : ', ') + '\'' + s + '\'';
        }
        string query1 = 'Select Id, firstName, LastName, Full_Name__c from User where Full_Name__c  IN (' + soqlWHERE  + ')';
		system.debug ('*** query ' +query1);						
		Map<String, Id> mpUserName =  new Map<String, Id>();
		List<User> lstUsers = database.query(query1);
		
		for (User u :lstUsers)
		{
			mpUserName.put(u.Full_Name__c, u.Id);
		}
		return  mpUserName ;
	}
	
	
	public static void UpdatePartnerOppOwner(Map<Id, rvpe__RVAccount__c> mpNewrvAcc, Map<Id, Id> mpOldrvAcc)
    {        
            List<Opportunity> opps = new List<Opportunity>([select Id, OwnerId,AccountId, rvpe__RVAccount__c  from Opportunity where isClosed = false and  rvpe__RVAccount__c in :mpNewrvAcc.KeySet() ]);
            List<Opportunity> updopps = new List<Opportunity>();
            
            for (Opportunity o :opps)
            {
              if ( mpNewrvAcc.get(o.rvpe__RVAccount__c) <> null
                 && o.OwnerId <> mpNewrvAcc.get(o.rvpe__RVAccount__c).OwnerId
                 && ( o.OwnerId == mpOldrvAcc.get(o.rvpe__RVAccount__c))
                 )
              {
                  o.OwnerId = mpNewrvAcc.get(o.rvpe__RVAccount__c).OwnerId;
                  updopps.add(o);
              }
   
            }
            
            try
            {
                
                update updopps;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('RV Account Trigger Handler', 'after update', 'Error in RV Account Trigger Handler - update ', ': update Partner Opportunity' );
 
               system.debug('***ERROR: RV AccountTrigger:: ' + exc.getStackTraceString());
            }
    }      

	public static void UpdateRVMember(Map<Id, rvpe__RVAccount__c> mpNewrvAcc, Map<Id, Id> mpOldrvAcc)
    {        
 		List<rvpe__RVMember__c> mems = new List<rvpe__RVMember__c>([select Id, OwnerId, rvpe__RVAccount__c  from rvpe__RVMember__c where  rvpe__RVAccount__c in :mpNewrvAcc.KeySet() ]);
        List<rvpe__RVMember__c> updmems = new List<rvpe__RVMember__c>();
            
            for (rvpe__RVMember__c m :mems)
            {
              if ( 
                 	 m.OwnerId <> mpNewrvAcc.get(m.rvpe__RVAccount__c).OwnerId
                 )
              {
                  m.OwnerId = mpNewrvAcc.get(m.rvpe__RVAccount__c).OwnerId;
                  updmems.add(m);
              }
   
            }
            
            try
            {
                
                update updmems;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('RV Account Trigger Handler', 'after update', 'Error in RV Account Trigger Handler - update ', ': update Partner Opportunity' );
 
               system.debug('***ERROR: RV AccountTrigger:: ' + exc.getStackTraceString());
            }
    }
}