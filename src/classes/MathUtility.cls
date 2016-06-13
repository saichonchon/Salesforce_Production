/**
 * MathUtility
 * Author: Steve O'Neal
 * Date: 2016-05-25
 * Purpose: For commonly-used math-related methods
 * Ticket: BAP-3629
 *
 * Updates:
 * *********
 * 
 */

global class MathUtility {
    /**
     * Generates a random number between the floor and ceiling
     * @author Steve O'Neal
     * @date   2016-05-25
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3629
     * @param  floor         The lowest desired value
     * @param  ceiling       The highest desired value.  Must be greater than floor.
     * @return A random integer between the floor and ceiling.
     */
    global static integer RandomInteger(integer floor, integer ceiling)
    {
    	System.Debug('MathUtility.RandomInteger(floor=' + floor + ',ceiling=' + ceiling + ')');
    	
    	if (floor == null)
    	{
    		throw new ApplicationException('The floor parameter is required and cannot be null');
    	}

    	if (ceiling == null)
    	{
    		throw new ApplicationException('The ceiling parameter is required and cannot be null');
    	}

    	if (ceiling <= floor)
    	{
    		throw new ApplicationException('The ceiling parameter must be greater than the floor parameter');
    	}

    	integer retVal = 0;
    	
    	// seed the range with a random value
    	integer seededRange = Math.round((ceiling - floor) * Math.random());
    	System.Debug('seededRange=' + seededRange);
    	
    	// add the result to the floor value
    	retVal = floor + seededRange;
    	
    	// validate that we did not go over the ceiling or over the floor. This shouldn't happen, but it's good to be paranoid
    	if (retVal < floor)
    	{
    		retVal = floor;
    	}
    	else if (retVal > ceiling)
    	{
    		retVal = ceiling;
    	}
    	
    	System.Debug('retVal=' + retVal);
    	return retVal;
    }
    
    
    /**
     * Generates a random true or false
     * @author Steve O'Neal
     * @date   2016-05-25
     * @ticket link          https://jira.bigcommerce.com/browse/BAP-3629
     * @return A random true or false.
     */
    global static boolean RandomBoolean()
    {
    	System.Debug('MathUtility.RandomBoolean');
    	Boolean retVal = (MathUtility.RandomInteger(0,1) == 1);
    	System.Debug('retVal=' + retVal);
    	return retVal;
    }
}