/**********************************************************************
Name:  Opportunity Controller
============================================================
 Purpose: Create Opportunities from Buttons using onclick js

1. Create Opportunity from Subscription.
2. Create Trial Opportunity from Account.
3. Create Upsell Opportunity from Store purchase opportunity.
============================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 3/5/2014  Initial development
 
***********************************************************************/

public without sharing class CreateopportunityController {

    public database.saveresult [] result{get; set;}
    public ID theID;
 
 
  // creating Instance of OpportunityOperations Class.
      OpportunityOperations OppOperation = new OpportunityOperations(); 

    // Calling autorun method.
    public PageReference autoRun()
    {
        Id OppId;
        theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('theId'+theId);
        Schema.SObjectType sobjectType = theId.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		system.debug('my object'+sobjectname);
		if (sobjectName =='Account') //create trial opportunity
		{
			Opportunity newOpp = CreateTrialopportunity(theId);
			OppId = newOpp.Id;
		}
		else if (sobjectName =='Opportunity') //create upsell opportunity
		{
			 if (ApexPages.currentPage().getUrl().containsIgnoreCase ('CreateOpportunity'))
			 {
					Opportunity newOpp = CreateUpgradeOpportunity(theId);
					OppId = newOpp.Id;
					system.debug(OppId);
			 }
			 else
			 {
			 		Opportunity newOpp = CreatePSOpportunity(theId);
					OppId = newOpp.Id;
					system.debug(OppId);
			 }
		}
		
		else {
	    // List to collect All Subscription Id.
	        list<String> lstSubID = new list<String>();
	        lstSubID.add(theId);
	        system.debug('lstSubID'+lstSubID);
	        
	    // Calling Createopportunity method to perform further Operations.
	        Createopportunity(lstSubID);
	        for(Integer i=0;i<result.size();i++)
	        {
	            OppId=result[0].id;
	        }
	        system.debug(OppId);
		}
		
		if (OppId <> null)
		{
			PageReference newocp = new PageReference('/'+OppId);
	        newocp.setRedirect(true);
	        return newocp;
		}
	    else
	    {
	    	PageReference newocp = new PageReference('/'+theId);
	        newocp.setRedirect(true);
	        return newocp;
	    }
    }

    // Method to perform Opportunity Creation Operation.
    public void Createopportunity(List<String> lstSubId)
    {
    
//      Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
    	
   // creating Instance of OpportunityOperations Class.
      OpportunityOperations OppOperation = new OpportunityOperations(); 

    //List to Hold Opportunity to be insert. 
        List<Opportunity> lstopp = new List<Opportunity>();
    // Set to hold All AccountId.   
        Set<Id> staccid = new Set<Id>();
        
        for(Subscription__c obj:[SELECT Account__c, Account__r.Name, Id,MBASubscriptionID__c, PurchaseDate__c, Purchase_Rep__c, Purchase_Team__c, Revenue_Rep__c, Revenue_Team__c, OwnerId 
        						 FROM Subscription__c WHERE Id IN:lstSubId])
        {   
            System.debug('Subscription object'+obj);
            if(obj.Account__c!= null)
            {
                staccid.add(obj.Account__c);
                Opportunity Opp = new Opportunity();
                Opp.Name= obj.Account__r.Name + ' - ' + obj.MBASubscriptionID__c;
                Opp.StageName = Label.Opportunity_Stage_Purchased;
//                Opp.RecordTypeId = StoreRecordTypeId;
                Opp.SubscriptionType__c = 'Store';
				Opp.pricebook2Id =Label.Sales_Pricebook;
                Opp.isTrial__c = false;
                Opp.AccountId = obj.Account__c;
                Opp.MostRecentSubscription__c=obj.Id;
                if (obj.Purchase_Rep__c <> null) Opp.Purchase_Rep__c = DLUtility.getuserbyName(obj.Purchase_Rep__c).Id;
                Opp.Purchase_Team__c = obj.Purchase_Team__c;
                if (obj.Revenue_Rep__c <> null) 
                {
                	Opp.Revenue_Rep__c = DLUtility.getuserbyName(obj.Revenue_Rep__c).Id;
                }
                else
                {
                	Opp.Revenue_Rep__c = obj.OwnerId;
                }
           
			    Opp.Revenue_Team__c = obj.Revenue_Team__c;
                if (obj.PurchaseDate__c <> null) Opp.CloseDate= obj.PurchaseDate__c;
                else Opp.CloseDate= Date.Today().addDays(30);
                lstopp.add(Opp);
            }
        }
        system.debug('lstopp'+lstopp);
        
    // Checking for empty.  
        if(!lstopp.isEmpty())
        {
            result=Database.insert(lstopp);
            system.debug(result);
        // Calling method to Perform Creation Of OpportunityContactRole.        
            OppOperation.createOpportunityContactRole(staccid,lstopp);
        }
        
    }   
    
 
   // Method to perform Upgrade Opportunity Creation Operation.
    public Opportunity CreateUpgradeOpportunity(Id OppId)
    {
       
       Opportunity Opp = new Opportunity();
       if(OppId != null)
       {     
			Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
			
	       String query = 'Select ';     
	       Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
	
			// Grab the fields from the describe method and append them to the queryString one by one.
			for(String s : objectFields.keySet()) {
	   			query += ' ' + s + ', ';
			}
	
			// Manually add related object's fields that are needed.
			query += 'Account.Name from Opportunity where Id =\'' +OppId + '\''; // modify as needed
	        system.debug('***'+query);
	         
	        Opportunity o = database.query(query)  ;    
         
            Opp = o.clone(false, true,false, false);
            Opp.Name=  o.Name + ' - Upgrade';
            Opp.RecordTypeId = UpgradeRecordTypeId;
            Opp.pricebook2Id =Label.UpgradePricebook;
            Opp.OwnerId = UserInfo.getUserId();
            Opp.forecastCategoryName = 'Pipeline';
            Opp.Revenue_Rep__c = UserInfo.getUserId();
            Opp.Revenue_Team__c = DLUtility.getuserbyName(UserInfo.getName()).Department;
            Opp.isTrial__c = false;
            Opp.StageName = 'Qualify';
            Opp.Amount = 0.00;
            Opp.ParentOpportunity__c = o.Id;
            Opp.MKT_Friendly__c = null;
            Opp.MKT_Case_Study__c = null;
            Opp.MKT_Showcase__c = null;
            Opp.MKT_Testimonial__c = null;
            Opp.Client_Reference_Status__c = null;
            Opp.Big_Brand__c = null;
            Opp.Zuora_External_Id__c = null;
             
            Opp.CloseDate=Date.today().addDays(30);
            insert Opp;
		 
        }
        
        return Opp;
    }   
    
	// Method to perform Trial Opportunity Creation Operation.
    public Opportunity CreateTrialopportunity(Id accId)
    {
    
 		Id TrialRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
        //List to Hold Opportunity to be insert. 
        List<Opportunity> lstopp = new List<Opportunity>();
     	// Set to hold All AccountId.   
        Set<Id> staccid = new Set<Id>();
         
        Account obj= [SELECT Id, name, MBAAccountID__c, Source__c 
        						 FROM Account WHERE Id =:accId];
        Opportunity Opp = new Opportunity();
            
            if(obj!= null)
            {
                staccid.add(obj.Id);
                Opp.Name= obj.Name ;
                Opp.RecordTypeId = TrialRecordTypeId;
                If (obj.Source__c == 'BMP')
                {Opp.pricebook2Id = Label.Zuora_Base_Products_Pricebook;}
                else 
                {Opp.pricebook2Id =Label.Sales_Pricebook;}
                Opp.isTrial__c = true;
                Opp.StageName = 'Prospect';
                Opp.CloseDate=system.today();
                Opp.AccountId = obj.Id;
                Opp.MBAAccountId__c = obj.MBAAccountId__C;
				lstopp.add(Opp);
            	
            }
            
           // Checking for empty.  
        if(!lstopp.isEmpty())
        {
          	result=Database.insert(lstopp);
            	system.debug(result);
         // Calling method to Perform Creation Of OpportunityContactRole.        
            OppOperation.createOpportunityContactRole(staccid,lstopp);
         }
        
        return Opp;
    } 
	// Method to perform PS Opportunity Creation Operation.
    public Opportunity CreatePSOpportunity(Id oppId)
    {
     //create an opportunity
      
        Opportunity opp = OpportunityHelper.createOppProfFromOpp(oppId);
        
        return Opp;
    } 

 
}