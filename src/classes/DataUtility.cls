public class DataUtility {

    public static Boolean IsWeekendDay(Date dateParam)
    {
       boolean result     = false;
       system.debug('dateParam = '+dateParam); 
       //Recover the day of the week
       Date startOfWeek   = dateParam.toStartOfWeek();
       system.debug('startOfWeek = '+startOfWeek);
       Integer dayOfWeek  = dateParam.day() - startOfWeek.day();
       system.debug('dayOfWeek = '+dayOfWeek);   
       result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
       system.debug('result = '+result); 
       return result;
    } 
    
    
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd )
    {
       //Add or decrease in BusinessDaysToAdd days 
       Date finalDate = StartDate;
       system.debug('finaldate = '+finalDate);
       integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
       system.debug('direction = '+direction);
        while(BusinessDaysToAdd != 0)
        {
            finalDate = finalDate.AddDays(direction);
            system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd);            
            system.debug('finaldate = '+finalDate);
            if (!isWeekendDay(finalDate))
            {
                BusinessDaysToAdd -= direction;
                
            }
        }

        return finalDate;
    }
    
    public static String truncateString(String origString, integer lengthToTrim )
    {
 		String finalString = '';
 		
 		if(origString == null || origString == '')
 		return origString;
 		
 		if(origString.length()>lengthToTrim)
              {
                finalString = origString.substring(0,lengthToTrim);
              }
 		else
 		{
 			finalString = origString;
 		}
 		return finalString;
    }
}