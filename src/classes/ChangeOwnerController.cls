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
           
	        objAccount =[select Id, Name, OwnerId from Account where Id = :objId];
         
            if (objAccount.OwnerId <> Label.Account_Default_Owner)
            {
            	
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to change the owner ....Please contact your manager');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            objAccount.OwnerId= USERID;
            List<Account> stAccountIds = new List<Account>();
            stAccountIds.add(objAccount);

            try
            {
                update stAccountIds;

            }
            catch(Exception exc)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to change the owner ....Please contact your support');
                ApexPages.addMessage(myMsg);
                system.debug('***ERROR: ChangeOwnerController:changeOwner: ' + exc.getStackTraceString());
            }
        }
        
        
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
           
	        objLead =[select Id, Name, OwnerId from Lead where Id = :objId];
         
            if (objLead.OwnerId <> Label.Lead_Default_Owner)
            {
            	
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to change the owner ....Please contact your manager');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            objLead.OwnerId= USERID;
            List<Lead> stLeadIds = new List<Lead>();
            stLeadIds.add(objLead);
            

            try
            {
                update stLeadIds;

            }
            catch(Exception exc)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to change the owner ....Please contact your support');
                ApexPages.addMessage(myMsg);
                system.debug('***ERROR: ChangeOwnerController:changeLeadOwner : ' + exc.getStackTraceString());
            }
        }
        
        
        return new PageReference('/' + objId);
        
    }
}