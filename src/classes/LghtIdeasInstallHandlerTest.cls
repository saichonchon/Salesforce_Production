@isTest
public class LghtIdeasInstallHandlerTest { 
	@isTest
	static void testOnInstall() {
		LghtIdeasInstallHandler installHandler = new LghtIdeasInstallHandler();
		Test.testInstall(installHandler, null);
		
		List<LghtIdeasSettings__c> settingsCommunity = [SELECT Value__c FROM LghtIdeasSettings__c WHERE Name = 'community'];
		
		if (settingsCommunity.size() == 1) {
			System.assertEquals(settingsCommunity[0].Value__c, 'undefined', 'Invalid value');
		}
		else {
			System.assertEquals(false, true, 'Settings value has not been created');
		}
	}
}