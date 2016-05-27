public class DisplayUtils {
	
	public static void addStatus( String msg )
    {    	
        if ( msg != null )
        {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,msg));
        }       
    }
    
    public static void addError(String msg) 
    {    	
        if ( msg != null )
        {
            msg = getFormattedErrorMessage(msg);            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,msg));      
        }        
    }
    
    public static String getFormattedErrorMessage( String incomingMsg )
    {
    	System.debug('get nicely formatted error message for: ' + incomingMsg);
    	String msg = incomingMsg;    	    	
    	if ( msg != null && msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) 
    	{
        	 String errorMessage = msg;
        	 Integer cutPoint = msg.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') + 34;
        	 errorMessage = msg.substring(cutPoint);
        	 errorMessage = String.escapeSingleQuotes(errorMessage);
        	 errorMessage = errorMessage.replace('&quot;','\'');
        	 errorMessage = errorMessage.replace('&lt;','<');
        	 cutPoint = errorMessage.indexOf(':');
        	 System.debug('error message length, cutpoint: ' + errorMessage.length() + ', ' + cutPoint );
        	 if ( errorMessage.length() > cutPoint )
        	 {
	        	 msg = errorMessage.subString(0,cutPoint); 
	        	 msg = '<br /> [Validation Error]: ' + '<b>' + msg + '</b>';
        	 }
        } 
        System.debug('returning nicely formatted error message: ' + msg );
    	return msg; 
    }
    
    public static Boolean isEquals( String s1, String s2 )
    {
    	System.debug('starting isEquals. s1, s2: ' + s1 + ', ' + s2);
        Boolean isEquals = false;
        if ( isBlank( s1 ) && isBlank( s2 ))
        {
                isEquals = true;
        }
        else if ( s1 == s2 )
        {
                isEquals = true;
        }            
        System.debug('isEquals: ' + isEquals );   
        return isEquals;
    }
    
    public static Boolean isBlank( String s )
    {
    	System.debug('starting isBlank. s: ' + s);
        Boolean isBlank = false;
        if ( s == null || s.trim().length() < 1 )
        {
                isBlank = true;
        }
        System.debug('isBlank: ' + isBlank);
        return isBlank;
    }
    
    public static Boolean isNotBlank( String s )
    {    	
    	return ( isBlank( s ) ? false : true );    	
    }

    public static Set<String> parseIncomingStringIntoSet( String incomingString, String separator )
    {
        Set<String> stringSet = new Set<String>();
        List<String> stringList = new List<String>();
        
        if ( incomingString != null ) 
        {
            stringList = incomingString.split( separator );
            System.debug('stringList: ' + stringList);
            for ( String s : stringList )
            {
                System.debug('adding string to Set: ' + s);
                stringSet.add( s.trim() );
            }
        }       
            
        return stringSet;
    }
    
    public static String getFormattedIdList( Set<Id> incomingIds )
    {   
    	String formattedStr = null;  
        if ( incomingIds != null )
        {        
	        formattedStr = '';
	        String sep = '';
	        for ( Id id : incomingIds )
	        {
	            formattedStr = formattedStr + sep + '\'' + id + '\'';
	            sep = ', ';
	        }
        }
        return formattedStr;
    } 
    
    public static String getSafeTrim( String s )
    {
    	String rtn = '';
    	if ( s != null )
    	{
    		rtn = s.trim();	
    	}
    	return rtn;
    }
    
	static testMethod void testStrings() {
    	/* Test addStatus() */
    	String s = 'foo';
    	addStatus( s );
    	System.AssertEquals( ApexPages.hasMessages(), true );    	
    	
    	/* Test pretty formatted exception */
    	s = 'First exception on row 0 with id 001T000000umL2aIAE; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Oops - this is not a real exception, just a test of exception catching -- DISREGARD FROM LOGS: execution of AfterInsert caused by: System.SObjectException: SObject row was retrieved via SOQL without querying the requested field: Some_Bogus_Object__c.Some_Bogus_Field__c External entry point Trigger.Fake_Test_Trigger: line 4, column 1';
    	//s = 'This message contains a jjjjjjjjjj FIELD_CUSTOM_VALIDATION_EXCEPTION: foo';
    	String formatted = getFormattedErrorMessage(s);
    	System.AssertEquals( formatted.contains('[Validation Error]'), true);
    	/* Test the blank checkers */    	
    	String msg = '';
    	System.assertEquals( isBlank( msg ), true );
    	System.assertEquals( isNotBlank( msg ), false );
    	
    	msg = 'foo';
    	System.assertEquals( isNotBlank( msg ), true );
    	System.assertEquals( isBlank( msg ), false );
    	
    	/* Test isEquals() */
    	String s1 = '';
    	String s2 = '';
    	System.assertEquals( isEquals( s1, s2 ), true);
    	s1 = 'foo';
    	s2 = 'foo';
    	System.assertEquals( isEquals( s1, s2 ), true);
    	s1 = 'boo';
    	s2 = 'hoo';
    	System.assertEquals( isEquals( s1, s2 ), false);

        /* Test parseStringIntoSet() */
        String incomingString = '1, 2, 3';
        String separator = ', ';
        Set<String> stringSet = parseIncomingStringIntoSet(incomingString, separator);
        System.assertEquals( 3, stringSet.size() );
        
        /* Test formattedIdList */
        Id firstId = UserInfo.getUserId();
        Id secondId = UserInfo.getProfileId();
        Set<Id> idSet = new Set<Id>();
        idSet.add( firstId );
        idSet.add( secondId );
        String formattedStr = getFormattedIdList( idSet );
        System.debug('formattedStr = ' + formattedStr );
        System.assertEquals( 2, parseIncomingStringIntoSet(formattedStr, ',').size() );
	}

	
	static testMethod void testError() 
	{
		String err = 'foo';
	    addError( err );
	    System.AssertEquals( ApexPages.hasMessages(), true );    
	}
}