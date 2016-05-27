global class SalesLiveAgentChatController {	
	
	public SalesLiveAgentChatController() {		
		
	}

	@RemoteAction
    public static User doGetFullPhotoUrl(String userId){
            
        User fullUrl = [SELECT SmallPhotoUrl FROM User WHERE Id = : userId ];

        return fullUrl;
    } 
}