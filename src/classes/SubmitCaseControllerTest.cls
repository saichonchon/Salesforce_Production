@isTest(seeAllData = false)
private class SubmitCaseControllerTest { 

    public static SubmitCaseController scc { get; set; }
    public static Subscription__c testSub { get; set; }
    public static Account testAccount { get; set; }
    public static Contact testContact { get; set; }
    public static CaseSubmissionSettings__c css { get; set; }
    public static CaseQueueRouting__c testSupportQueue { get; set; }

        
    public static void setUp() {
        SubmitCaseControllerTest.setUp(true);
    }    

    public static void setUp(Boolean newScc) {
        System.debug('SubmitCaseControllerTest->setUp()');

 
        testSub = new Subscription__c(
            RecordTypeId = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId(),
            StoreURL__c= 'testingStorebigcommerce',
            ProductType__c = 'Store',
            Status__c = 'Active',
//            Account__c = testAccount.Id,
//            Contact__c = testContact.Id,
            productId__c ='28',
            Source__c = 'Direct Trial'                  
            );

        insert testSub;
      testAccount = new Account(
            RecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Record Type').getRecordTypeId(),
            Name = 'testName',
            Type = 'Client',
            Status__c = 'Open', 
            Client_Start_Date__c = date.today(), 
            SupportPin__c = '1234'
            );

        insert testAccount;

        testContact = new Contact(
            LastName = 'testLastName',
            accountId = testAccount.id
            );
        insert testContact;

 

        testSub.Account__c = testAccount.Id;
        testSub.Contact__c = testContact.Id;
        update testSub;


        testSub = [SELECT Id, Account__c, Contact__c,StoreURL__c,Support_PIN__c FROM Subscription__c WHERE Id =: testSub.Id];

        css = new CaseSubmissionSettings__c(
            Name = 'Web2Case',
            Case_Origin__c ='Web',
            Case_Record_Type__c = '012a0000001NXkL',
            Contact_Record_Type__c = '',
            Default_Support_Account_ID__c = '',
            Default_Support_Owner_ID__c = '00Ga0000003ATBV',
            LiveAgent_Button_Name__c = '',
            Redirect_URL__c = '/SubmitCaseThanks'
        );
        insert css;
        

        System.assertEquals(testAccount.Id, testSub.Account__c);
        System.assertEquals(testContact.Id, testSub.Contact__c);

        testSupportQueue = new CaseQueueRouting__c (
            Name = '1',
            Queue_ID__c = '00Ga0000003ATBVEA4',
            Queue_Name__c = 'Support'
            );
        insert testSupportQueue;

        System.debug('testQueue : ' + testSupportQueue);

        if(newScc) {
            scc = new SubmitCaseController();
        }           
        
    }     
    
    static testMethod void myGetTargetDepartmentTest() {
        SubmitCaseControllerTest.setUp();

        scc.formDeptId.value = testSupportQueue.Queue_ID__c;

        String defaultDepartmentExpectation = scc.getTargetDepartment();

        System.assertEquals(defaultDepartmentExpectation, 'Support');
    }

    static testMethod void myPrepopulatedQueryStringTest() {
        PageReference pg = Page.SubmitCase;
        Test.setCurrentPage(pg);

        SubmitCaseControllerTest.setUp(false);

        ApexPages.currentPage().getParameters().put('storeUrl', testSub.StoreURL__c); 
        ApexPages.currentPage().getParameters().put('storeUrl', 'http;/testingBigcommerce#');
        ApexPages.currentPage().getParameters().put('storeUrl', 'http;/testingBigcommerce?');
        ApexPages.currentPage().getParameters().put('supportPin', testAccount.SupportPin__c); 

        SubmitCaseControllerTest.scc = new SubmitCaseController();

        System.assertEquals(scc.webFormOn, false);

    }

