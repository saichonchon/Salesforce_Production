public class ContactButtonController {
   
// Constructor - this only really matters if the autoRun function doesn't work right
    private final Contact theContact;
    
   
    public ContactButtonController(ApexPages.StandardController stdController) {
        // get the current Contact
        theContact = (Contact)stdController.getRecord();
    }

    public PageReference createOpp() {
       
 
       String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
        
        //create an opportunity

         OpportunityHelper oh = new OpportunityHelper();
         Opportunity opp = oh.createOppProfFromCon(theId);
         
        return new PageReference('/' + opp.id);
    }


}