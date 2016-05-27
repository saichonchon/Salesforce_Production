public without sharing class CreateNewTrialController 
{
	public static String EMAIL_REGEX = '^([a-zA-Z0-9_\\-\\.]+)@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})$';
		
	public Subscription__c subscription {get; set;}
	public Lead objLead {get; set;}
	
	public String firstName {get; set;}
	public String lastName {get; set;}
	public String company {get; set;}
	public String email {get; set;}	
	public String password {get;set;}
	public String phone {get; set;}
	
	public String storeName {get; set;}	
	public String country {get; set;}	//Where is store based? (country list)
	public String industry {get; set;}	//What will you sell? (industry)			
	
	public List<SelectOption> accounts {get; set;}
	public String selectedAccountId {get; set;}
	//public String selectedCountry {get; set;}
	//public String selectedIndustry {get; set;}
		
	public Boolean createNewAccount {get; set;}
	public Boolean subscriptionSent {get; set;}
	public Boolean isError {get; set;}
	
	ApexPages.StandardController controller;
	
	public CreateNewTrialController(ApexPages.StandardController stdController)
	{ 
		system.debug('@@@CreateNewTrialController:CreateNewTrialController - Start');
		
		controller = stdController;
		subscription = (Subscription__c)controller.getRecord();
		 
		subscriptionSent = false;
		createNewAccount = true;
		isError = false;
		
		populateAccountList();
		
		setFieldValues();
		
		system.debug('@@@CreateNewTrialController:CreateNewTrialController - End');
	}
	
	public void setFieldValues()
	{
		system.debug('@@@CreateNewTrialController:setFieldValues - subscription: ' + subscription);
		
		if (subscription != null && subscription.Id != null)
		{				
			subscription = [SELECT Id, RecordTypeId, Country__c, Password__c, Industry__c, StoreName__c, Lead__c, Account_Name__c, Account__c
							FROM Subscription__c
							WHERE Id = :subscription.Id];
			
			system.debug('@@@CreateNewTrialController:setFieldValues - subscription queried: ' + subscription);
										
			// Set the subscription fields
			country = subscription.Country__c;
			password = subscription.Password__c;
			industry = subscription.Industry__c;
			storeName = subscription.StoreName__c;
			
			// If an account is associated to the Sub
			if (subscription.Account__c != null)
			{
				createNewAccount = false;
				selectedAccountId = subscription.Account__c;
				
				Contact objContact = null;
				
				for (Contact c : [SELECT FirstName, LastName, Email, MailingStreet, MailingCity, Phone, MailingState, MailingPostalCode, MailingCountry, AccountId
									FROM Contact 
									WHERE AccountId = :subscription.Account__c
									ORDER BY LastModifiedDate DESC
									LIMIT 1])
				{
					objContact = c;
					break;
				}
				
				if (objContact != null)
				{
					firstName = objContact.FirstName;
					lastName = objContact.LastName;
					company = subscription.Account_Name__c;
					phone = objContact.Phone;
					email = objContact.Email;
				}
			}
			else if (subscription.Lead__c != null)
			{
				createNewAccount = true;
				
				objLead = [SELECT Id, FirstName, LastName, Email, Country, Company, Phone
							FROM Lead
							WHERE Id = :subscription.Lead__c];
				
				//selectedAccountId = subscription.Lead__c;
				firstName = objLead.FirstName;
				lastName = objLead.LastName;
				company = objLead.Company;
				phone = objLead.Phone;
				email = objLead.Email;
			}
		}
		
		system.debug('@@@CreateNewTrialController:setFieldValues - End');
	}
	
	public pageReference initTrialComplete()
	{
		system.debug('@@@CreateNewTrialController.initTrialComplete - Subscription: ' + subscription);
		pageReference pr = null;
		
		if (subscription != null && subscription.Id != null && !subscriptionSent && !isError)
		{
			pr = sendNewTrial();
		}
		
		system.debug('@@@CreateNewTrialController:initTrialComplete - End');
		
		return pr;
	}
	
	public pageReference sendNewTrial()
	{
		system.debug('@@@CreateNewTrialController.sendNewTrial - Subscription: ' + subscription);
		
		if (subscription != null && subscription.Id != null)
		{
			try
			{
				isError = !SubscriptionAPIUtils.sendSubscription(subscription.Id);
				subscriptionSent = true;
			}
			catch (Exception e)
			{
				isError = true;
				DisplayUtils.addError('The following errors have occurred while processing your new Trial.  Please contact your system administrator if this continues to happen.');
				//DisplayUtils.addError(e.getMessage());
				System.debug('*** Error Creating New Trial: ' + e.getMessage());
			}
		}
		
		system.debug('@@@CreateNewTrialController:sendNewTrial - End');
		
		return null;
	}
	
	//**** Populates the Account/Lead drop down list ****
	public void populateAccountList()
	{	
		system.debug('@@@CreateNewTrialController:populateAccountList - Start');
		
		accounts = new List<SelectOption>();
		accounts.add(new SelectOption('NONE', 'CREATE NEW CUSTOMER'));
		//** get current portal user subscriptions	
		List<Subscription__c> subscriptions = [SELECT Id, Account_Name__c, Account__c, Lead__c 
											FROM Subscription__c 
											//WHERE Channel_Partner__c = '001a0000019dqjy'
											WHERE Channel_Partner__c = :String.valueOf(PartnerPortalHelper.PartnerAccount.Id)
												AND Channel_Partner__c <> Null
											ORDER BY Account_Name__c];
			
		//** create map of unique account/lead Ids to name **
		Map<Id, String> idToNameMap = new Map<Id, String>();
		List<String> accountNamesASC = new List<String>();
		
		for(Subscription__c s:subscriptions)
		{
			Id acctId;
			if(s.Account__c != null)
			{
				acctId = s.Account__c;
			}
			else
			{
				acctId = s.Lead__c;
			}			
			
			if(acctId != null)
			{
				if(!idToNameMap.containsKey(acctId))
				{ 
					idToNameMap.put(acctId, s.Account_Name__c);
					accountNamesASC.add(acctId);
				}
			}		
		}
		
		//** populate SelectOption List
		for(String s:accountNamesASC)
		{
			accounts.add(new SelectOption(s, idToNameMap.get(s)));
		}
		/*
		for(Id i:idToNameMap.keyset())
		{
			accounts.add(new SelectOption(i, idToNameMap.get(i)));
		}
		*/
		
		system.debug('@@@CreateNewTrialController:populateAccountList - End');
	}	
	
	public List<SelectOption> getCountries() 
	{
	 	system.debug('@@@CreateNewTrialController:getCountries - Start');
	 	
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Account.Portal_Country__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		
		for( Schema.PicklistEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		
		system.debug('@@@CreateNewTrialController:getCountries - End');
		
		return options;	 
	}
	
	public List<SelectOption> getEmails()
	{
		system.debug('@@@CreateNewTrialController:getEmails - Start');
		
		email = null;
		
		List<SelectOption> options = new List<SelectOption>();
		if(selectedAccountId != 'NONE' && selectedAccountId != 'CREATE NEW ACCOUNT') 
		{
			String objectAPIName = ((Id)selectedAccountId).getSObjectType().getDescribe().getName();
			if(objectAPIName == 'Account')
			{				
				//List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email <> Null AND AccountId = :selectedAccountId];
				List<Contact> contacts = NoSharingUtils.queryObject('SELECT Id, Email FROM Contact WHERE Email <> Null AND AccountId = \'' + selectedAccountId + '\'');
				for(Contact c:contacts)
				{
					options.add(new SelectOption(c.Email, c.Email));
				}
			}
			else if(objectAPIName == 'Lead')
			{
				Lead l = (Lead)NoSharingUtils.queryObject1('SELECT Email FROM Lead WHERE Id = \'' + selectedAccountId + '\'');
				options.add(new SelectOption(l.Email, l.Email));
			}
		}
		
		system.debug('@@@CreateNewTrialController:getEmails - End');
		
		return options;		
	}
	
	public List<SelectOption> getIndustries() 
	{
	 	system.debug('@@@CreateNewTrialController:getIndustries - Start');
	 	
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('I\'m not sure yet...','I\'m not sure yet...'));
		Schema.DescribeFieldResult fieldResult = Subscription__c.Industry__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		
		for( Schema.PicklistEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		
		system.debug('@@@CreateNewTrialController:getIndustries - End');
		
		return options;
	}
	
	public void changeAccount()
	{
		system.debug('@@@CreateNewTrialController:changeAccount - Start');
		
		if(selectedAccountId == 'NONE' || selectedAccountId == 'CREATE NEW ACCOUNT') 
		{
			createNewAccount = true;
		}
		else
		{
			createNewAccount = false;
		}
		
		getEmails();
		
		system.debug('@@@CreateNewTrialController:changeAccount - End');		
	}
	
	public pageReference createNewTrial()
	{	
		try
		{
			Account partnerAcct = PartnerPortalHelper.PartnerAccount;
			
			if(createNewAccount)
			{
				if(DisplayUtils.isBlank(firstName) || DisplayUtils.isBlank(lastName) || DisplayUtils.isBlank(company) || DisplayUtils.isBlank(phone) || DisplayUtils.isBlank(email)
					|| DisplayUtils.isBlank(storeName) || DisplayUtils.isBlank(password))
				{
					DisplayUtils.addError('All fields must be entered.');
					return null;					
				}
				
				if (!Pattern.matches(EMAIL_REGEX, email))
				{
					DisplayUtils.addError('Plesae enter a valid Email.');
					return null;
				}
				
				if (objLead == null || objLead.Id == null)
				{
					objLead = new Lead();
				}				
				
				objLead.FirstName = firstName;
				objLead.LastName = lastName;
				objLead.Email = email;
				objLead.Country = country;
				objLead.Company = company;
				objLead.Phone = phone;
				if (partnerAcct != null)
				{
					objLead.OwnerId = partnerAcct.OwnerId;
				} 
				
				// insert or update lead if New Account
				if (objLead.Id == null)
				{
					NoSharingUtils.insertObject(objLead);
				}
				else
				{
					NoSharingUtils.updateObject(objLead);
				}
								
				// and associate new lead to subscription
				subscription.Lead__c = objLead.Id;
			}
			else
			{
				if(DisplayUtils.isBlank(storeName) || DisplayUtils.isBlank(password))
				{
					DisplayUtils.addError('All fields must be entered.');
					return null;
				}
				
				// Check if this subscription was already submitted and associated to an existing lead
				if (subscription.Lead__c != null && objLead != null & objLead.Id != null)
				{
					// Clear the lead and delete it
					subscription.Lead__c = null;
					delete objLead;
				}
				
				//** determine if selectedAccountId is a lead or account
				String objectAPIName = ((Id)selectedAccountId).getSObjectType().getDescribe().getName();
				if(objectAPIName == 'Account')
				{	
					subscription.Account__c = selectedAccountId;
					List<Contact> contacts = NoSharingUtils.queryObject('SELECT FirstName, LastName, Email, MailingStreet, MailingCity, Phone, MailingState, MailingPostalCode, MailingCountry, Account.Name FROM Contact WHERE AccountId = \'' + subscription.Account__c + '\' AND Email = \'' + email + '\' ORDER BY LastModifiedDate DESC');
					if(contacts.size() > 0)
					{
						firstName = contacts[0].FirstName;
						lastName = contacts[0].LastName;
						company = contacts[0].Account.Name;
						phone = contacts[0].Phone;						
						//email = contacts[0].Email;
					}
				}
				else if(objectAPIName == 'Lead')
				{
					subscription.Lead__c = selectedAccountId;
					List<Lead> leads = NoSharingUtils.queryObject('SELECT FirstName, LastName, Email, Phone, Company FROM Lead WHERE Id = \'' + subscription.Lead__c + '\'');
					if(leads.size() > 0)
					{
						firstName = leads[0].FirstName;
						lastName = leads[0].LastName;
						company = leads[0].Company;
						phone = leads[0].Phone;						
						email = leads[0].Email;
					}
					
				}
			}		
			
			subscription.StoreName__c = storeName;
			subscription.Password__c = password;
			subscription.Industry__c = industry;
			subscription.Country__c = country;
			subscription.Source__c = 'PRM Portal';
			subscription.RecordTypeId = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();				
			subscription.IsTrial__c = true;
						
			if (partnerAcct != null)
			{
				subscription.Channel_Partner__c = partnerAcct.Id;
				subscription.MBAPartnerID__c = string.valueOf(partnerAcct.iDev_Partner_ID__c);
				subscription.OwnerId = partnerAcct.OwnerId;
			}
			
			// insert or update subscription
			if (subscription.Id == null)
			{
				NoSharingUtils.insertObject(subscription);
			}
			else
			{
				NoSharingUtils.updateObject(subscription);
			}
			//insert subscription;			
			
			// send subscription info to REST API
			//SubscriptionAPIUtils.sendSubscription(subscription.Id);			
		}
		catch(Exception e)
		{
			DisplayUtils.addError('An Error has occurred while processing your new Trial.  Please contact your system administrator if this continues to happen.');
			DisplayUtils.addError(e.getMessage());
			System.debug('*** Error Creating New Trial: ' + e.getMessage());
			return null;
		}		
		
		pageReference pr = Page.CreateNewTrialComplete;
		pr.getParameters().put('id', subscription.Id);
		pr.setRedirect(true);
		return pr;
	}
	
	public pageReference cancel()
	{
		// Check if an existing subscription and error
		if (isError && subscription != null)
		{
			// Delete the existing subscription and lead if needed
			delete subscription;
			
			if (objLead != null && objLead.Id != null)
			{
				delete objLead;
			} 
		}
		
		pageReference pr = new PageReference('/home/home.jsp');
		pr.setRedirect(false);
		return pr;
	}
	
	public pageReference tryAgain()
	{
		pageReference pr = Page.CreateNewTrial;
		pr.getParameters().put('id', subscription.Id);
		pr.setRedirect(true);
		return pr;
	}
	
	public pageReference doAgain()
	{
		// Check if an existing subscription and error
		if (isError && subscription != null)
		{
			// Delete the existing subscription and lead if needed
			delete subscription;
			
			if (objLead != null && objLead.Id != null)
			{
				delete objLead;
			} 
		}
		
		pageReference pr = Page.CreateNewTrial;
		pr.setRedirect(true);
		return pr;
	}
}