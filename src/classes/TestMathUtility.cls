/**
 * TestMathUtility
 * Author: Steve O'Neal
 * Purpose: For testing MathUtlity
 * Ticket: BAP-3629
 *
 * Updates:
 * *********
 * 
 */

@isTest
private class TestMathUtility {
	/**
	 * Test the randomInteger function
	 * @author Steve O'Neal
	 * @date   2016-05-25
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3629
	 * @return nothing
	 */
	static testMethod void testRandomInteger()
	{
		// positive test
		integer floor = 0;
		integer ceiling = 100;

		integer result = MathUtility.RandomInteger(floor, ceiling);

		System.assert(result >= floor);
		System.assert(result <= ceiling);

		// negative test - null floor
		try
		{
			integer resultFail = MathUtility.RandomInteger(null, ceiling);
			// if we hit this code, we have failed
			System.assert(false);
		}
		catch (Exception e)
		{
			// do nothing, this is considered a success
		}

		// negative test - null ceiling
		try
		{
			integer resultFail = MathUtility.RandomInteger(floor, null);
			// if we hit this code, we have failed
			System.assert(false);
		}
		catch (Exception e)
		{
			// do nothing, this is considered a success
		}

		// negative test - ceiling > floor
		try
		{
			integer resultFail = MathUtility.RandomInteger(ceiling, floor);
			// if we hit this code, we have failed
			System.assert(false);
		}
		catch (Exception e)
		{
			// do nothing, this is considered a success
		}

	}


	/**
	 * Test the randomBoolean function
	 * @author Steve O'Neal
	 * @date   2016-05-25
	 * @ticket link          https://jira.bigcommerce.com/browse/BAP-3629
	 * @return nothing
	 */
	static testMethod void testRandonBoolean()
	{
		// positive test
		boolean result = MathUtility.RandomBoolean();

		System.assertNotEquals(result, null);
	}
}