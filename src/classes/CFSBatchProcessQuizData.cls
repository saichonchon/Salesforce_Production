global class CFSBatchProcessQuizData implements Database.Stateful, Database.Batchable<sObject>{

	global Boolean isFullLog = true;

	private String Log;
	private Integer BathcNumber;
	private lmscons__Quiz__c lastQuiz;
	private String email;
	private Set<String> checkDublicate;
	private Map <String, Integer> QuizName_TotalCreatedForQuiz;
	private Integer countAnswersCreated;
	private Map<Id, lmscons__Quiz__c> QuizDataId_Quiz = New Map<Id, lmscons__Quiz__c>();
	private void writeToLog(String s) {
		this.Log += s+'\n';
	}


	global CFSBatchProcessQuizData(String e) {
		Log = 'Start: \n';
		BathcNumber = 0;
		email = e;
		countAnswersCreated = 0;
		checkDublicate = New Set<String>();
		QuizName_TotalCreatedForQuiz = New Map <String, Integer>();
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator('SELECT Status__c, External_Id__c, Quiz_Name__c, Description__c, Duration__c, Max_Attempts__c, Passing_Score__c, Show_score__c, Question__c, Type__c, Correct_Answers__c, Incorrect_Answers__c FROM CFS_Quiz_Data__c WHERE Status__c = NULL ORDER BY External_Id__c');
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<CFS_Quiz_Data__c> QuizDataList = (List<CFS_Quiz_Data__c>) scope;

		Map<String, lmscons__Quiz__c> NameQuiz_QuizObject = New Map<String, lmscons__Quiz__c>();
		Map<String, lmscons__Question__c> NameQuestion_QuestionObject = New Map<String, lmscons__Question__c>();

		BathcNumber = BathcNumber + 1;
		writeToLog('Start Batch #: '+BathcNumber);

		try {
			//create Quizzes
			QuizHelper createQuizzess = New QuizHelper();
			createQuizzess.setLastQuiz(lastQuiz);
			createQuizzess.setQuizDataList(QuizDataList);
			NameQuiz_QuizObject = createQuizzess.getMap_NameQuiz_QuizObject();
			this.lastQuiz = createQuizzess.getLastQuiz();

			QuizDataList.clear(); //clear the data list of duplicates by Quiz Name
			QuizDataList.addall(createQuizzess.getQuizDataList());
			QuizDataId_Quiz.putall(createQuizzess.QuizDataId_Quiz);

			writeToLog(createQuizzess.getLog());

			//create questions
			QuestionHelper createQuestions = New QuestionHelper();
			createQuestions.setQuizDataList(QuizDataList);
			NameQuestion_QuestionObject = createQuestions.getMap_QuizQuestionTypeTextType_QuestionObject();

			writeToLog(createQuestions.getLog());

			createQuizQuestionObject(NameQuiz_QuizObject, NameQuestion_QuestionObject);

			QuizDataList.clear(); //clear the data list of duplicates by Quiz Name
			QuizDataList.addall(createQuestions.getMap_QuestionId_QuizDataRecord().values());

			//create answers
			AnswerHelper createAnswers = New AnswerHelper();
			createAnswers.setMap_QuestionId_QuizDataRecord(createQuestions.getMap_QuestionId_QuizDataRecord());
			createAnswers.createAnswers();
			countAnswersCreated = countAnswersCreated + createAnswers.getCountAnswersCreated();
			writeToLog(createAnswers.getLog());

			updateCFSQuizDataStatus(QuizDataList, scope);

		} catch (Exception e) {
			generateExceptionLog(e);
		}
	}

	private void updateCFSQuizDataStatus(List<CFS_Quiz_Data__c> QuizDataList, List<sObject> scope) {
		Map<Id, CFS_Quiz_Data__c> QuizDataMap = New Map<Id, CFS_Quiz_Data__c>((List<CFS_Quiz_Data__c>)scope);
		for (CFS_Quiz_Data__c QuizData : QuizDataList) {
			QuizData.Status__c = 'Complete';
			if (QuizDataMap.containsKey(QuizData.Id)) {
				QuizDataMap.get(QuizData.Id).Status__c = 'Complete';
			}
		}
		update QuizDataMap.values();
	}

	private String getLogCountQuizAndQuestion() {
		String TotalLog = '';
		if (QuizName_TotalCreatedForQuiz != NULL && QuizName_TotalCreatedForQuiz.size() > 0) {
			TotalLog += 'Total Quizzess created: '+QuizName_TotalCreatedForQuiz.size()+'\n';
			Integer countquestionsCreated = 0;
			for (String QuizName : QuizName_TotalCreatedForQuiz.keySet()) {
				TotalLog += 'Total Questions for Quiz Name: '+QuizName + ' - created: '+QuizName_TotalCreatedForQuiz.get(QuizName)+'\n';
				countQuestionsCreated = countQuestionsCreated + QuizName_TotalCreatedForQuiz.get(QuizName);
			}
			TotalLog += 'Total Questions created: '+countQuestionsCreated + '\n';
			TotalLog += 'Total Answers created: '+countAnswersCreated + '\n';
		}
		return TotalLog;
	}

	private void createQuizQuestionObject(Map<String, lmscons__Quiz__c> NameQuiz_QuizObject, Map<String, lmscons__Question__c> NameQuestion_QuestionObject) {
		List<lmscons__Quiz_Question__c> QuizQuestionList = New List<lmscons__Quiz_Question__c>();

		Set<String> ExistsQuizQuestionRecords = New Set<String>();
		ExistsQuizQuestionRecords.addall(getExistsQuizQuestionRecords(NameQuiz_QuizObject, NameQuestion_QuestionObject));

		system.debug('##ExistsQuizQuestionRecords: '+ExistsQuizQuestionRecords);


		for (String RecordName : NameQuestion_QuestionObject.keySet()) {
			List<String> SplitRecordName = RecordName.split('#:#', 4);
			String QuizName = QuizDataId_Quiz.get(RecordName).Name;
			Id QuizId = QuizDataId_Quiz.get(RecordName).Id;

			system.debug('##146: '+QuizId);

			Id QuestionId = NameQuestion_QuestionObject.get(RecordName).Id;

			String checkedValue = ''+QuizId+QuestionId;

			if (ExistsQuizQuestionRecords.contains(checkedValue) == false) {
				QuizQuestionList.add(
					New lmscons__Quiz_Question__c(
						lmscons__Quiz__c = QuizId,
						lmscons__Question__c = QuestionId
					)
				);
			} else {
				writeToLog('Dublicated Quiz Question is found, Quiz Name: '+QuizName + ' Question Name: '+RecordName);
			}
		}
		insertQuizQuestionObject(QuizQuestionList);
	}

	private Set<String> getExistsQuizQuestionRecords(Map<String, lmscons__Quiz__c> NameQuiz_QuizObject, Map<String, lmscons__Question__c> NameQuestion_QuestionObject) {
		List<lmscons__Quiz_Question__c> checkQuizQuestionList = New List<lmscons__Quiz_Question__c>();
		Set<String> ExistsQuizQuestionRecords = New Set<String>();

		checkQuizQuestionList = [SELECT Id, lmscons__Quiz__c, lmscons__Question__c FROM lmscons__Quiz_Question__c WHERE lmscons__Quiz__c IN: NameQuiz_QuizObject.values() AND lmscons__Question__c IN :NameQuestion_QuestionObject.values()];

		for (lmscons__Quiz_Question__c QQ : checkQuizQuestionList) {
			ExistsQuizQuestionRecords.add(''+QQ.lmscons__Quiz__c+QQ.lmscons__Question__c);
		}

		return ExistsQuizQuestionRecords;
	}

	private void insertQuizQuestionObject(List<lmscons__Quiz_Question__c> QuizQuestionList) {
		try {

			insert QuizQuestionList;

			QuizQuestionList = [SELECT Id, lmscons__Quiz__r.Name, lmscons__Question__r.Name FROM lmscons__Quiz_Question__c WHERE Id IN: QuizQuestionList];
			if (QuizQuestionList.size() > 0) {

			writeToLog('Success - created Quiz_Question records: ');

				for (lmscons__Quiz_Question__c qq : QuizQuestionList) {
					writeToLog('\tId: '+qq.Id+'\n\t\tQUIZ NAME: '+qq.lmscons__Quiz__r.Name+'\n\t\tQUESTION NAME: '+qq.lmscons__Question__r.Name);
					countQuiestionsForQuiz(qq);
				}
			} else {
				writeToLog('No new Quiz_Question records created.');
			}
		} catch (Exception e) {
			generateExceptionLog(e);
		}
	}

	private void countQuiestionsForQuiz(lmscons__Quiz_Question__c qq) {
		if (QuizName_TotalCreatedForQuiz.containsKey(qq.lmscons__Quiz__r.Name) == true) {
			Integer currentValue = QuizName_TotalCreatedForQuiz.get(qq.lmscons__Quiz__r.Name);
			currentValue = currentValue + 1;
			QuizName_TotalCreatedForQuiz.put(qq.lmscons__Quiz__r.Name, currentValue);
		} else {
			QuizName_TotalCreatedForQuiz.put(qq.lmscons__Quiz__r.Name, 1);
		}
	}

	public void generateExceptionLog(Exception e) {
		writeToLog('WARNING ERROR EXCEPTON:');
		writeToLog('\tMessage: '+e.getMessage());
		writeToLog('\tStack Trace: '+e.getStackTraceString());
		writeToLog('\tLine Number: '+String.ValueOf(e.getLineNumber()));
		writeToLog('\tType Name: '+e.getTypeName()+'\n');
	}

	global void finish(Database.BatchableContext BC) {

		String totalLog = getLogCountQuizAndQuestion();

		system.debug(totalLog);
		system.debug(Log);

		String fullLog = totalLog+'\n\n';

		if (isFullLog) {
			fullLog	= +totalLog+'\n\n'+Log;
		}

		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
		try {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] { email };
			mail.setToAddresses(toAddresses);
			mail.setSubject('CFS Quiz Data Batch log');
			mail.setPlainTextBody ('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures. \n\n'+fullLog);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
		catch (Exception e) { }

	}

}