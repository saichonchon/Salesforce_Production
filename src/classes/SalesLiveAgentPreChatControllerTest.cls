@isTest
private class SalesLiveAgentPreChatControllerTest {	
	
	public static SalesLiveAgentPreChatController slapcc { get; set; }

	static testMethod void myEmptyFields(){

		slapcc = new SalesLiveAgentPreChatController();

		slapcc.formFname.value = '';
		//slapcc.formLname.value = '';
		slapcc.formEmail.value = '';		

		Boolean testEmptyFields = slapcc.hasEmptyFields();

		System.assert(testEmptyFields);	
	}	

	static testMethod void myGoodDetails(){

		slapcc = new SalesLiveAgentPreChatController();

		slapcc.formFname.value = 'Sponge';
		//slapcc.formLname.value = 'Bob';
		slapcc.formEmail.value = 'sp@email.com';		

		Boolean testEmptyFields = slapcc.hasEmptyFields();

		System.assert(!testEmptyFields);			
	}

	static testMethod void myValueAndErrorTest() {
        slapcc = new SalesLiveAgentPreChatController();
        
        SupportLiveAgentPreChatController.ValueAndError testValueAndError= new SupportLiveAgentPreChatController.ValueAndError();
        testValueAndError.value =  'value';
        testValueAndError.error = 'error';
        System.assertEquals(testValueAndError.value,  'value');
        System.assertEquals(testValueAndError.error, 'error');
        System.assertEquals(testValueAndError.isEmpty(), false);
        System.assertEquals(testValueAndError.getHasError(), true);

        testValueAndError.error = null;
        System.assertEquals(testValueAndError.getHasError(), false);
    }
}