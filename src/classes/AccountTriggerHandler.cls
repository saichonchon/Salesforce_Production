public class AccountTriggerHandler {
  
//update sub and opportunity owner
    public static void UpdateSubOwner( Map<Id, Account> mapaccOwner)
    {    
    	Id idPartnerRecordType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Channel Partner Record Type').getRecordTypeId();
 		Id idClientRecordType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Record Type').getRecordTypeId();
 		Id idBMPClientRecordType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('BMP Client').getRecordTypeId();
 		
 		
 		Map<Id, Account> mapchAcc = new Map<Id, Account> ();
    	Map<Id, Account> mapAcc = new Map<Id, Account> ();
    	
 		
		for (Account a : mapaccOwner.Values())
		{
			if (a.RecordTypeId == idPartnerRecordType)
				mapchAcc.put(a.Id, a);
			if (a.RecordTypeId == idClientRecordType || a.RecordTypeId == idBMPClientRecordType )
				mapAcc.put(a.Id, a);    
			
		}
            
    	if (!mapchAcc.isEmpty()) UpdatePartnerOppOwner(mapchAcc);
        if (!mapAcc.isEmpty()) UpdateOppOwner(mapAcc);
    		
            
    }
    
    public static void UpdateContactOwner( Map<Id, Id> mapAccOwner)
    {    
    	List<Contact> cons = new List<Contact>([select Id, OwnerId, AccountId from Contact where  AccountId in :mapaccOwner.KeySet()]);
        List<Contact> updcons = new List<Contact>();  
        
        for (Contact con :cons)
            {
            	if (con.OwnerId <> mapaccOwner.get(con.AccountId))
            	{
            		con.OwnerId = mapaccOwner.get(con.AccountId);
            		system.debug('Contact Owner '+con.OwnerId);
            		updcons.add(con);
            	}
            }
            
            try
            {
                
                update updcons;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('Account Trigger Handler', 'after update', 'Error in Account Trigger Handler - update ', ': update Contact' + cons[0].Id);
 
               system.debug('***ERROR: AccountTrigger:: ' + exc.getStackTraceString());
            }
    }
    
            
    public static void UpdateOppOwner(Map<Id, Account> mapAcc)
    {        
        List<Schema.RecordType> recordTypes = [select Id, Name, DeveloperName, SObjectType from RecordType where SObjectType = 'Opportunity'];
        List<Id> omitOppRecordTypes = new List<Id>();
        for (RecordType rt : recordTypes)
        {
            // record types to ignore when updating ownership
            if (rt.DeveloperName == 'SBD_Upsell' || rt.DeveloperName == 'Upgrade_Store' || rt.DeveloperName == 'Professional_Services')
            {
                omitOppRecordTypes.add(rt.Id);
            }
        }

        List<Opportunity> opps = new List<Opportunity>([select Id, OwnerId, AccountId, Channel_Partner__c from Opportunity where isClosed = false and  AccountId in :mapAcc.KeySet() and recordTypeId not in :omitOppRecordTypes ]);
        List<Opportunity> updopps = new List<Opportunity>();
        system.debug('user profile id '+UserInfo.getProfileId() );
        
        for (Opportunity o :opps)
        {
        	if ( StaticVariables.runningAccRoundRobin ||
        	     (
        	     (o.Channel_Partner__c == null || o.OwnerId == Label.Account_Default_Owner )
        		 && (o.OwnerId == Label.Account_Default_Owner 
        		 || UserInfo.getProfileId() <> Label.Sales_Rep_Profile
        		 || o.OwnerId == UserInfo.getUserId())
        	     && o.OwnerId <> mapAcc.get(o.AccountId).OwnerId)
        	     )
        	{
        		{
        			o.OwnerId = mapAcc.get(o.AccountId).OwnerId;
        			 system.debug('***AccountTrigger:: updating Opportunity Owner **');
        			updopps.add(o);
        		}
        	}

        }
        
        try
        {
            
            update updopps;
        }
        catch(Exception exc)
        {
           ErrorEmailHelper.notifyOnError('Account Trigger Handler', 'after update', 'Error in Account Trigger Handler - update ', ': update Opportunity'+updopps );

           system.debug('***ERROR: AccountTrigger:: ' + exc.getStackTraceString());
        }
    }  
    
    public static void UpdatePartnerOppOwner(Map<Id, Account> mapchAcc)
    {        
            List<Opportunity> opps = new List<Opportunity>([select Id, OwnerId, AccountId, Channel_Partner__c from Opportunity where isClosed = false and  Channel_Partner__C in :mapchAcc.KeySet() ]);
            List<Opportunity> updopps = new List<Opportunity>();
            
            for (Opportunity o :opps)
            {
            	if ( o.Channel_Partner__c <> null 
            	   && mapchAcc.get(o.Channel_Partner__c) <> null
            	   && o.OwnerId <> mapchAcc.get(o.Channel_Partner__c).OwnerId)
            	{
            		{
            			o.OwnerId = mapchAcc.get(o.Channel_Partner__c).OwnerId;
            			updopps.add(o);
            		}
            	}
   
            }
            
            try
            {
                
                update updopps;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('Account Trigger Handler', 'after update', 'Error in Account Trigger Handler - update ', ': update Partner Opportunity' );
 
               system.debug('***ERROR: AccountTrigger:: ' + exc.getStackTraceString());
            }
    }      
}