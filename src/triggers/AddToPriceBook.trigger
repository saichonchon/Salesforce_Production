trigger AddToPriceBook on Product2 (after insert, after update) {
	
	list<PricebookEntry> lstPbe=new list<PricebookEntry>();
	sObject s = [select ID from Pricebook2 where IsStandard = TRUE];
	Map <id, Id> stdprdpbe = new Map <id, Id>();
	Map <id, Id> zprdpbe = new Map <id, Id>();
	
	for (PricebookEntry pbe :[Select p.ProductCode, p.Product2Id, p.Pricebook2Id 
								From PricebookEntry p
								where Pricebook2Id = :s.Id]) 
	{
		stdprdpbe.put(pbe.Product2Id, pbe.Pricebook2Id );
	}
	
	for (PricebookEntry pbe :[Select p.ProductCode, p.Product2Id, p.Pricebook2Id 
								From PricebookEntry p
								where Pricebook2Id = :Label.Zuora_Base_Products_Pricebook
								OR Pricebook2Id = :Label.Zuora_PS ]) 
	{
		zprdpbe.put(pbe.Product2Id, pbe.Pricebook2Id );
	}
	
	
	for (Product2 newp :Trigger.New)
	{
		if(newp.Category__c <> null )
			{
				
				if (!stdprdpbe.containsKey(newp.Id))
				{
					PricebookEntry stdpb = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=newp.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
					lstPbe.add(stdpb);
				}
				if (!zprdpbe.containsKey(newp.Id))
				{
					PricebookEntry zPB = new PricebookEntry();
					if(newp.Category__c == 'Base Products' )
					{ zPB.Pricebook2Id = Label.Zuora_Base_Products_Pricebook;}
					else {zPB.Pricebook2Id = Label.Zuora_PS;}
	//				zPB.UnitPrice=objProduct.Advertised_Price__c;
					zPB.UnitPrice=0.0;
	    			zPB.UseStandardPrice=true;
	    			zPB.IsActive=true;
	    			zPB.Product2Id = newp.id;
    				lstPbe.add(zPB);
				}
			}
	}
     Try {
     		insert lstPbe;
     }
     catch (exception e)
     {
     	system.debug('*** failed ');
     }
}