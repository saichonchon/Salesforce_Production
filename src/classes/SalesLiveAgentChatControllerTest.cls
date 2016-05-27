@isTest
private class SalesLiveAgentChatControllerTest {	

	public static void setup(){

		User testUser = TestUtilityBox.getTestUsers(1, 'System Administrator');  	
	    insert testUser;		
	}

	static testMethod void doGetUserUrlTest(){

		SalesLiveAgentChatControllerTest.setup();
		List<User> dbUser = [SELECT Id FROM User LIMIT 1];
		User userTest = SalesLiveAgentChatController.doGetFullPhotoUrl(dbUser[0].Id);
		System.assertEquals(true, userTest != null);
	}	
}