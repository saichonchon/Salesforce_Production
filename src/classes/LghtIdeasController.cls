public with sharing class LghtIdeasController {
    private static final Integer DEFAULT_ITEMS_PER_PAGE = 5;
	private static final Integer MAX_ITEMS_PER_PAGE = 500;

	@AuraEnabled
    public static Map<String, String> getUserInfo(){
		Map<String, String> uInf = new Map<String, String>();
		uInf.put('Id', UserInfo.getUserId());
		uInf.put('Name', UserInfo.getName());
		uInf.put('Username', UserInfo.getUserName());
		uInf.put('Email', UserInfo.getUserEmail());
		uInf.put('Type', UserInfo.getUserType());
        
        return uInf;
    }

    @AuraEnabled
    public static List<Idea> getIdeas(String community, Map<String,String> filterData, Integer page, Integer itemsPerPage, String orderBy){
        LghtIdeasHelper.performAccessCheck('read');
		
		String queryFields = 'Title, Body, Status, CreatedDate, CreatedById, CreatorName, CreatorSmallPhotoUrl, NumComments, Categories, '
							+ 'VoteTotal, (SELECT Type FROM Votes WHERE CreatedById = \''+ UserInfo.getUserId() +'\')';
		String query = 'SELECT ' + queryFields + ' FROM Idea'
				+' WHERE CommunityId = \'' + LghtIdeasHelper.getCommunityId(community) + '\' AND ParentIdeaId = null';
		String queryWhere = LghtIdeasHelper.compileWhereStatement(filterData);
		String queryOrderBy = LghtIdeasHelper.compileOrderByStatement(orderBy);
		List<Idea> res_items;

		page = Integer.valueOf(page);
		itemsPerPage = Integer.valueOf(itemsPerPage);

		if (itemsPerPage < 1 || itemsPerPage > MAX_ITEMS_PER_PAGE) itemsPerPage = DEFAULT_ITEMS_PER_PAGE;
		
		query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';
		query += String.isNotBlank(queryOrderBy) ? ' ORDER BY ' + queryOrderBy : '';
		query += ' LIMIT ' + itemsPerPage;
        query += (page > 1) ? ' OFFSET ' + String.valueOf(itemsPerPage*(page-1)) : '';

		res_items = Database.query(query);
        
        return res_items;
    }

	@AuraEnabled
    public static Idea getIdea(String recordId) {
        LghtIdeasHelper.performAccessCheck('read');

		if(String.isBlank(recordId)) return null;
		
		String queryFields = 'Title, Body, Status, CreatedDate, CreatedById, CreatorName, CreatorSmallPhotoUrl, NumComments, Categories, ParentIdeaId, '
							+ 'VoteTotal, (SELECT Type FROM Votes WHERE CreatedById = \''+ UserInfo.getUserId() +'\')';
		String query = 'SELECT ' + queryFields + ' FROM Idea WHERE Id = \'' + String.escapeSingleQuotes(recordId) + '\'';
		      
        return Database.query(query);
    }

	@AuraEnabled
    public static Integer getIdeasCount(String community, Map<String,String> filterData) {
		LghtIdeasHelper.performAccessCheck('read');
		
		String query = 'SELECT COUNT() FROM Idea'
				+' WHERE CommunityId = \'' + LghtIdeasHelper.getCommunityId(community) + '\' AND ParentIdeaId = null';
		String queryWhere = LghtIdeasHelper.compileWhereStatement(filterData);
		Integer result_count = 0;

		query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';

		result_count = Database.countQuery(query);
        
        return result_count;
    }

	@AuraEnabled
    public static List<Idea> getMergedIdeas(String parentId) {
		LghtIdeasHelper.performAccessCheck('read');
		
		return [SELECT Title, CreatedDate FROM Idea WHERE ParentIdeaId = :parentId ORDER BY CreatedDate DESC LIMIT 10];
	}

	@AuraEnabled
    public static Idea createNewIdea(String community, Idea newIdea) {
		LghtIdeasHelper.performAccessCheck('create');
		
		newIdea.CommunityId = LghtIdeasHelper.getCommunityId(community);

		try {
			insert newIdea;
		}
		catch (DmlException e) {
			System.debug(e.getMessage());
			return null;
		}

		newIdea = [SELECT Title, Body, Status, CreatedDate, CreatedById, CreatorName, CreatorSmallPhotoUrl, 
						NumComments, Categories, VoteTotal 
					FROM Idea WHERE Id = :newIdea.Id];

        return newIdea;
    }

	@AuraEnabled
	public static Map<String, List<Map<String, String>>> getFilterData(Map<String, String> options) {
		LghtIdeasHelper.performAccessCheck('read');
		
		Map<String, List<Map<String, String>>> data = new Map<String, List<Map<String, String>>>();
		String categories_source = options.get('categories_source');

		data.put('category', LghtIdeasHelper.getCategoryOptions(categories_source));
		data.put('status', LghtIdeasHelper.getStatusOptions());

		return data;
	}

	@AuraEnabled
    public static String addVote(String ideaId, String voteType) {
		if (String.isBlank(ideaId)) return 'error';
		if (String.isBlank(voteType)) return 'error';
		if (UserInfo.getUserType() == 'Guest') return 'auth_required';

		LghtIdeasHelper.performAccessCheck('create_vote');

		try {
            insert new Vote(ParentId = ideaId, Type = voteType);
        } 
		catch (DmlException e) {
            System.debug(e.getMessage());
			return 'error';
        }

		Idea voteIdea = [SELECT VoteTotal FROM Idea WHERE Id = :ideaId];

		return String.valueOf(voteIdea.VoteTotal);
    }

	@AuraEnabled
    public static List<Vote> getIdeaVotes(String ideaId) {
        LghtIdeasHelper.performAccessCheck('read_vote');
		
		if(String.isBlank(ideaId)) return null;

        String query = 'SELECT CreatedById, Type, CreatedBy.SmallPhotoUrl, CreatedBy.FirstName, CreatedBy.LastName' +
						' FROM Vote WHERE ParentId = \''+ String.escapeSingleQuotes(ideaId) +'\'' +
						' ORDER BY SystemModstamp DESC' +
						' LIMIT  100';

        return Database.query(query);
    }

	@AuraEnabled
	public static List<IdeaComment> getIdeaComments(String ideaId, String queryLimit, String orderDir, String fromDatetime) {
		LghtIdeasHelper.performAccessCheck('read_comments');
		
		String query = 'SELECT Id, CommentBody, CreatedDate, CreatorName, CreatedById, CreatorSmallPhotoUrl FROM IdeaComment';

		if(String.isBlank(ideaId)) return null;

        query += ' WHERE IdeaId = \'' + String.escapeSingleQuotes(ideaId) + '\'';
		if (String.isNotBlank(fromDatetime)) {
			query += ' AND CreatedDate';
			query += orderDir == 'asc' ? ' > ' : ' < ';
			query += String.escapeSingleQuotes(fromDatetime);
		}
		query += orderDir == 'asc' ? ' ORDER BY CreatedDate ASC' : ' ORDER BY CreatedDate DESC';
        query += String.valueOf(queryLimit).isNumeric() ? ' LIMIT ' + String.valueOf(queryLimit) : 'LIMIT 0';

        return Database.query(query);
    }


	@AuraEnabled
    public static IdeaComment saveComment(String ideaId, String message) {
        LghtIdeasHelper.performAccessCheck('create_comments');
		
		IdeaComment comment = new IdeaComment(CommentBody = message, IdeaId = ideaId);

        try {
            insert comment;
        } 
		catch (DmlException e) {
            System.debug(e.getMessage());
			return null;
        }

		return [SELECT CommentBody, CreatedDate, CreatorName, CreatedById, CreatorSmallPhotoUrl 
					FROM IdeaComment WHERE Id = :comment.Id];
    }


	@AuraEnabled
    public static List<Idea> getSimilarIdeas(Idea newIdea) {
        LghtIdeasHelper.performAccessCheck('read');

		List<String> ids = Ideas.findSimilar(newIdea);

		return [SELECT Title FROM Idea WHERE Id IN :ids ORDER BY CreatedDate DESC LIMIT 10];
    }
}