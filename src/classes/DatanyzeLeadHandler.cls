public  class DatanyzeLeadHandler {
	
	public static void beforeInsertDatanyze(List<Lead> newLeads)
	{
		List<Lead> dLeads = new List<Lead>();
		for (Lead le : newLeads) 
		{
			if (le.LeadSource == 'Datanyze')
			dLeads.add(le);
		}
		updateDatanyzeFields(dLeads);
		
	 
	}
	
	public static void afterDatanyze(List<Lead> newLeads)
	{
		List<Lead> dLeads = new List<Lead>();
		for (Lead le : newLeads) 
		{
			if (le.LeadSource == 'Datanyze')
			dLeads.add(le);
		}
		system.debug(dLeads.size());
		addToCampaign(dLeads);
	 
	}
	public static void updateDatanyzeFields(List<Lead> dLeads)
	{
		for (Lead l : dLeads) 
		{
			string spaceChar = ' ';
			String strK = '000';
			String strM = strK + strK;
			String strB = strM + strM;
			
			l.Industry = l.Datanyze_Industry__c;
			l.Phone = DataUtility.truncateString(l.Datanyze_Phone__c, 40);
// employee number
			if (l.Datanyze_Employee_No__c <> null)
			{			
				String empRange = l.Datanyze_Employee_No__c.substringBefore(spaceChar);
				if(empRange.containsAny('KM'))
				{
					string tmp = empRange.substring(empRange.length()-1,empRange.length());
				    if (tmp =='K')
	            	empRange = empRange.substring(0, empRange.length()-2) + strK;
	 			}
				l.NumberOfEmployees = Integer.valueOf(empRange);
			}
// handle revenue
			if (l.Datanyze_Revenue__c <> null)
			{
				integer strsize = l.Datanyze_Revenue__c.length();
				string dnrevenue ='';	
				string temp = l.Datanyze_Revenue__c.substring(strsize -1,strsize);		
				if (l.Datanyze_Revenue__c.containsAny('-'))
				{
					dnrevenue = l.Datanyze_Revenue__c.substringBefore(spaceChar);
					if(dnrevenue.containsAny('KMB'))
					{
						temp = dnrevenue.substring(dnrevenue.length()-1,dnrevenue.length());
						dnrevenue = dnrevenue.substring(1,dnrevenue.length()-1);
					}
					else dnrevenue = dnrevenue.substring(1,dnrevenue.length());
				}
				else dnrevenue = l.Datanyze_Revenue__c.substring(1,strsize -1);
				
				if (temp =='M')
	            	dnrevenue = dnrevenue + strM;
//	            else if (temp =='K')
//	             	dnrevenue = dnrevenue + strK;
				else if (temp =='B')
	             	dnrevenue = dnrevenue + strB;
	            system.debug('dnrev ' +dnrevenue);
			
				l.AnnualRevenue = Decimal.valueOf(dnrevenue);
			}
		}
		
	}
	
	public static void addToCampaign(List<Lead> newLeads)
	{
		List<Lead> eligLeads = new List<Lead>();
		String emailCamId = CampaignUtility.getCampaignIdByName('Datanyze Email');
		String phoneCamId = CampaignUtility.getCampaignIdByName('Datanyze Phone');
		Map<Id, Id > mapLeadIdCampnId = new Map<Id, Id > ();
		
		for (Lead l : newLeads) 
		{
			Boolean englang = false;
			if (l.Datanyze_Country__c <> null && Label.English_Countries.containsIgnoreCase(l.Datanyze_Country__c))
			englang = true;
			system.debug('lang' +englang);
			if (englang == true 
				&& l.CreatedDate.date() == Date.Today() 
			  	&& ( l.Datanyze_Phone__c <> null ||	(l.Email <> null && !Label.Bad_Email.contains(l.Email)))
			  	&& (l.Datanyze_Domain_Tech__c == null || !l.Datanyze_Domain_Tech__c.containsignoreCase('Bigcommerce'))
			  	&& (l.Datanyze_Platform__c == null || !l.Datanyze_Platform__c.containsIgnoreCase('Bigcommerce'))	
			  	)
			  	{
			  		system.debug('Add to campaign'+l.Id);
			  		if (l.Datanyze_Phone__c <> null)
			  			mapLeadIdCampnId.put(l.Id, phoneCamId);
			  		else
			  			mapLeadIdCampnId.put(l.Id, emailCamId);
			  	}
		}
		
		if (!mapLeadIdCampnId.isEmpty())
			CampaignUtility.AddLeadToCampaign(mapLeadIdCampnId);
	}
/*

	public static void insertIntoCampaign(List<Lead> newLeads)
	{
		Id datanyzeCampaignId;
		
		List<CampaignMember> newMembers = new List<CampaignMember>();
		List<CampaignMember> currentMembers = [SELECT LeadId, CampaignId
												FROM CampaignMember 
												WHERE CampaignId IN :myCampaignIds AND LeadId IN :Trigger.new];

		for (Lead l : newLeads) 
		{
			found = false;
			
			for (CampaignMember cm : currentMembers) 
			{
				if (cm.LeadId == l.Id && cm.CampaignId == datanyzeCampaignId) 
				{
					found = true;
				}
			}

			if (!found) 
			{
				newMembers.add(new CampaignMember(CampaignId = datanyzeCampaignId, LeadId = l.Id));
			}
		}
		
		insert newMembers;
		
	}
*/
}