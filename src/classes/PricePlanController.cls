public class PricePlanController {
	
	public integer annualOrderCount {get;set;}
    public decimal aov {get;set;}
    public decimal annualGMV {get;set;}
    public Pricing__c pplan {get;set;}
    public decimal minPricePerOrder{get;set;}
    public decimal maxPricePerOrder{get;set;}
    public boolean samReqd {get;set;}
    public boolean forceEntPlan {get;set;}
    
    public  PricePlanController()
    {
    	samReqd = false;
    	forceEntPlan = false;
    }
    
    public void getPricePlan(){
        
 		if (annualGMV > 0)
 		{
	 		if (aov == null || aov == 0)
	 		    aov = (annualGMV/annualOrderCount).setscale(2);
	 		else if (annualOrderCount == null || annualOrderCount == 0)
	 		    annualOrderCount = (Integer)(annualGMV/aov);   
 		}
		
 		if ((annualOrderCount > 0 && aov >0))
 		{
        	pplan = PricingHelper.getPricing(annualOrderCount, aov, samReqd, forceEntPlan);
 		}
 		else
 		{
       		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter  atleast 2 values.');
			ApexPages.addMessage(myMsg);
 
      		return;
      	}
		if(pplan.Id == null)
      	{
       		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Sorry, no price plan was found - please contact your manager.');
			ApexPages.addMessage(myMsg);
       		system.debug( 'price plan '+pplan.Id);
 //     		return;
      	}
        else 
        {
        	
        	system.debug( 'price plan '+pplan.Id);
        
	        if (annualGMV == null || annualGMV == 0 ) {annualGMV = annualOrderCount * aov;}
	        minPricePerOrder = pplan.Minimum_Price__c * 12/pplan.Order_Max__c;
	        minPricePerOrder = minPricePerOrder.setScale(2);                
	        maxPricePerOrder = pplan.Target_Price__c * 12/pplan.Order_Max__c;               
	        maxPricePerOrder = maxPricePerOrder.setScale(2);
        }
    }



    public PageReference cancel() {
    	    
    	    annualOrderCount = 0;
    	    aov = 0;
    	    pplan = new Pricing__c();
    	    annualGMV = null;
        	minPricePerOrder = 0.00;
        	maxPricePerOrder = 0.00;            
        	forceEntPlan = false;
        	samReqd = false;
            return null; 
    }

}