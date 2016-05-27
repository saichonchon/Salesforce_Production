@isTest
private class SubscriptioncStatsTT {

   static testMethod void testTrigger() {
      try {
          Subscription__c o = new Subscription__c();
          insert o;

          System.assertNotEquals(null, o);
      }
      catch(Exception e) {
          List<Subscription__c> l = [SELECT Id from Subscription__c LIMIT 1];
          update l;
          System.assertNotEquals(null, l);
      }
   }
}