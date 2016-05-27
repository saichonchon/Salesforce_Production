public with sharing virtual class GeneralHelper {
	public Map<String, String> inputType_outputType = New Map<String, String>();
	public Map<String, String> inputTextType_outputTextType = New Map<String, String>();
	public List<CFS_Quiz_Data__c> QuizDataList = New List<CFS_Quiz_Data__c>();
	public Map<String, Integer> QuizName_Counter = New Map<String, Integer>();
	public Map<Id, lmscons__Quiz__c> QuizDataId_Quiz = New Map<Id, lmscons__Quiz__c>();

	private String Log = '';
	private Map<String, List<String>> logObject = New Map<String, List<String>>();

	public String getLog() {
		return this.Log;
	}

	public Map<String, List<String>> getLogObject() {
		return this.logObject;
	}


	public void writeToLog(String s) {
		this.Log += s+'\n';
	}

	public void writeToLog(String TypeLog, String s) {
		if (logObject.containsKey(TypeLog)) {
			logObject.get(TypeLog).add(s);
		} else {
			List<String> tmpString = New List<String>();
			tmpString.add(s);
			logObject.put(TypeLog, tmpString);
		}
	}

	public void setQuizDataList(List<CFS_Quiz_Data__c> QuizDataList) {
		this.QuizDataList.addall(QuizDataList);
	}
	public List<CFS_Quiz_Data__c> getQuizDataList() {
		return this.QuizDataList;
	}

	public GeneralHelper() {
		generateTypes();
		generateTextTypes();
	}

	public void addQuizNameToCounterMap(String QuizName) {
		if (this.QuizName_Counter.containsKey(QuizName)) {
			this.QuizName_Counter.put(QuizName, this.QuizName_Counter.get(QuizName) + 1);
		} else {
			this.QuizName_Counter.put(QuizName, 1);
		}
	}

	private void generateTextTypes() {
		//original values input output
		inputTextType_outputTextType.put('Short Text', 'Short Text');
		inputTextType_outputTextType.put('Long Text', 'Long Text');

		//custom
		inputTextType_outputTextType.put('Free Text Short', 'Short Text');
		inputTextType_outputTextType.put('Free Text Long', 'Long Text');
	}

	private void generateTypes() {
		//original values input output
		inputType_outputType.put('True/False', 'True/False');
		inputType_outputType.put('Multi Select', 'Multi Select');
		inputType_outputType.put('Free Text', 'Free Text');
		inputType_outputType.put('Single Select', 'Single Select');

		//custom
		inputType_outputType.put('True\False', 'True/False');
		inputType_outputType.put('True or False', 'True/False');
		inputType_outputType.put('True False', 'True/False');
		inputType_outputType.put('Free Text Short', 'Free Text');
		inputType_outputType.put('Free Text Long', 'Free Text');
	}

	public String generate80SymbolsForNameField(String input) {
		String output = '';
		if (String.ValueOf(input).length() > 80) {
			output = input.substring(0, 77)+'...';
		} else {
			output = String.ValueOf(input);
		}
		return output;
	}

	public void generateExceptionLog(Exception e) {
		writeToLog('WARNING ERROR EXCEPTON:');
		writeToLog('\tMessage: '+e.getMessage());
		writeToLog('\tStack Trace: '+e.getStackTraceString());
		writeToLog('\tLine Number: '+String.ValueOf(e.getLineNumber()));
		writeToLog('\tType Name: '+e.getTypeName()+'\n');
	}
	public void generateExceptionLog(Exception e, String Additional) {
		writeToLog('WARNING ERROR EXCEPTON:');
		writeToLog('\tMessage: '+e.getMessage());
		writeToLog('\tStack Trace: '+e.getStackTraceString());
		writeToLog('\tLine Number: '+String.ValueOf(e.getLineNumber()));
		writeToLog('\tType Name: '+e.getTypeName()+'\n');
		writeToLog('\tAdditional Info: '+Additional+'\n');
	}

}