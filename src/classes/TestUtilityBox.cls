/**
* @Bigcommerce 2012

* Class Name: TestUtilityBox

* Object Name: 

* Developed By: CG

* Date: 10/16/2012

* Version: 1.0

* Purpose: produces our test USERS, Subscription, and Totango Engagement records

* History: 


***/

public with sharing class TestUtilityBox {	
	
	public static User getTestUsers(Integer i, String profileName){
        
        User newUser  = new User();
        
        newUser.FirstName = 'Name' + i;
        newUser.LastName = 'Last Name' + i;
        newUser.Alias = 'user' + i;
        newUser.Email = 'big'+ i + '@commerce.com';
        newUser.Username = 'test' + i + '@bigcommerce.com';
        newUser.CommunityNickname = 'test_' + i + '@bigcommerce.com';
        newUser.ProfileId = [SELECT Id FROM Profile WHERE name =: profileName].Id;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.isActive = true;   
        newUser.Department = 'Sales Operations' ;    
        
        system.debug('User created with a profile  ' + profileName + ' and a last name  ' + newUser.LastName);
        
        return newUser;         
    }
    
    public  static List<Account> getTestAccounts(String recordType,Integer numberOfRecords){
		    	
    	Account[] newAccounts = new Account[]{};  

        Id recType = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get(recordType).getRecordTypeId();

    	for(Integer x=0; x<numberOfRecords;x++){
    		
    		Account AccountTocreate = new Account( 
    		RecordTypeId =  recType,           	
    		Name = 'AccountTest ' + x,      		
            BillingStreet='Main St',
            BillingCity='Austin',
            BillingState = 'TX',     
            BillingPostalCode='70000',
            BillingCountry = 'US',
            Type = 'Client',
            Status__c = 'Open',                       
            SupportPin__c = '000' + x,
            Client_Start_Date__c = date.today()
                       	     		
    		);
    		
    		newAccounts.add(AccountTocreate);   		
    	}
    	   	
    	system.debug('Success we created ' + newAccounts.size() + '  Account records');
    	
    	return newAccounts;       
    }  
    
    
    public static List<Contact> getTestContacts( List<Account> accountRecs, String email){   	
    	
    	Contact[] newContacts = new Contact[]{};      	
    	
    	if(accountRecs != null){   		
    		
    		system.debug('Acquired ' + accountRecs.size() +' Account records IDs');    		
    		
    		for(Integer x=0; x<accountRecs.size();x++){    			
    			 			
    			Contact createContact = new Contact(    			
    			lastname='last' + x,
                firstname='first' + x,
                accountId= accountRecs[x].Id,
                email=  x + email						
    			);    			
    			
    			newContacts.add(createContact);
    		}   
    		system.debug('Success we created ' + newContacts.size() + '  Contact records');	
    	}	   	    	
    	return newContacts;    
    }      
   
    public  static List<Subscription__c> getTestSubscriptions(String recordType,List<Account> accountRecs, Integer numberOfRecords){
    	
    	Subscription__c[] newSubs = new Subscription__c[]{}; 

        if(accountRecs == null){

            Id recType = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get(recordType).getRecordTypeId();

            for(Integer x=0; x<numberOfRecords;x++){
                
                Subscription__c subscriptionTocreate = new Subscription__c( 
                RecordTypeId = recType,
                ProductType__c = 'Store',
                StoreURL__c = 'http://www.testingStore'+ x + 'bigcommerce.com',         
                Purchase_Team__c = 'Sales Operations' + x,
                Source__c = 'Direct Trial',
                Upgrade_Stage__c = 'New',
                Sales_Stage__c = 'New',          
                Status__c = 'Active',
                IsTrial__c = true,
                Was_Trial__c = true,
                Product__c = 'Open',
                Totango_Insights__c = 'Subscription test' + x                                       
                );
                
                newSubs.add(subscriptionTocreate);          
            } 

            system.debug('Success we created ' + newSubs.size() + '  Subscription records'); 
        }else{

            if(accountRecs != null){
                Id recType = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get(recordType).getRecordTypeId();

                for(Integer x=0; x<accountRecs.size();x++){
                
                Subscription__c subscriptionTocreate = new Subscription__c( 
                RecordTypeId = recType,
                ProductType__c = 'Store',
                StoreURL__c = 'http://www.testingStore'+ x + 'bigcommerce.com',         
                Purchase_Team__c = 'Sales Operations' + x,
                Source__c = 'Direct Trial',
                Upgrade_Stage__c = 'New',
                Sales_Stage__c = 'New',          
                Status__c = 'Active',
                IsTrial__c = true,
                Was_Trial__c = true,
                Product__c = 'Open',
                Totango_Insights__c = 'Subscription test' + x,
                Account__c = accountRecs[x].Id                                      
                );
                
                newSubs.add(subscriptionTocreate);          
            } 

            system.debug('Success we created ' + newSubs.size() + '  Subscription with Accounts records'); 

            }
        }    		 	
    	
    	return newSubs;       
    }

    public static List<Totango_Engagement__c> getTestTotangoEngagements(List<Subscription__c> subList){
        
        Totango_Engagement__c[] newTotangos = new Totango_Engagement__c[]{};        
        
        if(subList != null){            
            
            System.debug('getTestTotangoEngagements : Create' + subList.size() + '  records');
            //for(Subscription__c subsRec : subList){
            for(Integer x=0; x<subList.size();x++){
                
                Totango_Engagement__c createTotango = new Totango_Engagement__c(                
                Subscription__c = subList[x].Id,                
                TotangoInsights__c = 'Totango testing' + x          
                );
                
                newTotangos.add(createTotango);
            }   
            system.debug('Success we created ' + newTotangos.size() + '  Totango with subscription records');   
        }               
        return newTotangos;    
    } 

    public static List<Lead> getTestLeads(String recordType,String email, Integer numberOfRecords) {
    	
    	Lead[] newLeads = new Lead[]{};  

        Id recType = Lead.getSObjectType().getDescribe().getRecordTypeInfosByName().get(recordType).getRecordTypeId();    		
    
    	for(Integer x=0; x<numberOfRecords;x++){
    		
    		Lead LeadTocreate = new Lead(     		
    		RecordTypeId = recType, 		
    		FirstName = 'First ' + x,
			LastName = 'Last ' + x,
			Email =  x + email,
			Type__c = 'Trial',
			LeadSource = 'Web Trial',
			Lead_Assignment_Method__c = 'Round Robin',
			Phone = '555-555-555' + x,
			Assign_Now__c = true,
			Company = 'Test Company' + x,
			Country = 'US',		
//			Stage__c = 'New', 
			Status = 'Open',
			Expected_Plan__c = 'Bronze',
			Temperature__c = 'Cold' 	    	     		
    		);
    		
    		newLeads.add(LeadTocreate);   		
    	}
    	   	
    	system.debug('Success we created ' + newLeads.size() + '  Lead records');
    	
    	return newLeads;       
    }    
  
    public static List<Webinar__c> getTestWebinars(String email, Integer numberOfRecords ) {
    	
    	Webinar__c[] newWebinars = new Webinar__c[]{};       	
    	
    		for(Integer x=0; x<numberOfRecords;x++){
    			    					    		
    			Webinar__c WebinarTocreate = new Webinar__c(    			    		
    			Name = 'Webinar ' + x,	    			    			   				
				Registrant_Email__c =  x + email			    	     		
    			);    		
    			newWebinars.add(WebinarTocreate); 
    		}      	   	
    		
    	   	
    	system.debug('Success we created ' + newWebinars.size() + '  Webinar records');
    	
    	return newWebinars;       
    }   
}