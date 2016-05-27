/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String formUrl {get; set;}
    public String formError {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
//    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String communityNickname {get;set;}
    public String supportpin {get;set;}
    public List<Contact> cons {get;set;}
    public Id accountId {get;set;}
    public Boolean webFormOn { get; set; }
    
    public  SubmitCaseController SubmitCaseCtr {get;set;}
     
    public CommunitiesSelfRegController() 
    {
        webFormOn = False;
    
    }
     
    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    public PageReference authenticateUser() {
    
        
        Boolean isValidSupportPin = true;
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; // To be filled in by customer.
        
        formUrl = formURLFormatter(formUrl);
        accountId = ValidatePin();
        
        system.debug(' account id ' +accountId); 
        if (accountId == null)
        { 
//          accountId = cons[0].AccountId;
            
//          if (supportpin <> cons[0].Account__r.SupportPin__c)
                isValidSupportPin = false;
        }
        
        if (!isValidSupportPin) {
            formError = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, formError);
            ApexPages.addMessage(msg);
            return null;
        }  
        
             
       cons = DLUtility.getContactFromAcct(accountId);
//      List<Contact> cons = Contactutility.getContactFromEmail(email);
       if (cons.isEmpty()) {
            formError = 'Your contact information is not complete in our records.  Please contact Support.';
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, formError);
            ApexPages.addMessage(msg);
            return null;
        }  
       email =  cons[0].email;
       webFormOn = True;
       system.debug(' email 1' +email);    
        return null;
    }
     public PageReference registerUser() {
    
           // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        
        String profileId = Label.Community_User_Profile; 
        system.debug(' email 1' +cons[0].email);   
        String userName = cons[0].email;
 
        User u = new User();
        u.Username = userName;
        u.Email =  cons[0].email;
        u.FirstName = cons[0].firstName;
        u.LastName = cons[0].lastName;
        u.ContactId = cons[0].Id;
        u.UserPermissionsChatterAnswersUser = false;
  //      system.debug(' test'+u.lastName.substring(1,4 ));
        u.CommunityNickname = 'bcs'+u.lastName.substring(1,1) +randomNumber();
 //      u.CommunityNickname =communityNickname ;
        u.ProfileId = profileId;
        system.debug(' test user' +u);
        system.debug(' test account'+cons[0].accountid);
        String userId = Site.createPortalUser(u, cons[0].accountId, password);
      
        if (userId != null) { 
            system.debug ('Sucess !!!' +userID);
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, null);
            }
            else {
 //               ErrorEmailHelper.notifyOnError('Self Reg_Utility', 'SelfRegistration', 'Error in SelfRegistration', 'Error With User: ' +u.ContactId  + '; Error Message: ' + 'Self Registration Failed');
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
          
        }
        else{
          system.debug ('Failed !!!'  );
           ErrorEmailHelper.notifyOnError('Self Reg_Utility', 'SelfRegistration', 'Error in SelfRegistration', 'Error With User: ' +u.ContactId  + '; Error Message: ' + 'Self Registration Failed');
              
          PageReference errorpage = System.Page.BCSError;
          errorpage.setRedirect(true);
          return errorpage;
          }
        return null;
    }
    
 public Integer randomNumber(){

    Integer random = Math.Round(Math.Random() * 10000);
//    Integer random = Math.Round(Math.Random());


     return random;

  }
  
  public Id validatePIN()
    {
             
        
            Id accId = DLUtility.getSubfromStoreurl(formUrl, supportpin);
            return accId;
        

        
        
    }
        
    public String formURLFormatter(String url) 
    {
        url = url.trim();  //removes leading and trailing spaces as well as control and newline characters

        if(url.startsWith('http://')) {
            url = url.removeStart('http://');
        }

        if(url.startsWith('https://')) {
            url = url.removeStart('https://');
        }

        if(url.startsWith('www.')) {
            url = url.removeStart('www.');
        }

        if(url.contains('#')){
            url = url.substringBefore('#');  //removes any non-URL paths added to the Store URL string
        }

        if(url.contains('?')){
            url = url.substringBefore('?');  //removes any non-URL paths added to the Store URL string
        }

        if(url.contains('/')){
            url = url.substringBefore('/');  //removes any non-URL paths added to the Store URL string
        }

        return url;
    }

}