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
}