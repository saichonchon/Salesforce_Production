public class RESTMBAPackage
{
	//public class Pricing 
	//{
	//	public Monthly monthly;
	//	public Monthly annually;
	//}

	public Integer id;
	public String agencyId;
	public String agnecyName;
	public String name;
	public String planToken;
	public String shortName;
	public String paymentType;
	public String diskSpace;
	//public Integer bandwidth;
	public String numUsers;
	public String numProducts;
	public String numApiRequests;
	public String apiRequestInterval;
	public String featureFlags;
	//public Pricing pricing;

	//public class Monthly 
	//{
	//	public String monthly;
	//	public String setup;
	//}
	
	public static RESTMBAPackage parse(String json) 
	{
		return (RESTMBAPackage) System.JSON.deserialize(json, RESTMBAPackage.class);
	}
	
	public static List<RESTMBAPackage> parseList(String json) 
	{
		return (List<RESTMBAPackage>) System.JSON.deserialize(json, List<RESTMBAPackage>.class);
	}
}