global class UpdateCampaignStatus {
    
    webservice static String updateRecords(Id CampaignId)
    {
        Map<Id, CampaignMember> mapContactIdMems = new Map<Id, CampaignMember> ();
        List<CampaignMember> updcampmembers = new  List<CampaignMember>();
        for (CampaignMember campm : [SELECT id, ContactId, status FROM CampaignMember WHERE CampaignId =:CampaignId and status='Not Sent'])
        {
        	mapContactIdMems.put(campm.ContactId, campm );
        	
//        	campm.status='Sent';
        } 
        
        Set<Id> sentIds = new Set<Id> ();
        
        for (task t :[select Id, Subject, whoId from Task where who.Id in :mapContactIdMems.keySet() and status = 'Completed' and Type ='Email'])
        {
        	if (t.Subject.contains('Mass Email'))
        	sentIds.add(t.whoId);
        }
       
      	for (Id cId :sentIds)
      	{
      		CampaignMember cm = mapContactIdMems.get(cId);
      		cm.status='Sent';
      		updcampmembers.add(cm);
      	}
      
        Integer counter = updcampmembers.size();
        
        // Update  in one transaction, rollback if any problems
      // and return error messages to the calling environment.
      try {
         Database.update(updcampmembers);
      }
      catch (DmlException e) {
         return e.getMessage();
      }
	
		String message = 'Updated' + counter + 'successfully';
      // On success, return a message to the calling program.
      return message;
        
    }

}