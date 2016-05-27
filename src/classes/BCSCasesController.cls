public with sharing class BCSCasesController {

    public Case selectedCase { get; set; }
    public User CurrentUser {get; set;}
    public String selectedtab {get;set;}
    Pagereference pageref {get;set;}
    
    public BCSCasesController() {
        
        selectedtab ='My Open Cases';
        CurrentUser = [Select u.Name,u.profileid, u.Username,u.usertype, u.Phone,  u.LastName, u.Id, u.FirstName, u.Email, u.Contact.AccountID, u.Contact.Id, u.Contact.Phone, u.Contact.Account.Name From User u where Id = :UserInfo.getUserId()];
        
        //if(currentUser.profileid==label.Community_User_Profile)
        if(CurrentUser.userType == 'Guest')
        pageref = Page.BCSLOGIN;
        else
        pageref = null;
    }
 /*      
    public Case[] getMyOpenCases() {
        return [SELECT Id, Subject, Status FROM Case WHERE OwnerId = :UserInfo.getUserId()
            AND Status != 'Closed'];
    }
    
    public Case[] getMyClosedCases() {
        return [SELECT Id, Subject, Status FROM Case WHERE OwnerId = :UserInfo.getUserId()
            AND Status = 'Closed'];
    }
    
 
    public PageReference viewCase() {
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        selectedCase = [SELECT Id FROM Case WHERE Id = :caseId];
        return null;
    }
     */  
            
    public List<Case> getMyClosedCases()
    {
        try {
            return [Select c.Id, c.Subject, c.Status, c.CreatedDate, c.CreatedBy.Name, c.CreatedById, c.ClosedDate,  c.CaseNumber, c.AccountId From Case c 
                                    where c.RecordTypeId = :Label.CS_Record_Type and IsClosed = true  
                                    and  Department__C <> 'Legal/Abuse' 
                                    and  Documentation_Only__c = false
                                    order by CreatedDate desc limit 500];
        } 
        catch (Exception exp) 
        {
            return null;
        }
    }
    public List<Case> OpenCases;
    
    public List<Case> getMyOpenCases()
    {
        try {
            if (OpenCases == null){
                OpenCases = ([Select c.Id, c.Subject, c.Status, c.CreatedDate, c.CreatedBy.Name, c.CreatedById, c.ClosedDate, c.CaseNumber, c.AccountId From Case c 
                				WHERE IsClosed = false and c.RecordTypeId = :Label.CS_Record_Type  
                				and  Department__C <> 'Legal/Abuse' 
                				and  Documentation_Only__c = false
                				order by CreatedDate desc limit 500]);
               }                
            return OpenCases;
        } 
        catch (Exception exp) 
        {
            return null;
        }
    }
    
    public pagereference redirect(){
        return pageref;
    }
}