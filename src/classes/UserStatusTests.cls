/**
 * This class contains unit tests for validating UserStatus.trigger
 */
@isTest
private class UserStatusTests {
	/*
	// Grab 5 users. We really don't care who they are.
	static map<Id, User> users = new map<Id, User>([SELECT Id, Included_in_Round_Robin__c, Name FROM User WHERE IsActive = true LIMIT 5]);
	
    //
     // Confirm that the user's status changes when appropriate
     //
    static testMethod void confirmPositive() {
    	User thisUser = users.values().get(0);
    	Id key = thisUser.Id;
        
        // Insert a status and check that the user is in sync
        User_Status__c newStatus1 = new User_Status__c();
        newStatus1.OwnerId = thisUser.Id;
        newStatus1.Status__c = 'Out of Office';
        insert newStatus1;
        
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Not Included');
        
        // Add a new status and check the user changes
        User_Status__c newStatus2 = new User_Status__c();
        newStatus2.OwnerId = thisUser.Id;
        newStatus2.Status__c = 'In the Office';
        insert newStatus2;
    
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Included');
        
        // Update the status back again and check that the user conforms
        newStatus2.Status__c = 'Out of Office';
        update newStatus2;
        
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Not Included');
    }

    //
     // Confirm that the user's status doesn't change when appropriate
     //
    static testMethod void confirmNegative() {
    	User thisUser = users.values().get(0);
    	Id key = thisUser.Id;
        
        // Insert a status and check that the user is in sync
        User_Status__c newStatus1 = new User_Status__c();
        newStatus1.OwnerId = thisUser.Id;
        newStatus1.Status__c = 'Out of Office';
        insert newStatus1;
        
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Not Included');
        
        // Add a new status with the same status and check the user doesn't change
        User_Status__c newStatus2 = new User_Status__c();
        newStatus2.OwnerId = thisUser.Id;
        newStatus2.Status__c = 'Out of Office';
        insert newStatus2;
    
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Not Included');
        
        // Update the status again and check that the user conforms
        newStatus2.Status__c = 'Out of Office';
        update newStatus2;
        
        RegetUsers();       
        system.assertEquals(users.get(key).Included_in_Round_Robin__c, 'Not Included');
    }

    //
     // Confirm that during a mass update/insert appropriate changes are made.
     //
    static testMethod void confirmBulk() {
        User_Status__c[] statuses = new User_Status__c[] {};
        
        // Insert a status for each user
        for (Id key : users.keyset()) {
        	User thisUser = users.get(key);
        	
	        User_Status__c newStatus = new User_Status__c();
	        newStatus.OwnerId = thisUser.Id;
	        newStatus.Status__c = 'Out of Office';
	        statuses.add(newStatus);
        }
        insert statuses;

 		// Check everyone's in sync
 		RegetUsers();       
        for (Id key : users.keyset()) {
        	User thisUser = users.get(key);
	        system.assertEquals(thisUser.Included_in_Round_Robin__c, 'Not Included');
        }
       
        // Add some new statuses and check that the right people change
        statuses = new User_Status__c[] {};
        Boolean thisOne = false;
        for (Id key : users.keyset()) {
        	User thisUser = users.get(key);
        	
	        User_Status__c newStatus = new User_Status__c();
	        newStatus.OwnerId = thisUser.Id;
	        if (thisOne) {
	        	newStatus.Status__c = 'Out of Office';
	        	thisOne = false;
	        }
	        else {
	        	newStatus.Status__c = 'In the Office';
	        	thisOne = true;
	        }
	        statuses.add(newStatus);
        }
        insert statuses;
        
 		// Check everyone's in sync
 		RegetUsers();       
        for (User_Status__c thisStatus : statuses) {
        	User thisUser = users.get(thisStatus.OwnerId);
        	if (thisStatus.Status__c == 'Out of Office') {
        		system.assertEquals(thisUser.Included_in_Round_Robin__c, 'Not Included');
        	}
        	else if (thisStatus.Status__c == 'In the Office') {
        		system.assertEquals(thisUser.Included_in_Round_Robin__c, 'Included');
        	}
        }
       
        // Do the same thing again, this time with updates
        for (User_Status__c thisStatus : statuses) {
        	User thisUser = users.get(thisStatus.OwnerId);
        	
	        User_Status__c newStatus = new User_Status__c();
	        newStatus.OwnerId = thisUser.Id;
	        if (thisStatus.Status__c == 'Out of Office') {
	        	thisStatus.Status__c = 'In the Office';
	        }
        }
        update statuses;
        
 		RegetUsers();       
        for (Id key : users.keyset()) {
        	User thisUser = users.get(key);
	        system.assertEquals(thisUser.Included_in_Round_Robin__c, 'Included');
        }
    }
    
    private static void RegetUsers() {
		// get the same accounts back so that we can see the changes
		map<Id, User> resetUsers = new map<Id, User>([SELECT Id, Included_in_Round_Robin__c, Name FROM User WHERE Id IN :users.values()]);
		users = resetUsers;
    }
    */
}