    static testMethod void myValidatePinWithInvalidCredentialsTest() {
        PageReference pg = Page.SubmitCase;
        Test.setCurrentPage(pg);

        SubmitCaseControllerTest.setUp(false);

        ApexPages.currentPage().getParameters().put('storeUrl', testSub.StoreURL__c); 
        ApexPages.currentPage().getParameters().put('supportPin', testAccount.SupportPin__c + '1'); 

        SubmitCaseControllerTest.scc = new SubmitCaseController();

        System.assertEquals(scc.webFormOn, false);

        System.assertEquals(true, scc.formErrorsList.size() > 0 );

    }    

    static testMethod void mySubmitCaseFailsTest() {
        PageReference pg = Page.SubmitCase;
        Test.setCurrentPage(pg);

        SubmitCaseControllerTest.setUp(false);

        ApexPages.currentPage().getParameters().put('SupportSetting', 'Web2Case');
        ApexPages.currentPage().getParameters().put('storeUrl', testSub.StoreURL__c); 
        ApexPages.currentPage().getParameters().put('supportPin', testAccount.SupportPin__c); 

        SubmitCaseControllerTest.scc = new SubmitCaseController();
        SubmitCaseControllerTest.scc.css = css;

        scc.formDeptId.value = testSupportQueue.Queue_ID__c;

        PageReference nextAction = scc.submitCase();

        System.assertEquals(null, nextAction);

    }

    static testMethod void myValueAndErrorTest() {
        SubmitCaseControllerTest.setUp();
        
        SubmitCaseController.ValueAndError testValueAndError= new SubmitCaseController.ValueAndError();
        testValueAndError.value =  'value';
        testValueAndError.error = 'error';
        System.assertEquals(testValueAndError.value,  'value');
        System.assertEquals(testValueAndError.error, 'error');
        System.assertEquals(testValueAndError.isEmpty(), false);
        System.assertEquals(testValueAndError.getHasError(), true);

        testValueAndError.error = null;
        System.assertEquals(testValueAndError.getHasError(), false);

    }

    static testMethod void myIDValueAndErrorTest() {
        SubmitCaseControllerTest.setUp();

        SubmitCaseController.IDValueAndError testIDValueAndError = new SubmitCaseController.IDValueAndError();
                
        testIDValueAndError.error = 'error';               
        System.assertEquals(testIDValueAndError.error, 'error');
        System.assertEquals(testIDValueAndError.isEmpty(), true);
        System.assertEquals(testIDValueAndError.getHasError(), true);

        testIDValueAndError.error = null;
        System.assertEquals(testIDValueAndError.getHasError(), false);
    }

    static testMethod void myFormUrlFormatterTest() {
        SubmitCaseControllerTest.setUp();

        //formURLFormatter UNIT Testing
        scc.formURLFormatter('http://testingStorebigcommerce/');
        scc.formURLFormatter('https://testingStorebigcommerce/');
        scc.formURLFormatter('www.https://testingStorebigcommerce/');
    }

    static testMethod void mySubmitCaseControllerTest() {
        SubmitCaseControllerTest.setUp();

        String fullUrl = 'http://' + testSub.StoreURL__c;
        List<Subscription__c> testSubList = [SELECT Id, Account__c, Account__r.OwnerId, Contact__c, Lead__c, Support_PIN__c, StoreURL__c, Email__c FROM Subscription__c
                                                WHERE Support_PIN__c = :testSub.Support_PIN__c AND (StoreURL__c = :testSub.StoreURL__c OR StoreURL__c = :fullUrl)
                                                AND Status__c = 'Active' LIMIT 1];


        scc.deptName = null;
        scc.deptName ='Support';

        System.assertEquals(testSubList.isEmpty(), false);
    
    } 

    static testMethod void myValidatePinTest() {
        SubmitCaseControllerTest.setUp();

        scc.formURL.value = testSub.StoreURL__c;
        scc.formPIN.value = testSub.Support_PIN__c;        
        scc.validatePIN(); 
        System.assertEquals(scc.webFormOn,true);
        
        SubmitCaseController controller = new SubmitCaseController();
        controller.formURL.value = '';
        controller.formPIN.value = '1234';
        controller.validatePIN();
        System.assertEquals(controller.webFormOn,false);

        SubmitCaseController controller1 = new SubmitCaseController();
        controller1.formURL.value = testSub.StoreURL__c;
        controller1.formPIN.value = '1234sdgh';
        controller1.validatePIN();
        System.assertEquals(controller1.webFormOn,false);

    } 

