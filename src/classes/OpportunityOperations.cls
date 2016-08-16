/**********************************************************************
Name:  OpportunityOperations
======================================================
 Purpose: Perform action on OpportunityOperations.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick   12/3/2014   update owner on account.
2.0 Maggie Frederick   12/4/2014   change opp name
3.0 Maggie Frederick   12/4/2014   set revenue rep from upgrade opp
4.0 Maggie Frederick   12/9/2014	add product button logic
5.0 Maggie Frederick   12/13/2014   add strategic partner and same month downgrade
5.1 Maggie Frederick   1/22/2015    add change account logic and report checkboxes on history
5.2 Maggie Frederick   2/11/2015 	remove revenue rep for upgrade opportunity - use owner instead
5.3 Maggie Frederick   7/1/2015		changes for bmp
5.4 Maggie Frederick   11/1/2015	implement 90 day rule
5.5 Maggie Frederick   11/17/2015	changes for sbd  
***********************************************************************/

Public without sharing Class OpportunityOperations{
    

	public static Id StoreRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_StorePurchase).getRecordTypeId();
	public static Id TrialRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();
	public static Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();

    // Map to hold OwnerId and Departement Value.
    public Map<String,String> mpOwnerIdToDepartment = new Map<String,String>();
    
               
/*
public Map<String,String> getMBAaccToSubIdmap(List<Opportunity> lstopp)
{
    // Map to hold All MBASubscriptionID.
    Map<String,String> mpMBAAccountIdToMBASubId = new Map<String,String>();
     
    for(Opportunity obj:lstopp)
    {   
        if(obj.MBA_Account_ID__c!=null && obj.MBASubscriptionID__c!=null){
           mpMBAAccountIdToMBASubId.put(obj.MBA_Account_ID__c,obj.MBASubscriptionID__c);
        }
    }
    return mpMBAAccountIdToMBASubId;
}*/

	public static map<string,PricebookEntry> getPricebookEntry(String strPricebook, List<String> strProdCodes)
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
	
// Method to query Contact on the basis of AccountID.
public map<Id,Contact> querycontact(Set<Id> setAccid)
{
    Set<Id> primaryContacts = new Set<Id>();
    Set<Id> mbaContacts = new Set<Id>();
    
    Map<Id,Contact> mpAccountIdToContact = new Map<Id,Contact>();
    for(Contact obj:[SELECT Id, AccountId, Account.Name, Name, MBAAccountID__c,Email,Phone, Primary_MBA_Contact__c, Type__C From CONTACT WHERE AccountId IN:setAccid order by createddate desc])
    {
   // if it is a primary contact this is the One !!      
          if (obj.Type__c == 'Primary Contact')
 		  {
 		  	if (!mpAccountIdToContact.containsKey(obj.AccountID))
            {	mpAccountIdToContact.put(obj.AccountID,obj); }
            else
            {
            	mpAccountIdToContact.remove(obj.AccountID);
            	mpAccountIdToContact.put(obj.AccountID,obj);
            }
            primaryContacts.add(obj.AccountID);
            system.debug('Primary Contact found' );
 		  }
// otherwise if no primary was found add the first mba contact
		  else if ( !mpAccountIdToContact.containsKey(obj.AccountID) )
	 		  	{
		 		  		mpAccountIdToContact.put(obj.AccountID,obj);
		 		  		if (obj.Primary_MBA_Contact__c == true) mbaContacts.add(obj.AccountID);
	 		  	}	
	 	  else  if ( mpAccountIdToContact.containsKey(obj.AccountID)  
	 	             && !primaryContacts.contains(obj.AccountId)
	 	             && !mbaContacts.contains(obj.AccountId)
	 	             && obj.Primary_MBA_Contact__c == true
	 	  			)
 		  			{
 		  				mpAccountIdToContact.remove(obj.AccountID);
            			mpAccountIdToContact.put(obj.AccountID,obj);
 		  			}
 		  	    
		
       }
            
        return mpAccountIdToContact;
}
 
//Before Insert Operations 
public void BeforeInsert(List<Opportunity> lstopp)
{
    system.debug('IN BeforeInsert');
// setting contact on the opportunity

    Set<Id> AccountIds = new Set<Id> ();
    Set<Id> AcctOwnerIds = new Set<Id> ();
    
    if(lstopp.size()>0){
        for(Opportunity obj:lstopp)
        {   
            system.debug('obj'+obj.Name);    
            if (obj.Contact__c == null)
            {
              AccountIds.add(obj.AccountID);
            }   
            if ( obj.RecordtypeId <> UpgradeRecordTypeId 
                &&  UserInfo.getProfileId()==Label.API_User_Profile 
				&&	obj.OwnerId <> label.Account_Default_Owner
			   )
			    {
			    	system.debug('Check opp owner');
			    	AcctOwnerIds.add(obj.AccountID);
			    }	
        }
    }
    if (AcctOwnerIds.size() > 0)
    {
	    for (Account a :[select Id, OwnerId, Owner.Name, Enterprise_Account__c, CreatedDate, Valid_Activity_Date__c, Valid_Activity_by__c, 
	    				(Select Id, PurchaseDate__c, Stage_Change_Date__c, OwnerId from Opportunities)
	    				from Account where Id in :AcctOwnerIds])
	    {
	    	date historyDate = Date.today().addDays(-90);
	    	boolean isValid = true;
	    	
	    	if (a.CreatedDate > historyDate
	    		 || a.Enterprise_Account__c > 0 
	    		 || ( a.Valid_Activity_by__c == a.Owner.Name
	    	    		&& a.Valid_Activity_Date__c > historyDate))
	    	{
	    		AcctOwnerIds.remove(a.Id);
	    		isValid = false;
	    	}
	    	if (isValid)
	    	{ 
	    		for (Opportunity o :a.Opportunities)
	    		{
	    			if (o.OwnerId == a.OwnerId &&
	    			 	(o.PurchaseDate__c > historyDate || o.Stage_Change_Date__c > historyDate ))
	    				AcctOwnerIds.remove(a.Id);
	    		}
	    	}
	    }
    }  

	if (AcctOwnerIds.size() > 0)
    {
    	for(Opportunity obj:lstopp)
        { 
        	if (AcctOwnerIds.contains(obj.AccountId))
        	     obj.OwnerId = label.Account_Default_Owner;
        }
    }    
   
   // Map to Hold AccountID and Contact Id.
    Map<Id, Contact> mpAccountIdToContact = new Map<Id,Contact>();
    if(AccountIds.size()>0)
    {
       mpAccountIdToContact = querycontact(AccountIds);
    }
    
    if(lstopp.size()>0){
        for(Integer i=0;i<lstopp.size();i++)
        {  
            if(lstopp[i].Contact__c == null && mpAccountIdToContact.containskey(lstopp[i].AccountID))
            {
               lstopp[i].Contact__c = mpAccountIdToContact.get(lstopp[i].AccountId).Id ;
               lstopp[i].Contact_Phone__c = mpAccountIdToContact.get(lstopp[i].AccountId).Phone ;
            }
// set the name on the opportunity
        	
            if (mpAccountIdToContact.containskey(lstopp[i].AccountID))  
            {
                try 
                {
                    lstopp[i].Name = setOppName(mpAccountIdToContact.get(lstopp[i].AccountId).Account.Name, lstopp[i].MBASubscriptionID__c) ;  
                }
                catch (Exception e)
                {
                    System.Debug(e);
                }
               
            }
        }
    }
    
}

