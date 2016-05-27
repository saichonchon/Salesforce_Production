public with sharing virtual class QuizHelper extends GeneralHelper {

	private Map<String, lmscons__Quiz__c> generatedMap_NameQuiz_QuizObject = New Map<String, lmscons__Quiz__c>();
	private List<lmscons__Quiz__c> existsQuizList = New List<lmscons__Quiz__c>();
	private lmscons__Quiz__c LastQuiz;
	private Set<String> shortQuizNames = New Set<String>();
	public lmscons__Quiz__c getLastQuiz() {
		return lastQuiz;
	}

	public void setLastQuiz(lmscons__Quiz__c updatedLastQuiz) {
		lastQuiz = updatedLastQuiz;
	}

	public Map<String, lmscons__Quiz__c> getMap_NameQuiz_QuizObject() {
		if (this.generatedMap_NameQuiz_QuizObject.size() == 0) {
			generateFullMapQuizObject();
		}
		return generatedMap_NameQuiz_QuizObject;
	}

	private void generateFullMapQuizObject() {
		for (CFS_Quiz_Data__c QuizData : this.QuizDataList) {
			if(QuizData.Quiz_Name__c != NULL && QuizData.Quiz_Name__c.Trim() != '') {
				generateLastQuizObject(QuizData);
			} else if (this.lastQuiz == NULL) {
				writeToLog('FATAL ERROR Empty Quiz Object, CFS Quiz Data RecordId: '+QuizData.Id);
			} else {
				generateQuizDataRecord(QuizData);
			}
			if (QuizData.Quiz_Name__c == NULL) {
				writeToLog('FATAL ERROR Empty Quiz Name, CFS Quiz Data RecordId: '+QuizData.Id);
			} else {
				shortQuizNames.add(generate80SymbolsForNameField(QuizData.Quiz_Name__c));
				this.generatedMap_NameQuiz_QuizObject.put(
					//generate80SymbolsForNameField(QuizData.Quiz_Name__c),
					QuizData.Quiz_Name__c,
					getLastQuiz()
				);


			}

			//lmscons__Quiz__c tmpQuizObj = this.generatedMap_NameQuiz_QuizObject.get(generate80SymbolsForNameField(QuizData.Quiz_Name__c));

			//QuizDataId_Quiz.put(QuizData.Id, tmpQuizObj);
		}
		removedBadRecordsFromQuizDataList();
		updatedTmpMap_NameQuiz_QuizObject();
		removedBadRecordsFromQuizDataList();
		upsertQuizObject();

		for (CFS_Quiz_Data__c QuizData : this.QuizDataList) {
			QuizDataId_Quiz.put(QuizData.Id, this.generatedMap_NameQuiz_QuizObject.get(QuizData.Quiz_Name__c));
		}
	}

	private void generateQuizDataRecord(CFS_Quiz_Data__c QuizData) {
		QuizData.Quiz_Name__c = this.lastQuiz.lmscons__Description__c;
		QuizData.Description__c = this.lastQuiz.lmscons__Description__c;
		QuizData.Duration__c =  String.valueOf(this.lastQuiz.lmscons__DurationTime__c);
		QuizData.Max_Attempts__c =  String.valueOf(this.lastQuiz.lmscons__Max_Attempts__c);
		QuizData.Passing_Score__c = String.valueOf(this.lastQuiz.lmscons__Passing_Score__c);
		QuizData.Show_Score__c = this.lastQuiz.lmscons__Show_Score__c == true ? 'Yes' : '';
	}

	private void generateLastQuizObject(CFS_Quiz_Data__c QuizData) {
		this.lastQuiz = New lmscons__Quiz__c (
			Name = generate80SymbolsForNameField(QuizData.Quiz_Name__c),
			lmscons__Description__c = QuizData.Description__c,
			lmscons__DurationTime__c = QuizData.Duration__c,
			lmscons__Duration__c = (QuizData.Duration__c == NULL ? NULL : Integer.valueOf(QuizData.Duration__c)),
			lmscons__Max_Attempts__c = (QuizData.Max_Attempts__c == NULL ? NULL : Integer.valueOf(QuizData.Max_Attempts__c)),
			lmscons__Passing_Score__c = (QuizData.Passing_Score__c == NULL ? NULL : Integer.valueOf(QuizData.Passing_Score__c)),
			lmscons__Show_Score__c = (QuizData.Show_Score__c == 'Yes' ? true : false)
		);
	}

	private void removedBadRecordsFromQuizDataList() {
		List<CFS_Quiz_Data__c> QuizDataListWithoutDublicate = New List<CFS_Quiz_Data__c>();

		for (CFS_Quiz_Data__c QuizData : this.QuizDataList) {
			if (this.generatedMap_NameQuiz_QuizObject.containsKey(QuizData.Quiz_Name__c) == true) {
				QuizDataListWithoutDublicate.add(QuizData);
			} else {
				writeToLog('Dublicate Quiz Name found, removed FROM Quiz Data List, Name: '+QuizData.Quiz_Name__c+' Id Record: '+QuizData.Id);
			}
		}

		this.QuizDataList.clear();

		if (QuizDataListWithoutDublicate.size() > 0) {
			this.QuizDataList.addall(QuizDataListWithoutDublicate);
		}
	}

	private void updatedTmpMap_NameQuiz_QuizObject() {
		//count the number of duplicated Quizzes if > 1 add to log, 2 or More Quizzes with the same name

		List<lmscons__Quiz__c> QuizList = [SELECT Id,
												Name,
												lmscons__Description__c,
												lmscons__DurationTime__c,
												lmscons__Duration__c,
												lmscons__Max_Attempts__c,
												lmscons__Passing_Score__c,
												lmscons__Show_Score__c
											FROM
												lmscons__Quiz__c
											WHERE
												Name IN: shortQuizNames];

		for (lmscons__Quiz__c Quiz : QuizList) {

			addQuizNameToCounterMap(Quiz.lmscons__Description__c);

			if (this.QuizName_Counter.get(Quiz.lmscons__Description__c) == 1) {
				this.generatedMap_NameQuiz_QuizObject.put(
					Quiz.lmscons__Description__c,
					Quiz
				);
				writeToLog('Existing Quiz is Founded.\nQuiz Name: '+Quiz.lmscons__Description__c+' Id Record: '+Quiz.Id);
			} else {
				writeToLog('WARNING: Dublicated Quiz Name: Removed from Map QuizObject Id: '+this.generatedMap_NameQuiz_QuizObject.get(Quiz.lmscons__Description__c));
				writeToLog('WARNING: Removed from Map Quiz Name, Id: '+Quiz.lmscons__Description__c+', '+Quiz.Id);
				this.generatedMap_NameQuiz_QuizObject.remove(Quiz.lmscons__Description__c);
			}
		}
	}

	private void upsertQuizObject () {
		try {
			upsert this.generatedMap_NameQuiz_QuizObject.values();
			writeToLog('Success - created/updated quizzes: ');

			for (lmscons__Quiz__c quiz : this.generatedMap_NameQuiz_QuizObject.values()) {
				writeToLog('\tId: '+quiz.Id+' Name: '+quiz.Name);
			}
		} catch (Exception e) {
			generateExceptionLog(e);
		}
	}

}