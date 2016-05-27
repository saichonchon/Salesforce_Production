public class RG_BCSViewcaseDetailsController {
    
    ///############### THIS CONTROLLER IS USED BY BCSVIEWCASEDETAILS PAGE. ###############///
    ///############### AUTHOR***********R G****APPLIKONTECH.COM*****************###############///
    ///############### DATE*************9-JULY-2014************************###############///
    
     public   Boolean isErrorwhileUploading{get;set;}
     public  Blob CaseFileContent{get;set;} 
     public  String CasefileName{get;set;}
     public  boolean isAttacted  {set;get;}
     public list<CaseComment> previouscomments{get;set;}
     public boolean nopreviouscomments {get;set;}
      Case caserecord;
      public CaseComment casecomment {get;set;}
     
     public RG_BCSViewcaseDetailsController(ApexPages.StandardController Controller){
        nopreviouscomments = false;
        caserecord = (Case)Controller.getRecord();
        casecomment = new caseComment(parentid=caserecord.id);
        previouscomments = [select CommentBody,createddate from casecomment where parentid=:caserecord.id order by createddate desc];
        if(previouscomments.size()<1)
        nopreviouscomments = true; 
     }
     
     public pagereference AttachFileToCase(){
        isErrorwhileUploading = true;
       isAttacted  =false;
       if(CaseFileContent != null)
       { 
            try {
                //Attaching file with case
                Attachment  newattch = new Attachment();
                newattch.Body = CaseFileContent;
                newattch.Name = CasefileName;
                // newattch.IsPrivate = false;
                newattch.ParentId = caserecord.id ;
                insert newattch;       
                CaseFileContent  = null;     
                isAttacted  = true ; 
            }
            catch(Exception e){ApexPages.addMessages(e);return null ;}
      }
      else{     
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file and click upload') ;
            ApexPages.addMessage(errormsg) ;   

            return null ;   
         }   
      ApexPages.Message infoMsg = new ApexPages.Message(ApexPages.severity.Info, 'Thank you! Your file is now attached to the case.') ;
      ApexPages.addMessage(infoMsg) ; 
      return null ; 
     }
     
     public pagereference submitcomment(){
         isErrorwhileUploading = true ;
        CaseFileContent  = null ;
       /* 
        if(!isAttacted){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file and click upload') ;
            ApexPages.addMessage(errormsg) ;   
            return null ;
        }
        */ 
        try{
            insert casecomment;
        }catch(DMLException e){                             
             ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Error Inserting Case Comment. please contact administrator.') ;
            ApexPages.addMessage(errormsg) ;   
        }
        return Page.BCSViewCases;
     }
}