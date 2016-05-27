/* ============================================================
 * Contributor: Caleb Sidel
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
@IsTest
private class UserHelper_Test {

	static testMethod void test_getCurrentUser() {
		User u = UserHelper.getCurrentUser();
		System.assertEquals(UserInfo.getUserId(),u.Id);						
	}
	
	static testMethod void test_getCurrentUser_NEW() {
		TestDataGenerator data = new TestDataGenerator();
		User newUsr = data.getUsers(null)[0];
		System.runAs(newUsr){			
			System.assertEquals(UserInfo.getUserId(),UserHelper.getCurrentUser().Id);
		}						
	}

	static testMethod void test_getUserMapSize_Empty() {
		System.assertEquals(-1,UserHelper.getUserMapSize());
	}

	static testMethod void test_getUsersFromIds() {
		TestDataGenerator data = new TestDataGenerator();
		User newUsr = data.getUsers(null)[0];
		System.assertNotEquals(null,newUsr.Id);
		
		Set<Id> userIds = new Set<Id>();
		userIds.add(newUsr.Id);
		
		List<User> users = UserHelper.getUsersFromIds(userIds);
		
		System.debug('users = ' + users);
		System.assertEquals(1,users.size());
		System.assertEquals(newUsr.Id,users[0].Id);
		System.assertEquals(1,UserHelper.getUserMapSize());
		
		//Want to see that the cache is working
		List<User> usersDuplicate = UserHelper.getUsersFromIds(userIds);
		System.assertEquals(1,UserHelper.getUserMapSize());		
	}

}