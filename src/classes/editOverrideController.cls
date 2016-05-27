public class editOverrideController{
    private final Case caseObj;
    public Map<String, String> params{get;set;}
    
    //Constructor
    public editOverrideController(ApexPages.StandardController stdController) {
        
        //Get the case information
        this.caseObj = (Case)stdController.getRecord();
        
        //Get all the parameters from the url
        PageReference pg = ApexPages.currentPage();
        params = new Map<String, String>();
        params = pg.getParameters();
   
    }
    
    //Method to create log and navigate to the case
    Public PageReference createLog(){
    
    //Get the profile name for current user
    Profile pr = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    
    set<Id> stCaseIds = new set<Id>();
    if (caseObj.Id != null){
      stCaseIds.add(caseObj.Id);
    }
   
     PageReference pageRef;
    //Check if the profile name contains Client success
    if( Label.Custom_Edit_Cases_Profiles.contains(pr.Name)){
     
     //Call the method creating the log
     CaseHandle_Helper.case_StartWorking(stCaseIds);
      pageRef = new PageReference('/apex/E2CP__New_Comment?id='+ caseObj.Id+'&scontrolCaching=1&core.apexpages.devmode.url=1');
    
    }
    else{
         pageRef = new PageReference('/'+caseObj.Id+'/e?retURL='+params.get('retURL')+'&nooverride=1');
   }
    return pageRef;
    
    }
}