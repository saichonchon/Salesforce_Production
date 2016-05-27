public class AreaCodeUtility {
	
	//Map to store Area - Location Mapping
    public static Map<string, string> areaStateMap = new Map<string, string>();
        
    //Map to store Area - Time Zone Mapping
    public static Map<string, string> areaTimeZoneMap = new Map<string, string>();
        
    public static void getAreaCodes()
    {
        //Load Codes from Custom Setting
        for (Area_Codes__c areaCode : Area_Codes__c.getAll().values())
        {
            areaStateMap.put(areaCode.Area_code__c, areaCode.Location__c);
            areaTimeZoneMap.put(areaCode.Area_code__c, areaCode.Timezone__c);
        }
	}    

 	public void UpdateContacts(List<Contact> consList) {
 		
 		
 		for(Contact conObject : consList)
        {
            
            // Check that Phone Number is not null
            if(conObject.Phone != null && conObject.Phone != '' && conObject.US_Time_Zone__c == null)
            {    
                String phoneNumber = conObject.Phone;
                List<String> Area = getTZState(phoneNumber);
                if (Area[0] <> null) conObject.MailingState=Area[0];
                if (Area[1] <> null) conObject.US_Time_Zone__c=Area[1];
            }
        }
 		
 	}
	private  List<String> getTZState(string phonenumber)
    {
 
 		List<String> Area = new List<String>();
 		String State;
 		String Time_Zone;
        
        //Buffer string to carry area code      
        string phoneAreaCode = '';

        if (areaStateMap.isEmpty() || areaTimeZoneMap.isEmpty() ) getAreaCodes();
        
        system.debug(' ***test '+areaStateMap.size());
  
    	 //Remove Leading +1 or 001
            if(phoneNumber.StartsWith('+1'))
            {
                phoneNumber = phoneNumber.subString(2);
                system.debug('User1 After removing +1'+phoneNumber);
            }
            else 
            {	if(phoneNumber.StartsWith('001'))
                {
                    phoneNumber = phoneNumber.subString(3); 
                    system.debug('User1 After removing 001'+phoneNumber);
                }
            }
                
            //Remove these chars: - or ( or ) from the number and any spaces
            phoneNumber = phoneNumber.replace('-', '').replace('(', '').replace(')', '').replace(' ', '');

            //Check if Phone Number length after removing all characters and preceding country code is 10
            if(phoneNumber.length() == 10)
            {
                //Get Area code
                phoneAreaCode = phoneNumber.Substring(0, 3);
                
                //Check if area code exists in the maps, then set Contact state and time zone with the correct value
                if(areaStateMap.get(phoneAreaCode) != null && areaTimeZoneMap.get(phoneAreaCode) != null)
                {
                    State = areaStateMap.get(phoneAreaCode);
                   
                    Time_Zone = areaTimeZoneMap.get(phoneAreaCode);
                    
                }
                    
                 
            }
          
          Area.add(State);
          Area.add(Time_Zone);
          return Area;  
            
    }

}