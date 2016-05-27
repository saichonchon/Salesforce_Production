/********************************************************************** 
Name:  ZuoraSubscription
  ======================================================
 Purpose: trigger to populate fields on Opportunity.
====================================================== 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 7/1/2015  Initial development
 
***********************************************************************/
trigger ZuoraSubscription on Zuora__Subscription__c (before insert, before update, after insert, after update)
{
// before action - populate opportunity lookup field on zuora subscription	
	if(Trigger.isBefore)
 	{ 
 		for(Zuora__Subscription__c  obj : Trigger.new)
	     {
 			if (obj.crmId__c <> null )
	            obj.Opportunity__c = obj.crmId__c;
	     }
 		
 	}

// after action populate all zuora fields on Opportunity 
// and Opportunity product history (kicked off by opportunity trigger).
	if(Trigger.isAfter)
 	{ 	
	// create new version of Opportunity product history.
     database.Dmloptions dml = new database.Dmloptions();
     Map <SObject,SObject> mpSourceObjToDestObj = new map<SObject, SObject>();
     Map<Id, Id> mapZidOpp = new Map<Id, Id>();  
     List<Opportunity> updOpps = new List<Opportunity>(); 
	     for(Zuora__Subscription__c  obj : Trigger.new)
	     {
	            Opportunity o = new  Opportunity ();
	            if (obj.crmId__c <> null)
	            {
		            o.Id = obj.crmId__c;
		            o.Zuora_MRR__c = obj.Zuora__MRR__c;
		            o.Zuora_Version__c = obj.Zuora__Version__c;
		            o.MonthlyRecurringRevenue__c = obj.Zuora__MRR__c;
		            updOpps.add(o);
//		            mpSourceObjToDestObj.put(obj,o);
//		            mapZidOpp.put(obj.Id, obj.crmId__c);
	            }
	            
	      }
        
        /* calling the method of SObjectUtils.SyncObjects to insert data in the databse and map with the opportunity*/
//          SObjectUtils.SyncObjects('Zuora__Subscription__c','Opportunity',mpSourceObjToDestObj,dml);           
		StaticVariables.ZuoraUpdate=true;
		Try{			
			 update updOpps;
		}
		Catch (exception e)
		{
			  
           ErrorEmailHelper.notifyOnError('Zuora Subscription Trigger', 'Opportunity Sync', 'Error in Opportunity Sync', 'Error With Opportunity: ' +  updOpps[0] + '; Error Message: ' + e.getMessage());
        }		
		StaticVariables.ZuoraUpdate=false;
		
		List <Zuora__SubscriptionProductCharge__c> updzuorasubs = new List<Zuora__SubscriptionProductCharge__c>();
		for (Zuora__SubscriptionProductCharge__c zuorasub :[Select Id, Related_Opportunity__r.Id, Zuora__Subscription__c, Zuora__ExtendedAmount__c, Zuora__Type__c, Zuora__Price__c, Zuora__ProductSKU_Product__c, Zuora__Quantity__c, Product_Type__c 
                                                From Zuora__SubscriptionProductCharge__c
                                                where Zuora__Subscription__c in : Trigger.New
                                                ])
        {
        	if (mapZidOpp.get(zuorasub.Zuora__Subscription__c) <> null)
        	{
        		Id oppId = mapZidOpp.get(zuorasub.Zuora__Subscription__c);
        		if (zuorasub.Related_Opportunity__r.Id == null || zuorasub.Related_Opportunity__r.Id <> oppId)
        		{
        			zuorasub.Related_Opportunity__c = oppId;
        			system.debug('*** sub opp'+zuorasub.Related_Opportunity__c );
        			updzuorasubs.add(zuorasub);
        		}
        	}
        }
       
        update updzuorasubs;

 	}
}