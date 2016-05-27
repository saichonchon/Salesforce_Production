public without sharing class TermsConditionsController 
{
    public static string TermsID = ApexPages.currentPage().getParameters().get('id');
    public static string PartnerId = ApexPages.currentPage().getParameters().get('partId');
    
    public TermsConditionsController() 
    {
        ValidIdsExist = true;
        
        system.debug('***TermsConditionsController:TermsConditionsController - TermsID: ' + TermsID);
        system.debug('***TermsConditionsController:TermsConditionsController - PartnerId: ' + PartnerId);
        
        // Ensure both TC Id and Partner Id has been passed in
        if (TermsID != null && PartnerId != null)
        {
            system.debug('***TermsConditionsController:TermsConditionsController - Valid Ids');         
        }
        else
        {
            system.debug('***TermsConditionsController:TermsConditionsController - No Valid Ids');
            ValidIdsExist = false;
        }
    }
    
    public boolean ValidIdsExist {get; set;}
    
    public Terms_Conditions__c TC;
    
    public Terms_Conditions__c getTC()
    {
        Terms_Conditions__c retVal = null;
        
        if (TC == null)
        {
            for (Terms_Conditions__c tc : [SELECT Id, Active_Date__c, Expiration_Date__c, Type__c, T_C_Text__c 
                                        FROM Terms_Conditions__c
                                        WHERE Id = :TermsID])
            {
                retVal = tc;
                system.debug('***TermsConditionsController:TermsConditionsController - Terms Found: ' + tc);
                break;
            }
        }
        else
        {
            retVal = TC;
        }
        
        return retVal;
    }
    
    public pageReference AgreeToTerms()
    {
    	system.debug('***TermsConditionsController:AgreeToTerms - Start');
        pageReference pr = Page.PartnerHome;
        
        Partner_T_C_Agreement__c ptc = null;
        
        // Check if a Partner Terms Agreement record exist for this partner / Terms and Conditions combination
        for (Partner_T_C_Agreement__c p : [SELECT Id, Account__c, Terms_Conditions__c, Accepted_Date__c, Accepted_By__c
                                                FROM Partner_T_C_Agreement__c
                                                WHERE Account__c = :PartnerId
                                                    AND Terms_Conditions__c = :TermsID])
        {
            ptc = p;
            
            if (p.Accepted_Date__c != null)
            {
                break;
            }
        }
        
        // If a Partner Terms Agreement record does NOT exist
        if (ptc == null)
        {
        	system.debug('***TermsConditionsController:AgreeToTerms - Partner TC Agreement - PartnerId: ' + PartnerId);
        	system.debug('***TermsConditionsController:AgreeToTerms - Partner TC Agreement - TermsID: ' + TermsID);
        	
            ptc = new Partner_T_C_Agreement__c();
            ptc.Account__c = PartnerId;
            ptc.Terms_Conditions__c = TermsID;
        }
        
        ptc.Accepted_By__c = PartnerPortalHelper.CurrentUserRecord.ContactId;
        ptc.Accepted_Date__c = System.now();
        
        system.debug('***TermsConditionsController:AgreeToTerms - Partner TC Agreement: ' + ptc);
        
        try
        {   
        	upsert ptc;
        }
        catch(Exception exc)
        {
        	system.debug('***Error: TermsConditionsController:AgreeToTerms - Save Partner TC with Error: ' + exc.getMessage());
        } 
        
        return pr;
    }
    
    public pageReference Cancel()
    {
    	string strURL = 'http://www.bigcommerce.com';
    	
        pageReference pr = new pageReference(strURL);
        pr.setRedirect(true);
        return pr;
    }
}