public without sharing class PartnerPortalHelper 
{
    public static Terms_Conditions__c PartnerPortalTC;
    public static Partner_T_C_Agreement__c PartnerPortalTCAgree;
    
    public static User CurrentUserRecord
    {
    	get
    	{
    		User retUser = null;
    		
    		if (CurrentUserRecord == null)
    		{	        
		        if (UserInfo.getUserId() != null)
		        {
		            retUser = [SELECT Id, Contact.AccountId, ContactId, Email, FirstName, LastName, UserName FROM User WHERE Id = :UserInfo.getUserId()];
		            
		            system.debug('***PartnerPortalHelper:CurrentUserRecord - User Found: ' + retUser);
		            system.debug('***PartnerPortalHelper:CurrentUserRecord - User Contact Id: ' + retUser.ContactId);
		            system.debug('***PartnerPortalHelper:CurrentUserRecord - User Contact Account Id: ' + retUser.Contact.AccountId);
		        }
		        else
		        {
		        	system.debug('***PartnerPortalHelper:CurrentUserRecord - No getUser Found');
		        }
    		}
    		else
    		{
    			retUser = CurrentUserRecord;
    		}
    		
    		return retUser;
    	}
    }

    public static Account PartnerAccount
    {
    	get
    	{
    		Account retAcct = null;
    		
    		if (PartnerAccount == null)
	        {   
		        if (CurrentUserRecord != null)
		        {
		            // Check if the User has contact info (should always since they are already logged into the Portal)
		            if (CurrentUserRecord.ContactId != null)
		            {
		                for (Account a : [SELECT Id, iDev_Partner_ID__c, Name, OwnerId FROM Account WHERE Id = :CurrentUserRecord.Contact.AccountId])
		                {
		                    system.debug('***PartnerPortalHelper:PartnerAccount - Account Found: ' + a);
		                                
		                    retAcct = a;
		                    break;
		                }
		            }
		        }		        
	        }
	        else
	        {
	        	retAcct = PartnerAccount;
	        }
	        
	        return retAcct;
    	}
    }
    
    public static boolean HasPartnerAcceptedCurrentTerms()
    {
        boolean hasAccepted = false;
        
        PartnerPortalTC = null;
        PartnerPortalTCAgree = null;
        
        // Find the most current Terms and Conditions for the Partner Portal
        for (Terms_Conditions__c tc : [SELECT Id, Active_Date__c, Expiration_Date__c, Type__c
                                        FROM Terms_Conditions__c
                                        WHERE Type__c = 'Partner Portal'
                                            AND Active_Date__c <= TODAY
                                            AND (Expiration_Date__c >= TODAY 
                                                    OR Expiration_Date__c = null)])
        {
            PartnerPortalTC = tc;
            break;
        }
        
        // If no T&Cs exist then default to true
        if (PartnerPortalTC == null)
        {
            system.debug('***PartnerPortalHelper:HasPartnerAcceptedCurrentTerms - No Terms Found');
            hasAccepted = true;
        }
        // If partner account is not found
        else if (PartnerAccount == null)
        {
            system.debug('***PartnerPortalHelper:HasPartnerAcceptedCurrentTerms - No Partner Account Found');
            hasAccepted = false;
        }
        else
        {
            system.debug('***PartnerPortalHelper:HasPartnerAcceptedCurrentTerms - Terms Found: ' + PartnerPortalTC.Id);
            system.debug('***PartnerPortalHelper:HasPartnerAcceptedCurrentTerms - Partner Account Id: ' + PartnerAccount.Id);
            
            // Check if a record exists for the current Partner Portal T&Cs
            for (Partner_T_C_Agreement__c p : [SELECT Id, Account__c, Terms_Conditions__c, Accepted_Date__c, Accepted_By__c
                                                FROM Partner_T_C_Agreement__c
                                                WHERE Account__c = :PartnerAccount.Id
                                                    AND Terms_Conditions__c = :PartnerPortalTC.Id])
            {
                PartnerPortalTCAgree = p;
                
                // If the partner has already accepted
                if (p.Accepted_Date__c != null)
                {
                    hasAccepted = true;
                }
                
                break;
            }
        }
        
        return hasAccepted;
    }
}