public void AfterInsert(List<Opportunity>lstopp)
{   

// Handle situation where a lead with MBA trial was mnaully converted to create the Opportunity.
// Populate MBA subscription ID and sync with MBA Sub
// When a new opportunity is created by MBA staging add th eproducts.

    map<String, Id> mpSubOppIds = new  map<String, Id>();
    Map<String, Id> mpMBASubOppIds = new Map<String,Id>();
    // Map to hold OpportunityIds and Opportunity Value.
    Map<Id,Opportunity> mpOppIdToOpportunity = new Map<Id,Opportunity>();
       
    // Map to store ProductId and Opportunity Id.
    Map<Id,String> mpOppIdToProId = new map<Id,String>();
    Set<Id> oppIds = new Set<Id>();
 
    if(lstopp.size()>0){
        for(Opportunity opp:lstopp)
        {          
            if((opp.MBAAccountID__c ==null || opp.MBASubscriptionId__c == null) && opp.MostRecentSubscription__c <> null )
            {   
               
               if (opp.MBASubscriptionId__c == null)	
               {
               		mpSubOppIds.put(opp.MostRecentSubscription__c, opp.Id);
               }
               else
               {
               	   mpMBASubOppIds.put(opp.MBASubscriptionId__c, opp.Id);
               }
            }     
            if (opp.MBASubscriptionId__c <> null && opp.ProductID__c <> null)
            {
	           	 If ( opp.Source__c == 'BMP')  
	           	 {
	           	 	system.debug( 'Insert with BMP');
	           	 }
		          else
		          {     
		               mpOppIdToOpportunity.put(opp.Id,opp);    
		               mpOppIdToProId.put(opp.Id, opp.ProductID__c);    
		          }
            }    
            oppIds.add(opp.Id); 
        }
    }
   
    
    if(mpOppIdToProId.size()>0 || mpOppIdToOpportunity.size()>0){
    	handleOppProducts(mpOppIdToProId, mpOppIdToOpportunity);
   		 }
    if(mpOppIdToOpportunity.size()>0){
    	handleOppprodHist(mpOppIdToOpportunity);
    	} 
// calling future methods    	
    if (!mpSubOppIds.isEmpty()) syncOppwithStagingSub(mpSubOppIds);
    if (!mpMBASubOppIds.isEmpty()) syncOppwithMBASub(mpMBASubOppIds)  ;	
    createOpportunityContactRole(oppIds);
}

public void beforeInsertUpdate(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isDelete, Boolean isUpdate, 
                         List<Opportunity> lstnew,List<Opportunity> lstold)
{
    
    // Map To Hold AAccount
    Map<Id,Account> mpAccounts = new Map<Id,Account>();
    Set<Id> AccountIds = new Set<Id> ();
    
    // List To Hold All Opportunity OwnerId.
    List<String> lstOppOwnerId = new List<String>();
 
// To find the related subscription
    
    // Map to collect MBAAccountIDAccount
    Map<String,String> mpMBAAccountIdToMBASubId =  new Map<String,String>();
    
    // Map To Get Subscription Id For MBASubscription.
    Map<String,Subscription__c> mpMBASubIDToSubId = new Map<String,Subscription__c>();
    
    List <Opportunity> sbdopps = new  List <Opportunity> ();
    List<Opportunity> acctOpps = new List<Opportunity>();
     
    if(lstnew.size()>0){
        for(Opportunity obj:lstnew)
        {   
            lstOppOwnerId.add(obj.OwnerID); //--------------------- Addition
 // populate subscription if empty           
            if(obj.MBA_Account_ID__c!=null && obj.MBASubscriptionID__c!=null
               && obj.Subscription__c  == null)
            {
               mpMBAAccountIdToMBASubId.put(obj.MBA_Account_ID__c,obj.MBASubscriptionID__c);
            }
 // populate contact           
            if (obj.Contact__c == null)
            {
              AccountIds.add(obj.AccountID);
            }
            if ( obj.Strategic_Partner__c ==null &&
		  		(obj.LandingPage__c <> null && (obj.LandingPage__c <> '/' ) || obj.referral_id__c <> null) )
		  	{
		  		sbdopps.add(obj);
		  	}

              
        }
    }
    

    
    // Query to get the Departement on the basis of OwnerId.
    if(lstOppOwnerId.size()>0){
        for(User obj:[SELECT Department,Id FROM User WHERE Id IN:lstOppOwnerId]) 
        {
            mpOwnerIdToDepartment.put(obj.Id,obj.Department);
        } 
    }
    
    if(mpMBAAccountIdToMBASubId.values().size()>0){  
        for(Subscription__c objs:[SELECT Id, Account__r.Id, MBASubscriptionID__c FROM Subscription__c WHERE MBASubscriptionID__c IN:mpMBAAccountIdToMBASubId.values() and Account__c <> null])
        {
            mpMBASubIDToSubId.put(objs.MBASubscriptionID__c,objs);
        }
    }    

    // Map to Hold AccountID and Contact Id.
    Map<Id, Contact> mpAccountIdToContact = new Map<Id,Contact>();
    if(AccountIds.size()>0)
    {
       mpAccountIdToContact = querycontact(AccountIds);
    }
    
    // List to collect  Opportunity.
    List<Opportunity> trialOpps = new List<Opportunity>();
    List<Opportunity> paidOpps = new List<Opportunity>();
    List<Opportunity> updOpps = new List<Opportunity>();
    
    
       for(Integer i=0;i<lstnew.size();i++)
        {   
            if(lstnew[i].Subscription__c == null && mpMBASubIDToSubId.get(lstnew[i].MBASubscriptionID__c)!=null)
            {
                Subscription__c s = mpMBASubIDToSubId.get(lstnew[i].MBASubscriptionID__c);
                if (s.Account__r.Id == lstnew[i].AccountId)
                lstnew[i].Subscription__c = s.Id;
            }
            
            if(lstnew[i].Contact__c == null && mpAccountIdToContact.containskey(lstnew[i].AccountID))
            {
             	lstnew[i].Contact__c = mpAccountIdToContact.get(lstnew[i].AccountId).Id ;
              	
            }
            
            If (lstnew[i].Source__c == 'BMP' && lstnew[i].MonthlyRecurringRevenue__c  == null )
            {
            	
            	if (lstnew[i].Zuora_MRR__c <> null) lstnew[i].MonthlyRecurringRevenue__c = lstnew[i].Zuora_MRR__c;
            	else
            	lstnew[i].MonthlyRecurringRevenue__c = 0.0;
            	
            }
            
            // Assigning Revenue Rep as the Opportunity Owner.
            

            if( (isInsert && !lstnew[i].isTrial__c) ||
                (isUpdate && !lstnew[i].isTrial__c &&
                             (lstnew[i].MonthlyRecurringRevenue__c <> lstold[i].MonthlyRecurringRevenue__c
                             || lstnew[i].ProductId__c <>  lstold[i].ProductID__c))
                )
            {
            	system.debug('setting revenue rep ' );
            	if (lstnew[i].Revenue_Rep__c == null || lstnew[i].Revenue_Rep__c <> lstnew[i].OwnerId) lstnew[i].Revenue_Rep__c = lstnew[i].OwnerId;
	            if(mpOwnerIdToDepartment.get(lstnew[i].OwnerId)!=null)       
	            {   
	                lstnew[i].Revenue_Team__c = mpOwnerIdToDepartment.get(lstnew[i].OwnerID);
	            } 
            }
 			if(lstnew[i].IsTrial__c)
 			{
 				trialOpps.add(lstnew[i]);
 			}
 			else if ( lstnew[i].RecordtypeId == UpgradeRecordTypeId )
		 			{
		 				updOpps.add(lstnew[i]);
		 			}
		 			else 
		 			    { paidOpps.add(lstnew[i]);}
 			
 			if(isUpdate && lstnew[i].MBAAccountID__c  <> lstold[i].MBAAccountID__c)
     	 	{
     	 		acctOpps.add(lstnew[i]);
     	 	}
        
    }

	if (!trialOpps.isEmpty()) setTrialValues(trialOpps);
 	if (!paidOpps.isEmpty())  setPurchaseValues(paidOpps);
 //	if (!updOpps.isEmpty())  setUpgradeValues(updOpps);
 // 	if (isInsert) updatePartnerAccount(lstnew);
 	if (!sbdopps.isEmpty()) updateStrategicPartner(sbdopps);
    if (!acctOpps.isEmpty()) updateAccount(acctOpps);
}


