/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest(SeeAllData=true)
private class ArticlePageControllerTest {

    static testMethod void myUnitTest() {
       
     ArticlePageController acon = new ArticlePageController ();
     
      University__kav ukav = [Select Id , KnowledgeArticleId
                              From University__kav  
                              WHERE PublishStatus = 'Online' AND Language = 'en_US'
                              limit 1];
       acon.karticleId = ukav.KnowledgeArticleId;
       acon.karticleType = 'University__kav';                                                                  
       acon.getKArticle(); 
       
       Public__kav pkav = [Select Id , KnowledgeArticleId
                              From Public__kav  
                              WHERE PublishStatus = 'Online' AND Language = 'en_US'
                              limit 1];
       acon.karticleId = pkav.KnowledgeArticleId;
       acon.karticleType = 'Public__kav';                                                                  
       acon.getKArticle(); 
       
       Learning__kav lkav = [Select Id , KnowledgeArticleId
                              From Learning__kav  
                              WHERE PublishStatus = 'Online' AND Language = 'en_US'
                              limit 1];
       acon.karticleId = lkav.KnowledgeArticleId;
       acon.karticleType = 'Learning__kav';                                                                  
       acon.getKArticle();
        
    }
}