@isTest
private class BatchKnowledgeGlobalSearchAndReplaceTest {
    static List<String> getArticleTypes(){
        // Iterate through all defined article types and return first with at least one custom text field
        List<String> listArticleTypes = new List<String>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
        if(globalDescribe != null && !globalDescribe.isEmpty()){
            for(String key : globalDescribe.keySet()){
                if(key.endsWith('__kav')){
                    System.debug('Article Type='+key);
                    sObject sArticleType = Schema.getGlobalDescribe().get(key).newSObject();
                    Schema.DescribeSObjectResult r = sArticleType.getSObjectType().getDescribe();                    
                    Map<String, Schema.SObjectField> mapFields = r.fields.getMap();
                    for (Schema.SObjectField field : mapFields.values()) {
                        Schema.DescribeFieldResult f = field.getDescribe();
                        System.debug('Field Name(getArticleTypes)='+f.getName());
                        System.debug('Field Type(getArticleTypes)='+f.getType());
                        if (f.getName().equalsIgnoreCase('Title')) continue;
                        if (f.getName().equalsIgnoreCase('UrlName')) continue;
                        if (f.getName().equalsIgnoreCase('ArticleNumber')) continue;
                        if (f.getName().toLowerCase().endsWith('name__s')) continue;
                        if (f.getType() == Schema.DisplayType.String || 
                            f.getType() == Schema.DisplayType.TextArea) {
                            listArticleTypes.add(key+','+f.getName());
                            break; // Only need first text field for test
                        }
                    }
                }
            }
        }
        
        return listArticleTypes;
    }
    
    static testMethod void runPositiveTestCase() {
    
        List<String> listArticleTypes = getArticleTypes();
        System.assertNotEquals(listArticleTypes.size(), 0);
        
        String strArticleType = listArticleTypes[0].substring(0,listArticleTypes[0].indexOf(','));
        String strSearchField = listArticleTypes[0].substring(listArticleTypes[0].indexOf(',')+1);
        
        System.debug('strArticleType='+strArticleType);
        System.debug('strSearchField='+strSearchField);
        
        String strPublishStatus = 'Draft';
        String strLanguage = 'en_US';
        Boolean bPublishNewVersion = false;
        Boolean bMultiLingualKB = true;
    
        // Create a new draft article for testing purposes
        
        String strArticleTitle = 'Knowledge Global Search and Replace Test Article';
        String strArticleUrlName = 'Knowledge-Global-Search-and-Replace-Test-Article';
        String strSearchString = 'is for testing purposes only';
        String strReplacementString = 'was modified during test';
        String strOriginalFieldValue = 'This article '+strSearchString; 
        String strFinalFieldValue = 'This article '+strReplacementString; 
      
        sObject objNewArticle = Schema.getGlobalDescribe().get(strArticleType).newSObject();
        
        objNewArticle.put('Title',strArticleTitle);
        objNewArticle.put('UrlName',strArticleUrlName);
        objNewArticle.put(strSearchField, strOriginalFieldValue);
        
        // Define values for all mandatory fields (required as of Winter 2014)
        Schema.DescribeSObjectResult r = objNewArticle.getSObjectType().getDescribe();                    
        Map<String, Schema.SObjectField> mapFields = r.fields.getMap();
        for (Schema.SObjectField field : mapFields.values()) {
            Schema.DescribeFieldResult f = field.getDescribe();
            System.debug('Field Name='+f.getName());
            System.debug('Field Type='+f.getType());
            System.debug('Field isNillable='+f.isNillable());
            
            if (f.isCustom() && !f.isNillable()) {
                String fieldName = f.getName();
                Schema.DisplayType fieldType = f.getType();
                
                if (fieldType == Schema.DisplayType.String)   {objNewArticle.put(fieldName, 'Test'); continue;}
                if (fieldType == Schema.DisplayType.TextArea) {objNewArticle.put(fieldName, 'Test'); continue;}    
                if (fieldType == Schema.DisplayType.Email)    {objNewArticle.put(fieldName, 'anyone@abc.com'); continue;}
                if (fieldType == Schema.DisplayType.Double)   {objNewArticle.put(fieldName, 0); continue;}
                if (fieldType == Schema.DisplayType.Integer)  {objNewArticle.put(fieldName, 0); continue;}    
                if (fieldType == Schema.DisplayType.Percent)  {objNewArticle.put(fieldName, 0); continue;}                                                
                if (fieldType == Schema.DisplayType.Currency) {objNewArticle.put(fieldName, 0); continue;}                    
                if (fieldType == Schema.DisplayType.Date)     {objNewArticle.put(fieldName, Date.today()); continue;}
                if (fieldType == Schema.DisplayType.DateTime) {objNewArticle.put(fieldName, DateTime.now()); continue;}                
                if (fieldType == Schema.DisplayType.Phone)    {objNewArticle.put(fieldName, '800-555-1212'); continue;}   
                if (fieldType == Schema.DisplayType.URL)      {objNewArticle.put(fieldName, 'http://www.salesforce.com');  continue;}  
  
            }
        }                 

        insert(objNewArticle);

        // Retrieve new draft article
        sObject[] listDraftArticle = 
            Database.query('SELECT Id, KnowledgeArticleId, '+strSearchField+' FROM '+strArticleType
                + ' WHERE Title=\''+strArticleTitle+'\''
                + ' AND PublishStatus=\''+strPublishStatus+'\''
                + ' AND Language=\''+strLanguage+'\' LIMIT 1');
        
        System.assertEquals(listDraftArticle.size(), 1);
        Id draftArticleId = listDraftArticle[0].Id;
        String strKnowledgeArticleId = (String)listDraftArticle[0].get('KnowledgeArticleId');
        
        // Perform search and replace operation on draft
        Id batchId = null;
        Boolean bSearchOnly = false;

        BatchKnowledgeGlobalSearch batch =
            new BatchKnowledgeGlobalSearch(bSearchOnly, bPublishNewVersion, bMultiLingualKB,
                strArticleType, strPublishStatus, strLanguage, 
                strSearchField, strSearchString, strReplacementString);
                
        batchId = Database.executeBatch(batch, 500); 
        System.assertNotEquals(batchId, null);        

        // Perform search and replace on published article        
        
        strPublishStatus = 'Online';
        KbManagement.PublishingService.publishArticle(strKnowledgeArticleId, bPublishNewVersion);
        
        batch =
            new BatchKnowledgeGlobalSearch(bSearchOnly, bPublishNewVersion, bMultiLingualKB,
                strArticleType, strPublishStatus, strLanguage, 
                strSearchField, strSearchString, strReplacementString);
                
        batchId = Database.executeBatch(batch, 500); 
        System.assertNotEquals(batchId, null);

    }
}