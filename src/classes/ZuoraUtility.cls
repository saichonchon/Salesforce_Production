public class ZuoraUtility {
    
  public static map<string,PricebookEntry> getPricebookEntry(String strPricebook, Set<String> strProdCodes)
  {
      map<string,PricebookEntry> mpProductcodeToPricebook = new map<string,PricebookEntry>();
      try
      {
          for(PricebookEntry obj:[SELECT Id,IsActive,Name,Pricebook2Id,Product2Id,ProductCode, UnitPrice FROM PricebookEntry WHERE Pricebook2Id =: strPricebook AND ProductCode IN:strProdCodes])
          {              
              mpProductcodeToPricebook.put(obj.ProductCode,obj);
          }
      }
      catch(Exception ex)
      {
        System.Debug('Error:'+ex.getMessage());
      }
      return mpProductcodeToPricebook;
    }

    public static Zuora__CustomerAccount__c getBillingAccount(Id accId)
    {
        
        List<Zuora__CustomerAccount__c> zcalist = [Select Id, Zuora__Zuora_Id__c, Zuora__PaymentMethod_Type__c 
                                                    from Zuora__CustomerAccount__c 
                                                    where Zuora__Account__c = :accId];
        return zcaList[0];
    }

    public static void addProductsfromQuote(Set<Id> quoteIds)
    {
        
        Map <Id, zqu__Quote__c> mapzq= new Map <Id, zqu__Quote__c>([select z.Id, z.zqu__Opportunity__c 
                                                                From zqu__Quote__c z
                                                                where z.Id in :quoteIds]);
        Map<Id, zqu__QuoteCharge__c> mapzqc = new Map <Id, zqu__QuoteCharge__c> ([Select z.Id, z.zqu__Quote__r.zqu__Opportunity__c, z.Product_SKU__c, z.zqu__Quantity__c, z.zqu__ProductName__c, z.zqu__ListTotal__c, z.zqu__ListPrice__c, z.zqu__EffectivePrice__c, z.Name 
                                                                                    From zqu__QuoteCharge__c z
                                                                                    where z.zqu__Quote__c in :mapzq.KeySet()]);
        Set<String> productskus = new Set<String>();
        for (zqu__QuoteCharge__c zqc :mapzqc.Values())
        {
            productskus.add(zqc.Product_SKU__c);
        }
        List<OpportunityLineitem> oppitems = new List<OpportunityLineitem>();
        Map<string,PricebookEntry> mpProductcodeToPricebook1 = new Map<string,PricebookEntry>();
        
        if(productskus.size()>0)
        {
           mpProductcodeToPricebook1 = getPricebookEntry(Label.Zuora_PS,productskus);
          
        }
        for (zqu__QuoteCharge__c zqc :mapzqc.Values())
        {
            
            OpportunityLineitem opplnt = new OpportunityLineitem();
            opplnt.OpportunityId =zqc.zqu__Quote__r.zqu__Opportunity__c;
            opplnt.Quantity=zqc.zqu__Quantity__c;
            opplnt.UnitPrice = zqc.zqu__ListTotal__c;
            
            if (mpProductcodeToPricebook1.get(zqc.Product_SKU__c) <> null)
            {
               opplnt.PricebookEntryId = mpProductcodeToPricebook1.get(zqc.Product_SKU__c).Id;
               system.debug(' pb id '+opplnt.PricebookEntryId);
            }
            else 
            {
                ErrorEmailHelper.notifyOnError('Add Opp Products', 'OpportunityLineIten', 'Error in PricebookEntry', 'Product Code Does not Exist in PriceBookEntry  ' + zqc.Product_SKU__c );
                system.debug(' price book by product missing '+zqc.Product_SKU__c);
            }
            oppitems.add(opplnt);          
        }
        try {
            	insert oppitems;
      		} 
      	catch(Exception ex){
           	ApexPages.addMessages(ex);
         }
        
    }

    public static void deleteProducts(Set<Id> oppIds)
    {
    
      // query the Opportunity Product Line Item.
      List <OpportunityLineItem> oppl = new List <OpportunityLineItem> ([SELECT Id, OpportunityId, Family__c FROM OpportunityLineItem WHERE OpportunityId IN:oppIds]);
      
      delete oppl;
    }
    public static void updateOpps(Set<Id> oppIds)
    {
    
      // update the Opportunity stage to closed won.
      List <Opportunity> opps = new List <Opportunity> ([SELECT Id, stageName FROM Opportunity WHERE Id IN:oppIds]);
      
      for (Opportunity o :opps)
      {
        o.Stagename = 'Closed Won';
      }
      
      try {
            update opps;
      } catch(Exception ex){
                                ApexPages.addMessages(ex);
                            }
      
    } 
   
// create opp products from zuora subscription charge   
    public static void createLineItems (List <Zuora__SubscriptionProductCharge__c> lstZSubPrdCh)
    {
        List<OpportunityLineItem> lstnewOppLntm = new List<OpportunityLineItem>();  
        Set<String> productskus = new Set<String>();
        Set<Id> oppIds = new Set<Id>();
        
        for (Zuora__SubscriptionProductCharge__c zsc :lstZSubPrdCh)
        {
            system.debug('*** product type'+zsc.Zuora__Type__c);
            if (zsc.Zuora__Type__c <> 'Usage')
            {
                productskus.add(zsc.Zuora__ProductSKU_Product__c);
            }
            oppIds.add(zsc.Related_Opportunity__c);
        }
                
        Map<string,PricebookEntry> mpProductcodeToPricebook1 = new Map<string,PricebookEntry>();
        
        if(productskus.size()>0)
        {
            mpProductcodeToPricebook1 = ZuoraUtility.getPricebookEntry(Label.Zuora_Base_Products_Pricebook,productskus);
      
        }    
        List<OpportunityLineItem> exOppLntm = new List<OpportunityLineItem>();  
        
 		Map<Id, Id> mapOppPb = new map <Id, Id>();
 		for (Zuora__SubscriptionProductCharge__c zsc :lstZSubPrdCh)
        {
           if (zsc.Related_Opportunity__c<> null && mpProductcodeToPricebook1.get(zsc.Zuora__ProductSKU_Product__c) <> null)
           {     
                OpportunityLineItem opplnt = new OpportunityLineItem();
                opplnt.OpportunityId=zsc.Related_Opportunity__c;
                system.debug( ' product sku '+zsc.Zuora__ProductSKU_Product__c);
                opplnt.PricebookEntryId = mpProductcodeToPricebook1.get(zsc.Zuora__ProductSKU_Product__c).Id;
                opplnt.Quantity = zsc.Zuora__Quantity__c;
                opplnt.UnitPrice = zsc.Zuora__ExtendedAmount__c;
                if (opplnt.UnitPrice == null)
                {
                    opplnt.UnitPrice = 0;
                }
           		opplnt.Zuora_SubscriptionCharge_Id__c = zsc.Id;
                lstnewOppLntm.add(opplnt);
                mapOppPb.put(opplnt.OpportunityId, mpProductcodeToPricebook1.get(zsc.Zuora__ProductSKU_Product__c).Pricebook2Id);
           }
           else{
           	
           	  if (mpProductcodeToPricebook1.get(zsc.Zuora__ProductSKU_Product__c) == null)
           	      system.debug(' BMP/Zuora  price book by product missing '+zsc.Zuora__ProductSKU_Product__c);
 
           }
        }
        //New Opportunity Line Item  Insert.
        if(!lstnewOppLntm.isEmpty())
        {
            Try
            {
            	insert lstnewOppLntm;
            }
            catch (DMLException e)
            {
 				system.debug('Failed try to change pricebook'+mapOppPb.KeySet());
            	changeOppPb(mapOppPb) ;
            	insert lstnewOppLntm;
            }
        }
    }
  
    public static void changeOppPb(Map<Id, Id> mapOppPb)
    {
    	List<Opportunity> updOpps = new List<Opportunity>();
    	Set<Id> delProd = new Set<Id>();
    	
    	for (Opportunity o:[select Id, Pricebook2Id from Opportunity where Id in :mapOppPb.KeySet()])
    	{
    		if (o.Pricebook2Id <> mapOppPb.get(o.Id))
    		{
    			o.Pricebook2Id = mapOppPb.get(o.Id);
    			updOpps.add(o);
    			delProd.add(o.Id);
    		}
    		
    	}
    	
    	deleteProducts(delProd);
    	update updOpps;
    }
}