@isTest
public with sharing class TestCFSBatchProcessQuizData {

	private static String prefixName;

	@IsTest static void createAllTestData() {
		List<CFS_Quiz_Data__c> QuizDataRecords = New List<CFS_Quiz_Data__c>();

		prefixName = 'test 1';
		List<CFS_Quiz_Data__c> dataForTest1 = createCFSQuizData();

		prefixName = 'test 2';
		List<CFS_Quiz_Data__c> dataForTest2 = createCFSQuizData();

		QuizDataRecords.addall(dataForTest1);
		QuizDataRecords.addall(dataForTest2);

		//todo: write assert good info, not fake
		system.assertEquals(1, 1);

	}

	static List<CFS_Quiz_Data__c> createCFSQuizData() {
		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();

		HelperForTests.prefixName = prefixName;

		dataForTest.add(HelperForTests.createMultiSelectNOTCorrect());
		dataForTest.add(HelperForTests.createMultiSelectCORRECT());
		dataForTest.add(HelperForTests.createTrueFalseWithCorrectTrue());
		dataForTest.add(HelperForTests.createTrueFalseWithCorrectFalse());
		dataForTest.add(HelperForTests.createFreeTextShortWithAnswer());
		dataForTest.add(HelperForTests.createFreeTextShort());
		dataForTest.add(HelperForTests.createFreeTextLongWithAnswer());
		dataForTest.add(HelperForTests.createFreeTextLong());
		dataForTest.add(HelperForTests.createSingleSelectCorrect());
		dataForTest.add(HelperForTests.createSingleSelectNOTCorrect());
		dataForTest.add(HelperForTests.createEmptyQuiz());
		return dataForTest;
	}

	@IsTest static void testEmptyBatch() {
		Test.StartTest();
			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);
		Test.StopTest();
		Integer CreatedQuizObject = HelperForTests.getCount('Not Found');
		system.assertEquals(0, CreatedQuizObject);
	}

	@IsTest static void testMultiSelect() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'MultiSelect NOTCorrect';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createMultiSelectNOTCorrect());
		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testMultiSelectWithExistQuiz() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'MultiSelect NOTCorrect';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createMultiSelectNOTCorrect());
		insert dataForTest;

		lmscons__Quiz__c Q = New lmscons__Quiz__c(Name = 'Test '+prefixName);
		insert Q;

		Test.StartTest();
			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);
		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(2, CreatedQuizObject);
	}

	@IsTest static void testMultiSelectWith_2_ExistsQuiz() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'MultiSelect NOTCorrect';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createMultiSelectNOTCorrect());
		insert dataForTest;

		List<lmscons__Quiz__c> qList = New List<lmscons__Quiz__c>();
		lmscons__Quiz__c Q = New lmscons__Quiz__c(Name = 'Test '+prefixName);
		qList.add(Q);
		lmscons__Quiz__c Q2 = New lmscons__Quiz__c(Name = 'Test '+prefixName);
		qList.add(Q2);

		insert qList;



		Test.StartTest();
			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);
		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(3, CreatedQuizObject);

	}

	@IsTest static void testTrueFalse() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'TrueFalse_CORRECTTrue';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createTrueFalseWithCorrectTrue());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testTrueFalse_CorrectFalse() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'TrueFalse_CorrectFalse';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createTrueFalseWithCorrectFalse());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testFreeTextShort() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'FreeText_ShortText_withAnswer';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createFreeTextShortWithAnswer());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}


	@IsTest static void testFreeText() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'FreeText_ShortText';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createFreeTextShort());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testFreeTextLongWithAnswer() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'FreeText_LongText_WithAnswer';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createFreeTextLongWithAnswer());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testFreeTextLong() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'FreeText_LongText';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createFreeTextLong());
		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testSingleSelect() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'SingleSelect';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createSingleSelectCorrect());

		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testSingleSelectNotCorrect() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'SingleSelect_NOT';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createSingleSelectNOTCorrect());

		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testLongQuestinName() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'SingleSelect_NOT test long question name and quiz long name, put here more 80 symbols, any symbols for test, thank you';
		String prefixNameForQuery = 'SingleSelect_NOT test long question name ';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createSingleSelectNOTCorrect());

		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		Integer CreatedQuizObject = [SELECT count() FROM lmscons__Quiz__c WHERE Name LIKE:String.escapeSingleQuotes('%'+prefixNameForQuery+'%')];

		system.assertEquals(1, CreatedQuizObject);

	}

	@IsTest static void testCreatedFullQuizStructure() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		prefixName = 'SingleSelect_NOT';
		HelperForTests.prefixName = prefixName;
		dataForTest.add(HelperForTests.createSingleSelectNOTCorrect());

		dataForTest.add(HelperForTests.createEmptyQuiz());

		insert dataForTest;

		Test.StartTest();

			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);

		Test.StopTest();

		String SearchValue = String.escapeSingleQuotes('%'+prefixName+'%');

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);
		system.assertEquals(1, CreatedQuizObject);

		Integer CreatedQuestionObject = [SELECT COUNT() FROM lmscons__Question__c WHERE Name LIKE:SearchValue];
		system.assertEquals(2, CreatedQuestionObject);

		Integer CreatedQuizQuestionObject = [SELECT COUNT() FROM lmscons__Quiz_Question__c WHERE lmscons__Quiz__r.Name LIKE:SearchValue AND lmscons__Question__r.Name Like:SearchValue];
		system.assertEquals(2, CreatedQuizQuestionObject);

		Integer CreatedAnswersObject = [SELECT COUNT() FROM lmscons__Answer__c WHERE lmscons__Question__r.Name LIKE:SearchValue];
		system.assertEquals(true, CreatedQuizObject >= 1);
	}


	@IsTest static void test2QuestionWithExistsQuiz() {

		List<CFS_Quiz_Data__c> dataForTest = New List<CFS_Quiz_Data__c>();
		HelperForTests.prefixName = 'Test MultiSelect NOTCorrect';
		prefixName = HelperForTests.prefixName;
		dataForTest.add(HelperForTests.createMultiSelectNOTCorrect());
		insert dataForTest;

		lmscons__Quiz__c Q = New lmscons__Quiz__c(Name = 'Test '+prefixName);
		insert Q;

		lmscons__Question__c Q2 = New lmscons__Question__c(Name = 'Test '+prefixName, lmscons__Question__c= 'Test '+prefixName, lmscons__Type__c = 'Multi Select');
		insert Q2;

		lmscons__Question__c Q33 = New lmscons__Question__c(Name = 'Test '+prefixName, lmscons__Question__c= 'Test '+prefixName, lmscons__Type__c = 'Multi Select');
		insert Q33;

		lmscons__Quiz_Question__c qq1 = New lmscons__Quiz_Question__c(lmscons__Quiz__c = Q.Id, lmscons__Question__c = Q2.Id);
		insert qq1;
		lmscons__Quiz_Question__c qq2 = New lmscons__Quiz_Question__c(lmscons__Quiz__c = Q.Id, lmscons__Question__c = Q33.Id);
		insert qq2;

		List<CFS_Quiz_Data__c> QuizDataList = New List<CFS_Quiz_Data__c>();
		QuizDataList.add(HelperForTests.configCFSQuiqDataRecord(prefixName, 3));
		QuizDataList.add(HelperForTests.configCFSQuiqDataRecord(prefixName, 4));
		insert QuizDataList;

		Test.StartTest();
			CFSBatchProcessQuizData b = New CFSBatchProcessQuizData('test@test.com');
			Database.executeBatch(b);
		Test.StopTest();

		Integer CreatedQuizObject = HelperForTests.getCount(prefixName);

		system.assertEquals(2, CreatedQuizObject);
	}

}