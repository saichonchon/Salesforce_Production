trigger BIData on BI_Data__c (before insert, before update, after insert, after update) {

// update the Account on the record.
  if (trigger.isBefore)  
  {
    Map<Id, Id> mpBiAcc = new Map<Id, id>();
    
    for(BI_data__c bi :Trigger.New)
    {
      
         if (bi.Opportunity__c <> null 
         	&& (bi.Account__c == null || bi.Account_Mismatch__c == true)
//               || (Trigger.isUpdate && Trigger.New[i].Opportunity__c <> Trigger.Old[i].Opportunity__c)
               
             )
             {
               mpBiAcc.put(bi.Id, bi.Opportunity__c );
             }
    }
    
    Map<Id, Opportunity> oppListMap = new Map<Id, Opportunity>([Select Id, AccountId from Opportunity where Id in :mpBiAcc.Values()]);
    
    for(BI_data__c bi :Trigger.New)
    {
      
         Opportunity o = new Opportunity();
         if (mpBiAcc.get(bi.Id) <> null)
             
             {
               o = oppListMap.get(mpBiAcc.get(bi.Id));
               bi.Account__c = o.AccountId;
             }
    }

    
  }


	if (trigger.isAfter)
	{
		List<BI_Data__c> childObjectList = new List<BI_Data__c>();
		List<BI_Data__c> oldchildObjectList = new List<BI_Data__c>();
		
		Map<Id, Id> mpBiOpp = new Map<Id, id>();
		Map<Id, BI_Data__c> mapOppBi = new Map <Id, BI_Data__c>();
		date firstDate = System.Today().toStartOfMonth();
		date lastMonth = firstDate.addMonths(-1);
		
		for(Integer i=0;i<Trigger.new.size();i++)
		{
			
	     	if (Trigger.New[i].Opportunity__c <> null)
	     	{
	            if( Trigger.isInsert || Trigger.New[i].Opportunity__c <> Trigger.Old[i].Opportunity__c)
		           {
		             mpBiOpp.put(Trigger.New[i].Opportunity__c,Trigger.New[i].Id );
		           }
	         	if (Trigger.New[i].Partner_Account__c<> null 
	         		&& Trigger.New[i].Last_Payment_Amount__c <> null 
	         		&& Trigger.New[i].Last_Payment_Amount__c > 0
	         		&& Trigger.New[i].Last_Payment_Date__c <> null
	         		&& (Trigger.isInsert || Trigger.New[i].Last_Payment_Date__c  <>  Trigger.Old[i].Last_Payment_Date__c 
	         		       ||  Trigger.New[i].Last_Payment_Amount__c <> Trigger.Old[i].Last_Payment_Amount__c )
	         		&& Trigger.New[i].Last_Payment_Date__c > lastMonth
	         		)
	         	{
	         		mapOppBi.put(Trigger.New[i].Opportunity__c, Trigger.New[i]);
	         	}
	     	}
	           
	        if ((Trigger.isInsert ||Trigger.New[i].Lifetime_GMV__c <> Trigger.Old[i].Lifetime_GMV__c)
	             && Trigger.New[i].Account__c <> null)
	         
	         {
	         	childObjectList.add(Trigger.New[i]);
	         	if (!Trigger.isInsert) oldchildObjectList.add(trigger.oldMap.get(Trigger.New[i].Id));
	         }
		}
		
		if (!mpBiOpp.isEmpty())
		{
			List<Opportunity> oppList = new List<Opportunity>();
			
			for (Opportunity o :[Select Id, BI_Data__c, AccountId, rvpe__RVAccount__c from Opportunity where Id in:mpBiOpp.KeySet()])
			{
				if (o.BI_Data__c == null || o.BI_Data__c <> mpBiOpp.get(o.Id))o.BI_Data__c = mpBiOpp.get(o.Id);
				oppList.add(o);
			}
			
			update oppList;
		}
		
		if (!mapOppBi.isEmpty())
		{ 
			PartnerCommissionsHelper.createCommrecords(mapOppBi);
		}
	
	 // do the rollups to account   
 /* commenting out
 			if( Trigger.isDelete ) {
					childObjectList = Trigger.old;
			} 
			else if (!childObjectList.isEmpty())	
			{
				//Pass in the name of the child record, in this case 'Opportunity' and the name of the parent record, in this case 'Account';	
				LookupRollupHelper lh = new LookupRollupHelper( 'Bi_Data__c', 'Account', 'BI Data - Account');
				
				//Convert the Trigger.list to a list of sObjects
				if(Trigger.isUpdate) {
					lh.rollupSummary((List<sObject>)childObjectList, (List<sObject>)oldchildObjectList);
				} else {
					lh.rollupSummary((List<sObject>)childObjectList, null);
				}   
			}
*/			
			
	} // end after actions
}