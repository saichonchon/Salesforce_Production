public class JSONParserUtil {
    
    public static integer pagenum;
    public static void promoterioCallout() {
		Integer i=0;
        Integer j=0;
        Integer t =0;
         
          if(pagenum==null){
              pagenum=0;
          }
		PromoterioSettings__c pioSettings = PromoterioSettings__c.getOrgDefaults();
        Boolean Alltime = pioSettings.Fetch_All__c;        
		String SpecificCampaign;
          if( pioSettings.Specific_Campaign_ID__c != null ){
               SpecificCampaign = pioSettings.Specific_Campaign_ID__c; 
          } 		
             Http httpProtocol = new Http();
            // Create HTTP request to send.
            HttpRequest request = new HttpRequest();
            // Set the endpoint URL.
            String endpoint;
          if(SpecificCampaign!=null){
              endpoint = pioSettings.End_Point__c+'?&survey__campaign='+SpecificCampaign; 
          }	else {
              endpoint = pioSettings.End_Point__c;
          }          
            request.setHeader('Authorization', 'Token '+pioSettings.Token__c);
            request.setEndPoint(endpoint);
            // Set the HTTP verb to GET.
            request.setMethod('GET');
            // Send the HTTP request and get the response.
            // The response is in JSON format.
            HttpResponse response = httpProtocol.send(request);
            // Parse entire JSON response.
            JSONParser parser = JSON.createParser(response.getBody());
            jsonresponse jres = (jsonresponse)parser.readValueAs(jsonresponse.class);
            if(jres.count!=null){
                t=math.round(jres.count/100);
            } 
          List< Promoter_io_Callout__c> picList = new List< Promoter_io_Callout__c>();
          Datetime SessionTime = system.now();        
          if(pioSettings.Last_Run_On__c!=null){pioSettings.Previous_Run_Date__c = pioSettings.Last_Run_On__c.date();}
          pioSettings.Last_Run_On__c = SessionTime;
          upsert pioSettings;
          
          for(integer l=1;l<t+2;l++){
              pagenum=pagenum+1;
              Promoter_io_Callout__c  pic = new Promoter_io_Callout__c();
              if(SpecificCampaign!=null){
              	pic.API_URL__c = pioSettings.End_Point__c+'?page='+pagenum+'&survey__campaign='+SpecificCampaign; 
              } else {
              	pic.API_URL__c = pioSettings.End_Point__c+'?page='+pagenum;
              }
              pic.Session_Time__c = SessionTime;
              pic.PageNumber__c = pagenum;
              pic.Unique_ID__c = SessionTime+'-'+pagenum;
              picList.add(pic);
          }
          if(!picList.isEmpty()){
              upsert picList Unique_ID__c;
          }
    	} 
    

	public static List<Promoter_io_Feedback__c> promoterioJSONParser(integer pagenumf) {

        Boolean stoplooping;
        promoterioSettings__c pioSettings = promoterioSettings__c.getOrgDefaults();
		String SpecificCampaign;
          if( pioSettings.Specific_Campaign_ID__c != null ){
               SpecificCampaign = pioSettings.Specific_Campaign_ID__c; 
          }  
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        system.debug('>><< pagenumf for endpoint is = '+pagenumf);
        String endpoint;
        if(SpecificCampaign!=null){
            endpoint = pioSettings.End_Point__c+'?page='+pagenumf+'&survey__campaign='+SpecificCampaign;
        } else {
        	endpoint = pioSettings.End_Point__c+'?page='+pagenumf;
        }
        request.setHeader('Authorization', 'Token '+pioSettings.Token__c);
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(response.getBody());
        jsonresponse jres = (jsonresponse)parser.readValueAs(jsonresponse.class);

        List<Promoter_io_Feedback__c> piofList = new List<Promoter_io_Feedback__c>();
        set<string> feedbackidset = new set<string>();
        
        Date cutoffdate;
        if(pioSettings.Previous_Run_Date__c!=null){
            cutoffDate = pioSettings.Previous_Run_Date__c.addDays(-1);
        } else {
            cutoffDate = system.today().addYears(-1);
        }
        if(jres.results!=null){
            for(cls_results res:jres.results){
                if(!feedbackidset.contains(res.campaign+'-'+res.id)&&res.posted_date.date()>cutoffDate){
                    Promoter_io_Feedback__c piof = new Promoter_io_Feedback__c();
                    piof.Campaign_External_ID__c = res.campaign;
                    piof.Comment__c = res.comment;
                    piof.Contact_External_ID__c  = res.Contact.id;
                    if(res.Contact.attributes.SF_AccountID!=null){
                    	piof.SF_Account_ID__c = res.Contact.attributes.SF_AccountID;
                    } else if(res.Contact.attributes.SF_Account_ID!=null){
                        piof.SF_Account_ID__c = res.Contact.attributes.SF_Account_ID;
                    }
                    if(res.Contact.attributes.SF_Contact_Id!=null){
                    	piof.SF_Contact_ID__c = res.Contact.attributes.SF_Contact_Id;
                    }
                    piof.Email__c = res.Contact.email;
                    piof.Feedback_Unique_External_ID__c = res.campaign+'-'+res.id;
                    piof.Feedback_ID__c = res.id;
                    piof.Feedback_URL__c = res.followup_href;
                    piof.FirstName__c = res.Contact.first_name;
                    piof.LastName__c = res.Contact.last_name;
                    piof.Posted_Date__c = res.posted_date;
                    piof.Score__c = res.score;
                    piof.Score_Type__c = res.score_type;
                    if(res.Contact.attributes.StoreID!=null){
                    	piof.Store_ID__c = res.Contact.attributes.StoreID;
                    } else if(res.Contact.attributes.Store_ID!=null){
                        piof.Store_ID__c = res.Contact.attributes.Store_ID;
                    }
                    piof.Session_Time__c = pioSettings.Last_Run_On__c;
                    feedbackidset.add(res.campaign+'-'+res.id);
                    piofList.add(piof);
                }
            }

        } else {
            if(jres.next==null){
            	stoplooping=true; 
        	}
        }
        return piofList;
    } 
    
    // Inner classes used for serialization by readValuesAs(). 
    
    public class jsonresponse {
        public integer count;
        public string next;
        public String previous;
        public List<cls_results> results;      
    }  
    
    public class cls_results {
        public String campaign;
        public Integer score;
        public String score_type;
        public String comment;
        public Datetime posted_date;
        public con Contact;  
        public string id;
        public string followup_href;
    }  
    
    public class Con {
        public String first_name;
        public String last_name;
        public String email;
        public string id;
        Public cls_attributes attributes;
    }  
    
    public class cls_attributes {
        public String SF_AccountID;
        public String SF_account_id;
        public String sf_contact_id;
        public String StoreID;
        public String Store_ID;
        public String StoreAcctNum;
    }
    
    public static List<Case> assignFeedbackToCase(List<Case> cases){
        List<Case> caseList = (List<Case>)cases;
        List<Case> updateCaseList = new List<Case>();
        Set<Id> conIds = new Set<Id>();
        for(Case cs:caseList){
            conIds.add(cs.contactid);
        }
        Map<String,Promoter_io_Feedback__c> MapFeedbacktoCon = new Map<String,Promoter_io_Feedback__c>();
       	List<Promoter_io_Feedback__c> listPioFeedbacks = new List<Promoter_io_Feedback__c>([Select id, contact__c,contact__r.id, Subscription__c, Posted_Date__c  from Promoter_io_Feedback__c where Contact__c in :conIds and id NOT in (select Promoter_io_Feedback__c from Case where Contactid in :conIds)]);
        for(Promoter_io_Feedback__c piof:listPioFeedbacks){
            if(piof.Contact__r.id!=null&&piof.Posted_Date__c!=null){
                MapFeedbacktoCon.put(string.valueOf(piof.Contact__r.id).left(15)+'-'+string.valueOf(piof.Posted_Date__c.date()),piof);
            }
        }

        if(!caseList.isEmpty()){
            for(case cs:caseList){
                if(cs.contactid!=null&&cs.Promoter_io_Feedback_Date__c!=null){
                    if(MapFeedbacktoCon.get(string.valueOf(cs.ContactId).left(15)+'-'+string.valueOf(cs.Promoter_io_Feedback_Date__c))!=null){
                        cs.Promoter_io_Feedback__c = MapFeedbacktoCon.get(string.valueOf(cs.ContactId).left(15)+'-'+string.valueOf(cs.Promoter_io_Feedback_Date__c)).id;

                        if(MapFeedbacktoCon.get(string.valueOf(cs.ContactId).left(15)+'-'+string.valueOf(cs.Promoter_io_Feedback_Date__c)).Subscription__c !=null&&cs.Subscription__c==null){
                            cs.Subscription__c = MapFeedbacktoCon.get(string.valueOf(cs.ContactId).left(15)+'-'+string.valueOf(cs.Promoter_io_Feedback_Date__c)).Subscription__c;
                        }                        
                    }
                    updateCaseList.add(cs);
                }
            }
  
        } 
        
        return updateCaseList;
    }
}