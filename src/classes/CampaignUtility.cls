public  class CampaignUtility {


   public static Map<String,Id> LoadNameCampaignIdMap()
  {
    system.debug('***LoadNameMap');
    map<string, Id> mpRetVal = new map<string, Id>();
     
     //Retrieve custom setting
    Map<String, CampaignRules__c> mpcampaigns = CampaignRules__c.getAll();
  
    // Find the unique list of campaign Ids from the custom setting
    for (CampaignRules__c s : mpcampaigns.Values())
    {
     
      mpRetVal.put(s.Name, s.Campaign_Id__c);
    }
   
    return mpRetVal;
  }
  
  public static Map<String,Id> LoadNameCampaignIdMap( String rule)
  {
    
    map<string, Id> mpRetVal = new map<string, Id>();
     
     //Retrieve custom setting
    Map<String, CampaignRules__c> mpcampaigns = CampaignRules__c.getAll();
  
    // Find the unique list of campaign Ids from the custom setting
    for (CampaignRules__c s : mpcampaigns.Values())
    {
      if (s.Rule_Name__c == rule)
      mpRetVal.put(s.Name, s.Campaign_Id__c);
    }
   
    return mpRetVal;
  }
  public static String getCampaignId(Decimal prevMonRev)
  {
 	List<campaignRules__c> camRules = new List<campaignRules__c> ([select Name, Campaign_ID__c, Starting_GMV__c, Ending_GMV__c 
 																	from CampaignRules__c where Rule_Name__c = 'GMV'
 																	order by Starting_GMV__c asc ]);
	String camId;
	
    for (CampaignRules__c s : camRules)
    {
      if (prevMonRev >= s.Starting_GMV__c && prevMonRev < s.Ending_GMV__c)
      {
      	 camId = s.Campaign_Id__c;
         break;
      }
    }
    system.debug( ' rules '+camId);
    return camId;
  }
  
  public static String getCampaignIdByName(String sName)
  {
 	CampaignRules__c camRule = CampaignRules__c.getInstance(sName) ;
 		
    if (camRule <> null)
     return  camRule.Campaign_Id__c;
    else return '';
  }
  
  public static CampaignRules__c getCampaignByName(String sName)
  {
 	CampaignRules__c camRule = CampaignRules__c.getInstance(sName) ;
    
	return  camRule;
    
  }
  
  public static void AddLeadToCampaign(Map<Id, Id > mapMemIdCampnId)
  {
  	    Map<Id, CampaignMember > mapContactCampaign = new Map<Id, CampaignMember >();
        for (CampaignMember cm : [SELECT Id, CampaignId, LeadId FROM CampaignMember 
        							where CampaignId in :mapMemIdCampnId.Values() and 
        							LeadId in :mapMemIdCampnId.KeySet()])
        {
        	 mapContactCampaign.put(cm.LeadId, cm);
        }

// add to campaign
		List<CampaignMember> addCamMem  = new List<CampaignMember>();
		List<CampaignMember> remCamMem  = new List<CampaignMember>();

		for (Id lId : mapMemIdCampnId.KeySet())
		{
			String newCampId ='';
			String existCamId ='';

			if (mapContactCampaign.get(lId) <> null)
			{
			    CampaignMember existCam = mapContactCampaign.get(lId);
			    existCamId = existCam.CampaignId;
			}
			newCampId = mapMemIdCampnId.get(lId);
			system.debug(' new campaign id '+newCampId);
			system.debug(' existing campaign id '+existCamId);

			if (!existCamId.contains(newCampId) )
			{
				CampaignMember cm = new CampaignMember(LeadId = lId, CampaignId = newCampId );
				addCamMem.add(cm);
				if (existCamId <> '' ) remCamMem.add(mapContactCampaign.get(lId)); 
		 	
			}
			
		}
		
		insert addCamMem;
		delete remCamMem;
  	
  } 
  
  public static void AddContactToCampaign(Map<Id, Id > mapMemIdCampnId)
  {
  	    Map<Id, List<CampaignMember> > mapDiffContactCampaign = new Map<Id, List<CampaignMember> >();
  	    Map<Id, CampaignMember > mapSameContactCampaign = new Map<Id, CampaignMember >();

        for (CampaignMember cm : [SELECT Id, CampaignId, ContactId FROM CampaignMember 
        							where CampaignId in :mapMemIdCampnId.Values() and 
        							ContactId in :mapMemIdCampnId.KeySet()])
        {
        	if (mapMemIdCampnId.get(cm.ContactId) <> cm.CampaignId)
        	{
        		List<CampaignMember> existMems = new List<CampaignMember>();
				if (mapDiffContactCampaign.containsKey(cm.ContactId) )
	        		{	 
	        			existMems = mapDiffContactCampaign.get(cm.ContactId); 
	        		}
    	 		existMems.add(cm);
    	 		mapDiffContactCampaign.put(cm.ContactId, existMems);
        		
        	}
        	else
        	  mapSameContactCampaign.put(cm.ContactId, cm);
        }

// add to campaign
		List<CampaignMember> addCamMem  = new List<CampaignMember>();
		
		for (Id conId : mapMemIdCampnId.KeySet())
		{
			String newCampId ='';
			String existCamId ='';

			if (mapSameContactCampaign.get(conId) == null)
			{
				
				newCampId = mapMemIdCampnId.get(conId);
				system.debug(' new campaign id '+newCampId);
				
				system.debug(' contact id '+conId);
	 
				if (newCampId <> null   )
				{
					CampaignMember cm = new CampaignMember(ContactId = conId, CampaignId = newCampId );
					addCamMem.add(cm);
					
				}
			}
			
		}
		
  		Try 
		{
			system.debug('Inserting '+addCamMem.size());
			insert addCamMem;
			
		}
		catch (Exception ex)
	    {
	      System.Debug('Error:'+ex.getMessage());
//			ErrorEmailHelper.notifyOnError('Campaign_Utility', 'Adding to Campaign', ex.getMessage(), 'Error with ' + );
          
		}
  } 
  public static void RemoveContactFromCampaign( Map<Id, List<CampaignMember> > mapContactCampaign)
  {
 
		List<CampaignMember> remCamMem  = new List<CampaignMember>();

		for (Id conId : mapContactCampaign.KeySet())
		{
			for (CampaignMember cm :mapContactCampaign.get(ConId))
			{
				if (mapContactCampaign.get(conId) <> null)
					{ 
						remCamMem.add(cm);
					}
			}
		}
		Try 
		{
			system.debug('Deleting '+remCamMem.size());
			delete remCamMem;
		}
		catch (Exception ex)
	    {
	      System.Debug('Error:'+ex.getMessage());
//			ErrorEmailHelper.notifyOnError('Campaign_Utility', 'Removing from Campaign', ex.getMessage(), 'Error with ' + );
          
		}
  		
  } 
}