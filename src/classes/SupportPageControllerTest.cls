@isTest(seeAllData = true)
private class SupportPageControllerTest {

	static testMethod void testUnivpage() {
		
		SupportPageController sp = new SupportPageController();
		sp.setdcsname('Build_Your_Store');
		List <University__kav> ua = sp.univArtListByName;  
	}

}