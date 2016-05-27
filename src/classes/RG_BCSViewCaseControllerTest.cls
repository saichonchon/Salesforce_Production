@istest
public class RG_BCSViewCaseControllerTest {

	public static  testmethod  void testmethod1(){
		Account acc = new account(name='abc');
		insert acc;
		
		Contact con = new Contact(accountid=acc.id,lastname='lastname');
		insert con;
		
		system.assertequals(1,[select count() from Contact where accountid=:acc.id]);
		
		Case caserecord = new case(accountid=acc.id,contactid=con.id,subject='test subject');
		insert caserecord;                     
		
		casecomment casecomment = new casecomment(commentbody='sample body', parentid=caserecord.id);
		insert casecomment;
		                                
		Apexpages.standardController controller = new apexPages.standardController(caserecord);
		RG_BCSViewcaseDetailsController ctrl = new RG_BCSViewcaseDetailsController(controller);
		ctrl.CaseFileContent = Blob.valueof('TEest Data');
        ctrl.CasefileName = 'test';
        ctrl.AttachFileToCase(); 
        system.assertEquals(ctrl.isAttacted, true);
        casecomment cc2 = new casecomment();
        
        ctrl.submitcomment();
        ctrl.casecomment =cc2;
        ctrl.submitcomment();
        ctrl.CaseFileContent=null;
        ctrl.AttachFileToCase(); 
        
	}
	
	public static  testmethod  void testmethod2(){
		
		Account acc = new account(name='abc');
		insert acc;
		
		Contact con = new Contact(accountid=acc.id,lastname='lastname');
		insert con;
		
		system.assertequals(1,[select count() from Contact where accountid=:acc.id]);
		
		Case caserecord = new case(accountid=acc.id,contactid=con.id,subject='test subject');
		insert caserecord;   
		
		Case caserecord2 = new case(accountid=acc.id,contactid=con.id,subject='test subject',status='closed');
		insert caserecord2;          
		
		                         
		BCSCasesController bcc = new BCSCasesController();
		bcc.redirect();
		bcc.getMyOpenCases();
		bcc.getMyClosedCases();
		
	}
}