public void afterUpdate(List<Opportunity> lstnew,List<Opportunity> lstold){
    
 //   system.debug('afterUpdate method starts new value'+lstnew[0].StageName+''+lstnew[0].IsTrial__c+''+lstnew);
 //   system.debug('afterUpdate method starts old value'+lstold[0].StageName+''+lstold[0].IsTrial__c+''+lstold);
   
    // Map to hold OpportunityIds and Opportunity Value.
    Map<Id,Opportunity> mpOppIdToOpportunity = new Map<Id,Opportunity>();
     
    // Map to store ProductId and Opportunity Id.
    Map<Id,String> mpOppIdToProId = new map<Id,String>();
 
 // BMP changes  
    Map<Id,Opportunity> mpBMPOpp = new Map<Id,Opportunity>();
    Map<Id,Opportunity> mpBMPOppStat = new Map<Id,Opportunity>();
    Map<Id,Opportunity> mpBMPOppProd = new Map<Id,Opportunity>();
       
    // Compare If Any Of The Product Field On The Opportunity have been Updated.
    if(lstnew.size()>0){    
        for(Integer i=0;i<lstnew.size();i++)
        {    
            system.debug('*** source '+lstnew[i].Source__c);
            if (lstnew[i].Source__c == 'BMP' )
            {
           		if (lstnew[i].Zuora_Version__c <> null && StaticVariables.ZuoraUpdate == true
           			&& ( (lstnew[i].Zuora_Version__c ==1 && lstold[i].Zuora_Version__c == null)
           				|| (lstnew[i].Zuora_Version__c <> lstold[i].Zuora_Version__c)
           			     
           				) )
 				{
            		mpBMPOpp.put(lstnew[i].Id,lstnew[i]);
 				}
 				else if (lstnew[i].Status__c!= lstold[i].Status__c)
           		{
           			mpBMPOppStat.put(lstnew[i].Id,lstnew[i]);
           		}
           		else if (lstnew[i].ProductID__c!= lstold[i].ProductID__c)
           		{
           			mpBMPOppProd.put(lstnew[i].Id,lstnew[i]);
           		}
            }
            else if (lstnew[i].MonthlyRecurringRevenue__c!= lstold[i].MonthlyRecurringRevenue__c
               		|| lstnew[i].ProductID__c!= lstold[i].ProductID__c
               		|| lstnew[i].Status__c!= lstold[i].Status__c
                	)
           
			{
               	mpOppIdToOpportunity.put(lstnew[i].Id,lstnew[i]); 
  				mpOppIdToProId.put(lstnew[i].Id,lstnew[i].ProductID__c);   
            } 
          
        }
    }
    
    if(mpOppIdToProId.size()>0 || mpOppIdToOpportunity.size()>0){
    	handleOppProducts(mpOppIdToProId, mpOppIdToOpportunity);
    }
    if(mpOppIdToOpportunity.size()>0){
    	handleOppprodHist(mpOppIdToOpportunity);
    }
	if (mpBMPOpp.size()>0) {
// 		handleBMPOppProducts(mpBMPOpp);
 		handleOppprodHist(mpBMPOpp);
 	}
    else if (mpBMPOppStat.size()>0)
    {
    	handleOppprodHist(mpBMPOppStat);
 //   	handleBMPOppProducts(mpBMPOppStat);
    }
    if (mpBMPOppProd.size()>0)
    {
    	handleBMPOppprodHist(mpBMPOppStat);
    }
}

