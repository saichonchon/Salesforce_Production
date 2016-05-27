/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class BCSLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global BCSLoginController () {}
    global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/BCSLogin');
    }
    global PageReference login() {
        return Site.login(username, password, null);
    }


}