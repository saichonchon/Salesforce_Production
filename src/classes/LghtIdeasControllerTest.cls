@isTest
private class LghtIdeasControllerTest {

	@testSetup static void setup() {
		List<Idea> ideasList;
		Idea testIdea_1;
		String cId;
		Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		LghtIdeasSettings__c communitySettings = new LghtIdeasSettings__c(Name='community', Value__c='TestCommunity');
		communitySettings.Name = 'community';
		communitySettings.Value__c = 'TestCommunity';
		insert communitySettings;

		cId = LghtIdeasHelper.getCommunityId();

		User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com', 
							EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
							LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, 
							TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');
		
		ideasList = new List<Idea>();
		ideasList.add(new Idea(Title='Test idea_1', Body='Body of test idea_1', Status='New', Categories='test_1', CommunityId=cId));
		ideasList.add(new Idea(Title='Test idea_2', Body='Body of test idea_2', Status='Delivered', Categories='test_1', CommunityId=cId));
		ideasList.add(new Idea(Title='Test idea_3', Body='Body of test idea_3', Status='New', Categories='test_2', CommunityId=cId));
		ideasList.add(new Idea(Title='Test idea_4', Body='Body of test idea_4', Status='New', Categories='test_2', CommunityId=cId));

		insert ideasList;

		testIdea_1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

		insert new IdeaComment(CommentBody='First comment', IdeaId=testIdea_1.Id);

		System.runAs(testUser) {
			ideasList = new List<Idea>();
			ideasList.add(new Idea(Title='Test idea_5', Body='Body of test idea_5', Status='New', Categories='test_3', CommunityId=cId));
			ideasList.add(new Idea(Title='Test idea_6', Body='Body of test idea_6', Status='New', Categories='test_2', CommunityId=cId));
			ideasList.add(new Idea(Title='Test idea_7', Body='Body of test idea_7', Status='Delivered', Categories='test_2', CommunityId=cId));
			ideasList.add(new Idea(Title='Test idea_8', Body='Body of test idea_8', Status='New', Categories='test_2', CommunityId=cId));

			insert ideasList;

			insert new Vote(ParentId=testIdea_1.Id, Type='Up');
			insert new IdeaComment(CommentBody='Second comment', IdeaId=testIdea_1.Id);
		}
    }

	@isTest
	public static void testGetUserInfo() {
		Map<String, String> uInf = LghtIdeasController.getUserInfo();

		System.assertEquals(true, String.isNotEmpty(uInf.get('Id')), 'Id property is empty');
		System.assertEquals(true, String.isNotEmpty(uInf.get('Name')), 'Name property is empty');
		System.assertEquals(true, String.isNotEmpty(uInf.get('Username')), 'Username property is empty');
		System.assertEquals(true, String.isNotEmpty(uInf.get('Email')), 'Email property is empty');
		System.assertEquals(true, String.isNotEmpty(uInf.get('Type')), 'Type property is empty');
	}

	@isTest
	public static void testGetIdeas() {
		Map<String,String> filterData = new Map<String,String>();
		String cId = LghtIdeasHelper.getCommunityId();
		Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
		List<Idea> resultList;
		
		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, '');

		System.assertEquals(true, resultList.size() > 0, 'No items retrieved');

		//test pagination
		resultList = LghtIdeasController.getIdeas(filterData, 1, 5, '');

		System.assertEquals(5, resultList.size(), 'Wrong number of first page items');

		resultList = LghtIdeasController.getIdeas(filterData, 2, 5, '');

		System.assertEquals(3, resultList.size(), 'Wrong number of second page items');

		//test filters
		filterData.put('status', 'New');
		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, '');

		System.assertEquals(6, resultList.size(), 'Wrong number of items filtered by Status');

		filterData.put('category', 'test_1');
		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, '');

		System.assertEquals(1, resultList.size(), 'Wrong number of items filtered by Status and Category');

		filterData = new Map<String,String>();
		filterData.put('created_by_me', 'true');
		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, '');

		System.assertEquals(4, resultList.size(), 'Wrong number of items filtered by owner');

		//test order by
		filterData = new Map<String,String>();
		insert new Idea(Title='Test idea_last_added', Body='Body of test idea_last_added', Status='New', Categories='test_1', CommunityId=cId);
		insert new IdeaComment(CommentBody='First comment', IdeaId=testIdea.Id);

		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, '');

		System.assertEquals('Test idea_last_added', resultList[0].Title, 'Order by default failed');

		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, 'Trending');

		System.assertEquals('Test idea_2', resultList[0].Title, 'Order by Trending failed');

		resultList = LghtIdeasController.getIdeas(filterData, 1, 10, 'Popular');

		System.assertEquals('Test idea_1', resultList[0].Title, 'Order by Popular failed');
	}

	@isTest
	static void getGetIdea() {
		Idea testItem = [SELECT Id FROM Idea WHERE Title = 'Test idea_2'];
		
		Idea testIdea = LghtIdeasController.getIdea(testItem.Id);

		System.assertEquals('Test idea_2', testIdea.Title);
	}

	@isTest
	static void testGetIdeasCount() {
		Map<String,String> filterData = new Map<String,String>();
		Integer countVal;
		
		countVal = LghtIdeasController.getIdeasCount(filterData);

		System.assertEquals(8, countVal, 'Ivalid count without filter');

		filterData.put('category', 'test_2');
		countVal = LghtIdeasController.getIdeasCount(filterData);

		System.assertEquals(5, countVal, 'Ivalid count with category filter');

		filterData.put('status', 'Delivered');
		countVal = LghtIdeasController.getIdeasCount(filterData);

		System.assertEquals(1, countVal, 'Ivalid count with category and status filter');
	}

	@isTest
	static void testCreateNewIdea() {
		Idea newIdea = new Idea(Title='Test idea_created', Body='Body of test idea_created', Status='New', Categories='test_1');
		
		newIdea = LghtIdeasController.createNewIdea(newIdea);

		Idea testItem = [SELECT Title FROM Idea WHERE Id = :newIdea.Id];
		
		System.assertEquals('Test idea_created', testItem.Title);
	}

	@isTest
	static void testGetFilterData() {
		Map<String, String> options = new Map<String, String>();
		
		LghtIdeasController.getFilterData(options);
	}

	@isTest
	static void testGetIdeaVotes() {
		Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
		List<Vote> vts = LghtIdeasController.getIdeaVotes(testIdea.Id);

		System.assertEquals(2, vts.size());
	}

	@isTest
	static void testAddVote() {
		Idea testIdea_1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
		Idea testIdea_2 = [SELECT Id FROM Idea WHERE Title = 'Test idea_3' LIMIT 1];
		String res;
		User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com'];
		
		System.runAs(testUser) {
			res = LghtIdeasController.addVote(testIdea_1.Id, 'Up');
			
			System.assertEquals('20', res);

			res = LghtIdeasController.addVote(testIdea_2.Id, 'Down');
			
			System.assertEquals('0', res);
		}

		res = LghtIdeasController.addVote(testIdea_1.Id, 'Up');

		System.assertEquals('error', res);
	}

	@isTest
	static void testGetIdeaComments() {
		Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

		List<IdeaComment> comments = LghtIdeasController.getIdeaComments(testIdea.Id, '5', null);

		System.assertEquals(2, comments.size());
	}

	@isTest
	static void testSaveComment() {
		Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
		
		IdeaComment testComment = LghtIdeasController.saveComment(testIdea.Id, 'Test comment');

		System.assertEquals('Test comment', testComment.CommentBody);
	}
}