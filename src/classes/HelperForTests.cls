@isTest
public with sharing class HelperForTests {

	public static String prefixName;

	public static CFS_Quiz_Data__c createMultiSelectNOTCorrect() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question Multi Select '+prefixName,
				Type__c = 'Multi Select',
				Correct_Answers__c = 'Answer',
				Incorrect_Answers__c = 'Answer Multi | Select 1 | NOT Correct '+prefixName
			);
	}

	public static CFS_Quiz_Data__c createMultiSelectCORRECT() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question Multi Select '+prefixName,
				Type__c = 'Multi Select',
				Correct_Answers__c = 'Answer Multi Select 1 CORRECT '+prefixName,
				Incorrect_Answers__c = ''
			);
	}

	public static CFS_Quiz_Data__c createTrueFalseWithCorrectTrue() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question True/False '+prefixName,
				Type__c = 'True/False',
				Correct_Answers__c = 'True',
				Incorrect_Answers__c = 'False'
			);
	}

	public static CFS_Quiz_Data__c createTrueFalseWithCorrectFalse() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question True/False '+prefixName,
				Type__c = 'True/False',
				Correct_Answers__c = 'False',
				Incorrect_Answers__c = 'True'
			);
	}

	public static CFS_Quiz_Data__c createFreeTextShortWithAnswer() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question Free Text '+prefixName,
				Type__c = 'Free Text Short',
				Correct_Answers__c = 'Answer Free Text Short Text 1 '+prefixName
			);
	}

	public static CFS_Quiz_Data__c createFreeTextShort() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Duration__c = '30',
				Question__c = 'Question Free Text '+prefixName,
				Type__c = 'Free Text Short'
			);
	}


	public static CFS_Quiz_Data__c createFreeTextLongWithAnswer() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Duration__c = '30',
				Question__c = 'Question Free Text '+prefixName,
				Type__c = 'Free Text Long',
				Correct_Answers__c = 'Answer Free Text Long Text '+prefixName
			);
	}
	public static CFS_Quiz_Data__c createFreeTextLong() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Duration__c = '30',
				Question__c = 'Question Free Text '+prefixName,
				Type__c = 'Free Text Long'
			);
	}

	public static CFS_Quiz_Data__c createSingleSelectCorrect() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question Single Select '+prefixName,
				Type__c = 'Single Select',
				Correct_Answers__c = 'Single Select 1 '+prefixName,
				Incorrect_Answers__c = 'Yes'
			);
	}

	public static CFS_Quiz_Data__c createSingleSelectNOTCorrect() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 1,
				Quiz_Name__c = 'Test '+prefixName,
				Description__c = 'Test '+prefixName,
				Passing_Score__c = '50',
				Duration__c = '30',
				Max_Attempts__c = '1',
				Show_Score__c = 'Yes',
				Question__c = 'Question Single Select '+prefixName,
				Type__c = 'Single Select',
				Correct_Answers__c = 'Single Select 1 '+prefixName,
				Incorrect_Answers__c = 'No'
			);
	}

	public static CFS_Quiz_Data__c createEmptyQuiz() {
		return New CFS_Quiz_Data__c(
				External_Id__c = 2,
				Question__c = 'Question Single Select '+prefixName,
				Type__c = 'Single Select',
				Correct_Answers__c = 'Single Select 1 '+prefixName,
				Incorrect_Answers__c = 'No Select 1 | No Select 2 | No Select 3'
			);
	}

	public static Integer getCount(String SearchValue) {
		SearchValue = SearchValue == NULL ? '': SearchValue;
		SearchValue = '%'+String.escapeSingleQuotes(SearchValue)+'%';
		return [SELECT COUNT() FROM lmscons__Quiz__c WHERE Name LIKE:SearchValue];
	}

	public static CFS_Quiz_Data__c configCFSQuiqDataRecord(String prefix, Integer ExternalId) {
		return New CFS_Quiz_Data__c(External_Id__c = ExternalId, Question__c = 'Test '+prefix, Type__c = 'Multi Select');
	}

	public static String generate80SymbolsForNameField(String input) {
		GeneralHelper GH = New GeneralHelper();
		return GH.generate80SymbolsForNameField(input);
	}

}