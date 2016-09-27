public without sharing class DLUtility {

     //This method will bring the contact record using account id
    
    public static List<Contact> getContactFromAcct(Id accId){
        
        List<Contact> cons = new List<Contact>([select Id, firstName, lastName, AccountId, email from Contact 
                                                where AccountId = :accId
                                                AND Primary_MBA_Contact__c = true]);
        
         return cons;

    }
      //This method will bring the contact record using account id
    
    public static Contact findPrimaryContactFromAcct(Id accId){
        
        List<Contact> cons = new List<Contact>([select Id, firstName, lastName, AccountId, email from Contact 
                                                where AccountId = :accId
                                                AND Primary_MBA_Contact__c = true Limit 1]);
        
         return cons[0];

    }   
    //This method will bring the subscription
    
    public static Id getSubfromStoreurl(String formUrl, String supportpin){
        
        String fullStoreUrl = 'http://' + formUrl;
        List<Subscription__c> subs = new List<Subscription__c> ([SELECT Id, Account__r.Id,  Contact__c,  Account__r.SupportPIN__c, StoreURL__c FROM Subscription__c
                                                                WHERE (StoreURL__c = :formUrl OR StoreURL__c = :fullStoreUrl)
                                                                AND Support_PIN__c = :supportpin 
                                                                AND Status__c = 'Active' LIMIT 1]);
         if (!subs.isEmpty())
           { return subs[0].Account__r.ID;}
           else 
           {return null;}

    }
    
 //This method will bring the opportunity with store url and support pin
    
    public static Opportunity getOppfromurlpin(String formUrl, String supportpin){
        
        Id ProfOppRecordTypeId =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
	    Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
	    Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
        
        Set<Id> notStoreRecIds = new Set<Id>();
	    notStoreRecIds.add(AppRecordTypeId);
	    notStoreRecIds.add(ProfOppRecordTypeId);
	    notStoreRecIds.add(UpgradeRecordTypeId);

        String fullStoreUrl = 'http://' + formUrl;
        List<Opportunity> opps = new List<Opportunity> ([SELECT Id, AccountId,   StoreURL__c, Subscription__c, Contact__c, Contact_Email__c , ProductId__c
        														FROM Opportunity 
        														WHERE SupportPIN__c =: supportpin AND (StoreURL__c = :formUrl OR StoreURL__c = :fullStoreUrl)
                    											AND Status__c = 'Active' 
                    											AND RecordTypeId not in :notStoreRecIds Limit 1 ]);
           if (!opps.isEmpty())
           { return opps[0];}
           else 
           {return null;}

    }
    
   //This method will bring the subscription with store url and support pin
    
    public static Subscription__c getSubfromurlpin(String formUrl, String supportpin){
        
        String fullStoreUrl = 'http://' + formUrl;
        List<Subscription__c> subs = new List<Subscription__c> ([SELECT Id, Account__c, Account__r.OwnerId, Support_PIN__c, StoreURL__c, Contact__c, Contact__r.Email, ProductId__c 
        														FROM Subscription__c 
        														WHERE Support_PIN__c =: supportPIN AND (StoreURL__c = :formUrl OR StoreURL__c = :fullStoreUrl)
		                    									AND Status__c = 'Active' LIMIT 1]);
         if (!subs.isEmpty())
           { return subs[0];}
           else 
           {return null;}

    }

    //This method will bring the contact record using account id and email. If it doesn't exist create it.
    
    public static Contact findContactByEmailAcct(Id accId, string emailaddress, string fname, string lname){
        
        Contact con = new Contact();
        Id accountOwnerId ;
        List<Contact> cons = new List<Contact>([select Id, firstName, lastName, AccountId, email, Account.OwnerId from Contact 
                                                where AccountId = :accId 
                                                ]);
         for (Contact c :cons)
         {
         	accountOwnerId = c.Account.OwnerId;
         	if (c.Email == emailaddress)
         	con = c;
         }
         return con;
    }

    public static User getUserbyName( String userName) {
 
    List<User> cusers;
    if(userName <> null) 
    {
       cusers = [SELECT Id,Email, Department FROM User WHERE name =:userName and isActive = true ];
    }
    if (cusers.isEmpty())
    {
       cusers = [SELECT Id,Email, Department FROM User WHERE name =:userName limit 1];
    }
    
     return cusers[0];
  }

    
    public static Map<String, PKB_Content__c > getPKBContentMap() {
 
    Map<String, PKB_Content__c > mapPKBContent = new Map<String, PKB_Content__c>();
    
    for ( PKB_Content__c pkbc :[Select p.Name, p.Id, p.Content__c, Text_Content__c, p.Active__c From PKB_Content__c p where Active__c = true])
    { 
         mapPKBContent.put(pkbc.Name, pkbc);
          
    }
    return mapPKBContent;
  }
    
    public static String  getDataCategoryByArtId(Id artId) 
    {
        List <Public__kav> peaList = new List <Public__kav> ([Select p.Id, (Select DataCategoryName From DataCategorySelections) From Public__kav p WHERE PublishStatus = 'Online' AND Language = 'en_US' and KnowledgeArticleId =:artId]) ;
        String dcsName ='';
        for (Public__kav pea :peaList)
        {
            for (Public__DataCategorySelection dcs : pea.DataCategorySelections)
            {
                dcsName = dcs.DataCategoryName;
            }
            
        }
        
        return dcsName;
    }
     
     public static String  getDataCategoryByArtIdUniv(Id artId) 
    {
        List <University__kav> peaList = new List <University__kav> ([Select p.Id, (Select DataCategoryName From DataCategorySelections) From University__kav p WHERE PublishStatus = 'Online' AND Language = 'en_US' and KnowledgeArticleId =:artId]) ;
        String dcsName ='';
        for (University__kav pea :peaList)
        {
            for (University__DataCategorySelection dcs : pea.DataCategorySelections)
            {
                dcsName = dcs.DataCategoryName;
            }
            
        }
        
        return dcsName;
    }
    
     public static String  getDataCategoryByArtIdComm(Id artId) 
    {
        List <Community_Article__kav> peaList = new List <Community_Article__kav> ([Select p.Id, (Select DataCategoryName From DataCategorySelections) From Community_Article__kav p WHERE PublishStatus = 'Online' AND Language = 'en_US' and KnowledgeArticleId =:artId]) ;
        String dcsName ='';
        for (Community_Article__kav pea :peaList)
        {
            for (Community_Article__DataCategorySelection dcs : pea.DataCategorySelections)
            {
                dcsName = dcs.DataCategoryName;
            }
            
        }
        
        return dcsName;
    }
    public static String  getDataCategoryByArtId(Id artId, string articleTypeName) 
    {
        String dcsName ='';
        if (articleTypeName.contains('Public')) dcsName = getDataCategoryByArtId(artId);
        else
        if (articleTypeName.contains('University')) dcsName = getDataCategoryByArtIdUniv(artId);
        else
        if (articleTypeName.contains('Community')) dcsName = getDataCategoryByArtIdComm(artId);
               
        return dcsName;
    }
    
    public static List <University__kav>  getUnivArticles(String datacat) 
    {
        List <University__kav> peaList = new List <University__kav> ([Select Id, UrlName, Short_Title__c, Short_Description__c , Sort_Order__C ,Thumbnail_Image_URL__c, Video_Duration__c, (Select DataCategoryName From DataCategorySelections) 
                                                                        From University__kav p 
                                                                        WHERE PublishStatus = 'Online' AND Language = 'en_US'
                                                                        ORDER by Sort_Order__c]) ;
        List <University__kav> artList = new List <University__kav>();
        
        for (University__kav pea :peaList)
        {
            for (University__DataCategorySelection dcs : pea.DataCategorySelections)
            {
                if (dcs.DataCategoryName == datacat)
                artList.add(pea);
            }
            
        }
        
        return artList;
    }
    
    public static Map<String, List<University__kav>>  getUnivArticles() 
    {
        Map<String, List<University__kav>>  mapArtList = new Map <String, List<University__kav>>();
        
        List <University__kav> peaList = new List <University__kav> ([Select Id, UrlName, Short_Title__c, Short_Description__c , Sort_Order__C ,Thumbnail_Image_URL__c, Video_Duration__c, (Select DataCategoryName From DataCategorySelections) 
                                                                        From University__kav p 
                                                                        WHERE PublishStatus = 'Online' AND Language = 'en_US'
                                                                        ORDER by Sort_Order__c]) ;
        List <University__kav> artList1 = new List <University__kav>();
        List <University__kav> artList2 = new List <University__kav>();
        List <University__kav> artList3 = new List <University__kav>();
        List <University__kav> artList4 = new List <University__kav>();
        
        String dcname1 = Label.University_Article_Category_1;
        String dcname2 = Label.University_Article_Category_2;
        String dcname3 = Label.University_Article_Category_3;
        String dcname4 = Label.University_Article_Category_4;
        
        for (University__kav pea :peaList)
        {
            
            for (University__DataCategorySelection dcs : pea.DataCategorySelections)
            {
                
                
                if (dcs.DataCategoryName == dcname1)
                    artList1.add(pea);
                else if (dcs.DataCategoryName == dcname2)
                    artList2.add(pea);
                else if (dcs.DataCategoryName == dcname3)
                    artList3.add(pea);
                else if (dcs.DataCategoryName == dcname4)
                    artList4.add(pea);
            }
            
        }
        
        mapArtList.put(dcname1, artList1);
        mapArtList.put(dcname2, artList2);
        mapArtList.put(dcname3, artList3);
        mapArtList.put(dcname4, artList4);
        
        return mapArtList;
    }
    
}