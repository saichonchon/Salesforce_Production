trigger ChatPostTriggerforCase on FeedItem (after insert) {
    //Get the key prefix for the Opportunity object via a describe call.
    String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
    
    Map<Id, FeedItem> mapCaseFeed = new Map<Id, FeedItem>();
    Set <Id> userIds = new Set<Id>();
    
    for (FeedItem f: trigger.new)
    {
        String parentId = f.parentId;
        //We compare the start of the 'parentID' field to the Opportunity key prefix to
        //restrict the trigger to act on posts made to the Opportunity object.
        if (parentId.startsWith(caseKeyPrefix)) 
        {            
            userIds.add(f.CreatedById);
            mapCaseFeed.put(f.parentId, f);
        }
    }
    
	if (!mapCaseFeed.isEmpty())
	{
		    Map<Id,User> postUsers = new Map<Id, User>([select Id, ProfileId from User where Id in :userIds ]);
		    List<CaseComment> ccs = new List<CaseComment>();
		    
		    for (ID cId :mapCaseFeed.keySet())
		    {
		        FeedItem ff = mapCaseFeed.get(cId);
		        if (postusers.get(ff.CreatedById).Profileid == Label.Community_User_Profile)
		        {    
		            CaseComment cs = new CaseComment(CommentBody=ff.Body, 
		                                            CreatedById = ff.CreatedById, 
		                                             ParentId = cId);
		            ccs.add(cs) ;
		        }                                
		    }
		    
		    insert ccs;
	}
}