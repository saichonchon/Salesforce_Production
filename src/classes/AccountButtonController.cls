public class AccountButtonController {
   
// Constructor - this only really matters if the autoRun function doesn't work right
    private final Account theAccount;
    
   
    public AccountButtonController(ApexPages.StandardController stdController) {
        // get the current Account
        theAccount = (Account)stdController.getRecord();
    }

    public PageReference createOpp() {
       
  
       String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        
        //create an opportunity

         OpportunityHelper oh = new OpportunityHelper();
         Opportunity opp = oh.createOppProfFromAcc(theId);
         
        return new PageReference('/' + opp.id);
    }

}