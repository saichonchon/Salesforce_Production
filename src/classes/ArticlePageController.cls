public with sharing class ArticlePageController {
	
  	public KnowledgeArticleRecord kar { get; set; }
//   	public String searchText 		{ get; set; }
//  	public pkb_controller pkbcon 	{get;set;}
  	public Id karticleId 			{get;set;}
  	public String karticleType 		{get;set;}
   	 
	public ArticlePageController() {
//		String qryString = 'SELECT Id, title, UrlName, Summary, ArticleType FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\' )';
//  		List<KnowledgeArticleVersion> articleList= Database.query(qryString);
  
  	}
  	 
  	public PageReference getKArticle()
  	{
	   kar = new KnowledgeArticleRecord ();
	   system.debug( '### article Id' + karticleId);
	   system.debug( '### article Type' + karticleType);
//	    karticleId = 'kA613000000TPV0';
//	    karticleType = 'Public_kav';
	     
	   if (karticleType == 'Public__kav')
	   {   
	       Public__kav kav = new Public__kav(); 
	       kav = ArticlePageHelper.getPublicArticle(karticleId);
	       kar = new KnowledgeArticleRecord(kav);
	   }  
	   else if (karticleType == 'University__kav')  
	   {
	   		University__kav kav = new University__kav(); 
	   		kav = ArticlePageHelper.getUnivArticle(karticleId);
	   		kar = new KnowledgeArticleRecord(kav);
	   }
	   else if (karticleType == 'Learning__kav')  
	   {
	   		Learning__kav kav = new Learning__kav(); 
	   		kav = ArticlePageHelper.getLearnArticle(karticleId);
	   		kar = new KnowledgeArticleRecord(kav);
	   }
	      
	      system.debug('kar'+kar.Id);
	      return null;
	    
  	}
 	
     
 

  public class KnowledgeArticleRecord {
    public String id                     { get; set; } 
    public String title                  { get; set; }
    public String summary                { get; set; }
    public String urlName                { get; set; }
    public String articleTypeName        { get; set; }
    
    public string Nav_Title				{ get; set; }
    public string FeedbackVisible		{ get; set; }
    public string chapterList 			{ get; set; }
    public string  nextButtonUrl 		{ get; set; }
    public string  backButtonUrl 		{ get; set; }
    public string  nextButtonText		{ get; set; }
    public string  Addition_Resources	{ get; set; }
    public string  description 			{ get; set; }
    public string Prev_Video_URL		{ get; set; }
    public string Prev_Video_Thumbnail	{ get; set; }
    public string  Prev_Video_Link_Text	{ get; set; }
    public string  Next_Video_URL		{ get; set; }
    public string  Next_Video_Thumbnail { get; set; }
    public string Next_Video_Link_Text	{ get; set; }
    public string Additional_Resources	{ get; set; }
    public string  Video_URL			{ get; set; }
    public string  Chapter				{ get; set; }
    
    public String Article_kar			{ get; set; }
//    public String articleNumber          { get; set; }
    public Id	kavId		 			{ get; set; }
  
    // ctor for empty KAD
    public KnowledgeArticleRecord() { }

   
    public KnowledgeArticleRecord(Public__kav kav) {
      init(kav);
    }
	
	public KnowledgeArticleRecord(University__kav kav) {
      initUniv(kav);
    }
	
	public KnowledgeArticleRecord(Learning__kav kav) {
      initLearn(kav);
    }
	public void init(Public__kav kav) {
        
      id = kav.Id;
      title = kav.Title;
      summary = kav.Summary;
      urlName = kav.UrlName;
      articleTypeName = kav.ArticleType;
      article_kar = kav.Article__c;
//      articleNumber = kav.ArticleNumber;
      FeedbackVisible= kav.Feedback_Visible__c;
      kavId = kav.KnowledgeArticleId;
    }
    public void initlearn(Learning__kav kav) {
 
      id = kav.Id;
      title = kav.Title;
//      summary = kav.Summary;
      urlName = kav.UrlName;
      articleTypeName = kav.ArticleType;
 	  Nav_Title	= kav.Nav_Title__c;
      chapterList = kav.Chapter_List__c; 
      nextButtonUrl = kav.Next_Button_URL__c;
      backButtonUrl = kav.Back_Button_URL__c; 
      nextButtonText = kav.Next_Button_Text__c;
      article_kar = kav.Article__c;
      Chapter = kav.Chapter__c;
 //     articleNumber = kav.ArticleNumber;
//      FeedbackVisible= kav.Feedback_Visible__c;
//      kavId = kav.KnowledgeArticleId;
    }
    public void initUniv(University__kav kav) {
  
      id = kav.Id;
      title = kav.Title;
//      summary = kav.Summary;
      urlName = kav.UrlName;
      articleTypeName = kav.ArticleType;
	  description = kav.Description__c ;
	  Prev_Video_URL = kav.Prev_Video_URL__c;
	  Prev_Video_Thumbnail = kav.Prev_Video_Thumbnail__c;
	  Prev_Video_Link_Text = kav.Prev_Video_Link_Text__c; 
	  Next_Video_URL = kav.Next_Video_URL__c;
	  Next_Video_Thumbnail = kav.Next_Video_Thumbnail__c;
	  Next_Video_Link_Text= kav.Next_Video_Link_Text__c;
	  Additional_Resources = kav.Additional_Resources__c;
	  Video_URL =kav.Video_URL__c;

//    articleNumber = kav.ArticleNumber;
//     FeedbackVisible= kav.Feedback_Visible__c;
//     kavId = kav.KnowledgeArticleId;
    }
  }
	
    
}