trigger TermsConditions_Trigger on Terms_Conditions__c (before insert, before update) 
{
	set<Id> stTCIds = new set<Id>();
	
	if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
	{
		for (Terms_Conditions__c t : trigger.new)
		{
			if (t.Id != null)
			{
				stTCIds.add(t.Id);
			}	
		}
		
		// Query all existing Terms & Conditions records
		list<Terms_Conditions__c> lstTC = [SELECT Id, Name, Active_Date__c, Expiration_Date__c, Type__c
											FROM Terms_Conditions__c
											WHERE Id NOT IN :stTCIds];
										

		boolean existingTCFound = false;
		
		// If existing TC records exist
		if (lstTC != null && !lstTC.isEmpty())
		{
			// Loop through each record and ensure it is not creating more than one TC record per type active at the same time
			for (Terms_Conditions__c t : trigger.new)
			{
				existingTCFound = false;
				
				for (Terms_Conditions__c existing : lstTC)
				{
					// The TC records are the same type
					if (t.Type__c == existing.Type__c)
					{
						// Check if the existing record's active date is before or equal to the new record
						if (existing.Active_Date__c <= t.Active_Date__c)
						{
							// Check if the existing record is overlapping the new record
							if (existing.Expiration_Date__c == null || existing.Expiration_Date__c >= t.Active_Date__c)
							{
								existingTCFound = true;
								break;
							}	
						}
						// The new record's active date is before the existing record's active date
						else
						{
							// Check if the new record is overlapping the existing one
							if (t.Expiration_Date__c == null || t.Expiration_Date__c >= existing.Active_Date__c)
							{
								existingTCFound = true;
								break;
							}
						}
					}	
				}
				
				// If an existing TC was found then add an error to the record
				if (existingTCFound)
				{
					t.addError('This Terms & Conditions Record is overlapping an already active existing T&C record for this type');
				}
			}
		}
	}
}