public without sharing class ChangeOwnerController 
{   
    private static final Id USERID = UserInfo.getUserId();
    private static final User CURUSER = [SELECT Id, Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
    private ApexPages.StandardController controller;
    public Account objAccount;
    public Id objId;
    public Lead objLead;
    
    public ChangeOwnerController(ApexPages.StandardController cntrl) 
    {
        controller = cntrl;
//        objAccount = (Account)cntrl.getRecord();
  
        objId = cntrl.getId();
      
    }
    
    public pageReference changeOwner()
    {
        system.debug('***ChangeOwnerController:changeOwner - objId: ' + objId);
        if (objId != null)
        {
           
	        objAccount =[select Id, Name, OwnerId, Owner.IsActive from Account where Id = :objId];
         
            boolean AccountCanBeReassigned = false;
            if (!objAccount.Owner.IsActive)
            {
                // anything owned by an inactive user/queue can be reassigned
                AccountCanBeReassigned = true;
            }
            else if (objAccount.OwnerId == Label.Lead_Default_Owner)
            {
                // anything owned by the bigcommerce default owner can be reassigned
                AccountCanBeReassigned = true;
            }

            if (AccountCanBeReassigned)
            {
                // let the current user claim the record
                objAccount.OwnerId= USERID;

                try
                {
                    update objAccount;

                }
                catch(Exception exc)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to change the owner ....Please contact your support');
                    ApexPages.addMessage(myMsg);
                    system.debug('***ERROR: ChangeOwnerController:changeOwner: ' + exc.getStackTraceString());
                    return null;
                }
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to change the owner ....Please contact your manager');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        // return the user back to the account
        return new PageReference('/' + objId);
        
    }

// Redirect the user back to the original page 
	public PageReference back() {  
	  		  
            String theId = controller.getId();
            System.debug('test id '+theid   );
            if (theId == null) {           
// Display the error message if no Id is passed over      
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error determining Opportunity');
                ApexPages.addMessage(myMsg);  

    	  	    return null;  
    	  	    }  
            PageReference pageRef = new PageReference('/' + theId);       
            pageRef.setRedirect(true);     
            return pageRef;     
         }
         
    public pageReference changeLeadOwner()
    {
        system.debug('***ChangeOwnerController:changeLeadOwner - objId: ' + objId);
        if (objId != null)
        {
           
	        objLead =[select Id, Name, OwnerId, Owner.Type, Owner.IsActive from Lead where Id = :objId];

            boolean LeadCanBeReassigned = false;
            if (!objLead.Owner.IsActive)
            {
                // anything owned by an inactive user/queue can be reassigned
                LeadCanBeReassigned = true;
            }
            else if (objLead.OwnerId == Label.Lead_Default_Owner)
            {
                // anything owned by the bigcommerce default owner can be reassigned
                LeadCanBeReassigned = true;
            }
            else if (objLead.Owner.Type == 'Queue')
            {
                // anything owned by a queue
                LeadCanBeReassigned = true;
            }
         
            if (LeadCanBeReassigned)
            {
                // let the current user claim the record
                objLead.OwnerId= USERID;
                try
                {
                    update objLead;

                }
                catch(Exception exc)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to change the owner ....Please contact your support');
                    ApexPages.addMessage(myMsg);
                    system.debug('***ERROR: ChangeOwnerController:changeLeadOwner : ' + exc.getStackTraceString());
                    return null;
                }
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to change the owner ....Please contact your manager');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        // return the user to the lead        
        return new PageReference('/' + objId);
    }
}