//Method to sync manual leads
@future
public static void syncOppwithStagingSub(Map<String,String> mpSubOppIds)
{   
    Map<String,String> lstMBASubTOSub = new Map<String,String>();
    for(Subscription__c obj:[Select Id,MBASubscriptionID__c from Subscription__c Where Id IN:mpSubOppIds.keyset()]){
       lstMBASubTOSub.put(obj.MBASubscriptionID__c ,obj.Id);
    }

    string soqlWHERE_SubIDs = '';
    // Query the Fields of MBA Staging Subscription.
    for (String mba : lstMBASubTOSub.keyset())
    {
        // Grab all the MBA Subscription Ids
        if (mba != null)
        {
            soqlWHERE_SubIDs += (soqlWHERE_SubIDs.length() == 0 ? '' : ', ') + '\'' + mba + '\'';
        }
    }
    System.Debug('soqlWHERE_SubIDs '+soqlWHERE_SubIDs );
    
    string soql_Opp = SObjectUtils.SubscriptionStagingSelect + ' WHERE MBASubscriptionID__c IN (' + soqlWHERE_SubIDs  + ')';
    
    database.Dmloptions dml = new database.Dmloptions();

    //Map Sobject for MBASubscription and Opportunity.
    Map<Sobject,Sobject> mpMBASubToOpp = new Map<Sobject,Sobject>();
    for(MBA_Staging_Subscription__c obj:database.query(soql_Opp))
    {
        Opportunity opp = new Opportunity(Id=mpSubOppIds.get(lstMBASubTOSub.get(obj.MBASubscriptionID__c)));  
        //opp.Subscription__c = lstSubTOMBASub.get(obj.MBASubscriptionID__c);
        //opp.MBASubscriptionID__c = obj.MBASubscriptionID__c;
        mpMBASubToOpp.put(obj,opp);
    }
    system.debug('User21 mpMBASubToOpp'+mpMBASubToOpp);
    
    // Calling SyncObjects Method To Do the Logic.
    if(mpMBASubToOpp.size()>0)
    {
        SObjectUtils.SyncObjects('MBA_Staging_Subscription__c', 'Opportunity', mpMBASubToOpp, dml);
    }
    system.debug('User21 Method Exit from querySubForManualLeads');
}
//Method to sync manual leads
@future
public static void syncOppwithMBASub(Map<String,Id> mpMBASubOppIds)
{   
    
    string soqlWHERE_SubIDs = '';
    // Query the Fields of MBA Staging Subscription.
    for (String mba : mpMBASubOppIds.keyset())
    {
        // Grab all the MBA Subscription Ids
        if (mba != null)
        {
            soqlWHERE_SubIDs += (soqlWHERE_SubIDs.length() == 0 ? '' : ', ') + '\'' + mba + '\'';
        }
    }
    System.Debug('soqlWHERE_SubIDs '+soqlWHERE_SubIDs );
    
    string soql_Opp = SObjectUtils.SubscriptionStagingSelect + ' WHERE MBASubscriptionID__c IN (' + soqlWHERE_SubIDs  + ')';
    
    database.Dmloptions dml = new database.Dmloptions();

    //Map Sobject for MBASubscription and Opportunity.
    Map<Sobject,Sobject> mpMBASubToOpp = new Map<Sobject,Sobject>();
    for(MBA_Staging_Subscription__c obj:database.query(soql_Opp))
    {
        Opportunity opp = new Opportunity(Id=mpMBASubOppIds.get(obj.MBASubscriptionID__c));  
        //opp.Subscription__c = lstSubTOMBASub.get(obj.MBASubscriptionID__c);
        //opp.MBASubscriptionID__c = obj.MBASubscriptionID__c;
        mpMBASubToOpp.put(obj,opp);
    }
    
    
    // Calling SyncObjects Method To Do the Logic.
    if(mpMBASubToOpp.size()>0)
    {
        SObjectUtils.SyncObjects('MBA_Staging_Subscription__c', 'Opportunity', mpMBASubToOpp, dml);
    }
    system.debug('User21 Method Exit from querySubForManualLeads');
}


    public static void handleOppProducts(Map<Id,String> mpOppIdToProId,  Map<Id,Opportunity> mpOppIdToOpportunity)
    {
        map<string,PricebookEntry> mpProductcodeToPricebook1 = new map<string,PricebookEntry>();
        if(mpOppIdToProId.size()>0)
        {
           mpProductcodeToPricebook1 = getPricebookEntry(Label.Sales_Pricebook,mpOppIdToProId.values());
           system.debug('In AFter Update mpProductcodeToPricebook1'+mpProductcodeToPricebook1);
        }
    
        if(mpOppIdToProId.keyset().size()>0){   
        	deleteOppprod(mpOppIdToOpportunity);
        }
       
//        system.debug('In AFter Update lstopproidTodel'+lstopproidTodel);
    
        //List to hold the new Opportunity Line Item.
        List<OpportunityLineItem> lstnewOppLntm = new List<OpportunityLineItem>();  
        String Productcodeerror;
        Boolean noproductid = false;
        try
        {
            if(mpOppIdToProId.keyset().size()>0){
                for(String opid:mpOppIdToProId.keyset())
                {   
                    if(mpOppIdToProId.get(opid)!= null)
                    {
                        Productcodeerror = mpOppIdToProId.get(opid);
                    }
                    else
                    {
                        noproductid = true;
                        Productcodeerror='No Product Specified In Subscription';
                    }
                    
                    if(mpProductcodeToPricebook1.containskey(mpOppIdToProId.get(opid)))
                    {
                        OpportunityLineItem opplnt = new OpportunityLineItem();
                        opplnt.OpportunityId=opid;
                        opplnt.PricebookEntryId = mpProductcodeToPricebook1.get(mpOppIdToProId.get(opid)).Id;
                        opplnt.Quantity=1;
                        if(mpOppIdToOpportunity.get(opid).SubscriptionType__c=='Store')
                        {
                            opplnt.UnitPrice = mpOppIdToOpportunity.get(opid).MonthlyRecurringRevenue__c;
 	                    }
                        else
                        {
                            opplnt.UnitPrice = mpOppIdToOpportunity.get(opid).BillingAmount__c;
                        }
                        if (opplnt.UnitPrice == 0  ) 
						{
 // sbd
                            Opportunity o = mpOppIdToOpportunity.get(opid);
                            if (o.SBD_Store_ID__c != null  && o.Agency__c != 'Bigcommerce' &&  o.Agency__c != null 
								&& o.Source__c <> 'BMP'&& o.MonthlyRecurringRevenue__c == 0  && o.ProductId__c <> null 
								&& o.Product_Price__c <> null)
								{
									opplnt.UnitPrice = o.Product_Price__c;
                        		}
 							 
						}
                        lstnewOppLntm.add(opplnt);
                    }
                    else
                    {
                        if (!noproductid)
                        ErrorEmailHelper.notifyOnError('Opportunity Operation', 'OpportunityLineIten', 'Error in PricebookEntry', 'Product Code Does not Exist in PriceBookEntry  ' + Productcodeerror );
                    }
                }
            }

                       
            //New Opportunity Line Item Going To Insert.
            if(!lstnewOppLntm.isEmpty())
            {
                insert lstnewOppLntm;
            }
    

        }
        catch(Exception e)
        {   
            system.debug('Productcodeerror'+Productcodeerror);
            ErrorEmailHelper.notifyOnError('Opportunity Operation', 'OpportunityLineIten', 'Error Occured in Method handleOppProducts ', ' Error Message: ' + e.getMessage());
        }   
        system.debug('In AFter Update lstnewOppLntm'+lstnewOppLntm);
    }
    
	public static void deleteOppprod(Map<Id,Opportunity> mpOppIdToOpportunity)
 	{
 		//List to hold Opportunity Line Item which are going to delete.
        List <OpportunityLineItem> lstopproidTodel  = new List<OpportunityLineItem>();
 		// query the Opportunity Product Line Item.
        
        for(OpportunityLineItem oppl:[SELECT Id, OpportunityId, Family__c FROM OpportunityLineItem WHERE OpportunityId IN:mpOppIdToOpportunity.keyset()])
        {
 				Opportunity o = mpOppIdToOpportunity.get(oppl.OpportunityId);
 				if (oppl.Family__c <> 'Promo' 
 				    && ((o.RecordTypeId == TrialRecordTypeId  && oppl.Family__c <> 'Forecast'  )
 				    	|| o.RecordTypeId == StoreRecordTypeId )
 				    	)
                   lstopproidTodel.add(oppl);
         }
           
           // Opportunity Line Item Going To Delete.
        if(!lstopproidTodel.isEmpty())
        {
            delete lstopproidTodel;
        }
            
 	}
    public static void handleOppprodHist(Map<Id,Opportunity> mpOppIdToOpportunity)
    {    
     
      // Map to hold Opportunity and Opportunity Custom Object.
      Map<SObject, SObject> mpSOb = new Map<SObject, SObject>();
      Database.Dmloptions dml1= new Database.Dmloptions();
      Map<Id,Opportunity_Product__c> mpOppProdct = new Map<Id,Opportunity_Product__c>();
 	  integer currentyear = Date.today().year();
      integer currentmonth = Date.today().month();

      // Update The Previous Version Of Opportunity Product.
      if(mpOppIdToOpportunity.keyset().size()>0){

			Map<Id, Opportunity> mpOppRep = getUpgradeOpps(mpOppIdToOpportunity.keyset());
			Map<Id, Opportunity_Product__c> mpOppProdhist = new Map<Id, Opportunity_Product__c>();
			
            for(Opportunity_Product__c obj:[SELECT ExpirationDate__c,Id,OpportunityID__c,MonthlyRecurringRevenue__c,RevenueChange__c, StartDate__c, LastVersion__c, Product__c ,PricingGroup__c
                                            FROM Opportunity_Product__c WHERE OpportunityID__c 
                                            IN: mpOppIdToOpportunity.keyset() AND LastVersion__c = true])
            {
                obj.EndDate__c = date.today();
                obj.LastVersion__c = false;
                mpOppProdct.put(obj.OpportunityID__c,obj);
            }
      
            //Create the Latest Version Of Opportunity Product.
            for(Id opID :mpOppIdToOpportunity.keyset())
            {   
                system.debug('opID'+opID);
                Opportunity opp = mpOppIdToOpportunity.get(opID);
                Opportunity_Product__c opprd = new Opportunity_Product__c();
                opprd.Name = opp.Name + ' - ' + opp.Product__c;
                opprd.StartDate__c = date.today();
//				 opprd.StartDate__c = opp.StartDate__c;
                opprd.OpportunityID__c = opID;
                if (mpOppRep.get(opId)<> null)
                {
                	opprd.Revenue_Team__c = mpOppRep.get(opId).Owner.Department;
                	opprd.Revenue_Rep__c = mpOppRep.get(opId).OwnerId; 
                }
                else
                {
  
                	opprd.Revenue_Team__c = opp.Revenue_Team__c;
                	opprd.Revenue_Rep__c = opp.Revenue_Rep__c; 
                }
                opprd.LastVersion__c = true;
                if(mpOppIdToOpportunity.get(opID).SubscriptionType__c=='Store')
                {
 // sbd       
	                if ((opp.MonthlyRecurringRevenue__c == null || opp.MonthlyRecurringRevenue__c == 0)
	                		&& opp.Product_Price__c <> null)
	                {
	                	opprd.MonthlyRecurringRevenue__c = opp.Product_Price__c;
	                }
	                else
                    { opprd.MonthlyRecurringRevenue__c = opp.MonthlyRecurringRevenue__c;}

                    if(mpOppProdct.get(opID)!=null)
                    {   
                    	Opportunity_Product__c  prevhist =  mpOppProdct.get(opId);
                    	if (prevHist.MonthlyRecurringRevenue__c <> null)
                    	{
                        	opprd.RevenueChange__c = opprd.MonthlyRecurringRevenue__c - prevHist.MonthlyRecurringRevenue__c;
                   		}
                    	else
                    	{
                    		opprd.RevenueChange__c = opprd.MonthlyRecurringRevenue__c;
                    	}
                         
		                if (opp.Product__c <> prevhist.Product__c)  opprd.Plan_Changed__c = true;
		                
		          		if ((opprd.MonthlyRecurringRevenue__c >0 && (prevHist.MonthlyRecurringRevenue__c == null || prevhist.MonthlyRecurringRevenue__c <1))
  //                         || (opp.isTrial__c == false && prevhist.isTrial__c == true)
  							) 
  						{ 
		          		    opprd.Purchase__c = true;
		                	
  						}
		                if  (opprd.RevenueChange__c > 0)
		                {
		                	if (opp.PricingTestGroup__c <> prevhist.PricingGroup__c
		                		&& opprd.Purchase__c == false)
		                		opprd.Price_Change_Reason__c = 'BC Pricing Change';
		                	else
		                	    opprd.Price_Change_Reason__c = 'Pricing Change';
		         // 		   	system.debug('test '+opprd.Price_Change_Reason__c);
		                }
		                
		                if (opprd.RevenueChange__c < 0
		                    && prevhist.StartDate__C.year() == currentyear  
		                    && prevhist.StartDate__C.month() == currentmonth
		                    && prevhist.RevenueChange__c > 0)
		                
		                	opprd.Same_Month_Downgrade__c = true;
                    	else opprd.Same_Month_Downgrade__c = false;
                    	
                    }
                    else
                    {
                        opprd.RevenueChange__c = opprd.MonthlyRecurringRevenue__c;
                        if (opp.isTrial__c == false && (opprd.MonthlyRecurringRevenue__c > 0 
                           || opp.Direct_Purchase__c == true)) 
                        { 
		          		    opprd.Price_Change_Reason__c = 'Pricing Change';
		          		    opprd.Purchase__c = true;
                        }
                    }  
                }
                else
                {
                    opprd.MonthlyRecurringRevenue__c = opp.BillingAmount__c;
                }
                  
                 mpSOb.put(mpOppIdToOpportunity.get(opID),opprd);
        
            }
        }
      system.debug('In AFter Update mpSOb'+mpSOb);
    
      // Opportunity Product list going to Update.
      if(!mpOppProdct.isEmpty())
        {
            update mpOppProdct.values();
        }
      if(mpSOb.keyset().size()>0)
        {
            // Method to Perform Insert/Update Logic.
            SObjectUtils.SyncObjects('Opportunity','Opportunity_Product__c',mpSOb,dml1);
        }
        
    }
