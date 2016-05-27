@isTest(seeAllData = true)
private class TestComponentController {
	
	static testMethod void testGetTranscript() {
		
		GetAttachment ga = new GetAttachment();
		LiveChatTranscript att = [SELECT CaseId, Id FROM LiveChatTranscript WHERE CaseId <> null and createddate = this_week LIMIT 1 ];
	
		ga.Doc_Id = att.Caseid;
		String bodyText = ga.getBody();  

	}
	
	static testMethod void testGetNotice() {
		
		PortalNoticeGenerator pn = new PortalNoticeGenerator();
	
		pn.topic = 'Portal_Notice';
		PKB_Content__c bodyText = pn.getContentByName;  

	}

}