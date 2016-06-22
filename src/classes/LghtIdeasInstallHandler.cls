global class LghtIdeasInstallHandler implements InstallHandler { 
	global void onInstall(InstallContext context) {
		if(context.previousVersion() == null) {
			//first install
		}

		this.checkConfigurationValues();
	}


	private void checkConfigurationValues() {
		List<LghtIdeasSettings__c> settingsCommunity = [SELECT Id FROM LghtIdeasSettings__c WHERE Name = 'community'];
		
		if (settingsCommunity.size() == 0) {
			LghtIdeasSettings__c communitySettings = new LghtIdeasSettings__c(Name='community', Label__c='Idea Zone Name', Value__c='undefined');
			insert communitySettings;
		}
	}
}