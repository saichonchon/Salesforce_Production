/*
Name: GAutility
Author: Maggie Frederick
Created: 4/6/2016
Purpose: This class contains the methods to build and send data to Google Analytics via the HTTP Post endpoint of the Google Analytics Measurement Protocol
Ticket: BAP-2406

Updates:
*********
Author: Maria Huemmer
Created: 5/6/2016
Purpose: Reviewing code and updating to add comments for testing
Ticket: BAP-2406

Author: Steve O'Neal
Created: 5/9/2016
Purpose: Modifying the utility to use a single URL string and have each method modify it, rather than several instances of the same string
Ticket: BAP-3444
*/

global class GAutility {
	// enumeration of all of the Google Analytics actions that we use
	global enum GAAction {lead_conversion, lead_capture, lead_lost, lead_reactivated, sales_funnel_stage, subscription_activation, subscription_termination, purchase}
	global static API_Connection_Setting__c APISettings = null;
	public static GAAction mostRecentAction;
	
	/*
		Steve O'Neal, BAP=3444: adding function to return only the first client id in a comma-delimited string
		Parameters:
		o - the sObject that the client Id belongs to
	*/
	private static List<string> getClientIds(sObject o)
	{
		boolean isOpportunity = false;
		string clientId = '';
		
		if (o.getSObjectType() == Schema.Opportunity.getSObjectType())
		{
			clientId = ((Opportunity)o).GA_Client_ID__c;
			isOpportunity = true;
		}
		else if (o.getSObjectType() == Schema.Contact.getSObjectType())
		{
			clientId = ((Contact)o).GAClientID__c;
		}
		else if (o.getSObjectType() == Schema.Account.getSObjectType())
		{
			clientId = ((Account)o).GAClientID__c;
		}
		else if (o.getSObjectType() == Schema.Lead.getSObjectType())
		{
			clientId = ((Lead)o).GAClientID__c;
		}
		else
		{
			throw new ApplicationException('Only Opportunities, Contacts, Leads, or Accounts may be passed into getClientID');
		}

		// use a set instead of a list so that we will only return unique values
		Set<string> retVal = new Set<string>();
		if (clientId != null && clientId != '')
		{
			List<string> clientIds = clientId.split(',');

			System.Debug('Number of client ids: ' + clientIds.size());
			if (clientIds.size() > 0)
			{
				for (string clientIdLoop : clientIds)
				{
					if (clientIdLoop != '')
					{
						// for opportunities, we only want to return one id in the list.  All other objects can have more than one value returned
						if (isOpportunity && retVal.size() > 0)
						{
							System.debug('Opportunity Client ID: ' + retVal);
							return new List<string>(retVal);
						}
						retVal.add(clientIdLoop);
					}
				}
			}
		}

		System.debug('Client IDs: ' + retVal);
		return new List<string>(retVal);
	}


	/**
	 * Returns a blank if the passed in string is null
	 * @author Steve O'Neal
	 * @date   2016-05-31
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3444
	 * @param  val        Value to be checked
	 * @return            Blank value if val=null, val if not null
	 */
	private static string returnBlankIfNull(string val)
	{
		if (String.isBlank(val))
		{
			return '';
		}
		else
		{
			return val;
		}
	}


	/**
	 * Returns a zero if the passed decimal is null
	 * @author Steve O'Neal
	 * @date   2016-06-03
	 * @ticket link       https://jira.bigcommerce.com/browse/BAP-3444
	 * @param  val        Value to be checked
	 * @return            0 if val=null, val if not null
	 */
	private static decimal returnZeroIfNull(decimal val)
	{
		if (val == null)
		{
			return 0;
		}
		else
		{
			return val;
		}
	}
	
	/**
	 * Generates a URL string that can be posted to Google Analytics
	 * @author Steve O'Neal
	 * @date   2016-05-26
	 * @ticket link            https://jira.bigcommerce.com/browse/BAP-3444
	 * @param  GA_ACTION       The reason for making the API call
	 * @param  affectedSObject The Salesforce object that needs to be sent to GA (Lead, Account or Opportunity)
	 * @return                 List of Google Analytics strings
	 */
	public static List<string> getGARequestStrings(GAAction GA_ACTION, sObject affectedSObject)
	{
		List<string> retVals = new List<string>();

		// to prevent the same outbound message being sent on the trigger's return trip, we check to see if the same message was sent more than once.
		System.Debug('Most Recent Action: ' + mostRecentAction + ' - Current Action: ' + GA_ACTION);
		if (mostRecentAction == GA_ACTION)
		{
			return retVals;
		}
		else
		{
			// save the most recent action so we don't run the code twice
			mostRecentAction = GA_ACTION;
		}
		
		if (GAutility.APISettings == null)
		{
			GAutility.APISettings = API_Connection_Setting__c.getValues('GoogleAnalytics');

		}

		if (Test.isRunningTest())
		{
			// for testing, we may need to create our own copy of API settings as the calling code may not be using SeeAllData
			GAutility.APISettings = new API_Connection_Setting__c();
			GAutility.APISettings.Google_Analytics_Property_Id__c = '123456789';
			GAutility.APISettings.URL__c = 'https://analytics.google.com/';
		}
		
		if (GA_ACTION == null || GA_ACTION.name() == '')
		{
			throw new ApplicationException('GA_ACTION must have a value');
		}
		
		if (affectedSObject == null)
		{
			throw new ApplicationException('affectedSObject must have a value');
		}

		
		for (string GA_CLIENT_ID : getClientIds(affectedSObject))
		{
	
			string retVal = 'v=1&tid=[GA_PROPERTY_ID]&cid=[GA_CLIENT_ID]&t=event&ec=salesforce&ea=[GA_ACTION][GA_ACTION_APPEND]&ni=1[SF_OBJECT_ID][GA_ACTIVE]&z=' + Crypto.getRandomInteger();
			retVal = retVal.replace('[GA_PROPERTY_ID]',APISettings.Google_Analytics_Property_Id__c);
			// replace all underscores in the action with the http encoded value for whitespace
			retVal = retVal.replace('[GA_ACTION]',String.ValueOf(GA_ACTION).replaceAll('_', '%20'));
			
			string GA_ACTION_APPEND = '';
			
			// depending on the object ids passed in, we need to include them in the URL with the matching parameter names
			string SF_OBJECT_ID = '';
	
			if (affectedSObject.getSObjectType() == Schema.Account.getSObjectType())
			{
				Account affectedAccount = (Account)affectedSObject;
				//SF_OBJECT_ID += '&cd17=' + affectedAccount.Id;
			}
			else if (affectedSObject.getSObjectType() == Schema.Lead.getSObjectType())
			{
				Lead affectedLead = (Lead)affectedSObject;
				
				// include the account and contact lead for converted leads
				if (GA_ACTION == GAAction.lead_capture)
				{
					SF_OBJECT_ID += '&cd16=' + affectedLead.Id;
				}
				else if (GA_ACTION == GAAction.lead_conversion)
				{
					SF_OBJECT_ID += '&cd17=' + affectedLead.ConvertedAccountId;
					SF_OBJECT_ID += '&cd18=' + affectedLead.ConvertedContactId;
				}
	
				// when qualifying a lead (GAAction.sales_funnel_stage), append the 'el' parameter, otherwise remove it.  It is not obvious in the documentation what this parameter represents
				if (GA_ACTION == GAAction.sales_funnel_stage)
				{
					GA_ACTION_APPEND += '&el=sales%20qualified';
				}
			}
			else if (affectedSObject.getSObjectType() == Schema.Opportunity.getSObjectType())
			{
				Opportunity affectedOpportunity = (Opportunity)affectedSObject;
				
				// the google analytics call does not require an object id for opportunities
				SF_OBJECT_ID = '';
				
				// when calling the purchase action, include additional transactional information
				if (GA_ACTION == GAAction.purchase)
				{
					GA_ACTION_APPEND += '&pa=' + String.ValueOf(GA_ACTION).replaceAll('_', '%20');
					GA_ACTION_APPEND += '&ti=' + returnBlankIfNull(affectedOpportunity.MBASubscriptioNID__c);
					GA_ACTION_APPEND += '&tr=' + returnZeroIfNull(affectedOpportunity.Amount);
					GA_ACTION_APPEND += '&tt=' + returnZeroIfNull(0); // Tax.  Hardcoded to blank because there is currently no tax field on opportunity.
					GA_ACTION_APPEND += '&tcc=' + returnBlankIfNull(affectedOpportunity.CouponCode__c);
					GA_ACTION_APPEND += '&pr1nm=' + returnBlankIfNull(affectedOpportunity.Product__c);
					GA_ACTION_APPEND += '&pr1id=' + returnBlankIfNull(affectedOpportunity.ProductID__c);
					GA_ACTION_APPEND += '&pr1ca=' + returnBlankIfNull(affectedOpportunity.SubscriptionType__c);
					GA_ACTION_APPEND += '&pr1pr=' + returnZeroIfNull(affectedOpportunity.Amount);
					GA_ACTION_APPEND += '&pr1qt=1'; // Quantity.  Hardcoded to 1 because we call this method with each purchase.
					GA_ACTION_APPEND += '&pr1cc=' + returnBlankIfNull(affectedOpportunity.CouponCode__c);
				}
			}
			else
			{
				throw new ApplicationException('Invalid object type of ' + affectedSObject.getSObjectType().getDescribe().getName() + ' passed for affectedSObject');
			}
	
			retVal = retVal.replace('[GA_ACTION_APPEND]',GA_ACTION_APPEND);
			retVal = retVal.replace('[SF_OBJECT_ID]',SF_OBJECT_ID);
			retVal = retVal.replace('[GA_CLIENT_ID]',GA_CLIENT_ID);
			
	
			// depending on the GAAction selected, the url expects different parameters for 'active'
			string GA_ACTIVE = '';
			if (GA_ACTION == GAAction.subscription_activation)
			{
				GA_ACTIVE = '&cd20=active';
			} 
			else if (GA_ACTION == GAAction.subscription_termination)
			{
				GA_ACTIVE = '&cd20=inactive';
			}
			else if (GA_ACTION == GAAction.lead_reactivated || GA_ACTION == GAAction.lead_capture)
			{
				GA_ACTIVE = '&cd19=active';
			}
			else if (GA_ACTION == GAAction.lead_lost)
			{
				GA_ACTIVE = '&cd19=inactive';
			}
			retVal = retVal.replace('[GA_ACTIVE]',GA_ACTIVE);
			
			System.Debug('getGACommunicationString = ' + retVal);
			
			retVals.add(retVal);
		}
		
		return retVals;
	}
	
	/*
		This method is creating the HTTP request with the required Google Analytics data and posting it to the Google Analytic Measurement Protocol 
		The @future decoration tells the system that the next method (GARequest) can be run asynchronously.  When the method is called, it is spun into another thread.
		Callout tells the system that you will be making an API callout in the method.  As far as I know, it is primarily needed for testing, so that the test methods do
		not execute that code.  It is a requirement for any methods that make external API callouts.  Because it is asynchronous, the calling code may have fully completed processing before 
	  	this method finishes, so you need to be careful not to depend on results of this method in the calling code 
		
		Steve O'Neal, BAP-3444: Changing the callout to use custom settings instead of labels.
		Parameters:
		strBody (required) - The body of the http callout.
	*/
    @future(callout=true) 
    public static void GARequest (List<string> strBodyList)
    {
    	for (string strBody : strBodyList)
    	{
			if (GAutility.APISettings == null)
			{
				GAutility.APISettings = API_Connection_Setting__c.getValues('GoogleAnalytics');
			}
	
	        //strBody is a concatenation of values that makes up the body of the HTTP post request 
	        
	        HttpResponse response;
	        
	        Http httpProtocol = new Http();
	        
	        // Create HTTP request to send to Google Analytics
	        HttpRequest request = new HttpRequest();
	        
	        //We have a custom setting called API_Connection_Setting__c that is used to construct endpoints. 
	        //We have added a value here to generate the Google Analytics endpoint
	        String url  = APISettings.URL__c;
	        
	        System.Debug('URL:' + url);
	
	        // Set the endpoint URL    
	        request.setEndPoint(url);
	        
	        // Set the HTTP verb to GET.
	        string strAction = 'POST';
	        request.setMethod(strAction);
	    
	        // If a body exists, set the body of the HttpRequest to the body
	        system.debug('*** body '+request.getBody());
	        if (strBody != null && strBody <> '')
	        {
	            request.setBody(strBody);
	        }
	        system.debug('*** Google Analytics callout: '+request.getBody());
	
	        if(test.isRunningTest())
	        {
		        Test.setMock(HttpCalloutMock.class, new GARequestMock());
	        }
	
	        try 
	        {
	        	system.debug('*** API Request Made with: ' + request.toString());
	        	response = httpProtocol.send(request);
	        	integer statusCode = response.getStatusCode();
		        system.debug('*** Google Analytics status: ' + statusCode + ', response: '+response.getBody());
		        
		        if (statusCode < 200 || statusCode >= 300)
		        {
		        	throw new ApplicationException('Error occurred while processing request, server returned a status of ' + statusCode);
		        }
	        }
	        catch (Exception e)
	        {
	          	System.debug('*** calling service failed: ' + e);
				// This is re-used code that sends an email if an error is generated, we can delete but I'm leaving it in if you want to use it while we are testing ErrorEmailHelper.notifyOnError('BMP Callout', 'Service Error', 'Error Occured in calling BMP', ' Error Message: ' + e.getMessage());
	        }
	    }
    }
}