public class ContactUtility {
	
    //This method will bring the contact record using email address
    
	public static List<Contact> getContactFromEmail(String emailadd){
		
		List<Contact> cons = new List<Contact>([select Id, firstName, lastName, AccountId, Account.SupportPin__c from Contact where email = :emailadd]);
		
		 return cons;

	}
//Zuora/BMP contacts	
	public static List<Contact> getBMPContacts(Id accID){
		
		List<Contact> cons = new List<Contact>([select Id, Name,  Type__c, AccountId from Contact where AccountId = :accId and Type__c <> null]);
		
		 return cons;

	}
	
	public static Contact getPrimaryContact(Id accID){
		
		Contact con = [select Id, Name,  Type__c, AccountId from Contact where AccountId = :accId and Type__c = 'Primary Contact' limit 1];
		
		 return con;
	
	}
	
	public static Contact getBillContact(Id accID){
		
		Contact con = [select Id, Name,  Type__c, AccountId from Contact where AccountId = :accId and Type__c = 'Billing Contact' limit 1];
		
		 return con;
	
	}
}