public with sharing virtual class AnswerHelper extends QuestionHelper {
	private Map<String, lmscons__Answer__c> generatedMap_QuestionIdAnswerName_AnswerObject = New Map<String, lmscons__Answer__c>();
	private Map<Id, CFS_Quiz_Data__c> QuestionId_QuizDataRecord = New Map<Id, CFS_Quiz_Data__c>();
	private List<lmscons__Answer__c> AnswersList = New List<lmscons__Answer__c>();
	private Id QuestionId;
	private Boolean isCorrect;
	private final String ORIGINAL_ANSWERS_SEPARATOR = '|';
	private final String PREF_ANSWERS_SEPARATOR = '#:#';

	public Integer getCountAnswersCreated() {
		return this.AnswersList != NULL ? this.AnswersList.size() : 0;
	}
	public void setMap_QuestionId_QuizDataRecord(Map<Id, CFS_Quiz_Data__c> newQuestionId_QuizDataRecord) {
		QuestionId_QuizDataRecord = newQuestionId_QuizDataRecord;
	}

	public void createAnswers() {
		for (Id forQuestionId : QuestionId_QuizDataRecord.keySet()) {
			this.QuestionId = forQuestionId;
			parseAnswers();
		}
		validateExistsAnswers();
		insertAnswersRecords();
	}

	private void parseAnswers() {
		if (QuestionId_QuizDataRecord != NULL && QuestionId_QuizDataRecord.containsKey(this.QuestionId)) {
			parseIncorrectAnswers();
			parseCorrectAnswers();
		}
	}
	private void parseIncorrectAnswers() {
		String incorrectAnswers = '';
		try {
			incorrectAnswers = QuestionId_QuizDataRecord.get(this.QuestionId).Incorrect_Answers__c == NULL ? '' : QuestionId_QuizDataRecord.get(this.QuestionId).Incorrect_Answers__c;
			isCorrect = false;
			prepareAnswers(incorrectAnswers);
		} catch (Exception e) {
			String Additional = '';
			Additional += ' Question ID: '+this.QuestionId;
				try {
					Additional += ' Answers: '+QuestionId_QuizDataRecord.get(this.QuestionId).Incorrect_Answers__c;
				} catch (Exception e2) {
					generateExceptionLog(e2);
				}
			generateExceptionLog(e, Additional);
		}
	}

	private void parseCorrectAnswers() {
		String correctAnswers = '';
		try {
			correctAnswers = QuestionId_QuizDataRecord.get(this.QuestionId).Correct_Answers__c == NULL ? '' : QuestionId_QuizDataRecord.get(this.QuestionId).Correct_Answers__c;
			isCorrect = true;
			prepareAnswers(correctAnswers);
		} catch (Exception e) {
			String Additional = '';
			Additional += ' Question ID: '+this.QuestionId;
				try {
					Additional += ' Answers: '+QuestionId_QuizDataRecord.get(this.QuestionId).Correct_Answers__c;
				} catch (Exception e2) {
					generateExceptionLog(e2);
				}
			generateExceptionLog(e, Additional);
		}
	}

	private void prepareAnswers(String allAnswers) {

		if (allAnswers == '') {
			return;
		}
		allAnswers = allAnswers.replace(ORIGINAL_ANSWERS_SEPARATOR, PREF_ANSWERS_SEPARATOR);
		List<String> Answers = allAnswers.split(PREF_ANSWERS_SEPARATOR);
		fillAnswersRecords(Answers);
	}

	private void fillAnswersRecords(List<String> Answers) {
		for (String answer : Answers) {
			if (answer != '') {
				AnswersList.add(
					New lmscons__Answer__c(
						Name = generate80SymbolsForNameField(answer),
						lmscons__Answer__c = answer,
						lmscons__Correct_incorrect__c = isCorrect,
						lmscons__Question__c = this.QuestionId
					)
				);
			}
		}

	}

	private void validateExistsAnswers() {
			if (AnswersList!=NULL && AnswersList.size() > 0) {

				Set<String> AnswerNames = New Set<String>();
				Set<Id> QuestionIds = New Set<Id>();

				for (lmscons__Answer__c answer : AnswersList) {
					AnswerNames.add(answer.name);
					QuestionIds.add(answer.lmscons__Question__c);
				}

				system.debug('##100 QuestionIds: '+QuestionIds);

				List<lmscons__Answer__c> getExistsAnswersList = [SELECT Id, Name, lmscons__Question__c FROM lmscons__Answer__c WHERE lmscons__Question__c IN :QuestionIds AND Name IN: AnswerNames];

				if (getExistsAnswersList.size() > 0) {
					removedDublicatedValuesFromAnswersList(getExistsAnswersList);
				}
			}
	}

	private void removedDublicatedValuesFromAnswersList(List<lmscons__Answer__c> ExistsAnswersList) {
		Set<String> QuestionIdsAnswerNames = New Set<String>();
		List<lmscons__Answer__c> AnswersWithoutDublicate = New List<lmscons__Answer__c>();

		for (lmscons__Answer__c answer : ExistsAnswersList) {
			QuestionIdsAnswerNames.add(''+answer.Name+answer.lmscons__Question__c);
		}

		for (lmscons__Answer__c answer : this.AnswersList) {
			String valuesFromList = ''+answer.Name+answer.lmscons__Question__c;

			if (QuestionIdsAnswerNames.contains(valuesFromList) == false) {
				AnswersWithoutDublicate.add(answer);
			}
		}

		this.AnswersList.clear();

		if (AnswersWithoutDublicate.size() > 0) {
			this.AnswersList.addall(AnswersWithoutDublicate);
		}
	}

	private void insertAnswersRecords() {
		try {
			if (AnswersList!=NULL && AnswersList.size() > 0) {
				insert AnswersList;

				List<lmscons__Answer__c> tmpAnswersList = [SELECT Id, Name, lmscons__Question__c, lmscons__Question__r.Name FROM lmscons__Answer__c WHERE Id IN: AnswersList];

				writeToLog('Success - created answers: ');
				for (lmscons__Answer__c answer : tmpAnswersList) {
					writeToLog('\tId: '+answer.Id+' Name: '+answer.Name+' \n\tFor Question Id: '+answer.lmscons__Question__c+' Name: '+answer.lmscons__Question__r.Name );
				}
			}
		} catch (Exception e) {
			generateExceptionLog(e);
		}
	}
}