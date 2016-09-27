public class PortalNoticeGenerator {
    
    public String topic {get;set;}
    public Boolean noNotice {get;set;}
   
    public Map<String, PKB_Content__c>  mapPKBContent  {get;set;}
    
    public PortalNoticegenerator(){
     
     
        mapPKBContent = DLUtility.getPKBContentMap();
        
      
    }
    
    public PKB_Content__c portalContent {get;set;}
    
    public PKB_Content__c getContentByName{ 
        get { 
            noNotice= false;
            portalContent = mapPKBContent.get(topic);
 			if (portalContent == null)
 			{ 
 				noNotice=true;
 				return null;
 			}
            else return portalContent;}
    }
    
}