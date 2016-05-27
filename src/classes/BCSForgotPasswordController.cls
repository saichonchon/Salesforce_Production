/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class BCSForgotPasswordController {
    public String username {get; set;}   
       
    public BCSForgotPasswordController() {}
  
    public PageReference forgotPassword() {
      boolean success = Site.forgotPassword(username);
      PageReference pr = Page.BCSForgotPasswordConfirm;
      pr.setRedirect(true);
      
      if (success) {        
        return pr;
      }
      return null;
    }
    
    
}