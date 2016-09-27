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