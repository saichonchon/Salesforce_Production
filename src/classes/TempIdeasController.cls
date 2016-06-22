public with sharing class TempIdeasController {
	public TempIdeasController() {
	}
		
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
    public static List<Idea> getIdeas(Map<String,String> filterData, Integer page, Integer itemsPerPage, String orderBy){
        return new List<Idea>();
    }

	@AuraEnabled
    public static Idea getIdea(String recordId) {
        return new Idea();
    }

	@AuraEnabled
    public static Integer getIdeasCount(Map<String,String> filterData) {
        return 0;
    }

	@AuraEnabled
    public static Idea createNewIdea(Idea newIdea) {
		return getIdea('');
    }

	@AuraEnabled
	public static Map<String, List<Map<String, String>>> getFilterData(Map<String, String> options) {
		return new Map<String, List<Map<String, String>>>();
	}

	@AuraEnabled
    public static String addVote(String ideaId, String voteType) {
		return String.valueOf('');
    }

	@AuraEnabled
    public static List<Vote> getIdeaVotes(String ideaId) {
        return new List<Vote>();
    }

	@AuraEnabled
	public static List<IdeaComment> getIdeaComments(String ideaId, String queryLimit, String fromDatetime) {
        return new List<IdeaComment>();
    }


	@AuraEnabled
    public static IdeaComment saveComment(String ideaId, String message) {
        return new IdeaComment();
    }

}