public class RESTMBAStore
{
	public Integer id;
	public Integer accountId;
	public MBAAccount account;
	public Integer packageId;
	public MBAPkg package1;
	public Integer partnerId;
	public Integer serverId;
	public String storeName;
	public String domain;
	public String status;
	public String paymentAmount;
	public String billingCycle;
	public String registrationDate;
	public String provisionDate;
	public String convertedDate;
	public String cancellationDate;
	public String sbdDomainName;
	public String sbdStoreId;	
	

	public class MBAAccount
	{		
		public String resource;
	}
	
	public class MBAPkg
	{		
		public String resource;
	}

	
	public static RESTMBAStore parse(String json) 
	{
		try{
			return (RESTMBAStore) System.JSON.deserialize(json.Replace('"package":', '"package1":').Replace('[\"text/html\", \"image/gif\", \"image/jpeg\", \"*\", \"*/*\"]', 'json'), RESTMBAStore.class);
		}
		catch(Exception e){
			return new RESTMBAStore();
		}
	}
	
	static testMethod void testParse() {
		String json = '{'+
		'\"id\": 986745134,'+
		'\"accountId\": 1345,'+
		'\"account\": {'+
		'\"resource\": \"/accounts/1345\"'+
		'},'+
		'\"packageId\": 33,'+
		'\"package\": {'+
		'\"resource\": \"/packages/33\"'+
		'},'+
		'\"partnerId\": 14224,'+
		'\"serverId\": 0,'+
		'\"domain\": \"lemurslemurslemurs.mybigcommerce.com\",'+
		'\"status\": \"Pending\",'+
		'\"paymentAmount\": \"0.00\",'+
		'\"billingCycle\": \"free\",'+
		'\"registrationDate\": \"2013-05-23\",'+
		'\"provisionedDate\": \"\",'+
		'\"convertedDate\": \"\",'+
		'\"cancellationDate\": \"\",'+
		'\"sbdDomainName\": \"\",'+
		'\"sbdStoreId\": \"\",'+
		'\"storeName\": \"Lemurs Lemurs Lemurs!\"'+
		'}';
		
		/*
		String json = '{'+
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
		*/
		RESTMBAStore obj = parse(json);
		System.assert(obj != null);
	}
	
}