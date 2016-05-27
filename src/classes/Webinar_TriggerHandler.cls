public with sharing class Webinar_TriggerHandler {	
	
	Map<String, Id> emailToContact = new Map<String, Id>();
    Map<String, Id> emailToLead = new Map<String, Id>();
    Map<String, Id> emailToAccount = new Map<String, Id>();
    Map<String, Id> emailToOwner = new Map<String, Id>();
    List<String> contactSearchEmails = new List<String>();
    List<String> leadSearchEmails = new List<String>();    
    
    public void createRelationship(List<Webinar__c> newWebinar){
    	
    	for (Webinar__c w : newWebinar) {
	        if ((w.Contact__c == null) && (w.Lead__c == null) && (w.Registrant_Email__c != null)) {
	            contactSearchEmails.add(w.Registrant_Email__c.toLowerCase());            
	        }
	    }    	    	    
	 
	    if (!contactSearchEmails.isEmpty()) {
	    		        
	        List<Contact> dbContactSearch = [SELECT Id, AccountId, OwnerId, Email FROM Contact WHERE Email IN :contactSearchEmails];
	                
	        for (Contact c : dbContactSearch) {
	            emailToContact.put(c.email.toLowerCase(), c.Id);
	            emailToAccount.put(c.email.toLowerCase(), c.AccountId);
	            emailToOwner.put(c.email.toLowerCase(), c.OwnerId);
	        }
	        for (String s : contactSearchEmails) {
	            if (!emailToContact.containsKey(s)) {
	                leadSearchEmails.add(s);
	            }
	        } 
	    }
	    
	    if (!leadSearchEmails.isEmpty()) {
	        List<Lead> dbLeadSearch = [SELECT Id, OwnerId, Email FROM Lead WHERE Email IN :leadSearchEmails AND isConverted = False];
	        for (Lead l : dbLeadSearch) {
	            emailToLead.put(l.Email.toLowerCase(), l.Id);
	            emailToOwner.put(l.Email.toLowerCase(), l.OwnerId);
	        }
	    }
	    
	    for (Webinar__c w: newWebinar) {
	        if ((w.Contact__c == null) && (w.Lead__c == null) && (w.Registrant_Email__c != null)) {
	            if (emailToContact.containsKey(w.Registrant_Email__c.toLowerCase())) {
	                w.Contact__c = emailToContact.get(w.Registrant_Email__c.toLowerCase());
	                w.Account__c = emailToAccount.get(w.Registrant_Email__c.toLowerCase());
	                w.OwnerId = emailToOwner.get(w.Registrant_Email__c.toLowerCase());
	            } else if (emailToLead.containsKey(w.Registrant_Email__c.toLowerCase())) {
	                w.Lead__c = emailToLead.get(w.Registrant_Email__c.toLowerCase());
	                w.OwnerId = emailToOwner.get(w.Registrant_Email__c.toLowerCase());
	            }
	        }
	    }       
    }  
}