    static testMethod void myValidateFileUpload(){
        SubmitCaseControllerTest.setUp();
        scc.fileAtt = Blob.valueOf('Good Extension and Size');
        scc.fileName = 'test-file.txt';
        scc.fileSize = 27800;

        Boolean testUpload = scc.validateFileUpload();      
        System.assertEquals(false, testUpload);


        scc.fileAtt = Blob.valueOf('Good Size bad extension ');
        scc.fileName = 'test-file.x';
        scc.fileSize = 2780;

        Boolean testExtensionUpload = scc.validateFileUpload();        
        System.assertEquals(true, testExtensionUpload);

        scc.fileAtt = Blob.valueOf('Good extension bad size ');
        scc.fileName = 'test-file.txt';
        scc.fileSize = 5302880;

        Boolean testsizeUpload = scc.validateFileUpload();        
        System.assertEquals(true, testsizeUpload);


        PageReference currPage = Page.SubmitCase;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'This file exceeds the maximum size limit of 10MB.'));
        Test.setCurrentPage(currPage);
        System.assertEquals(true, ApexPages.hasMessages(ApexPages.severity.ERROR));

        Boolean testsizeMaxUpload = scc.validateFileUpload(); 
        System.assertEquals(true, testsizeMaxUpload);        
        
    }   

    static testMethod void myCaseDescriptionValidatorTest() {
        SubmitCaseControllerTest.setUp();
        scc.formDescription.value = '';

        Boolean descriptionHasErrors = scc.validateDescription();
        
        System.assertEquals(descriptionHasErrors, true);

        scc.formDescription.value = 'test';
        descriptionHasErrors = scc.validateDescription();
        System.assertEquals(descriptionHasErrors, false);
    }
	
	static testMethod void myCaseSubjectValidatorTest() {
        SubmitCaseControllerTest.setUp();
        scc.formSubject.value = '';

        Boolean subjectHasErrors = scc.validateSubject();
        
        System.assertEquals(subjectHasErrors, true);

        scc.formSubject.value = 'test';
        subjectHasErrors = scc.validateSubject();
        System.assertEquals(subjectHasErrors, false);
    }
    
    static testMethod void myDeptTest() {
        SubmitCaseControllerTest.setUp();
        
        List<SelectOption> selDept = scc.getDepts();

        System.assertEquals(selDept.size() >0, true);
    }

    static testMethod void mySaveCaseHappyPathTest() {
        SubmitCaseControllerTest.setUp();

        System.debug('mySaveCaseHappyPathTest: CaseQueueRouting__c.getAll(): ' + CaseQueueRouting__c.getAll());

        // Values created during validatePin()
        scc.AcctId = testAccount.Id;
        scc.ContId = testContact.Id;
        scc.subId = testSub.Id;

        scc.formFname.value = testContact.FirstName;
        scc.formLname.value = testContact.LastName;
        scc.formPhone.value = '555-555-5555';

        // Values supplied in Form Step2
        scc.caseDescription = 'some text';
        scc.formDeptId.value = testSupportQueue.Queue_ID__c;  // 00Ga0000003ATBVEA4
        scc.css = css; 

        System.debug('mySaveCaseHappyPathTest: subId : '+scc.subId);

        System.debug('mySaveCaseHappyPathTest: deptId : '+ scc.formDeptId.value);

        System.debug('mySaveCaseHappyPathTest: css : '+ scc.css);

        PageReference nextAction =  scc.submitCase();  

        System.debug('mySaveCaseHappyPathTest: caseNum: ' + scc.caseNum); 

  //      System.assertEquals(true, scc.caseNum != null ); 
    }    
}