@istest(SeeAllData=true)
private class TestProductTriggers {

	private static testmethod void testPrdtrig() {
        // Create zproduct
       zqu__ZProduct__c zprd = new zqu__ZProduct__c (Name = 'Test Store', 
       												BCCategory__c = 'STORE',
       												zqu__SKU__c = 'STORE-FREE',
       												zqu__Description__c = 'Test',
       												zqu__Deleted__c = false,
       												zqu__ZuoraId__c = '2c92c0f84b30617f01',
                                                    zqu__Category__c = 'Base Products');
       insert zprd;  
       zprd.zqu__Description__c = 'Test Update';
       update zprd; 
	}  
}