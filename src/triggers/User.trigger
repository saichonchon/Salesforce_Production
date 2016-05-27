trigger User on User (after insert) {
    
    if ( Trigger.isInsert && Trigger.isAfter ) 
    { 
            List<id> UserIds = new List<id>();
            for ( user u: Trigger.new ) {
                if ( u.ProfileId == Label.Community_User_Profile ) {
                    UserIds.add(u.id);
                }                 
            } 
            if ( UserIds.size() > 0 ) {
                UserUtility.addCommunityUserToGroup(UserIds);  
            }           
        
    }


}