/*	
	public static void handleBMPOppProducts(Map <Id,Opportunity> mpOppIdToOpportunity)
    {
    
        if(mpOppIdToOpportunity.keyset().size()>0){   
        	deleteOppprod(mpOppIdToOpportunity);
        }
    
        //create the new Opportunity Line Item.
 //       ZuoraUtility.createZuoraLineItems(mpOppIdToOpportunity.keyset());
        
        
    }
*/	
	public static void handleBMPOppprodHist(Map<Id,Opportunity> mpOppIdToOpportunity)
    {  	
    	// Update The last Version Of Opportunity Product.
	Map<SObject, SObject> mpSOb = new Map<SObject, SObject>();
	Database.Dmloptions dml1= new Database.Dmloptions();
		for(Opportunity_Product__c opprd:[SELECT Id,OpportunityID__c,MonthlyRecurringRevenue__c,RevenueChange__c, StartDate__c, LastVersion__c, Product__c ,PricingGroup__c, isTrial__c
                                        	FROM Opportunity_Product__c WHERE OpportunityID__c 
                                        	IN: mpOppIdToOpportunity.keyset() AND LastVersion__c = true])
        {
             Opportunity opp = mpOppIdToOpportunity.get(opprd.OpportunityID__c);
	         if (opprd.MonthlyRecurringRevenue__c == opp.MonthlyRecurringRevenue__c)
	         { 
	             opprd.Revenue_Team__c = opp.Revenue_Team__c;
	             opprd.Revenue_Rep__c = opp.Revenue_Rep__c; 
	             mpSOb.put(opp,opprd);
	         }
            
        } 
        if(mpSOb.keyset().size()>0)
        {
            // Method to Perform Insert/Update Logic.
            SObjectUtils.SyncObjects('Opportunity','Opportunity_Product__c',mpSOb,dml1);
        }
    }

	private void setTrialValues(List<Opportunity> trialOpps)
	{
		
		for (Opportunity o :trialOpps)
		{
			// Assigning RecordtypeId,StageName,CloseDate to the Opportunity.
            o.RecordTypeId = TrialRecordTypeId;
//            o.StageName = Label.Opportunity_Stage_Trial;
            if (o.ExpirationDate__c <> null && o.CloseDate == null) 
            	o.CloseDate = o.ExpirationDate__c;
			
			if ((o.Status__c == 'Trial Expired' || o.Status__c == 'Cancelled')
				&& o.StageName <> 'Closed Lost')
			 {
	 	             if (o.OwnerId == Label.BCT_Id)
	 	             {
	 	             	o.StageName = 'Closed Lost';
	 	             	o.Closed_Lost_Reason__c = Label.Opportunity_ClosedLost;
	 	             }
	 	             else if (o.Status__c == 'Trial Expired') {
	    
	 	                  o.StageName=Label.Opportunity_Stage_TrialExpired;
	             		}
		             else if (o.Status__c ==Label.Opportunity_Status_Cancelled)
	 	               	{
	                     	o.StageName=Label.Opportunity_Stage_Cancelled;
	                 	} 
	            }

/*			if (o.StageName == 'Prospect')
			{
				if (o.Status__c == 'Active'){
	                    
	                	o.StageName=Label.Opportunity_Stage_Trial;
	               }
	             else if (o.Status__c == 'Trial Expired') {
	    
	 	                  o.StageName=Label.Opportunity_Stage_TrialExpired;
	             }
	             else if (o.Status__c ==Label.Opportunity_Status_Cancelled)
 	               	{
                     	o.StageName=Label.Opportunity_Stage_Cancelled;
                 	} 
                 if (o.ExpirationDate__c <> null ) 
            			o.CloseDate = o.ExpirationDate__c;
			}   
*/
		}	
	}	
	private void setPurchaseValues(List<Opportunity> paidOpps)
	{		
		Map<Id, string> mpOppProd = new Map<Id, string>();
		
		for (Opportunity o :paidOpps)
		{
		   	if (o.Master_Agreement_Date__c <> null )
		   	 	o.CloseDate = o.Master_Agreement_Date__c;
		   	else if (o.PurchaseDate__c <> null)
		   	{
		   		if (o.CloseDate <> o.PurchaseDate__c) o.CloseDate = o.PurchaseDate__c;
		   	}
		   	else
		   	{
		   		o.CloseDate = System.Today();
		   	}
		   	
            if(o.SubscriptionType__c == 'Store')
             {
                 o.RecordTypeId = StoreRecordTypeId;
                 o.StageName = Label.Opportunity_Stage_Purchased;
                     
				 if(o.Purchase_Rep__c == null)
                    {               
                        o.Purchase_Rep__c = o.OwnerID;
                        o.Purchase_Team__c = mpOwnerIdToDepartment.get(o.Purchase_Rep__c);
                    }
                  // Assigning Revenue Rep as the Opportunity Owner.
                  if(o.Purchase_Rep__c == null)
                    { 
                      	o.Revenue_Rep__c = o.OwnerId;
			            if(mpOwnerIdToDepartment.get(o.Revenue_Rep__c)!=null)       
			            {   
			                o.Revenue_Team__c = mpOwnerIdToDepartment.get(o.OwnerID);
			            } 
                    }
                  if(o.Original_Plan_Purchased__c==null)
                    {
                        o.Original_Plan_Purchased__c = o.Product__c;
                        o.Original_Plan_Value__c = o.MonthlyRecurringRevenue__c;
                    }
                  if (o.Status__c ==Label.Opportunity_Status_Active)
                    {
                       o.StageName=Label.Opportunity_Stage_Purchased;
                	} 
 	               else if(o.Status__c ==Label.Opportunity_Status_Cancelled)
 	               	{
                     	o.StageName=Label.Opportunity_Stage_Cancelled;
                 	} 
 					else if(o.Status__c ==Label.Opportunity_Status_Suspended)
 					{
                     	o.StageName=Label.Opportunity_Stage_Suspended;
 					}
 					else if(o.Status__c ==Label.Opportunity_Status_Pending)
 					{
                     		o.StageName=Label.Opportunity_Stage_Pending;
               		 }  
               		else if(o.Status__c == Label.Opportunity_Stage_Terminated)
 					{
                     		o.StageName=Label.Opportunity_Stage_Terminated;
               		 }  
// handle sbd opps
					if (o.SBD_Store_ID__c != null  && o.Agency__c != 'Bigcommerce' &&  o.Agency__c != null 
						&& o.Source__c <> 'BMP'&& o.MonthlyRecurringRevenue__c == 0  && o.ProductId__c <> null )
					{
						 mpOppProd.put(o.Id, o.ProductId__c);
					
					}
                
				} //store
                    else if (o.SubscriptionType__c <> '')
                    {
                           o.RecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_Recordtype_OneTimeProduct).getRecordTypeId();        
  						   if (o.Status__c ==Label.Opportunity_Status_Active) 
  						       o.StageName = 'Closed Won';
                    }
		
		
			}		
		
		if (!mpOppProd.isEmpty())
		{
			map<string,PricebookEntry> mpProductcodeToPricebook1 = new map<string,PricebookEntry>();
			
			mpProductcodeToPricebook1 = OpportunityOperations.getPricebookEntry(Label.Sales_Pricebook,mpOppProd.values());
		
			for (Opportunity o : paidopps)
			{
			   PricebookEntry pe = mpProductcodeToPricebook1.get(o.ProductId__c);
			   if (pe == null || pe.UnitPrice ==null){
			   			system.debug(' product '+o.ProductId__c);
			   	} 
			   	else {
			   			o.Product_Price__c = pe.UnitPrice;
			   			if (o.Original_Plan_Value__c == null && o.Product__c == o.Original_Plan_Purchased__c) 
			   				o.Original_Plan_Value__c = o.Product_Price__c;
			   		}
				
			}
		}
	}
	
