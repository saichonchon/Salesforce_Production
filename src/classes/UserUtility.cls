public  class UserUtility {
	
   
    public static void AddCommunityUserToGroup(list<ID> cUsers) 
    {
       try {
			Integer matches = Label.Community_Chatter_Groups.countMatches(';');

			List<String> groups = Label.Community_Chatter_Groups.split(';',matches+1);
			system.debug('first string' +groups[0]);
			
            List<CollaborationGroupMember> cgm = new List<CollaborationGroupMember>();
                                    
            for( Id userId : cUsers)
            {       
            	for (string s :groups)
            	{                   
            		system.debug(s);
               		cgm.add(new CollaborationGroupMember (CollaborationGroupId = s, MemberId = userId));   
            	}
            } 
            insert cgm;
        }
        catch (QueryException qe) {
            System.debug('QueryException in AddCommunityUserToGroup is :' + qe);  
        } 
        catch (Exception ex) {
            System.debug('Exception in AddCommunityUserToGroup is :' + ex);
        }    
    }

	

}