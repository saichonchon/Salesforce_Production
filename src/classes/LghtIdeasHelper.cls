public class LghtIdeasHelper { 
	public static List<Map<String, String>> getCategoryOptions(String source){
		List<Map<String, String>> listArray = new List<Map<String, String>>();
		Map<String, String> listItem;

		if (source == 'Custom settings') {
			List<LghtIdeasCategories__c> rows = [SELECT Name, Label__c, Parent__c FROM LghtIdeasCategories__c];

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
        String[] whereList = new List<String>();
		String category, status, ideaTheme, owner;

		if (filterData == null) return '';

        category = filterData.get('category');
		status = filterData.get('status');
		ideaTheme = filterData.get('idea_theme');
		owner = filterData.get('created_by_me');

        if(String.isNotBlank(category))
			whereList.add('Categories INCLUDES (\'' + String.escapeSingleQuotes(category) + '\')');

        if(String.isNotBlank(status))
			whereList.add('Status = \'' + String.escapeSingleQuotes(status) + '\'');

		if(String.isNotBlank(ideaTheme))
			whereList.add('IdeaThemeID = \'' + String.escapeSingleQuotes(ideaTheme) + '\'');

        if(String.isNotBlank(owner) && owner == 'true')
			whereList.add('CreatedById = \'' + UserInfo.getUserId() + '\'') ;

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


	public static String getCommunityId() {
		/*	String communityName = LghtIdeasHelper.getConfigValue('community');
if (communityName == '')
{ System.debug('Cannot find community name within component settings'); return ''; }
try
{ Community community = [SELECT Id FROM Community WHERE Name = :communityName LIMIT 1]; return community.Id; }
catch (Exception e)
{ System.debug('No communities with name "' + communityName + '"'); }
return ''; */
Community community = [SELECT Id FROM Community WHERE Id = :Label.Idea_Community_Id LIMIT 1];
        
        return community.Id;
	}


	public static String getConfigValue(String name) {
		for (LghtIdeasSettings__c row : [SELECT Name, Value__c FROM LghtIdeasSettings__c]) {
			if (row.Name == name) return row.Value__c;
		}

		return '';
	}


	public static void performAccessCheck(String accessType) {
		Schema.DescribeSObjectResult ideaDescribe = Idea.sObjectType.getDescribe();

		if (!ideaDescribe.isAccessible()
				|| (accessType == 'create' && !ideaDescribe.isCreateable())
				|| (accessType == 'edit' && !ideaDescribe.isUpdateable())
				|| (accessType == 'search' && !ideaDescribe.isSearchable()))
			throw new AuraHandledException('Access not granted');
	}
}