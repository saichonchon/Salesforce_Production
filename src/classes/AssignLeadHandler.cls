/*
 * This class handles running the lead routing rules. It essentially checks incoming leads
 * against a bunch of different criteria and assigns them to owners accordingly.
 *
 * Warning: I do a few bad things in here. 
 * You can't update leads that are in a list currently being itterated over. However, instead 
 * of wrapping the Lead list up in a nice data structure I decided to just make it a map and 
 * repeatedly mangle it. At some point I'll get to fixing this. Until then, please forgive me.
 */
public with sharing class AssignLeadHandler {
	/*
	// the list of leads we're working on.
	private map<Integer, Lead> Leads = new map<Integer, Lead>();

	//
	 // CONSTRUCTOR
	 //
	public AssignLeadHandler(list<Lead> theLeads, Boolean IgnoreOwnedLeads) {
    	// If this runs before insert, then the leads won't have any Id
    	// So lets track them by an Int instead.
    	Integer Key = 0;
    	for (Lead thisLead : theLeads) {
	        if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) || !IgnoreOwnedLeads) {
	            Leads.put(Key, thisLead);
	            Key++;
	        }
    	}
    	
    	MapPartnerAccounts();
	}
	

	//
	 // Assign all currently unassigned leads based on the round robin
	 //
	public void assignLeadsByRoundRobin() {
	    // Start by pulling out the unassigned leads
	    map<Integer, Lead> UnassignedLeads = new map<Integer, Lead>();
	    
	    // group them by email, so that duplicates in the group all to the same sales person
	    set<String> UnassignedEmails = new set<String>();
	    map<String, Id> LeadAssignments = new map<String, Id>();
				    
	    for (Integer thisKey : Leads.keySet()) {
	    	Lead thisLead = Leads.get(thisKey);
	    	
	        if (thisLead.OwnerId != NULL && thisLead.OwnerId != BCSettings.apiUser.Id) {
	            LeadAssignments.put(thisLead.Email, thisLead.OwnerId);
	        }
	        else {
	            if (LeadAssignments.get(thisLead.Email) == NULL) {
	                UnassignedEmails.add(thisLead.Email);
	            }
	            UnassignedLeads.put(thisKey, thisLead);
	        }
	    }
	
	    // Now that we have the lists, start checking assignments
	    if (!UnassignedLeads.isEmpty()) {
	        if (!UnassignedEmails.isEmpty()) {  
	                    
	            // get most recently RR assigned Lead
	            list<Id> RepsInRR = GetAllRepsInRR();
	            
	            // Sort by ID as well as created date, because otherwise if they are created in the same second the Round Robin will break
	            // Split by date so that we avoid the stupid bloody govenor limits
			    list<Lead> LastLeadList = new list<Lead>();
			    Date myDate = Date.Today();
			    integer itt = 1;
			    while (LastLeadList.size() < 1 && itt < 3) {
			        Date checkDate = myDate.addDays(-15 * itt);
		            LastLeadList = [SELECT Id, OwnerId FROM Lead WHERE CreatedDate > :checkDate AND Lead_Assignment_Method__c = 'Round Robin' AND OwnerId IN :RepsInRR ORDER BY CreatedDate DESC, Id DESC LIMIT 1];
			        itt++;
			    }
	                        
	            // find where we're up to in the round robin
	            Integer Position = -1;
	            if (LastLeadList.size() > 0) {
	            	Lead LastLead = LastLeadList.get(0);
		            for (Integer i = 0; i < RepsInRR.size(); i++) {
		                if (RepsInRR.get(i) == LastLead.OwnerId) {
		                    Position = i;
		                    break;
		                }
		            }
	            }
	            
	            // Assign our way through the list for each email
	            for (String thisEmail : UnassignedEmails) {
	                // keep track of where we're up to in the list.
	                Position++;
	                if (Position >= RepsInRR.size()) {
	                    Position = 0;
	                }
	                LeadAssignments.put(thisEmail, RepsInRR.get(Position));             
	                
	            }
	        }
	        
	        // Now that we know where everything is going, send it there!
	        for (Integer thisKey : UnassignedLeads.keySet()) {
	        	Lead thisLead = UnassignedLeads.get(thisKey);
	            thisLead.OwnerId = LeadAssignments.get(thisLead.Email);
	            thisLead.Lead_Assignment_Method__c = 'Round Robin';
	            Leads.put(thisKey, thisLead);
	        }
	    }
	}


	//
     // Check the leads to see whether there are any partnerIDs. Partner referrals are routed to the 
     // Partner Managers.
     //
    public void processForIncomingPartnerIds() {
        set<Id> PartnerIds = GetPartnerIds();
        
        if (PartnerIds.isEmpty()) {
        	return;
        }
        
        // Get partner accounts to assign
        list<Account> allExistingAccounts = [SELECT Id, OwnerId FROM Account 
                                        WHERE Id IN :PartnerIds
                                        ORDER BY CreatedDate ASC, Id ASC];
                                    
        if (!allExistingAccounts.isEmpty()) {
            // Because we sorted ASC, as we put things in the map, it will be the latest account that is the final value
            map<String, Account> latestExistingAccounts = new map<String, Account>();
            for (Account thisExistingAccount : allExistingAccounts) {
                latestExistingAccounts.put(thisExistingAccount.Id, thisExistingAccount);
            }
            
            // Collect the updated leads that have a partner account in there.
            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
		    for (Integer thisKey : Leads.keySet()) {
		    	Lead thisLead = Leads.get(thisKey);
                if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingAccounts.get(thisLead.Partner_Account__c) != NULL)) {
                    thisLead.OwnerId = latestExistingAccounts.get(thisLead.Partner_Account__c).OwnerId;
		            thisLead.Lead_Assignment_Method__c = 'Partner Lead';
                    updatedLeads.put(thisKey, thisLead);
                }
            }
            
            // Merge the updated leads back into the main collection.
 		    for (Integer thisKey : updatedLeads.keySet()) {
                Leads.put(thisKey, updatedLeads.get(thisKey));
            }
        }
    }


    //
     // Check the leads to see whether there are any existing leads with the same email and update the new leads appropriately.
	 //
    public void processForLeadsWithSameEmail() {
        set<String> theEmails = GetLeadEmails();
        
        if (!theEmails.isEmpty()) {
            list<Id> Reps = GetAllReps();
            // !!!!!!!!!!!!!!!!!!!!!! This query may cause a problem in the future!!
            list<Lead> allExistingLeads = [SELECT Id, Email, OwnerId FROM Lead 
                                        WHERE Email IN :theEmails 
                                        AND Id NOT IN :Leads.values() 
                                        AND OwnerId IN :Reps
                                        AND IsConverted = false
                                        ORDER BY CreatedDate ASC, Id ASC];
            if (!allExistingLeads.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Lead> latestExistingLeads = new map<String, Lead>();
                for (Lead thisExistingLead : allExistingLeads) {
                    latestExistingLeads.put(thisExistingLead.Email, thisExistingLead);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingLeads.get(thisLead.Email) != NULL)) {
                        thisLead.OwnerId = latestExistingLeads.get(thisLead.Email).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Same as existing lead (email)';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
    }


    //
     // Check the leads to see whether there are any existing leads with the same phone number and update the new leads appropriately.
     //
    public void processForLeadsWithSamePhoneNumber() {
        set<String> theNumbers = GetLeadPhoneNumbers();
        
        if (!theNumbers.isEmpty()) {
            list<Id> Reps = GetAllReps();
            list<Lead> allExistingLeads = [SELECT Id, Phone, OwnerId FROM Lead 
                                        WHERE Phone IN :theNumbers 
                                        AND Id NOT IN :Leads.values() 
                                        AND OwnerId IN :Reps
                                        AND IsConverted = false
                                        ORDER BY CreatedDate ASC, Id ASC];
            if (!allExistingLeads.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Lead> latestExistingLeads = new map<String, Lead>();
                for (Lead thisExistingLead : allExistingLeads) {
                    latestExistingLeads.put(thisExistingLead.Phone, thisExistingLead);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingLeads.get(thisLead.Phone) != NULL)) {
                        thisLead.OwnerId = latestExistingLeads.get(thisLead.Phone).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Same as existing lead (phone)';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
 	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
    }

    
    //
     // Check the leads to see whether there are any existing accounts with the same phone number and update the new leads appropriately.
     //
    public void processForAccountsWithSamePhoneNumber() {
        set<String> theNumbers = GetLeadPhoneNumbers();
        
        if (!theNumbers.isEmpty()) {
            list<Id> Reps = GetAllReps();
            list<Account> allExistingAccounts = [SELECT Id, Phone, OwnerId FROM Account 
                                            WHERE Phone IN :theNumbers 
                                            AND OwnerId IN :Reps
                                            ORDER BY CreatedDate ASC, Id ASC];
                                        
            if (!allExistingAccounts.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Account> latestExistingAccounts = new map<String, Account>();
                for (Account thisExistingAccount : allExistingAccounts) {
                    latestExistingAccounts.put(thisExistingAccount.Phone, thisExistingAccount);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingAccounts.get(thisLead.Phone) != NULL)) {
                        thisLead.OwnerId = latestExistingAccounts.get(thisLead.Phone).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Same as existing account (phone)';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
    }

    
    // 
     // Check the leads to see whether there are any existing contacts with the same email and update the new leads appropriately.
     //
    public void processForContactsWithSameEmail() {
        set<String> theEmails = GetLeadEmails();
        
        if (!theEmails.isEmpty()) {
            list<Id> Reps = GetAllReps();
            list<Contact> allExistingContacts = [SELECT Id, Email, OwnerId FROM Contact 
                                                WHERE Email IN :theEmails 
                                                AND OwnerId IN :Reps
                                                ORDER BY CreatedDate ASC, Id ASC];
 
            if (!allExistingContacts.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Contact> latestExistingContacts = new map<String, Contact>();
                for (Contact thisExistingContact : allExistingContacts) {
                    latestExistingContacts.put(thisExistingContact.Email, thisExistingContact);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingContacts.get(thisLead.Email) != NULL)) {
                        thisLead.OwnerId = latestExistingContacts.get(thisLead.Email).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Same as existing contact (email)';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
    }


	//
	 // Check whether this is a lead that should be going to the acquisitions team instead.
	 // NOTE: Yes, this is stupid, inefficient and is just repeating the same stuff over again.
	 // 		 I'm in a huge hurry, so I'll fix it later.
	 //
	public void processForAcquisitionLeads() {
        list<Id> Reps = GetAcquisitionsReps();
        
        set<String> theEmails = GetLeadEmails();
         //Check for leads that have the same email as the new lead
        if (!theEmails.isEmpty()) {
        	 // !!!!!!!!!!!!!!!!!!!!!! This query may cause a problem in the future!!
            list<Lead> allExistingLeads = [SELECT Id, Email, OwnerId FROM Lead 
                                        WHERE Email IN :theEmails 
                                        AND Id NOT IN :Leads.values() 
                                        AND OwnerId IN :Reps
                                        AND Lead_Type__c = 'Acquisition'
                                        ORDER BY CreatedDate ASC, Id ASC];
            
            if (!allExistingLeads.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Lead> latestExistingLeads = new map<String, Lead>();
                for (Lead thisExistingLead : allExistingLeads) {
                    latestExistingLeads.put(thisExistingLead.Email, thisExistingLead);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingLeads.get(thisLead.Email) != NULL)) {
                        thisLead.OwnerId = latestExistingLeads.get(thisLead.Email).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Acquisition team lead (email)';
			            thisLead.Lead_Type__c = 'Acquisition';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
         //Check for contacts that have the same email as the lead
        if (!theEmails.isEmpty()) {
            list<Contact> allExistingContacts = [SELECT Id, Email, OwnerId FROM Contact 
                                                WHERE Email IN :theEmails 
                                                AND OwnerId IN :Reps
                                                ORDER BY CreatedDate ASC, Id ASC];
            if (!allExistingContacts.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Contact> latestExistingContacts = new map<String, Contact>();
                for (Contact thisExistingContact : allExistingContacts) {
                    latestExistingContacts.put(thisExistingContact.Email, thisExistingContact);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingContacts.get(thisLead.Email) != NULL)) {
                        thisLead.OwnerId = latestExistingContacts.get(thisLead.Email).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Acquisition team lead (email)';
                        thisLead.Lead_Type__c = 'Acquisition';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }       
        
        set<String> theNumbers = GetLeadPhoneNumbers();  
         //Check for leads that have the same phone as the new lead
        if (!theNumbers.isEmpty()) {
            list<Lead> allExistingLeads = [SELECT Id, Phone, OwnerId FROM Lead 
                                        WHERE Phone IN :theNumbers 
                                        AND Id NOT IN :Leads.values() 
                                        AND OwnerId IN :Reps
                                        AND IsConverted = false
                                        ORDER BY CreatedDate ASC, Id ASC];
            if (!allExistingLeads.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Lead> latestExistingLeads = new map<String, Lead>();
                for (Lead thisExistingLead : allExistingLeads) {
                    latestExistingLeads.put(thisExistingLead.Phone, thisExistingLead);
                }
                
                // Collect the updated leads that have an existing lead in there.
	            map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
			    for (Integer thisKey : Leads.keySet()) {
			    	Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingLeads.get(thisLead.Phone) != NULL)) {
                        thisLead.OwnerId = latestExistingLeads.get(thisLead.Phone).OwnerId;
			            thisLead.Lead_Assignment_Method__c = 'Acquisition team lead (phone)';
                        thisLead.Lead_Type__c = 'Acquisition';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
 	 		    for (Integer thisKey : updatedLeads.keySet()) {
	                Leads.put(thisKey, updatedLeads.get(thisKey));
	            }
            }
        }
        //Check for accounts that have the same phone as the new lead
        if (!theNumbers.isEmpty()) {
            list<Account> allExistingAccounts = [SELECT Id, Phone, OwnerId FROM Account 
                                            WHERE Phone IN :theNumbers 
                                            AND OwnerId IN :Reps
                                            ORDER BY CreatedDate ASC, Id ASC];
                                        
            if (!allExistingAccounts.isEmpty()) {
                // Because we sorted ASC, as we put things in the map, it will be the latest lead that is the final value
                map<String, Account> latestExistingAccounts = new map<String, Account>();
                for (Account thisExistingAccount : allExistingAccounts) {
                    latestExistingAccounts.put(thisExistingAccount.Phone, thisExistingAccount);
                }
                
                // Collect the updated leads that have an existing lead in there.
                map<Integer, Lead> updatedLeads = new map<Integer, Lead>();
                for (Integer thisKey : Leads.keySet()) {
                    Lead thisLead = Leads.get(thisKey);
                    if ((thisLead.OwnerId == NULL || thisLead.OwnerId == BCSettings.apiUser.Id) && (latestExistingAccounts.get(thisLead.Phone) != NULL)) {
                        thisLead.OwnerId = latestExistingAccounts.get(thisLead.Phone).OwnerId;
                        thisLead.Lead_Assignment_Method__c = 'Acquisition team lead (phone)';
                        thisLead.Lead_Type__c = 'Acquisition';
                        updatedLeads.put(thisKey, thisLead);
                    }
                }
                
                // Merge the updated leads back into the main collection.
                for (Integer thisKey : updatedLeads.keySet()) {
                    Leads.put(thisKey, updatedLeads.get(thisKey));
                }
            }
        }
	}

	//
	 // Take the incoming Leads and process them to check whether there are any incoming
	 // partner IDs. If there are, find partner accounts that have a matching ID and 
	 // set the partner reference field. 
	 //
	private void MapPartnerAccounts() {
        map<Double, list<Integer>> externalIds = new map<Double, list<Integer>>();
        for (Integer thisLeadId : Leads.keySet()) {
        	Lead thisLead = Leads.get(thisLeadId);
        	
        	if (thisLead.MBA_Partner_ID__c != null && thisLead.Partner_Account__c == NULL) {
        		if (externalIds.containsKey(thisLead.MBA_Partner_ID__c)) {
        			externalIds.get(thisLead.MBA_Partner_ID__c).add(thisLeadId);
        		}
        		else {
        			list<Integer> leadIndexes = new list<Integer>();
        			leadIndexes.add(thisLeadId);
        			externalIds.put(thisLead.MBA_Partner_ID__c, leadIndexes);
        		}
        	}
        }
		
		List <Account> partnerAccounts = [SELECT Id, iDev_Partner_ID__c FROM Account WHERE iDev_Partner_ID__c IN :externalIds.keySet()];
		
		if (partnerAccounts.size() > 0) {
			for (Account thisAccount : partnerAccounts) {
				list<Integer> leadIds = externalIds.get(thisAccount.iDev_Partner_ID__c);
				for (Integer thisId : leadIds) {
					Leads.get(thisId).Partner_Account__c = thisAccount.Id;
				}
			}
		}
	}

    //
     // Get the lists of all sales people
     //
    private list<Id> AllReps = new list<Id>();
    private list<Id> AllRepsInRR = new list<Id>();
    private Boolean AllRepsProcessed = false;
    private list<Id> GetAllReps() {
        if (!AllRepsProcessed) {
            list<User> AllSalesUsers = [SELECT Id, Included_in_Round_Robin__c FROM User WHERE ProfileId = :BCSettings.conversionRepProfileId AND IsActive = true ORDER BY Id];
            for (User thisUser : AllSalesUsers) {
                AllReps.add(thisUser.Id);
                if (thisUser.Included_in_Round_Robin__c == 'Included') {
                    AllRepsInRR.add(thisUser.Id);
                }
            }    
            AllRepsProcessed = true;
        }
        return AllReps;
    }

    //
     // Get the lists of all partner reps
     //
    private list<Id> PartnerRepsInRR = new list<Id>();
    private Boolean PartnerRepsProcessed = false;
    private list<Id> GetPartnerReps() {
        if (!PartnerRepsProcessed) {
            list<User> PartnerRepUsers = [SELECT Id FROM User WHERE ProfileId = :BCSettings.partnerManagerProfileId AND IsActive = true AND Included_in_Round_Robin__c = 'Included' ORDER BY Id];
            for (User thisUser : PartnerRepUsers) {
                PartnerRepsInRR.add(thisUser.Id);
            }    
            PartnerRepsProcessed = true;
        }
        return PartnerRepsInRR;
    }


    //
     // Get the lists of all acquisitions reps
     //
    private list<Id> AllAcquisitionsReps = new list<Id>();
    private Boolean AcquisitionsRepsProcessed = false;
    private list<Id> GetAcquisitionsReps() {
        if (!AcquisitionsRepsProcessed) {
            list<User> AcquisitionsRepUsers = [SELECT Id FROM User WHERE ProfileId = :BCSettings.acquisitionRepProfileId AND IsActive = true ORDER BY Id];
            for (User thisUser : AcquisitionsRepUsers) {
                AllAcquisitionsReps.add(thisUser.Id);
            }    
            AcquisitionsRepsProcessed = true;
        }
        return AllAcquisitionsReps;
    }


    //
     // Get the lists of all sales people in the office
     //
    private list<Id> GetAllRepsInRR() {
        if (!AllRepsProcessed) {
            // We set this as part of GetAllReps()
            GetAllReps();
        }
        return AllRepsInRR;
    }

    //
    // Pull out the list of partner IDs for the incoming leads
    //
    private set<Id> LeadPartnerIds = new set<Id>();
    private Boolean PartnerIdsProcessed = false;
    private set<Id> GetPartnerIds() {
        if (!PartnerIdsProcessed) {
            for (Lead thisLead : Leads.values()) {
                if (thisLead.Partner_Account__c != null) {
                    LeadPartnerIds.add(thisLead.Partner_Account__c);
                }
            }
            PartnerIdsProcessed = true;
        }
        return LeadPartnerIds;
    }

    //
     //  Pull out the list of emails for all the leads
     //
    private set<String> LeadEmails = new set<String>();
    private Boolean LeadEmailsProcessed = false;
    private set<String> GetLeadEmails() {
        if (!LeadEmailsProcessed) {
            for (Lead thisLead : Leads.values()) {
                if (thisLead.Email != null) 
                    LeadEmails.add(thisLead.Email);
            }
            LeadEmailsProcessed = true;
        }
        return LeadEmails;
    }


    //
     // Pull out the list of phone numbers for all the leads
     //
    private set<String> LeadPhoneNumbers = new set<String>();
    private Boolean LeadPhoneNumbersProcessed = false;
    private set<String> GetLeadPhoneNumbers() {
        if (!LeadPhoneNumbersProcessed) {
            for (Lead thisLead : Leads.values()) {
                if (thisLead.Phone != null) 
                    LeadPhoneNumbers.add(thisLead.Phone);
            }
            LeadPhoneNumbersProcessed = true;
        }
        return LeadPhoneNumbers;
    }


	//
	 // Send emails to all the updated leads
     // I don't want to do another query here, but we only have data for sales people, and there's the 
     // potential that the partner owner may not be a sales rep.
     //
    public void sendEmails(list<Lead> newLeads) {
	    list<Lead> emailDetails = [select Id, Name, Email, Lead_Assignment_Method__c, Lead_Type__c, OwnerId, Owner.Name, Owner.Phone, Owner.Email FROM Lead WHERE Id IN :newLeads];
	    for (Lead thisLead : emailDetails) {
    		// If it was an acquisitions lead, email the owner
    		if (thisLead.Lead_Assignment_Method__c == 'Acquisition team lead (email)' || thisLead.Lead_Assignment_Method__c == 'Acquisition team lead (phone)') {
    			sendOwnerEmail(thisLead);
    		}
	    }
    }
    
    //
     // Send emails to a specific lead's owner
     //
    private void sendOwnerEmail(Lead thisLead) {
        try {
            if(thisLead.Owner.Email != null) {
                list<string> toAdd = new list<string>();
                toAdd.Add(thisLead.Owner.Email);

                Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
                string mailBody = 'A new lead has come in to the acquisitions team:<br/>' +
                                    'Name: ' + thisLead.Name + '<br/>' +
                                    'Email: ' + thisLead.Email + '<br/>';
                
                mail.setToAddresses(toAdd); 
                mail.setHtmlBody(mailBody);   
                mail.setSenderDisplayName('BigCommerce Team');
                mail.setReplyTo(thisLead.Owner.Email);   
                mail.setSubject('New Acquisitions lead');
                
                if(!test.isRunningTest())
                    Messaging.sendEmail(new Messaging.singleEmailMessage[] { mail });         
            }
        } 
        catch(Exception e) {
            system.Debug('>>>>>> Failed to send email to LeadOwnerId ' + thisLead.OwnerId + ' - Email: ' + thisLead.Owner.Email);
        }
    }
    */
}