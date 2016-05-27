public with sharing class ArticlePageHelper {
	
	//Used by ArticlePageController    
    public static University__kav  getUnivArticle(String artId) 
    {
        List <University__kav> artList = new List <University__kav> ([Select Id, Title, Description__c , UrlName, ArticleType, Prev_Video_URL__c,  Prev_Video_Thumbnail__c, Prev_Video_Link_Text__c, Next_Video_URL__c,Next_Video_Thumbnail__c,Next_Video_Link_Text__c,Additional_Resources__c,Video_URL__c
                                                                        From University__kav p 
                                                                        WHERE PublishStatus = 'Online' AND Language = 'en_US'
                                                                        and KnowledgeArticleId =:artId Limit 1]) ;
        
               
        return artList[0];
    }
    
    public static Public__kav  getPublicArticle(String artId) 
    {
        List <Public__kav> artList = new List <Public__kav> ([Select Id, Title, Feedback_Visible__c,   Article__c, Summary, UrlName, ArticleType, ArticleNumber, KnowledgeArticleId
                                                              From Public__kav p 
                                                              WHERE PublishStatus = 'Online' AND Language = 'en_US'
                                                              and KnowledgeArticleId =:artId Limit 1]) ;
        
               
        return artList[0];
    }
    
    public static Learning__kav  getLearnArticle(String artId) 
    {
        List <Learning__kav> artList = new List <Learning__kav> ([Select Id, Title, Nav_Title__c, ArticleType, UrlName, Chapter__c, Chapter_List__c,  Next_Button_URL__c,Back_Button_URL__c, Next_Button_Text__c, Article__c
                                                              	From Learning__kav p 
                                                              	WHERE PublishStatus = 'Online' AND Language = 'en_US'
                                                              	and KnowledgeArticleId =:artId Limit 1]) ;
             return artList[0];
    }                                                      
 // end ArticlePageController methods
    
}