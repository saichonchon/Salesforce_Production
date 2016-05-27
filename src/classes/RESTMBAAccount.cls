public class RESTMBAAccount 
{
	public Integer id;
	public String firstName;
	public String lastName;
	public String companyName;
	public String email;
	public String address1;
	public String address2;
	public String city;
	public String state;
	public String postcode;
	public String country;
	public String phone;
	public String supportPin;
	public Stores stores;
	public String password;

	public class Stores
	{		
		public String resource;
	}

	
	public static RESTMBAAccount parse(String json) 
	{
		return (RESTMBAAccount) System.JSON.deserialize(json, RESTMBAAccount.class);
	}
	
	
	static testMethod void testParse() {
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
		'\"supportPin\": \"4567\",'+
		'\"stores\": {'+		
		'\"resource\": \"/accounts/3245/stores\"'+
		'}'+
		'}';
		RESTMBAAccount obj = parse(json);
		System.assert(obj != null);
	}
	
}