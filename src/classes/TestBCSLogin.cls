/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class TestBCSLogin {
    @IsTest(SeeAllData=true) 
    global static void testBCSLoginController () {
       BCSLoginController controller = new BCSLoginController();
  //     System.assertEquals(null, controller.forwardToCustomAuthPage());       
    }    
}