public class AccountTriggerHandler {

/*       
    private static Map<String, AccountTeamMember> currentAccountTeamMembersMap;

 
    public static void AddToAccountTeam(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
                                        List<Account> newList,  List<Account> oldList, Map<Id, Account> newMap)
    {    
       List<AccountTeamRoleWrapper> atrList = new List<AccountTeamRoleWrapper>();   
       Set<id> acctIds = new Set<Id>();  
       
       for(integer i = 0; i < newList.size(); i++)
       {
                if (newList[i].SSC__C != null
                    && (isInsert || (!isInsert  && newList[i].SSC__C != oldList[i].SSC__C )))
                 {
                    atrList.add(new AccountTeamRoleWrapper(newList[i].Id, newList[i].SSC__C ,  'Success Squad Consultant'));
                    acctIds.add(newList[i].Id);
                 } 
                if (newList[i].Ltc__c != null
                     && (isInsert || (!isInsert  &&  newList[i].Ltc__c != oldList[i].Ltc__c )))
                 {
                    atrList.add(new AccountTeamRoleWrapper(newList[i].Id, newList[i].Ltc__c ,  'Launch Team Commando'));
                    acctIds.add(newList[i].Id);
                 } 

        }
             
        if (atrList.size() > 0)
                 {   
                    Set<String> roles = new Set<String>{'Success Squad Consultant','Launch Team Commando' };    
                    setExistingRoles(acctIds, roles);       
                    addAccountTeamRoles(atrList);   
                 }     
        
    }
    
  //create  roles if it does not already exist  
     private static void addAccountTeamRoles(List<AccountTeamRoleWrapper> atrList){   
         string uniqueId; 
          
         List<AccountTeamMember> atrsToInsert = new List<AccountTeamMember>();   
         List<AccountTeamMember> atrsToDelete = new List<AccountTeamMember>(); 
          for(AccountTeamRoleWrapper atr:atrList)
          {      
            uniqueId = atr.accountId + '-' + atr.UserId + '-' + atr.Role; 
            
            if(!currentAccountTeamMembersMap.containsKey(uniqueId))
            {   if (atr.UserId <> null && atr.AccountId <> null && atr.Role<> null)   
                 {
                    AccountTeamMember atrole = new AccountTeamMember();      
                    atrole.AccountId = atr.AccountId;        
                    atrole.UserId = atr.UserId;        
                    atrole.TeamMemberRole = atr.Role;             
                    atrsToInsert.add(atrole); 
                    for (String uniqueIdr :currentAccountTeamMembersMap.keySet())
                    {      
                      AccountTeamMember oldatr = currentAccountTeamMembersMap.get(uniqueIdr);      
                      if (oldatr.AccountId ==atr.AccountId && oldatr.TeamMemberRole == atr.Role)    
                          {      
                            atrsToDelete.add(oldatr); 
                          }
                    }
                 }
             } 
              
          }   
          if (atrsToInsert.size() > 0)
              {      
                try 
                {
                    insert atrsToInsert; 
                }
                catch (Exception exp)
                     {  system.debug ('failed to add account team'+exp);                                             
                     }  
              } 
          if (atrsToDelete.size() > 0)
           {      
                try 
                {
                    delete atrsToDelete;   
                }
                catch (Exception exp)
                     {  system.debug ('failed to delete account team'+exp);  
                                             
                     }  
              } 
            
   }
   
  //delete   
    private static void deleteAccountTeamRoles(Set<String> uniqueIds){ 
     List<AccountTeamMember> atrsToDelete = new List<AccountTeamMember>(); 
       Set<Id> atrIds = new Set<Id>();   
        for(String uniqueId:uniqueIds)
        {     
           List<String> parts = uniqueId.split('-');
           for (String uniqueIdr :currentAccountTeamMembersMap.keySet())
            {      
              AccountTeamMember oldatr = currentAccountTeamMembersMap.get(uniqueIdr);      
              if (oldatr.AccountId == parts[0] && oldatr.TeamMemberRole == parts[1])    
                  {      
                    atrsToDelete.add(oldatr); 
                  }
             }
              
         }      
         if (atrsToDelete.size() > 0)
            {      delete atrsToDelete;    }   
    }  
   
   private static void setExistingRoles(Set<Id> acctIds, Set<String> roles)
   { 
         
         if (currentAccountTeamMembersMap == null)
         {   
            currentAccountTeamMembersMap = new Map<String, AccountTeamMember>();  
         }
         else
         {   currentAccountTeamMembersMap.clear();      }    
             
           
                  
         List<AccountTeamMember> atrs = [Select a.User.Name, a.UserId, TeamMemberRole, AccountId
                                         From AccountTeamMember a 
                                         where TeamMemberRole in :roles 
                                         and accountId in :acctIds];    
         string uniqueId; 
                         
         for(AccountTeamMember atr:atrs)
          {        
             uniqueId = atr.accountId + '-' + atr.UserId + '-' + atr.TeamMemberRole;   
//             uniqueIdr = atr.accountId + '-' + atr.UserId + atr.TeamMemberRole;   
             currentAccountTeamMembersMap.put(uniqueId, atr);  
              
           } 
     }    
     public class AccountTeamRoleWrapper{    
        public Id userId {get;set;}    
        public Id accountId {get; set;}    
        public string role {get; set;}        
        public AccountTeamRoleWrapper(Id aId, Id cId,  string rl)
        {      userId = cId;     
               accountId = aId;     
               role = rl;    }
     }   
 */   
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