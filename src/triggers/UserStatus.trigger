/**
 * This trigger purely keeps the User object up to date with the current status
 * that user has set.
 */
trigger UserStatus on User_Status__c (after insert, after update) {
	//------------------------------------------------------------------------------------
	//// Commented out on 5/22/2013 
	////	- Do not need to update actual user record
	//------------------------------------------------------------------------------------
	
/*	
	// grab the users that are being referenced
	set<Id> affectedUserIds = new set<Id>();
	for (User_Status__c thisStatus : trigger.new) {
		affectedUserIds.add(thisStatus.OwnerId);
	}
	map<Id, User> affectedUsers = new map<Id, User>([SELECT Id, Included_in_Round_Robin__c FROM User WHERE Id IN :affectedUserIds]);
	
	// loop over the users and update them as needed
	set<User> usersToUpdate = new set<User>();
	for (User_Status__c thisStatus : trigger.new) {
		User thisUser = affectedUsers.get(thisStatus.OwnerId);
		
		if (thisStatus.Status__c == 'In the Office' && thisUser.Included_in_Round_Robin__c != 'Included') {
			thisUser.Included_in_Round_Robin__c = 'Included';
			usersToUpdate.add(thisUser);
		}
		else if (thisStatus.Status__c == 'Out of Office' && thisUser.Included_in_Round_Robin__c != 'Not Included') {
			thisUser.Included_in_Round_Robin__c = 'Not Included';
			usersToUpdate.add(thisUser);
		}
	}
	
	update new list<User>(usersToUpdate);
*/
}