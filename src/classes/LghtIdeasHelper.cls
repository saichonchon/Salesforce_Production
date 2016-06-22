public class LghtIdeasHelper { 
	public static List<Map<String, String>> getCategoryOptions(String source){
		List<Map<String, String>> listArray = new List<Map<String, String>>();
		Map<String, String> listItem;

		if (source == 'Custom settings') {
			List<LghtIdeasCategories__c> rows = [SELECT Name, Label__c, Parent__c FROM LghtIdeasCategories__c LIMIT 1000];

			for (LghtIdeasCategories__c row : rows) {
				listItem = new Map<String, String>();
				listItem.put('value', row.Name);
				listItem.put('label', row.Label__c);
				listItem.put('parent', row.Parent__c);
				listArray.add(listItem);
			}
		}
		else {
			Schema.DescribeFieldResult fieldResult = Idea.Categories.getDescribe();
			List<Schema.PicklistEntry> categoryPicklistEntries = fieldResult.getPicklistValues();
			
			for (Schema.PicklistEntry item : categoryPicklistEntries) {
				listItem = new Map<String, String>();
				listItem.put('value', item.getValue());
				listItem.put('label', item.getLabel());
				listArray.add(listItem);
			}
		}

		return listArray;
	}


	public static List<Map<String, String>> getStatusOptions(){
		List<Map<String, String>> listArray = new List<Map<String, String>>();
		Map<String, String> listItem;
        Schema.DescribeFieldResult fieldResult = Idea.Status.getDescribe();
        List<Schema.PicklistEntry> statusPicklistEntries = fieldResult.getPicklistValues();

		for (Schema.PicklistEntry item : statusPicklistEntries) {
			listItem = new Map<String, String>();
			listItem.put('value', item.getValue());
			listItem.put('label', item.getLabel());
			listArray.add(listItem);
		}

		return listArray;
	}

	
	public static String compileWhereStatement(Map<String,String> filterData) {
        List<String> whereList = new List<String>();
		List<String> searchIds = new List<String>();
		String searchQuery, category, status, ideaTheme, owner;

		if (filterData == null) return '';

        searchQuery = filterData.get('search');
		category = filterData.get('category');
		status = filterData.get('status');
		ideaTheme = filterData.get('idea_theme');
		owner = filterData.get('created_by_me');

        if (String.isNotBlank(category))
			whereList.add('Categories INCLUDES (\'' + String.escapeSingleQuotes(category) + '\')');

        if (String.isNotBlank(status))
			whereList.add('Status = \'' + String.escapeSingleQuotes(status) + '\'');

		if (String.isNotBlank(ideaTheme))
			whereList.add('IdeaThemeID = \'' + String.escapeSingleQuotes(ideaTheme) + '\'');

        if (String.isNotBlank(owner) && owner == 'true')
			whereList.add('CreatedById = \'' + UserInfo.getUserId() + '\'') ;

		if (String.isNotBlank(searchQuery)) {
			List<List<SObject>> searchList = [FIND :searchQuery IN ALL FIELDS RETURNING Idea(Id)];

			for (SObject obj : searchList[0]) {
				searchIds.add(obj.Id);
			}

			whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
		}

        return String.join(whereList, ' AND ');
    }


	public static String compileOrderByStatement(String orderByData) {
        String orderByClause = 'CreatedDate DESC';

        if (String.isNotBlank(orderByData)) {
            if (orderByData == 'Trending') {
                orderByClause = 'LastCommentDate DESC NULLS LAST, CreatedDate DESC';
            } 
			else if (orderByData == 'Popular') {
                orderByClause = 'VoteTotal DESC, CreatedDate DESC';
            }
        }

        return orderByClause;
    }


	public static String getCommunityId(String communityName) {
		if (String.isBlank(communityName)) {
			communityName = LghtIdeasHelper.getConfigValue('community');
		}

		if (communityName == '') { 
			System.debug('Cannot find community name within settings');
			return ''; 
		}

		try {
			Community community = [SELECT Id FROM Community WHERE Name = :communityName LIMIT 1];
			return community.Id;
		}
		catch (Exception e) {
			System.debug('No communities with name "' + communityName + '"');
		}
		
		return '';
	}


	public static String getConfigValue(String name) {
		for (LghtIdeasSettings__c row : [SELECT Name, Value__c FROM LghtIdeasSettings__c LIMIT 100]) {
			if (row.Name == name) return row.Value__c;
		}

		return '';
	}


	public static void performAccessCheck(String accessType) {
		Schema.DescribeSObjectResult ideaDescribe = Idea.sObjectType.getDescribe();
        Schema.DescribeSObjectResult voteDescribe = Vote.sObjectType.getDescribe();
        Schema.DescribeSObjectResult commentDescribe = IdeaComment.sObjectType.getDescribe();

		if (!ideaDescribe.isAccessible()
				|| (accessType == 'create' && !ideaDescribe.isCreateable())
				|| (accessType == 'edit' && !ideaDescribe.isUpdateable())
				|| (accessType == 'search' && !ideaDescribe.isSearchable()))
			throw new AuraHandledException('Access not granted');

		if (accessType == 'create_vote' && !voteDescribe.isAccessible()
				|| accessType == 'create_vote' && !voteDescribe.isCreateable()) {
			throw new AuraHandledException('Access not granted');
		}
        
        if ((accessType == 'read_comments' && !commentDescribe.isAccessible()) 
            	|| (accessType == 'create_comments') && !commentDescribe.isCreateable()) {
			throw new AuraHandledException('Access not granted');
		}
	}
}