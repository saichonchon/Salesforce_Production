// class referred to by SF to load email templates on the email action in console
global class SmartTemplateLoader implements Support.EmailTemplateSelector {
    // Empty constructor
    global SmartTemplateLoader() {}
    global ID getDefaultEmailTemplateId(ID caseId) {
    // Select the case we're interested in, choosing any fields that are relevant to our decision
    Case c = [SELECT Origin, Subject, Description, Recordtype.Name FROM Case WHERE Id=:caseId];
	system.debug('case subject' +c.Subject);
	List<CaseEmailTemplate__c> cRules = CaseEmailTemplate__c.getAll().Values();
    Map<String, ID> mpOriginValueId = new Map <string, Id>();
    Map<String, ID> mpRecValueId = new Map <string, Id>();
    for (CaseEmailTemplate__c aet :cRules)
  	{
    	if (aet.Origin__c <> null) mpOriginValueId.put(aet.Origin__c, aet.Template_Id__c);
    	else if (aet.Record_Type__c <> null) mpRecValueId.put(aet.Record_Type__c, aet.Template_Id__c);
     
  	}
    
    Id etId;

    if (mpOriginValueId.get(c.Origin) <> null) {
        etId = mpOriginValueId.get(c.Origin);
    } else if(mpRecValueId.get(c.RecordType.Name) <> null) {
		etId = mpRecValueId.get(c.RecordType.Name);
//        et = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'EnhancementTemplate'];
    } 

    // Return the ID of the template selected
    return etId;
}
    
    
}