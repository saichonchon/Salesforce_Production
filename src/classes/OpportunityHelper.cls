public class OpportunityHelper {

 public static Id idOppRecordType =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();

	public  Opportunity createOppProfFromAcc(Id acctId)
	{
        //create an opportunity
        Account acc = [select id, name, SSC__c, LTC__c from Account where id =:acctId];
         
        Opportunity opp = defaultOpportunityProf();
        opp.AccountId = acc.Id;
        opp.Name = acc.Name + '- Professional Services';
        opp.RecordTypeId = idOppRecordType;
        opp.Success_Squad_Consultant__c = acc.SSC__c;
        opp.Launch_Team_Commando__c = acc.ltc__c;
	    try {																 
			insert opp;
			}
		catch(Exception e) 
		{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error inserting Opportunity - ' + e.getMessage()));
        }		    
	        
	     return opp;
	}
	
	public  Opportunity createOppProfFromCon(Id conId)
	{
        //create an opportunity
       Contact con = [select id, name, AccountId, Account.Name from Contact where id =:conId];
         
        Opportunity opp = defaultOpportunityProf();
        opp.AccountId = con.AccountId;
        opp.RecordTypeId = idOppRecordType;
        opp.Name = con.Account.Name + '- Professional Services';
        string crole ='Professional Services Contact';
       try {																 
			insert opp;
			createContactRole(opp.Id, con.Id, crole);
		}
		catch(Exception e) 
		{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error inserting Opportunity - ' + e.getMessage()));
        }		
	    return opp;
	}
	
	public static Opportunity createOppProfFromOpp(Id oppId)
	{
        //create an opportunity
       Opportunity o = [select id, name, AccountId, Contact__r.Id, Account.Name, Subscription__c, Source__c from Opportunity where id =:oppId];
         
        Opportunity opp = defaultOpportunityProf();
        opp.AccountId = o.AccountId;
        opp.RecordTypeId = idOppRecordType;
//        opp.Name = o.Account.Name + '- Professional Services';
		opp.Name = 'PS: ' + DataUtility.TruncateString(o.Name, 75);
        opp.Store_Opportunity__c = o.Id;
        opp.Subscription__c = o.Subscription__c;
        string crole ='Professional Services Contact';
        if (o.Source__c == 'BMP') opp.Pricebook2Id = Label.Zuora_PS;
       try {																 
			insert opp;
			createContactRole(opp.Id, o.Contact__r.Id, crole);
		}
		catch(Exception e) 
		{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error inserting Opportunity - ' + e.getMessage()));
        }		
	    return opp;
	}
	
	public static Opportunity defaultOpportunityProf()
	{
		    Opportunity opp = new Opportunity();
	        opp.RecordTypeId = idOppRecordType;
	        opp.Pricebook2Id = Label.Bigcommerce_Pricebook;
	        opp.StageName ='Lead';
	        opp.Type = 'Existing Client';
	        opp.CloseDate = date.today().addDays(14);
	        return opp;
	}
	
	public static  map<Id, Id> getContactFromRole(Set<Id> oppIds, string crole)
	{
		List<OpportunityContactRole> crs = new List<OpportunityContactRole>([Select Role,ContactId, OpportunityId, Id
																		From OpportunityContactRole 
																		where OpportunityId in :oppIds
																		and role =:crole]);
		Map <Id, Id> oppCon = new Map<Id, Id>();														
        for (OpportunityContactRole cr :crs)
        {
        	oppCon.put(cr.OpportunityId, cr.ContactId);
        }
        return oppCon;
	}
	public static void  createContactRole(Id oppId, Id conId, string crole)
	{
		OpportunityContactRole cr = new OpportunityContactRole(Role = crole,ContactId =conId, 
																OpportunityId =oppId);
		try {																 
			insert cr;
			}
		catch(Exception e) 
		{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Error inserting Contact role - ' + e.getMessage()));
        }														
        
        
	}
	
	public static void storeOppTeamMembers(map<Id, Opportunity> oldMap, map<Id, Opportunity> newMap)
{
	if(oldMap != null && newMap != null)
	{
		Id oId;
		
		map<Id, list<OpportunityTeamMember>> mapOTMs = new map<Id, list<OpportunityTeamMember>>();
		list<OpportunityTeamMember> lstOTMs = new list<OpportunityTeamMember>();
		list<OpportunityTeamMember> existlstOTMs = new list<OpportunityTeamMember>([SELECT o.UserId, o.OpportunityId, o.TeamMemberRole
	                 						 FROM OpportunityTeamMember o
	                 						 WHERE o.OpportunityId =: newMap.keySet()
	                 						 ORDER BY OpportunityId]);
                 						 
		system.debug('## hlpr_Opportunity storeOppTeamMembers lstOTMs: ' + lstOTMs);
		if (!existlstOTMs.isEmpty())
		{
	        for(OpportunityTeamMember otm : existlstOTMs)
			{
				if(oId == null)
					oId = otm.OpportunityId;
					
				if(oId == otm.OpportunityId)
					lstOTMs.add(otm);
				else
				{
					mapOTMS.put(oId, lstOTMs);
					oId = otm.OpportunityId;
					lstOTMs = new list<OpportunityTeamMember>();
					lstOTMs.add(otm);
				}
			}
			
			if(!lstOTMs.isEmpty())
				mapOTMS.put(oId, lstOTMS);
			
			system.debug('## hlpr_Opportunity storeOppTeamMembers mapOTMS: ' + mapOTMS);
			StaticVariables.mapOOTMs = mapOTMS;
	    }
/*		for (Opportunity Opp : newMap.values())
		{
            if (oldMap.get(Opp.id).OwnerId != Opp.OwnerId)
 //               Opp.OpportunityTeamMembers__c = String.valueOf(mapOTMs.get(Opp.Id));
                
//			system.debug('## hlpr_Opportunity storeOppTeamMembers Opp.OpportunityTeamMembers__c: ' + Opp.OpportunityTeamMembers__c);
		}
		*/
	}
}

	public static void setOppTeamMembers(map<Id, Opportunity> mapOppsOld, map<Id, Opportunity> mapOppsNew)
 {
 		OpportunityTeamMember otm;
 		
 		list<OpportunityTeamMember> lstOTMs = new list<OpportunityTeamMember>();
// 		Schema.DescribeFieldResult fieldResult = OpportunityTeamMember.TeamMemberRole.getDescribe();
//		List<Schema.PicklistEntry> lstPickVals  = fieldResult.getPicklistValues();
//		String tmRole = lstPickVals[0].getValue();
 		
 	
 		if(mapOppsOld != null)
 		{
  		//Insert old team members
	  		for (Opportunity Opp : mapOppsNew.values())
	  		{
	            // Only if the record owner changed
	            if (mapOppsOld.get(Opp.id).OwnerId != Opp.OwnerId)
				{            	
	   //             system.debug('##  setOppOwnerTeamMember Opp.OpportunityTeamMembers__c: ' + Opp.OpportunityTeamMembers__c);
	                list<OpportunityTeamMember> otms = StaticVariables.mapOOTMs.get(Opp.Id);
		            if (otms <> null && otms.size() >0 )
		            {
		                for (OpportunityTeamMember ot:otms)
		   				{
		                   if (ot.userid <> Opp.OwnerId)  
		                   {  otm = new OpportunityTeamMember();
							 otm.UserId = ot.UserId;
							 otm.OpportunityId = ot.OpportunityId;
							 otm.TeamMemberRole = ot.TeamMemberRole;
	//	                     lstOTMs.addAll(otms);
							lstOTMs.add(otm);
		                   }
						} 
		            }
				  }
	  			}	  		
		}
		system.debug('## hlpr_Opportunity setOppTeamMembers lstOTMs: ' + lstOTMs);
 	
		if(!lstOTMs.isEmpty())
		{ Try{
			 	insert lstOTMs;
		  }catch(exception e) {system.debug ('*** failed to insert');}
		}
  }
  
}