public without sharing class CaseStartWorkingController 
{   
    private static final Id USERID = UserInfo.getUserId();
    private static final User CURUSER = [SELECT Id, Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
    private ApexPages.StandardController controller;
    public Case objCase;
    public Id objCaseId;
    
    public CaseStartWorkingController(ApexPages.StandardController cntrl) 
    {
        controller = cntrl;
        objCase = (Case)cntrl.getRecord();
        objCaseId = cntrl.getId();
    }
    
    public pageReference initPage()
    {
        pageReference pr = null;
        
        system.debug('***CaseStartWorkingController:initPage - objCaseId: ' + objCaseId);
        if (objCaseId != null)
        {
            set<Id> stCaseIds = new set<Id>();
            stCaseIds.add(objCaseId);
            
            try
            {
                CaseHandle_Helper.case_StartWorking(stCaseIds);
 //               pr = controller.cancel();
            }
            catch(Exception exc)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to set the case to be worked....Please contact your support department');
                ApexPages.addMessage(myMsg);
                system.debug('***ERROR: CaseStartWorkingController:initPage: ' + exc.getStackTraceString());
            }
        }
        pr= new PageReference('/apex/BCNewComment2?id='+objCaseId);
        return pr;
    }
//This ifrom the override button for E2CP new comment button
      public pageReference initRecord()
    {
        pageReference pr = null;
        
        system.debug('***CaseStartWorkingController:initPage - objCaseId: ' + objCaseId);
        if (objCaseId != null)
        {
            set<Id> stCaseIds = new set<Id>();
            stCaseIds.add(objCaseId);
            
            try
            {
//                stopWorking(stCaseIds);
                CaseHandle_Helper.case_StartWorking(stCaseIds);
 //               pr = controller.cancel();
            }
            catch(Exception exc)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error occurred trying to set the case to be worked....Please contact your support department');
                ApexPages.addMessage(myMsg);
                system.debug('***ERROR: CaseStartWorkingController:initRecord: ' + exc.getStackTraceString());
            }
        }
        string newurl = '/apex/E2CP__New_Comment?id=' +objCaseId ;
        pr = new PageReference(newurl);
        return pr;
    }
 /*   
    private void stopWorking(Set<Id> caseIds)
    {
            
    // Make sure to set the DML Options to not send any emails
            database.Dmloptions dml = new database.Dmloptions();
            dml.emailHeader.triggerAutoResponseEmail = false;
            dml.emailHeader.triggerUserEmail = false;
            dml.emailHeader.triggerOtherEmail = false;
            
   //       list<Case> lstCaseToUpdate = new list<Case>();
  //        objCase.setOptions(dml);
            
   //       lstCaseToUpdate.add(objCase);
            
  //          database.update(lstCaseToUpdate, dml);
            
            CaseHandle_Helper.case_StopWorkingAllOpenTime(caseIds);
    }
    */
}