global class SubscriptionREST 
{
	//****sandox****
	//public final static string strEndPoint = 'https://secret-falls-2038.herokuapp.com/';
	//****production****
	public final static string strEndPoint = 'https://account.bigcommerce.com/api/';
	
	public static HttpResponse JSONRequestSetup (string strEndPointMethod, string strAction, string strBody)
	{
		HttpResponse response;
		
		Http httpProtocol = new Http();
		
		// Create HTTP request to send.
		HttpRequest request = new HttpRequest();
	
		// Use actual username / password values for real		
		//****sandbox****
		//Blob headerValue = Blob.valueOf('username:password');
		//****production****
		Blob headerValue = Blob.valueOf('username:password'); // TO DO: CREATE CUSTOM SETTINGS FOR UN:PW
		string authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		request.setHeader('Authorization', authorizationHeader);
		request.setHeader('Content-Type', 'application/json');
		
		// Set the endpoint URL.		
		request.setEndPoint(strEndPoint + strEndPointMethod + '/');
		
		// Set the HTTP verb to POST.
		request.setMethod(strAction);
	
		// If a body exists
		if (strBody != null && strBody <> '')
		{
			request.setBody(strBody);
		}
		if(test.isRunningTest())
		{
			response = new HttpResponse();	
		}
		else
		{
			system.debug('*** SubscriptionREST:JSONRequestSetup - API Request Made with: ' + request.toString());
			response = httpProtocol.send(request);
		}
		
		return response;
	}
	/*
	public static void sendJSONPost()
	{
		// Create Account
		RESTMBAAccount a = new RESTMBAAccount();
		a.firstName = 'Bob';
		a.lastName = 'Bobby';
		a.address1 = '123 Main St.';
		a.city = 'Austin';
		a.state = 'TX';
		a.postcode = '78759';
		a.country = 'US';
		a.password = '123Test'; 
		a.companyName = 'Testing INC.';
		a.email = 'bbobby@mail.com.test';
		a.phone = '5551231234';
		
		String s = JSON.serialize(a);
				
		// Send the HTTP request and get the response.
		// The response is in JSON format.
		HttpResponse response = JSONRequestSetup('accounts', 'POST', s);
		System.debug(response.getBody());
	}
	
	public static void parseJSONResponse()
	{
		Http httpProtocol = new Http();
		
		// Create HTTP request to send.
		HttpRequest request = new HttpRequest();
		
		// Set the endpoint URL.
		String endpoint = 'http://secret-falls-2038.herokuapp.com/packages';		
		request.setEndPoint(endpoint);
		
		// Set the HTTP verb to GET.
		request.setMethod('GET');
		
		// Send the HTTP request and get the response.
		// The response is in JSON format.
		HttpResponse response = httpProtocol.send(request);
		System.debug(response.getBody());

		list<MBAPackage> lstPackages = new list<MBAPackage>();
		MBAPackage clsPackage;
		
		// Parser for multiple objects
		JSONParser parser = JSON.createParser(response.getBody());
		while (parser.nextToken() != null) 
		{
			// Start at the array of invoices.
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) 
			{
				while (parser.nextToken() != null) 
				{
					// Advance to the start object marker to
					// find next invoice statement object.
					if (parser.getCurrentToken() == JSONToken.START_OBJECT) 
					{
						// Read entire invoice object, including its array of line items.
						clsPackage = (MBAPackage)parser.readValueAs(MBAPackage.class);
						lstPackages.add(clsPackage);
						
						system.debug('Package ID: ' + clsPackage.id);
						system.debug('Package Name: ' + clsPackage.name);
						//system.debug('Size of list items: ' + inv.lineItems.size());
						// For debugging purposes, serialize again to verify what was parsed.
						//String s = JSON.serialize(clsPackage);
						//system.debug('Serialized Package: ' + s);
						// Skip the child start array and start object markers.
						parser.skipChildren();
					}
				}
			}
		}	
	}
	*/
	public class MBAStorePOST
	{
		public Integer packageId;
		public Integer accountId;
		public string storeName;
		public string subdomain;
		public integer timezoneOffset;
		public Integer partnerId;
	}
}