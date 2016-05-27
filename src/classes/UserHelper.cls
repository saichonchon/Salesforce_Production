global class UserHelper {

	private static User currentUser;
	private static Map<Id,User> userMap;

	public static Integer getUserMapSize(){
		if(userMap != null) {
			return userMap.size();
		} else {
			return -1;
		}
	}
  
	public static User getCurrentUser() {
		if(currentUser == null) {
			currentUser = [SELECT Id,Email FROM User WHERE Id = :UserInfo.getUserId()];
			if(userMap == null) userMap = new Map<Id,User>();
			userMap.put(currentUser.Id,currentUser);
		}
		return currentUser;
	}
	
	//This method will cache requests to get users in an attempt to reduce the number of queries
	//If the user is in the cache there is no need for a new query
	public static List<User> getUsersFromIds(Set<Id> userIds){
		
		if(userMap == null) userMap = new Map<Id,User>();
		
		List<Id> userIdsNotFound = new List<Id>();
		List<User> users = new List<User>();
		
		for(Id userId : userIds) {
			if(userMap.containsKey(userId)) {
				users.add(userMap.get(userId));
			} else {
				userIdsNotFound.add(userId);
			}
		}
		
		if(userIdsNotFound.size() > 0) {
			//if(Limits.getQueries() < Limits.getLimitQueries()) {			
			Map<Id,User> tmpUserMap = new Map<Id,User>([SELECT Id,Email FROM User WHERE Id IN :userIdsNotFound]);
			if(tmpUserMap != null && tmpUserMap.size() > 0) {
				users.addAll(tmpUserMap.values());
				userMap.putAll(tmpUserMap);
			}
			//} //ELSE ERROR! Can't do any more queries
		}
		
		return users;
	}
	

}