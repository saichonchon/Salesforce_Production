/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {
    
        system.debug(' user type' +UserInfo.getUserType());
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/BCSLogin');
        }
        else{
            //return null;
            return new PageReference('/s');
        }
    }
  
    public CommunitiesLandingController() {}
  

}