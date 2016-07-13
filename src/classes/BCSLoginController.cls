/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class BCSLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global BCSLoginController () {}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }


}