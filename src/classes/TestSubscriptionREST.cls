@isTest
public class TestSubscriptionREST {
	static testMethod void testJSONRequestSetup() 
	{		
		SubscriptionREST.JSONRequestSetup('accounts', 'POST', 'test');
	}
	
	static testMethod void testRESTMBAPackageParse() 
	{		
		String json = '{'+
		'\"id\": \"33\",'+
		'\"planToken\": \"15 Day Trial\",'+
		'\"paymentType\": \"free\",'+
		'\"diskSpace\": \"100 MB\",'+
		'\"numUsers\": \"100\",'+
		'\"numProducts\": \"Unlimited\",'+
		'\"numApiRequests\": \"20000\",'+
		'\"apiRequestInterval\": \"60\",'+
		'\"featureFlags\": \"3\",'+
		'\"agencyId\": \"1\",'+
		'\"agencyName\": \"Big Commerce\",'+
		'\"name\": \"15 Day Free Trial\"'+
		'}';
		RESTMBAPackage obj = RESTMBAPackage.parse(json);
		System.assert(obj != null);
	}
	
	static testMethod void testRESTMBAPackageListParse() 
	{		
		String json = '[{'+
		'\"id\": \"33\",'+
		'\"planToken\": \"15 Day Trial\",'+
		'\"paymentType\": \"free\",'+
		'\"diskSpace\": \"100 MB\",'+
		'\"numUsers\": \"100\",'+
		'\"numProducts\": \"Unlimited\",'+
		'\"numApiRequests\": \"20000\",'+
		'\"apiRequestInterval\": \"60\",'+
		'\"featureFlags\": \"3\",'+
		'\"agencyId\": \"1\",'+
		'\"agencyName\": \"Big Commerce\",'+
		'\"name\": \"15 Day Free Trial\"'+
		'}]';
		list<RESTMBAPackage> obj = RESTMBAPackage.parseList(json);
		System.assert(obj != null);
	}
}