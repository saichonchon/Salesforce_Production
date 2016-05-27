/**
* @Bigcommerce 2013

* Class Name: SubscriptionC_TriggerHandler

* Object Name: Subscription__c

* Developed By: Bigcommerce

* Date: 10/16/2013

* Version: 1.0

* Purpose: Create a Totango Engagement records when the Subscription record meets given criteria

* History: 

***/

public without sharing class Subscription_TriggerHandler
{

    public static Boolean ALREADY_RAN = false;    
    public static Id subRecType = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId(); 
    public static MarketingTrial__c mt ;
    
 /* commented out 11/15/14   
    public static void insertTotango(List<Subscription__c> subList){
 
        List<Totango_Engagement__c> dbTotango = [SELECT Id FROM Totango_Engagement__c WHERE Subscription__c IN : subList];

        if(dbTotango.isEmpty()){

            for(Subscription__c s : subList){

                if(s.RecordTypeId == subRecType){
                    if(s.Status__c == 'Active'){
                        if(s.Product__c == null){
                            dbTotango.add(new Totango_Engagement__c (Subscription__c = s.Id));
                            System.debug('Record is Active and product is empty');
                        }else{
                            if(!s.Product__c.contains('SSL')){
                                if(!s.Product__c.contains('Domain')){
                                    dbTotango.add(new Totango_Engagement__c (Subscription__c = s.Id));
                                    System.debug('Record is Active and does not contain SSL or Domain');
                                }
                            }
                        }
                    }
                }               
            }
            
            
            Try{
                insert dbTotango;
            }
            catch(Exception e) {
               ErrorEmailHelper.notifyOnError('Subscription Trigger Handler', 'Create Totango', 'Error in Sub Trigger Handler - Create Totango', 'Error Creating Totango for: ' + subList[0].Id);
                system.debug('Error in Subscription  Trigger Handler - Create Totango');
                }   
        
            
            
        }
    }       
    
    public static void UpdateCalcFields(Subscription__c[] newList, Map<ID, Subscription__c> SubscriptionMap, Subscription__c[] oldList)
    {
        integer currentyear = Date.today().year();
        integer currentmonth = Date.today().month();
        
        Map<Integer, String> mapMonth = new Map<Integer, String>();
               
        for (integer i =0; i < newList.size(); i++)
        {   
           if (!newList[i].IsTrial__c)  
           {
                decimal monthlyrev =0.00 ;
                system.debug(' test' +newList[i].purchasedate__c);
                
                if (newList[i].PurchaseDate__c <> null && newList[i].PurchaseDate__c.year() == currentyear  && newList[i].PurchaseDate__c.month() == currentmonth
                   && newList[i].X1st_Upgrade_Date__c <> null && newList[i].X1st_Upgrade_Date__c.year() == currentyear  && newList[i].X1st_Upgrade_Date__c.month() == currentmonth
                   && newList[i].Previous_Upgrade_Date__c <> null && newList[i].Previous_Upgrade_Date__c.year() == currentyear  && newList[i].Previous_Upgrade_Date__c.month() == currentmonth
                   )
                {
                    monthlyrev = newList[i].MonthlyRecurringRevenue__c ;
                }
                else if (
                        newList[i].PurchaseDate__c <> null && newList[i].PurchaseDate__c.year() == currentyear  && newList[i].PurchaseDate__c.month() == currentmonth
                        && newList[i].X1st_Upgrade_Date__c <> null && newList[i].X1st_Upgrade_Date__c.year() == currentyear  && newList[i].X1st_Upgrade_Date__c.month() == currentmonth
                         )
                   
                       {
                        monthlyrev = newList[i].MonthlyRecurringRevenue__c ;
                       }
                 else if ( newList[i].PurchaseDate__c <> null && newList[i].PurchaseDate__c.year() == currentyear  && newList[i].PurchaseDate__c.month() == currentmonth)
                       {
                         monthlyrev = newList[i].MonthlyRecurringRevenue__c ;
                       }
                 else if  ( newList[i].X1st_Upgrade_Date__c <> null && newList[i].X1st_Upgrade_Date__c.year() == currentyear  && newList[i].X1st_Upgrade_Date__c.month() == currentmonth
                   && newList[i].Previous_Upgrade_Date__c <> null && newList[i].Previous_Upgrade_Date__c.year() == currentyear  && newList[i].Previous_Upgrade_Date__c.month() == currentmonth
                   )
                     {
                        monthlyrev = newList[i].Previous_Upgrade_Amount__c  +  newList[i].X1st_Upgrade_Amount__c; 
                        
                     }
                 else if  (  newList[i].X1st_Upgrade_Date__c <> null && newList[i].X1st_Upgrade_Date__c.year() == currentyear  && newList[i].X1st_Upgrade_Date__c.month() == currentmonth
                   )
                     {
                        monthlyrev =  newList[i].X1st_Upgrade_Amount__c; 
                        
                     }  
                  else if  ( newList[i].Previous_Upgrade_Date__c <> null && newList[i].Previous_Upgrade_Date__c.year() == currentyear  
                            && newList[i].Previous_Upgrade_Date__c.month() == currentmonth)
                   
                     {
                        monthlyrev =  newList[i].Previous_Upgrade_Amount__c; 
                        
                     }  
                  else if (newList[i].Strategic_Partner_Type__c == 'Reseller'
                           && newList[i].StartDate__c.month() == currentmonth && newList[i].StartDate__c.year() == currentyear)
                        {
                            monthlyrev =  newList[i].SBD_Value__c;
                        }

// TODO  dynamically get field names for months from custom setting and update 

                  if (currentmonth == 1)             
                    {newList[i].jan_revenue__c = monthlyrev;}
                  else if (currentmonth == 2)
                    {newList[i].feb_revenue__c = monthlyrev;}
                  else if (currentmonth == 3)             
                    {newList[i].march_revenue__c = monthlyrev;}
                  else if (currentmonth == 4)
                    {newList[i].april_revenue__c = monthlyrev;}
                  else if (currentmonth == 5)
                    {newList[i].may_revenue__c = monthlyrev;}
                  else if (currentmonth == 6)
                    {newList[i].june_revenue__c = monthlyrev;}
                  else if (currentmonth == 7)
                    {newList[i].july_revenue__c = monthlyrev;}
                 else if (currentmonth == 8)
                    {newList[i].august_revenue__c = monthlyrev;}
                 else if (currentmonth == 9)
                    {newList[i].september_revenue__c = monthlyrev; }  
                 else if (currentmonth == 10)
                    {newList[i].october_revenue__c = monthlyrev;  }
                 else if (currentmonth == 11)
                    {newList[i].november_revenue__c = monthlyrev;  }
                 else if (currentmonth == 12)
                    {newList[i].december_revenue__c = monthlyrev;  }

                } 
               
        } //end  for
        
        
    }
    
*/
    public static void insertCases(Subscription__c[] subList)
    {
       List<Case> newCases = new List<Case>();
       Id idCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
       Id idMigCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
       Map<Id, Subscription__c> mapacct = new Map<Id, Subscription__c>([select Id, Account__R.Ltc__c, Account__r.SBD_Segment__c, Account__r.SBD_Orion_Persona__c from Subscription__c where Id in :subList]);
       
       for (integer i =0; i < subList.size(); i++)
       {     
            Boolean createSScase = false;
            Subscription__c sub = mapacct.get(subList[i].Id);
            
            If ( (sub.Account__r.SBD_Orion_Persona__c <> null 
                     && (sub.Account__r.SBD_Orion_Persona__c.containsIgnoreCase('royal') || sub.Account__r.SBD_Orion_Persona__c.containsIgnoreCase('owen')))
                  || subList[i].New_Product_Plan__c.containsIgnoreCase('Platinum')
                )
            {
              if (subList[i].SBD_Store_Id__c <> null)   
                createSScase = true;
                
            }
            
            Case newCase = new Case();
            newCase.Origin = 'Orion Request';
            newCase.Reason = 'Migration';
            newCase.Subject = 'Your Bigcommerce Migration';
            newCase.Description = 'Migration for Orion Client ' ;
            newCase.AccountId = subList[i].Account__c;
            newCase.Subscription__c = subList[i].Id;
            newCase.ContactId = subList[i].Contact__c ;          
          
           if (subList[i].Requested_Migration__c == 'Yes')
                {   
                    newCase.RecordTypeId = idMigCaseRecordType;
                    newCase.Department__c = 'Migration';
                    newCase.OwnerId = Label.Migration_Case_Queue;
                    if (createSScase)
                     {newCase.Needs_Store_setup__c = true; }  
                    newCases.add(newCase);
                }   
            else if (subList[i].Requested_Migration__c == 'No'
                     && createSScase)
                   
            {
                newCase.RecordTypeId = idCaseRecordType;
                newCase.Reason = 'Store Setup';
                newCase.Description = 'Store Setup for Orion Client ' ;
                newCase.Department__c = 'Professional Services';
                if (mapacct.get(subList[i].Id).Account__r.ltc__c <>null)  
                {
                        newCase.OwnerId =mapacct.get(subList[i].Id).Account__r.ltc__c;
                }
                else
                {
                    newCase.OwnerId = Label.PS_Queue;
                }
                newCases.add(newCase);
            }
//           if (newCase.OwnerId == null) newCase.OwnerId =$Current_User;
            
           
            
        }
        
        if (newCases.size() > 0)
        {
            Try{
                insert newCases;
            }
            catch(Exception e) {
               ErrorEmailHelper.notifyOnError('Subscription Trigger Handler', 'Create Case', 'Error in Sub Trigger Handler - Create Case', 'Error Creating case for: ' + subList[0].Id);
                system.debug('Error in Subscription  Trigger Handler - Create Case');
                }   
        
        
        }
    }
    
/*    
 public static void updateStrategicPartner(Subscription__c[] subList)   
 {
    
    Map<String, ID> mpLpValueId = new Map <string, Id>();
	Map<String, ID> mpRValueId = new Map <string, Id>();

	List<StrategicPartner__c> strpar = StrategicPartner__c.getall().Values();
	for (StrategicPartner__c sp :strpar)
	{
		if (sp.LandingPage__c <> null) mpLpValueID.put(sp.LandingPage__c, sp.Strategic_Partner__c);
		if (sp.Referral_ID__c <> null) mpRValueID.put(sp.Referral_ID__c, sp.Strategic_Partner__c);
		
	}
	
	for (Subscription__c s :subList)
	{

	  if (s.Test_store__c == false && s.Strategic_Partner__c ==null
		  && (s.LandingPage__c <> null && (s.LandingPage__c <> '/' ) || s.referral_id__c <> null) 
     	 )							 
	 {
//	 		if (!s.Email__c.contains('bigcommerce.com') )
		{
			for (String str :mpLpValueId.KeySet())
			{
			
				if (s.LandingPage__c <> null && s.LandingPage__c.contains(str))
                {
				    s.Strategic_Partner__c = mpLpValueID.get(str);
                     system.debug(' found sub '+s.Name);
   
                }
            }
            for (String str :mpRValueId.KeySet())
			{
                if (s.Referral_ID__c <> null && s.referral_id__c.contains(str))
                {
                    s.Strategic_Partner__c  = mpRValueID.get(str);    
                     system.debug(' found sub '+s.Name);
                  
                }   
                    
				   
			}
          
		}	
	  }	
	}
 }
    
    public static void UpdateMktTest(Subscription__c[] newList)
    {
 		integer currentyear = Date.today().year();
 		Boolean updMktTrial = false;
 		
        for (Subscription__c s:newList)
        {
            String Trial;
  			getMarketingTrial();
  // remove (s.LandingPage__c == null || s.LandingPage__c == '/') && 
            
            if (s.Referral_ID__c == null  
                && s.Strategic_Partner__c == null && s.MBAPartnerID__c == null && s.ProductType__c == 'Store'
                 && s.Product__c <> null && s.Product__c <> '' && !s.Product__c.contains('Domain')
                 && s.StartDate__c <> null && s.StartDate__c.year() == currentyear
                 )
            {

			     Decimal   trialNum = mt.Trial__c;
			        
			        if (trialNum > Decimal.valueOf(Label.Marketing_Test_Number))
			        {
			            trial = Label.Marketing_Test_Group;
			            mt.Trial__c =  1;
			        }
			        else
			        {
			            trial =  String.valueof(mt.Trial__c);
			            mt.Trial__c =  mt.Trial__c +1;
			        }
       
              
                s.Marketing_Test_Group__c = trial;
                updMktTrial = true;
            }
            
        }
        
          if (updMktTrial) UpdMarketingTrial();
    }

  
   public static void getMarketingTrial()
    {
       if(!Test.isRunningTest()){       
        	mt = MarketingTrial__c.getInstance('SalesTrial');
       }
 
       else if (mt==null || Test.isRunningTest())
        {
   	       
   	       mt = new MarketingTrial__c (Name ='SalesTrial', Trial__c =1);
  //  	   insert mtest;
  //  	   mt = MarketingTrial__c.getInstance('SalesTrial');
  
        }
    }
    
    public static void UpdMarketingTrial()
    {
        if (mt <> null && !Test.isRunningTest() )
        {
   	       update mt;
        }
    }
 */ 
}