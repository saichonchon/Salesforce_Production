/***
@Author: Maria Huemmer
@Description: Creat Cancellation Case from Opportunity
@History: July-21-2015 Maria Huemmer 
***/

public class CreateCancelCasefromOpp {
// Constructor - this only really matters if the autoRun function doesn't work right
    private Opportunity o;
    public string theId;
    public CreateCancelCasefromOpp(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdcontroller.getRecord();
    }
    
    // Code we will invoke on page load - visualforce page will be "triggering" it via a custom button
    public PageReference autoRun() {
 
        theId = ApexPages.currentPage().getParameters().get('id');
 		System.debug('OppId' + theId);
		// Display the Visualforce page's content if no Id is passed over
        if (theId == null) {
            
            return null;
        }
        
                    
      //Create a case with the ID we got
       
       case c = createcase();
       
        // Get the URL for the newly created case's "edit" page and return the user there 
       PageReference pageRef = new PageReference('/' + c.Id+'/e?retURL=%2F'+ c.Id);
       pageRef.setRedirect(true);
       return pageRef;
 
    }    
         
    private case CreateCase() {
        // Get the opportunity data we want to populate on the case
      Opportunity o = [select id, name, AccountId, BillingAmount__c, Contact__c, MBASubscriptionID__c, ProductId__c, Product__c, Subscription__C from Opportunity where id =:theId]; {
       System.debug('AccountId' + o.AccountId);
        

        //Store the userid to pass to the case as the case owner
        String userid = UserInfo.getUserId();
        System.debug('UserID' + userid);
        //Create a case with all the data
        Case c = new Case(AccountId = o.AccountId, ContactId=o.Contact__c, Opportunity__c=o.id, 
        				Origin='Phone', OwnerId=userid,  Paused_plan_prior_price__c = o.BillingAmount__c, 
        				Plan_at_Pause_Offer__c = o.Product__c,Product_ID__c = o.ProductID__c,
        				RecordTypeId = '012a0000001NYWL', Status = 'New', Subject = 'Cancellation ' + o.Name);  
        if (o.Subscription__c <> null ) c.Subscription__c = o.Subscription__c;
        insert c;
        return c;
    }
        
    }

}