/*	private void setUpgradeValues(List<Opportunity> upOpps)
	{		
		
		for (Opportunity o :upOpps)
		{
			
			o.StageName = 'Qualification';
		}
	}
*/	
	 // Method to create OpportunityContactRole.
    public void createOpportunityContactRole(Set<Id> accid,List<Opportunity> lstopp)
    {
        map<Id,Contact> mpAccountIdToContact=querycontact(accid);
        
        // List to collect All OpportunityContactRole.
        List<OpportunityContactRole> lstOppConRole = new List<OpportunityContactRole>();
        for(Opportunity obj:lstopp)
        {
            if(mpAccountIdToContact.containskey(obj.AccountId))
            {
                OpportunityContactRole OppConRole = new OpportunityContactRole();
                OppConRole.ContactId = mpAccountIdToContact.get(obj.AccountId).Id;
                OppConRole.IsPrimary = true;
                OppConRole.OpportunityId = obj.Id;
                OppConRole.Role = Label.Contact_Role;
                lstOppConRole.add(OppConRole);
            }
        }
        if(!lstOppConRole.isEmpty())
        {
            insert lstOppConRole;
        }
    }
 
	 // Method to create OpportunityContactRole.
	@future
    public static void createOpportunityContactRole( Set<Id> oppIds)
    {
        // creating Instance of OpportunityOperations Class.
        OpportunityOperations OppOperation = new OpportunityOperations();
        Set<Id> setaccid = new Set<Id>();
        List<Opportunity> lstopp = New List<Opportunity>();
       
        for (Opportunity Opp :[Select o.Id, o.AccountId, (Select ContactId, Role From OpportunityContactRoles) 
                                                         From    Opportunity o 
                                                         where Id in :oppIds ])
        {
        	if (Opp.OpportunityContactRoles.size() ==0)
        	{
        	  setaccid.add(opp.AccountId);
        	  lstopp.add(opp);
        	}
        }
        
        if (setaccid.size()>0)
        {
		        map<Id,Contact> mpAccountIdToContact= OppOperation.querycontact(setaccid);
		        
		        // List to collect All OpportunityContactRole.
		        List<OpportunityContactRole> lstOppConRole = new List<OpportunityContactRole>();
		        for(Opportunity obj:lstopp)
		        {
		            if(mpAccountIdToContact.containskey(obj.AccountId))
		            {
		                OpportunityContactRole OppConRole = new OpportunityContactRole();
		                OppConRole.ContactId = mpAccountIdToContact.get(obj.AccountId).Id;
		                OppConRole.IsPrimary = true;
		                OppConRole.OpportunityId = obj.Id;
		                system.debug('***'+OppConRole.OpportunityId);
		                OppConRole.Role = Label.Contact_Role;
		                lstOppConRole.add(OppConRole);
		            }
		        }
        
       
	        if(!lstOppConRole.isEmpty())
	        {
	            try{
	            	     insert lstOppConRole;
	            }
	            catch (Exception e)
	                {   
	                    ErrorEmailHelper.notifyOnError('Opportunity Trigger', 'Insert Contact Role', 'Error in Opportunity Trigger -Insert Contact Role', e.getMessage());         
	                } 
	        }
        }
    }
 
      
    // Method to query Account on The basis of MBAAccountID.
    public void queryAccount(map<String,Opportunity> mpMBAAccountIdToOpp)
    {
        for(Account obj:[SELECT Id,MBAAccountID__c FROM Account WHERE MBAAccountID__c IN:mpMBAAccountIdToOpp.keyset()])
        {
            if(mpMBAAccountIdToOpp.containskey(obj.MBAAccountID__c))
                {
                    mpMBAAccountIdToOpp.get(obj.MBAAccountID__c).AccountID = obj.Id;
                }
        }
    }
  
    //Method to get upgrade opportunity owner
	
	public static Map<Id, Opportunity> getUpgradeOpps(Set<Id> PoppIds)
	{ 
     	  
     Map<Id, Opportunity> mpOppRep = new Map<Id, Opportunity>();
     
     for (Opportunity opp :[select Id, StageName, CloseDate, ParentOpportunity__c, OwnerId, Owner.Department
                                                   from Opportunity where ParentOpportunity__c in :PoppIds 
                                                   and isClosed = false])
     {      
    	mpOppRep.put(opp.ParentOpportunity__c, opp);
     }    
	       
	  
	  return  mpOppRep;                                        
	}

	//Method to Update upgrade opportunities
	
	public static void updateUpgradeOpps(Set<Id> PoppIds)
	{   
        Set<Id> oppIds = new Set<Id>();
	    List<Opportunity> upgOpps = new List<Opportunity>([select Id, StageName, CloseDate, ParentOpportunity__c 
	                                                       from Opportunity where ParentOpportunity__c in :PoppIds 
	                                                       and isClosed = false]);
		Map <id, Id> mapOppParentId = new Map <id, Id>();
	    
	    if (!upgOpps.isEmpty())
	    {
		    for (Opportunity opp :upgOpps)
		    {
		    	oppIds.add(opp.Id);
		    	mapOppParentId.put(opp.Id, opp.ParentOpportunity__c);
		    	opp.StageName = 'Closed Won';
		    	opp.CloseDate =  System.Today();
		    }
		    
		    deleteUpgradeForecastProducts(OppIds);
		    addUpgradeProducts(mapOppParentId);
			update upgOpps;
	    }
	}

    public static void deleteUpgradeForecastProducts(Set<Id> upgOppIds)
    {
        
    //List to hold Opportunity Line Item which are going to delete.
     List <OpportunityLineItem> lstopproidTodel  = new List<OpportunityLineItem>();
   
     // query the Opportunity Product Line Item.
            for(OpportunityLineItem oppl:[SELECT Id, OpportunityId, Family__c FROM OpportunityLineItem WHERE OpportunityId IN:upgOppIds])
            {
 				
 				if (oppl.Family__c == 'Forecast')
 				   
                   lstopproidTodel.add(oppl);
            }
       
     
     	// Opportunity Line Item Going To Delete.
	    if(!lstopproidTodel.isEmpty())
	    {
	        delete lstopproidTodel;
	    }
    }    
     
    public static void addUpgradeProducts(Map <id, Id> mapOppParentId)
    {

     String upgradeProdcode = Label.UpgradeProduct;
     String upgradePricebook = Label.UpgradePricebook;
     
     List<OpportunityLineItem> lstNewOppLnItm = new List<OpportunityLineItem>();
     List<Opportunity_Product__c> parentproducts = new List<Opportunity_Product__c> ([select Id, RevenueChange__c, OpportunityID__c from Opportunity_Product__c where OpportunityID__c in :mapOppParentId.Values() and LastVersion__c = true]);
 
     Map<Id, Opportunity_Product__c> mapOppProdHist = new Map<Id, Opportunity_Product__c>(); 
     for (Opportunity_Product__c op :parentproducts )
     {
     	mapOppProdHist.put(op.OpportunityID__c, op);
     }	
     PricebookEntry obj = [SELECT Id,IsActive,Name,Pricebook2Id,Product2Id,ProductCode FROM PricebookEntry WHERE Pricebook2Id =: upgradePricebook AND ProductCode =:upgradeProdcode];
            
     for (Id oId :mapOppParentId.KeySet())   
     {            
            OpportunityLineItem opplnt = new OpportunityLineItem();
            opplnt.OpportunityId=oid;
            opplnt.PricebookEntryId = obj.Id;
            opplnt.Quantity=1;
            Opportunity_Product__c op =  mapOppProdHist.get(mapOppParentId.get(oId));        
            opplnt.UnitPrice = op.RevenueChange__c;
                        
            lstNewOppLnItm.add(opplnt);
       }
 /*                   else
                    {
                        ErrorEmailHelper.notifyOnError('Opportunity Operation', 'OpportunityLineIten', 'Error in PricebookEntry', 'Product Code Does not Exist in PriceBookEntry  ' + Productcodeerror );
                    }
                }
 */           
      
        
	    
	    //New Opportunity Line Item Going To Insert.
	    if(!lstNewOppLnItm.isEmpty())
	    {
	        insert lstNewOppLnItm;
	    }
   
	     
    }
    // Method to query partner Account on The basis of MBAPartnerID.
    
    public void updatePartnerAccount(List<Opportunity> Opps)
    {
        string soqlWHERE_IDevPartnerIDs = '';
        // Set to hold MBA Partner Ids
        set<string> stMBAPartnerId = new set<string>();
        
        for (Opportunity o :Opps)     
        {  
         // Grab all the MBA Partner Ids
            if (o.MBAPartnerID__c != null && o.MBAPartnerID__c.trim().length() > 0)
            {
                if (stMBAPartnerId.add(o.MBAPartnerID__c))
                {
                    soqlWHERE_IDevPartnerIDs += (soqlWHERE_IDevPartnerIDs.length() == 0 ? '' : ', ')  + o.MBAPartnerID__c;
                }
            }
        }           
               
        system.debug(' Find channel partner '+soqlWHERE_IDevPartnerIDs);
 
        if (soqlWHERE_IDevPartnerIDs == '') return;
        
        Subscription_Utility.LoadAcctByIDevPartnerIdMap(soqlWHERE_IDevPartnerIDs);  
        
        for (Opportunity o :Opps)     
        {  
        
        // If the subscription has a Partner Id then use the Account Owner of that partner account record to own the subscription
                
                if (o.MBAPartnerID__c != null && Subscription_Utility.mpAcctByIDevPartnerId.containsKey(o.MBAPartnerID__c))
                {
                    Account partneracc = Subscription_Utility.mpAcctByIDevPartnerId.get(o.MBAPartnerID__c);
                    if (partneracc.OwnerId != UserInfo.getUserId())
                    { 
                    	o.OwnerId = partneracc.OwnerId;
                    }
                    o.Channel_Partner__c = partneracc.Id;
                }
                else if (o.MBAPartnerID__c != null)
                {
                	o.OwnerId = Label.Partner_Default_Owner;
                }
        }
    }
   
    public void UpdateAccountOwner( Set<Id> OppIds)
    {    
    	Id ClientRecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Record Type').getRecordTypeId();
 		Id bmpRecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('BMP Client').getRecordTypeId();
    	   	
    	List<Opportunity> opps = new List<Opportunity>([Select Id, OwnerId, Account.Owner_Team__c, Account.OwnerId, AccountId,  Account.RecordTypeId From Opportunity where Id in :OppIds]);
        List<Account> updaccts = new List<Account>();  
        
        for ( Opportunity opp:opps)
            {
            	if (opp.Account.OwnerId <> opp.OwnerId
            	    && (opp.Account.OwnerId == Label.Account_Default_Owner || opp.Account.OwnerId == Label.Marketing_Test_Queue)
            	    && (opp.Account.RecordTypeId == ClientRecordTypeId || opp.Account.RecordTypeId == bmpRecordTypeId ))
            	{
            		
            		Account a = new Account(Id=opp.AccountId, OwnerId = opp.OwnerId);
            		updaccts.add(a);
            	}
            }
            
            try
            {
                
                update updaccts;
            }
            catch(Exception exc)
            {
               ErrorEmailHelper.notifyOnError('Opportunity Trigger Handler', 'after update', 'Error in OpportunityTrigger Handler - update ', ': update Account' + updaccts[0].Id);
 
               system.debug('***ERROR: AccountTrigger:: ' + exc.getStackTraceString());
            }
    }
    
    public static String setOppName(String contactName, String mbasubId)
    {
    	
    	String newName ='';
    	
    	if (contactName <> null && contactName <> '')
    	   newName = contactName;
    	 
    	if (mbasubId <> null && mbasubId <> '')
    	   newName = newName + ' - ' +  mbasubId;  
    	
    	if (newName <> '') 
    	{
    		newName  = DataUtility.truncateString(newName, 120);
    		return newName;
    	}
    	else return 'New Sub';
    }
    
    public void createExpectedProd(Map <Id, String> oppProdPlan)
    {
       
        List<OpportunityLineItem> oppitems = new List<OpportunityLineItem>();
        
        map<string,PricebookEntry> mpProductcodeToPricebook1 = new map<string,PricebookEntry>();
           
        mpProductcodeToPricebook1 = getPricebookEntry(Label.Sales_Pricebook,oppProdPlan.values());
           system.debug('In AFter Update mpProductcodeToPricebook1'+mpProductcodeToPricebook1);
        
        for (Id oppId :oppProdPlan.KeySet())
        {
		    	OpportunityLineItem opplnt = new OpportunityLineItem();
		        opplnt.OpportunityId=oppId;
		        String productPlan = oppProdPlan.get(oppId);
		        
		        system.debug('**** '+productPlan);
		        
		//        PricebookEntry pbe= getPricebookEntry(Label.Expected_Gold);
				PricebookEntry pbe= mpProductcodeToPricebook1.get(productPlan);
		        opplnt.PricebookEntryId = pbe.Id;
		        opplnt.Quantity=1;
		        opplnt.UnitPrice = pbe.UnitPrice;
		        oppItems.add(opplnt);
        }
        insert oppItems;
    	
    }
    
   public static void updateStrategicPartner(List<Opportunity> oppList)   
 {
    
    Map<String, ID> mpLpValueId = new Map <string, Id>();
	Map<String, ID> mpRValueId = new Map <string, Id>();

	List<StrategicPartner__c> strpar = StrategicPartner__c.getall().Values();
	for (StrategicPartner__c sp :strpar)
	{
		if (sp.LandingPage__c <> null) mpLpValueID.put(sp.LandingPage__c, sp.Strategic_Partner__c);
		if (sp.Referral_ID__c <> null) mpRValueID.put(sp.Referral_ID__c, sp.Strategic_Partner__c);
		
	}
	
	for (Opportunity o :oppList)
	{

	  if (o.Strategic_Partner__c ==null && 
		  (o.LandingPage__c <> null && (o.LandingPage__c <> '/' ) || o.referral_id__c <> null) 
     	 )							 
	 {
//	 		if (!s.Email__c.contains('bigcommerce.com') )
		{
			for (String str :mpLpValueId.KeySet())
			{
			
				if (o.LandingPage__c <> null && o.LandingPage__c.contains(str))
                {
				    o.Strategic_Partner__c = mpLpValueID.get(str);
                     system.debug(' found sub '+o.Name);
   
                }
            }
            for (String str :mpRValueId.KeySet())
			{
                if (o.Referral_ID__c <> null && o.referral_id__c.contains(str))
                {
                    o.Strategic_Partner__c  = mpRValueID.get(str);    
                     system.debug(' found sub '+o.Name);
                  
                }   
                    
				   
			}
          
		}	
	  }	
	}
 }
     
  // Method to query Account on The basis of MBAAccountID.
    
  public void updateAccount(List<Opportunity> Opps)
    {
        string soqlWHERE_MBAAcctIDs = '';
        
        // Set to hold MBA Account Ids
        set<string> stMBAAcctId = new set<string>();
        
        for (Opportunity o :Opps)     
        {  
        
         // Grab all the MBA Account Ids
            if (o.MBAAccountID__c != null)
            {
                if (stMBAAcctId.add(o.MBAAccountID__c) && o.MBAAccountID__c.trim().length() > 0)
                {
                    soqlWHERE_MBAAcctIDs += (soqlWHERE_MBAAcctIDs.length() == 0 ? '' : ', ') + '\'' + o.MBAAccountID__c + '\'';
                }
            }
            
        }           
               
        system.debug(' Find account '+soqlWHERE_MBAAcctIDs);
 
        if (soqlWHERE_MBAAcctIDs == '') return;
        
        Subscription_Utility.LoadAcctStagingByMBAAcctIdMap(soqlWHERE_MBAAcctIDs);
        Set<Id> AccountIds = new Set<Id>();
        
        for (Opportunity o :Opps)     
        {  
       		 if (Subscription_Utility.mpAcctByMBAAcctId <> null && Subscription_Utility.mpAcctByMBAAcctId.containsKey(o.MBAAccountID__c))
              {
               // Associate the opportunity to the found account and set the owner?
                o.AccountId = Subscription_Utility.mpAcctByMBAAcctId.get(o.MBAAccountID__c).Id;
				o.contact__c = null;
				AccountIds.add(o.AccountID);
              }
              
        }
        // Map to Hold AccountID and Contact Id.
	    Map<Id, Contact> mpAccountIdToContact = new Map<Id,Contact>();
	    if(AccountIds.size()>0)
	    {
	       mpAccountIdToContact = querycontact(AccountIds);
	    }
	    
	    for (Opportunity o :Opps)     
        {
	    	if(o.Contact__c == null && mpAccountIdToContact.containskey(o.AccountID))
            {
             	o.Contact__c = mpAccountIdToContact.get(o.AccountId).Id ;
              	
            }
        }
    }
   
}