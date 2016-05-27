public without sharing class SubscriptionAPIUtils 
{			
	public static boolean sendSubscription(Id subscriptionId)
	{	
		boolean sentSuccessfully = true;
		
		// used for error emails
		String emailsubject = 'An Error has occurred Creating New Trial';
		List<String> recipients = new List<String>();
		recipients.add(UserInfo.getUserEmail());
		
		// get subscription info
		Subscription__c subscription = [SELECT Account__r.MBAAccountId__c, Account__r.Name, Account__r.Phone, 
										Lead__r.MBAAccountId__c, Lead__r.FirstName, Lead__r.LastName, Lead__r.Company, 
										Lead__r.Phone, Lead__r.Email, Lead__r.Street, Lead__r.City, Lead__r.State, 
										Lead__r.PostalCode, Lead__r.Country, StoreName__c, 
										MBAAccountID__c, MBASubscriptionID__c, Password__c
										FROM Subscription__c 
										WHERE Id = :subscriptionId];
		
		if(subscription == null) return false;		
		
		System.debug('***subscription START: ' + subscription);
		
		// used for error emails
		String textBody;
		if(subscription.Account__r.Name != null)
		{
			textBody = 'An Error has occurred creating a new Trial for ' + subscription.Account__r.Name;
		}
		else
		{
			textBody = 'An Error has occurred creating a new Trial for ' + subscription.Lead__r.FirstName + ' ' + subscription.Lead__r.LastName;
		}
		
		String mbaAccountId;	
		
		Boolean updateAccount = false;	
		
		// does account/lead have MBAAccountId__c field filled?				
		if(subscription.Account__c != null)
		{ 
			mbaAccountId = subscription.Account__r.MBAAccountId__c;
		}
		else
		{
			mbaAccountId = subscription.Lead__r.MBAAccountId__c;
		}
		
		// if not POST/account and update MBAAccountId__c field on the account/lead and Subscription
		if(mbaAccountId == null)
		{
			updateAccount = true;
			
			String firstName;
			String lastName;
			String password = subscription.Password__c;
			String companyName; 
			String phone;
			String email;
			String address1;
			String city;
			String state;
			String postcode;
			String country;			
			
			if(subscription.Account__c != null)
			{				
				companyName = subscription.Account__r.Name;
				phone = subscription.Account__r.Phone;
								
				// TO DO: need to get contact fields for account for other parameters.  Need to verify contact is always there 
				List<Contact> contacts = [SELECT FirstName, LastName, Email, MailingStreet, MailingCity, 
											MailingState, MailingPostalCode, MailingCountry
											FROM Contact
											WHERE AccountId = :subscription.Account__c
											ORDER BY LastModifiedDate DESC];
				if(contacts.size() > 0)
				{
					firstName = contacts[0].FirstName;
					lastName = contacts[0].LastName;
					email = contacts[0].Email;
					address1 = contacts[0].MailingStreet;
					city = contacts[0].MailingCity;
					state = contacts[0].MailingState;
					postcode = contacts[0].MailingPostalCode;
					country = contacts[0].MailingCountry;
				}				
				
			}
			else
			{
				firstName = subscription.Lead__r.FirstName;
				lastName = subscription.Lead__r.LastName;
				companyName = subscription.Lead__r.Company;
				phone = subscription.Lead__r.Phone;
				email = subscription.Lead__r.Email;
				address1 = subscription.Lead__r.Street;
				city = subscription.Lead__r.City;
				state = subscription.Lead__r.State;
				postcode = subscription.Lead__r.PostalCode;
				country = subscription.Lead__r.Country;				
			}
			
			// required fields: firstName, lastName, password, companyName, phone, email, country
			// Create Account
			RESTMBAAccount a = new RESTMBAAccount();
			a.firstName = firstName;
			a.lastName = lastName;
			a.address1 = address1;
			a.city = city;
			a.state = state;
			a.postcode = postcode;
			a.country = country;
			a.password = password; 
			a.companyName = companyName;
			a.email = email;
			a.phone = phone;
			
			String s = JSON.serialize(a);
					
			// Send the HTTP request and get the response.
			// The response is in JSON format.
			HttpResponse response;
			if(test.isRunningTest())
			{
				response = new HttpResponse();
				String json = '{'+
				'\"id\": 428231,'+
				'\"firstName\": \"Joe\",'+
				'\"lastName\": \"Testerson\",'+
				'\"companyName\": \"Joe\'s Secondhand Lemur Enclosures\",'+
				'\"email\": \"joe@joeswholesale.com\",'+
				'\"address1\": \"Apartment 6\",'+
				'\"address2\": \"123 Fake st\",'+
				'\"city\": \"Fakesville\",'+
				'\"state\": \"NSW\",'+
				'\"postcode\": \"2830\",'+
				'\"country\": \"AU\",'+
				'\"phone\": \"+61 2 8234 1234\",'+
				'\"stores\": {'+
				'\"url\": \"https://account.bigcommerce.com/api/accounts/428231/stores.json\",'+
				'\"resource\": \"/accounts/3245/stores\"'+
				'}'+
				'}';
				response.setBody(json);	
			}
			else
			{
				try
				{
					system.debug('***SubscriptionAPIUtils:sendSubscription - body of Account post: ' + s);
					response = SubscriptionREST.JSONRequestSetup('accounts', 'POST', s);
				}
				catch (Exception e)
				{
					System.debug('*** Error POSTIng Account: ' + e);
					DisplayUtils.addError(textBody);
					DisplayUtils.addError(e.getMessage());
					
					return false;
					//EmailUtils.sendTextEmail(recipients, emailSubject, textBody);
				}
			}		
			
			Account acct;
			Lead ld;
			
			try
			{
				System.debug('***SubscriptionAPIUtils:sendSubscription - get Account Post response: ' + response.toString());
				System.debug('***response.getBody(): ' + response.getBody());
				//System.debug('***SubscriptionAPIUtils:sendSubscription - Account Post response body document: ' + response.getBodyDocument());
				
				// Make sure a valid response is returned
				if (response.getStatusCode() != 200)
				{
					system.debug('***SubscriptionAPIUtils:sendSubscription - Error Code Received for Account Post');
					RESTMBAErrorMessage errMsg = RESTMBAErrorMessage.parse(response.getBody());
					
					System.debug('***SubscriptionAPIUtils:sendSubscription - Response Error Msg: ' + errMsg);
					
					DisplayUtils.addError('Error creating new Account...Status Code Returned: ' + errMsg.Status + ' for Error(s):');
					for (String strErr : errMsg.messages)
					{
						DisplayUtils.addError(strErr);
					}
					
					return false;
					//EmailUtils.sendTextEmail(recipients, emailSubject, textBody + errMsg.messages);
				}
				else
				{				
					RESTMBAAccount newAccount = RESTMBAAccount.parse(response.getBody());
					
					System.debug('***subscription.Lead__c: ' + subscription.Lead__c);
					
					System.debug('***SubscriptionAPIUtils:sendSubscription - Response Account: ' + newAccount);
				
					if(subscription.Account__c != null)
					{ 
						acct = [SELECT MBAAccountId__c FROM Account WHERE Id = :subscription.Account__c];
						acct.MBAAccountID__c = String.valueOf(newAccount.id);
						mbaAccountId = acct.MBAAccountID__c;					
					}
					else
					{
						ld = [SELECT MBAAccountId__c FROM Lead WHERE Id = :subscription.Lead__c];
						ld.MBAAccountID__c = String.valueOf(newAccount.id);
						mbaAccountId = ld.MBAAccountID__c;					
					}
					
					subscription.MBAAccountID__c = mbaAccountId;
					
					// post the store
					postStore(mbaAccountId, subscription, recipients, emailSubject, textBody);	
					
					// update lead/account with MBA Account Id
					if(subscription.Account__r.MBAAccountId__c != null)
					{
						//update acct;
						NoSharingUtils.updateObject(acct);	
					}
					else
					{
						//update ld;
						NoSharingUtils.updateObject(ld);	
					}	
				}					
			}
			catch(Exception e)
			{
				System.debug('Error parsing JSON response: ' + e);
				DisplayUtils.addError(textBody);
				DisplayUtils.addError(e.getMessage());
				return false;
				//EmailUtils.sendTextEmail(recipients, emailSubject, textBody);
			}
		} 
		else
		{
			// MBA Account already exists, so just post store
			try
			{
				subscription.MBAAccountID__c = mbaAccountId;
				sentSuccessfully = postStore(mbaAccountId, subscription, recipients, emailSubject, textBody);
			}
			catch(Exception e)
			{
				System.debug('Error parsing JSON POST/post Store response: ' + e);
				DisplayUtils.addError(textBody);
				DisplayUtils.addError(e.getMessage());
				return false;
				//EmailUtils.sendTextEmail(recipients, emailSubject, textBody);
			}			
		}
		
		System.debug('***subscription END: ' + subscription);	
		
		return sentSuccessfully;
	}
	
	private static boolean postStore(String mbaAccountId, Subscription__c subscription, list<String> recipients, string emailSubject, string textBody)
	{
		boolean sentSuccessfully = true;
		// POST/stores call		
		
		// Get packages (should only be one)
		HttpResponse pkgResponse;
		if(test.isRunningTest())
		{
			pkgResponse = new HttpResponse();
			String json = '[{\"id\":1,\"agencyId\":1,\"name\":\"15 Day Free Trial\",\"shortName\":\"Free\",\"paymentType\":\"free\",\"diskSpace\":100,\"bandwidth\":0,\"users\":1,\"products\":20,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3},{\"id\":2,\"agencyId\":1,\"name\":\"BronzePlan\",\"shortName\":\"Bronze\",\"paymentType\":\"recurring\",\"diskSpace\":1024,\"bandwidth\":0,\"users\":3,\"products\":100,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3,\"pricing\":{\"monthly\":{\"monthly\":\"24.95\",\"setup\":\"0.00\"},\"annually\":{\"monthly\":\"240.95\",\"setup\":\"0.00\"}}},{\"id\":3,\"agencyId\":1,\"name\":\"BronzePlan\",\"shortName\":\"Bronze\",\"paymentType\":\"recurring\",\"diskSpace\":1024,\"bandwidth\":0,\"users\":3,\"products\":100,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3,\"pricing\":{\"monthly\":{\"monthly\":\"24.95\",\"setup\":\"0.00\"},\"annually\":{\"monthly\":\"240.95\",\"setup\":\"0.00\"}}},{\"id\":4,\"agencyId\":1,\"name\":\"BronzePlan\",\"shortName\":\"Bronze\",\"paymentType\":\"recurring\",\"diskSpace\":1024,\"bandwidth\":0,\"users\":3,\"products\":100,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3,\"pricing\":{\"monthly\":{\"monthly\":\"24.95\",\"setup\":\"0.00\"},\"annually\":{\"monthly\":\"240.95\",\"setup\":\"0.00\"}}},{\"id\":5,\"agencyId\":1,\"name\":\"BronzePlan\",\"shortName\":\"Bronze\",\"paymentType\":\"recurring\",\"diskSpace\":1024,\"bandwidth\":0,\"users\":3,\"products\":100,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3,\"pricing\":{\"monthly\":{\"monthly\":\"24.95\",\"setup\":\"0.00\"},\"annually\":{\"monthly\":\"240.95\",\"setup\":\"0.00\"}}},{\"id\":6,\"agencyId\":1,\"name\":\"Bronze Plan\",\"shortName\":\"Bronze\",\"paymentType\":\"recurring\",\"diskSpace\":1024,\"bandwidth\":0,\"users\":3,\"products\":100,\"apiRequests\":20000,\"apiRequestInterval\":60,\"featureFlags\":3,\"pricing\":{\"monthly\":{\"monthly\":\"24.95\",\"setup\":\"0.00\"},\"annually\":{\"monthly\":\"240.95\",\"setup\":\"0.00\"}}}]';			
			pkgResponse.setBody(json);
		}
		else
		{
			pkgResponse = SubscriptionREST.JSONRequestSetup('packages', 'GET', null);
		}
			
		system.debug('***pkgResponse.getBody(): ' + pkgResponse.getBody());	
		
		list<RESTMBAPackage> pkg = RESTMBAPackage.parseList(pkgResponse.getBody());
		//SubscriptionREST.MBAPackage pkg = new SubscriptionREST.MBAPackage().parse(pkgResponse.getBody());
		//List<SubscriptionREST.MBAPackage> pkg1 = pkg.parseList(pkgResponse.getBody());		
		system.debug('***SubscriptionAPIUtils:postStore - Package List: ' + pkg);
		
		// required fields are packageId, accountId and subdomain
		SubscriptionREST.MBAStorePOST store = new SubscriptionREST.MBAStorePOST();		
		store.packageId = pkg[0].Id;
		store.accountId = Integer.valueOf(mbaAccountId);		
		store.storeName = subscription.StoreName__c;
		store.partnerId = 1;
		
		String strJSON = JSON.serialize(store);
		System.debug('***strJSON: ' + strJSON);
		
		HttpResponse response;
		if(test.isRunningTest())
		{
			response = new HttpResponse();
			String json2 = '{'+
						'\"id\": 428231,'+
						'\"accountId\": 1,'+
						'\"account\": {'+
						'\"url\": \"https://account.bigcommerce.com/api/accounts/428231/stores.json\",'+
						'\"resource\": \"/accounts/3245/stores\"'+
						'},'+
						'\"packageId\": 1,'+
						'\"package\": {'+
						'\"url\": \"https://account.bigcommerce.com/api/accounts/428231/stores.json\",'+
						'\"resource\": \"/accounts/3245/stores\"'+
						'},'+
						'\"packageId\": 1,'+
						'\"server\": 1,'+
						'\"storeName\": \"Store Name\",'+
						'\"domain\": \"domain\",'+
						'\"status\": \"NSW\",'+
						'\"paymentAmount\": \"2830\",'+
						'\"billingCycle\": \"AU\",'+
						'\"registrationDate\": \"11/11/2013",'+
						'\"provisionDate\": \"11/11/2013",'+
						'\"convertedDate\": \"11/11/2013",'+
						'\"cancellationDate\": \"11/11/2013"'+			
						'}';
			response.setBody(json2);
		}
		else
		{
			system.debug('***SubscriptionAPIUtils:postStore - body of Subscription post: ' + strJSON);
			response = SubscriptionREST.JSONRequestSetup('stores', 'POST', strJSON);
		}		
		
		system.debug('***SubscriptionAPIUtils:postStore - get Subscription Post response: ' + response.toString());
		System.debug('*** response: ' + response.getBody());		
		
		// Make sure a valid response is returned
		if (response.getStatusCode() != 200)
		{
			system.debug('***SubscriptionAPIUtils:postStore - Error Code Received for Store Post');
			RESTMBAErrorMessage errMsg = RESTMBAErrorMessage.parse(response.getBody());
			
			System.debug('***SubscriptionAPIUtils:postStore - Response Error Msg: ' + errMsg);
			DisplayUtils.addError('Error creating new Trial Store: ' + errMsg.Status + '; with Error Messages: ' + errMsg.messages);
			
			sentSuccessfully = false;
			//EmailUtils.sendTextEmail(recipients, emailSubject, textBody + errMsg.messages);
		}
		else
		{
			RESTMBAStore newStore = RESTMBAStore.parse(response.getBody());
			subscription.MBASubscriptionID__c = String.valueOf(newStore.Id);
		
			//update subscription;
			NoSharingUtils.updateObject(subscription);
		}
		
		return sentSuccessfully;
	}
}