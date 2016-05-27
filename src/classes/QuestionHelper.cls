public with sharing virtual class QuestionHelper extends QuizHelper {

	private Map<String, lmscons__Question__c> generatedMap_QuizQuestionTypeTextType_QuestionObject = New Map<String, lmscons__Question__c>();
	private Set<String> QuizName = New Set<String>();
	private Set<String> QuestionName = New Set<String>();
	private Set<String> Type = New Set<String>();
	private Set<String> TextType = New Set<String>();
	private Map<Id, CFS_Quiz_Data__c> QuestionId_QuizDataRecord = New Map<Id, CFS_Quiz_Data__c>();
	private Map<String, CFS_Quiz_Data__c> QuizQuestionTypeTextType_QuizDataRecord = New Map<String, CFS_Quiz_Data__c>();

	public Map<Id, CFS_Quiz_Data__c> getMap_QuestionId_QuizDataRecord() {
		return QuestionId_QuizDataRecord;
	}

	public Map<String, lmscons__Question__c> getMap_QuizQuestionTypeTextType_QuestionObject() {

		if (this.generatedMap_QuizQuestionTypeTextType_QuestionObject.size() == 0) {
			generateFullMapQuestionObject();
		}

		return generatedMap_QuizQuestionTypeTextType_QuestionObject;

	}

	private void generateFullMapQuestionObject() {
		this.TextType.add(NULL);

		for (CFS_Quiz_Data__c QuizData : this.QuizDataList) {
			if (QuizData.Question__c != NULL && QuizData.Question__c.Trim() != '' && QuizData.Type__c != NULL && QuizData.Type__c.Trim() != '') {
				String tmpFreeTextType = getTextTypeForFreeTextQuestion(QuizData);
				this.generatedMap_QuizQuestionTypeTextType_QuestionObject.put(
					QuizData.Id,
					New lmscons__Question__c (
						Name = generate80SymbolsForNameField(QuizData.Question__c),
						lmscons__Question__c = QuizData.Question__c,
						lmscons__Type__c = getCorrectTypeQuestion(QuizData),
						lmscons__Text_Type__c = tmpFreeTextType
					)
				);
				this.QuizQuestionTypeTextType_QuizDataRecord.put (
					QuizData.Id,
					QuizData
				);
			} else {
				this.writeToLog('Empty Question, QuizData Id Record: '+QuizData.Id);
			}
		}
		upsertQuestionObject();
	}

	private String getTextTypeForFreeTextQuestion(lmscons__Quiz_Question__c QuizQuestionDataRecord) {
		CFS_Quiz_Data__c QuizDataRecord = New CFS_Quiz_Data__c(	Quiz_Name__c = QuizQuestionDataRecord.lmscons__Question__r.Name,  External_Id__c = NULL, Type__c = QuizQuestionDataRecord.lmscons__Question__r.lmscons__Type__c);
		return getTextTypeForFreeTextQuestion(QuizDataRecord);
	}

	private String getTextTypeForFreeTextQuestion(CFS_Quiz_Data__c QuizDataRecord) {
		String tmpFreeTextType = NULL;
		if (QuizDataRecord.Type__c.contains('Free Text')) {
			if (this.inputTextType_outputTextType.containsKey(QuizDataRecord.Type__c)) {
				tmpFreeTextType = this.inputTextType_outputTextType.get(QuizDataRecord.Type__c);
			} else {
				String ExternalId = (QuizDataRecord.External_Id__c == NULL ? 'Record from Quiz_Question object: Name: '+QuizDataRecord.Quiz_Name__c : String.valueOf(QuizDataRecord.External_Id__c)) ;
				this.writeToLog('Incorrect text type question: Record Id: '+QuizDataRecord.Id + '. External Id: '+ExternalId);
			}
		}
		return '#:#'+tmpFreeTextType;
	}

	private String getCorrectTypeQuestion(lmscons__Quiz_Question__c QuizQuestionDataRecord) {
		CFS_Quiz_Data__c QuizDataRecord = New CFS_Quiz_Data__c(	Quiz_Name__c = QuizQuestionDataRecord.lmscons__Question__r.Id, Type__c = QuizQuestionDataRecord.lmscons__Question__r.lmscons__Type__c);
		return getCorrectTypeQuestion(QuizDataRecord);
	}

	private String getCorrectTypeQuestion(CFS_Quiz_Data__c QuizDataRecord) {
		String tmpType = '';
		if (this.inputType_outputType.containsKey(QuizDataRecord.Type__c)) {
			tmpType = this.inputType_outputType.get(QuizDataRecord.Type__c);
		} else {
			if (QuizDataRecord.Id == NULL) {
				this.writeToLog('Incorrect type question: Record Id: '+QuizDataRecord.Quiz_Name__c + '. External Id: '+QuizDataRecord.External_Id__c);
			} else {
				this.writeToLog('Incorrect type question: Record Id: '+QuizDataRecord.Id + '. External Id: '+QuizDataRecord.External_Id__c);
			}
		}

		return tmpType;

	}

	private void upsertQuestionObject () {
		try {
			upsert this.generatedMap_QuizQuestionTypeTextType_QuestionObject.values();
			createLogUpsertedRecords();
			createMapQuestionId_QuizDataObject();
		} catch (Exception e) {
			generateExceptionLog(e);
		}
	}
	private void createLogUpsertedRecords() {
		writeToLog('Success - created/updated questions: ');

		for (lmscons__Question__c Question : this.generatedMap_QuizQuestionTypeTextType_QuestionObject.values()) {
			writeToLog('\tId: '+Question.Id+' Name: '+Question.Name);
		}
	}
	private void createMapQuestionId_QuizDataObject() {
		for (String QuestionNameWithType : this.generatedMap_QuizQuestionTypeTextType_QuestionObject.keySet()) {
			QuestionId_QuizDataRecord.put(
										this.generatedMap_QuizQuestionTypeTextType_QuestionObject.get(QuestionNameWithType).Id,
										this.QuizQuestionTypeTextType_QuizDataRecord.get(QuestionNameWithType)
										);
		}

	}


}