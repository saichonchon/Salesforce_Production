public class ValidatePartnerController 
{
	public string TCId {get; set;}
	public string AcctId {get; set;}
	
	public boolean IsPartnerValid
    {   	
    	get
    	{
    		boolean retVal = true;
    		
    		if (PartnerPortalHelper.PartnerAccount != null)
            {
		        // Validate the current Partner Account has signed off on the T&A
		        if (!PartnerPortalHelper.HasPartnerAcceptedCurrentTerms())
		        {   
		        	TCId = PartnerPortalHelper.PartnerPortalTC.Id;
		        	AcctId = PartnerPortalHelper.PartnerAccount.Id;
		            
		            retVal = false;
		        }
            }
            
            return retVal;
	    }
    }
}