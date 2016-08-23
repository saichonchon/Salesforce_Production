public class RESTAPIUtility {
	
	public static Map<String, String>  getJSONBody( Map<String, String> bmpsfIds)
	{	
		 Map<String, String> mapBmpIdBody = new Map<String, String>();

		for (String bmpId :bmpsfIds.KeySet())
		{
			string jsonBody = getJSON(bmpsfIds.get(bmpId));
			mapBmpIdBody.put(bmpId, jsonBody);
		}		
							
				
		return mapBmpIdBody;
	}

    public static string getJSON( String sfId )
    {
    	
    	// Create a JSON generator object
        JSONGenerator gen = JSON.createGenerator(true);
        // open the JSON generator
	  
	      gen.writeStartObject();
	      gen.writeFieldName('data');
	  	  gen.writeStartObject();
	      gen.writeStringField('salesforce_id', sfId);
	      gen.writeEndObject();
	      gen.writeEndObject();
        // close the JSON generator
      
	    // create a string from the JSON generator
	      String json2 = gen.getAsString();
	      system.debug(json2);
	      
	      return json2;
	
    }


}