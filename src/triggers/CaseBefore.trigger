trigger CaseBefore on Case (before insert, before update) {

   // This is a before Trigger !!!  
        
    if (Trigger.isBefore && Trigger.isInsert)
    {
        CaseHandle_Helper.updateEIGCase( Trigger.new);       
    }
    
    if (Trigger.isBefore && Trigger.isUpdate)
    {   
        Set<Id> stCaseId = new Set<Id>();
        list<Case> lstCaseToUpdate = new list<Case>();
        
        Id idCSCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
     	
     	List<Case> upDcases = new List<Case>();
     	
        for (Case c : trigger.New)
        {
            if (c.RecordTypeId == idCSCaseRecordType)
            {
                 lstCaseToUpdate.add(c);  
 /*                
                if (c.Ownerid == userinfo.getUserId()
                		&& c.Change_Owner__c <> 'Me'  )
                {
                	updCases.add(c);
                }
                else
  */
                 if (c.Change_Owner__c == 'Me'  
                		&& c.Ownerid <> userinfo.getUserId() 
                		&& UserInfo.getProfileId()<> Label.API_User_Profile) 
		                {
		                	c.Ownerid = userinfo.getUserId();
		                }
                
                else if (!StaticVariables.caseOwnerButtonUpdate
                			&& UserInfo.getProfileId()<> Label.API_User_Profile 
                			&& c.Change_Owner__c <> null 
                			&& c.Change_Owner__c <> trigger.oldMap.get(c.Id).Change_Owner__c 
                		)
                	{
						 system.debug(' support entered');
						 if (c.Change_Owner__c <> 'Me')
	               		 updCases.add(c);
                	}
            }
         }
         Boolean updateCases = false;
        
        if (!lstCaseToUpdate.isEmpty())
        {
            if (!CaseHandle_Helper.ALREADY_RAN)
            {
                CaseHandle_Helper.ALREADY_RAN = true;
                CaseHandle_Helper.rollUpCaseHandleTimeCases( updateCases, lstCaseToUpdate);
            }
        }

         if (!updCases.isEmpty()) 
         {
         	CaseOwnerUpdate cs = new CaseOwnerUpdate();
         	cs.setCaseOwner(updCases);
         }
    }   
}