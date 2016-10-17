/**
 * Utilities
 * Author: Bala Rajagopal
 * Purpose: Utility classes that can be used in other classes
 * Ticket: BAP-3907
 * 
 */
public class Utilities {
    
    public static Boolean checkEmail (String semail) {
        String InputString = semail;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);
        
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(InputString);
        
        if (!MyMatcher.matches()) {
        	return FALSE;
        }
        else {
        	return TRUE;
        }
    } //end email check
    
    public static Date formattedDate (String InputString) {
        //Use this method only in the string that needs to be formatted to
        //date type is in the format "Jan 1, 2016"
        Map<String,Integer> MonthNumberMap = new Map<String,Integer>{
            'Jan'=>1,
            'Feb'=>2,
            'Mar'=>3,
            'Apr'=>4,
            'May'=>5,
            'Jun'=>6,
            'Jul'=>7,
            'Aug'=>8,
            'Sep'=>9,
            'Oct'=>10,
            'Nov'=>11,
            'Dec'=>12
         };

        InputString = InputString.replace('<br>', '');
        InputString = InputString.replace(',','');

        Integer MonthInt = MonthNumberMap.get(InputString.split(' ')[ 0 ].trim().substring(0,3));
        Integer DayInt = Integer.valueOf(InputString.split(' ')[ 1 ].removeEnd(',').trim());
        Integer YearInt = Integer.valueOf(InputString.split(' ')[ 2 ].trim());
        date fdate = date.newInstance(YearInt, MonthInt, DayInt);
        
		return fdate;
    } //end date formatting
    
}