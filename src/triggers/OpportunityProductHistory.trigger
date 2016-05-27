/**********************************************************************
Name:  Opportunity Product History Trigger 
======================================================
 Purpose: Perform action on updates.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 9/5/2014  Initial development
 
***********************************************************************/

trigger OpportunityProductHistory on Opportunity_Product__c (after insert) {
	
   // Creating Instance Of A Class which Performs MBA store Logic. 
 //   OpportunityOperations operation= new OpportunityOperations();

	Set<ID> parentOppIds = new Set<Id> ();
	if(Trigger.isAfter)
    {   
         for(Integer i=0;i<Trigger.new.size();i++)
         {
            if (Trigger.New[i].RevenueChange__c > 0 
                 && Trigger.New[i].LastVersion__c == true) 
               
            { 
                parentOppIds.add(Trigger.new[i].OpportunityID__c);
               
            }
         }
         if(!parentOppIds.isEmpty() ){
            OpportunityOperations.updateUpgradeOpps(parentOppIds);
         }   
    }
	

}