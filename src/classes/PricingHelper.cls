public class PricingHelper {
	
	
	public static Pricing__c  getPricing(integer annualOrderCount, decimal aov, boolean samReqd, boolean forceEntPlan)
		
	{
        string qaov ;
        string planType ='';
        integer newOrderCount ;
        Pricing__c pplan = new Pricing__c();
        
        if (aov <= 25) qaov = 'Low';
        else if (aov > 25 && aov <= 300) qaov = 'Normal';
        else if (aov > 300) qaov = 'High';
        
        Decimal annualGMV = annualOrderCount * aov;
        boolean basicTier = true;
        
        system.debug(' SAM '+samReqd);
        
        If (annualGMV > 1000000) planType = 'Enterprise';
        else if (samReqd == false && annualGMV <= 50000) planType = 'Standard';
        else if (samReqd == false && annualGMV > 50000 && annualGMV <= 125000) planType = 'Plus';
        else if (annualGMV > 125000 ) basicTier = false;
        
 	    if (planType == 'Standard' || planType ==  'Plus' )
	        { newOrderCount = 0 ;}
	    else
	        { newOrderCount = annualOrderCount ;}
        
        system.debug('order count '+annualOrderCount);
        system.debug('plan  '+planType);
        
        String query = 'Select Id, Name, AOV__c,Incr_Fee__c,Plan_Type__c, Incr_Price_Per_Order__c, Order_Increment__c,Order_Max__c,Price_per_Order__c,Minimum_Price__c, Target_Price__c,Target_Take_Rate__c,Tier__c from Pricing__c ';
        query = query + 'where AOV__c =:qaov and Order_Max__c >= :newOrderCount and Min_Base_AOV__c < :aov ';
        
        if ( qaov <> 'High')
        {
            query = query + ' and Max_Base_AOV__c >= :aov ';
        }
		
		if (basicTier == false)
		{
			query = query + ' and Tier__c <> null and Tier__c <> \'\'';
		}
		if (forceEntPlan == true)
		{
			planType = 'Enterprise';
			query = query + ' and Tier_Value__c > 9 ';
		}
		if (samReqd == true)
		{
			query = query + ' and ((Minimum_Price__c < 2500 and Target_Price__c > 2500) Or Target_Price__c > 2500 ) ';
		}
		
//        if (planType == 'Enterprise')
		if (planType <> '')
        {
            query =  query + ' and Plan_Type__c = \'' +planType  +'\'';
            
        }
        
        
        query = query + ' order by Order_Max__c, Tier__c, Plan_Type__c asc ';
        List<Pricing__c> pplanlist = database.query(query);
        
        if(pplanList.size() > 0)
        { pplan = pplanList[0];}
        
		return pplan;
	}
}