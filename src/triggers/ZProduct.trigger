trigger ZProduct on zqu__ZProduct__c (after insert, after update) {
	
	
	Map<String, zqu__ZProduct__c> mapSKUProd = new Map<String, zqu__ZProduct__c>();
	
	for (zqu__ZProduct__c zqp :Trigger.New)
	{
		mapSKUProd.put(zqp.zqu__SKU__c, zqp);
	}
	
	 Map<String, Product2> mapProds = new Map<String, Product2>();
	 													
	 for (Product2 prd : [Select Id, Name, p.Zuora_SKU__c, p.Zuora_Product_ID__c, p.Product_Type__c, p.Product_ID__c, p.ProductCode, p.IsActive, p.Family, p.Description, p.Category__c 
	 													From Product2 p
	 													where ProductCode in :mapSKUProd.KeySet() ])													
		{
			mapProds.put(prd.ProductCode, prd);
		}
	
	List<Product2> updPrds = new List<Product2>();
	List<Product2> newPrds = new List<Product2>();
	database.Dmloptions dml = new database.Dmloptions();
    Map <SObject,SObject> mpSourceObjToDestObj = new map<SObject, SObject>();
  
	
	for (zqu__ZProduct__c zqp :Trigger.New)
	{
		if (mapProds.containsKey(zqp.zqu__SKU__c) )
		{
			system.debug('*** SKU -' +zqp.zqu__SKU__c);
			Product2 eprd = mapProds.get(zqp.zqu__SKU__c);
			if (zqp.BCCategory__c <> null)
			{
				if (zqp.BCCategory__c.containsIgnoreCase('STORE') )
				{ eprd.Family = 'Store Plan';}
				else if (zqp.BCCategory__c.containsIgnoreCase('MIGRATION') )
				{ eprd.Family = 'Migration';}
				else if (zqp.BCCategory__c.containsIgnoreCase('PROFESSIONAL SERVICES') )
				{ eprd.Family = 'Consulting Services';}
				else if (zqp.BCCategory__c.containsIgnoreCase('SSL') || zqp.BCCategory__c.containsIgnoreCase('Domain'))
				{eprd.Family = 'One-time Product';}
			}
			else {eprd.Family = 'TEST';}
//			eprd.Category__c = zqp.zqu__Category__c;
//			eprd.Zuora_SKU__c = zqp.zqu__SKU__c;
//			eprd.Zuora_Product_ID__c = zqp.zqu__ZuoraId__c;
			eprd.Name = zqp.Name;
			eprd.ProductCode = zqp.zqu__SKU__c;
			if (zqp.zqu__EffectiveEndDate__c > Date.today())
			{
				eprd.isActive = true;
			}
			else eprd.isActive = false;
			
			updPrds.add(eprd);
			mpSourceObjToDestObj.put(zqp,eprd);

		}
		else
		{
			system.debug('*** new product ' +zqp.zqu__SKU__c);
			Product2 newprd = new Product2() ;
			
			if (zqp.BCCategory__c <> null)
			{
				system.debug(' *** BC category'+zqp.BCCategory__c);
				if (zqp.BCCategory__c.containsIgnoreCase('STORE') )
				{ newprd.Family = 'Store Plan';}
				else if (zqp.BCCategory__c.containsIgnoreCase('MIGRATION') )
				{ newprd.Family = 'Migration';}
				else if (zqp.BCCategory__c.containsIgnoreCase('PROFESSIONAL SERVICES') )
				{ newprd.Family = 'Consulting Services';}
				else if (zqp.BCCategory__c.containsIgnoreCase('SSL') || zqp.BCCategory__c.containsIgnoreCase('Domain'))
				 {newprd.Family = 'One-time Product';}
			}
			if (zqp.zqu__EffectiveEndDate__c > Date.today())
			{
				newprd.isActive = true;
			}
			else newprd.isActive = false;
			
			newprd.Name = zqp.Name;
			newprd.ProductCode = zqp.zqu__SKU__c;
			newPrds.add(newprd);
			mpSourceObjToDestObj.put(zqp,newprd);
			
		}
		
	}
	
	if (!updPrds.isEmpty() || newPrds.size()>0) 
	        /* calling the method of SObjectUtils.SyncObjects to insert data in the databse and map with the opportunity*/
          SObjectUtils.SyncObjects('zqu__ZProduct__c','Product2',mpSourceObjToDestObj,dml);           
	
}