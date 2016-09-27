public class CaseTeamHandler {
      
    private static Map<String, CaseTeamMember> currentCaseTeamMembersMap;
	private static Map<Id, CaseTeamRole> mapctrs = new Map<Id, CaseTeamRole>();
	private static Map<String, Id> mapRoleId = new Map<String, ID>();
 	 
    public static void AddToCaseTeam(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
                                        List<Case> newList,  List<Case> oldList, Map<Id, Case> newMap)
    {    
       List<CaseTeamRoleWrapper> atrList = new List<CaseTeamRoleWrapper>();   
       Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
  
       Set<id> caseIds = new Set<Id>();  
       
       for(integer i = 0; i < newList.size(); i++)
       {
       	   if (isInsert && newList[i].RecordTypeId == idCaseRecordType)
                 {
                    atrList.add(new CaseTeamRoleWrapper(newList[i].Id, newList[i].CreatedById ,  'Sales Rep'));
                    caseIds.add(newList[i].Id);
                 } 

        }
             
        if (atrList.size() > 0)
                 {   
                    Set<String> roles = new Set<String>{'Sales Rep' };    
                    setExistingRoles(caseIds, roles);       
                    addCaseTeamRoles(atrList);   
                 }     
        
    }
    
  //create  roles if it does not already exist  
     private static void addCaseTeamRoles(List<CaseTeamRoleWrapper> atrList){   
         string uniqueId; 
          
         List<CaseTeamMember> atrsToInsert = new List<CaseTeamMember>();   
         List<CaseTeamMember> atrsToDelete = new List<CaseTeamMember>(); 
          for(CaseTeamRoleWrapper atr:atrList)
          {      
            uniqueId = atr.CaseId + '-' + atr.MemberId + '-' + atr.Role; 
            
            if(!currentCaseTeamMembersMap.containsKey(uniqueId))
            {   if (atr.MemberId <> null && atr.CaseId <> null && atr.Role<> null)   
                 {
                    CaseTeamMember atrole = new CaseTeamMember();      
                    atrole.ParentId = atr.CaseId;        
                    atrole.MemberId = atr.MemberId;        
                    atrole.TeamRoleId = mapRoleId.get(atr.Role);             
                    atrsToInsert.add(atrole); 
                    for (String uniqueIdr :currentCaseTeamMembersMap.keySet())
                    {      
                      CaseTeamMember oldatr = currentCaseTeamMembersMap.get(uniqueIdr);      
                      if (oldatr.ParentId ==atr.CaseId && oldatr.TeamRole.Name == atr.Role)    
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
    private static void deleteCaseTeamRoles(Set<String> uniqueIds){ 
     List<CaseTeamMember> atrsToDelete = new List<CaseTeamMember>(); 
       Set<Id> atrIds = new Set<Id>();   
        for(String uniqueId:uniqueIds)
        {     
           List<String> parts = uniqueId.split('-');
           for (String uniqueIdr :currentCaseTeamMembersMap.keySet())
            {      
              CaseTeamMember oldatr = currentCaseTeamMembersMap.get(uniqueIdr);      
              if (oldatr.ParentId == parts[0] && mapRoleId.get(oldatr.TeamRoleId) == parts[1])    
                  {      
                    atrsToDelete.add(oldatr); 
                  }
             }
              
         }      
         if (atrsToDelete.size() > 0)
            {      delete atrsToDelete;    }   
    }  
   
   private static void setExistingRoles(Set<Id> caseIds, Set<String> roles)
   { 
         
         if (currentCaseTeamMembersMap == null)
         {   
            currentCaseTeamMembersMap = new Map<String, CaseTeamMember>();  
         }
         else
         {   currentCaseTeamMembersMap.clear();      }    
             
                 
         for (CaseTeamRole ctr : [Select c.Id, c.Name From CaseTeamRole c where Name in :roles])
         {
         	mapctrs.put(ctr.Id, ctr);
         	mapRoleId.put(ctr.Name, ctr.Id);
         }
                   
         List<CaseTeamMember> atrs = [Select a.MemberId, TeamRoleId, TeamRole.Name, ParentId
                                         From CaseTeamMember a 
                                         where TeamRoleId in :mapctrs.Keyset()
                                         and ParentId in :caseIds];    
         string uniqueId; 
                         
         for(CaseTeamMember atr:atrs)
          {        
             uniqueId = atr.ParentId + '-' + atr.MemberId + '-' + atr.TeamRole.Name;   
	          currentCaseTeamMembersMap.put(uniqueId, atr);  
              
           } 
     }    
     public class CaseTeamRoleWrapper{    
        public Id MemberId {get;set;}    
        public Id CaseId {get; set;}    
        public string role {get; set;}        
        public CaseTeamRoleWrapper(Id aId, Id cId,  string rl)
        {      MemberId = cId;     
               CaseId = aId;     
               role = rl;    }
     }      
}