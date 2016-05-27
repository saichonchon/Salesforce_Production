@isTest(SeeAllData=true)
public class TestPricePlanController  {
	
	 static testMethod void testPricePlan()
	 {
	 	 PageReference pageRef = Page.PricePlan;
         Test.setCurrentPage(pageRef);
  
          // Instantiate a new controller with all parameters in the page      
          PricePlanController conca = new PricePlanController();
          conca.annualOrderCount = 500;
          conca.aov = 200;
          conca.getPricePlan();
   //1       
          System.assertEquals(conca.pplan.Plan_Type__c, 'Plus' );
          
          conca.annualOrderCount = 501;
          conca.aov = 200;
          conca.getPricePlan();
   //2       
          System.assertEquals(conca.pplan.Plan_Type__c, 'Plus' );
          
          conca.annualOrderCount = 1001;
          conca.aov = 100;
          conca.getPricePlan();
    //3      
//          System.assertEquals(conca.pplan.Tier__c, 'Plus' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Plus' );
          
          conca.annualOrderCount = 2000;
          conca.aov = 20;
          conca.getPricePlan();
   //4       
//          System.assertEquals(conca.pplan.Tier__c, 'Standard' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Standard' );
          
          conca.annualOrderCount = 2000;
          conca.aov = 500;
          conca.getPricePlan();
   //5       
          System.assertEquals(conca.pplan.Tier__c, 'T1' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Pro' );
          
          conca.annualOrderCount = 2000;
          conca.aov = 750;
          conca.getPricePlan();
   //6       
          System.assertEquals(conca.pplan.Tier__c, 'T1' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 2001;
          conca.aov = 100;
          conca.getPricePlan();
   //7       
          System.assertEquals(conca.pplan.Tier__c, 'T2' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Pro' );
         
          conca.annualOrderCount = 2001;
          conca.aov = 350;
          conca.getPricePlan();
   //8      
          System.assertEquals(conca.pplan.Tier__c, 'T2' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Pro' );
          
          conca.annualOrderCount = 2001;
          conca.aov = 500;
          conca.getPricePlan();
   //9       
          System.assertEquals(conca.pplan.Tier__c, 'T2' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 10001;
          conca.aov = 60;
          conca.getPricePlan();
   //10       
          System.assertEquals(conca.pplan.Tier__c, 'T10' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 10001;
          conca.aov = 100;
          conca.getPricePlan();
   //11       
          System.assertEquals(conca.pplan.Tier__c, 'T10' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 10001;
          conca.aov = 301;
          conca.getPricePlan();
   //12       
          System.assertEquals(conca.pplan.Tier__c, 'T10' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 100001;
          conca.aov = 20;
          conca.getPricePlan();
   //13       
          System.assertEquals(conca.pplan.Tier__c, 'T17' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 100001;
          conca.aov = 100;
          conca.getPricePlan();
   //14       
          System.assertEquals(conca.pplan.Tier__c, 'T17' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );
          
          conca.annualOrderCount = 350000;
          conca.aov = 350;
          conca.getPricePlan();
   //15       
          System.assertEquals(conca.pplan.Tier__c, 'T20' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );


          conca.annualOrderCount = 2001;
          conca.aov = 20;
          conca.getPricePlan();
   //16       
//          System.assertEquals(conca.pplan.Tier__c, 'Standard' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Standard' );

          conca.annualOrderCount = 1001;
          conca.aov = 25;
          conca.getPricePlan();
   //17       
 //         System.assertEquals(conca.pplan.Tier__c, 'Standard' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Standard' );

          conca.annualOrderCount = 7000;
          conca.aov = 15;
          conca.getPricePlan();
   //18       
 //         System.assertEquals(conca.pplan.Tier__c, 'Plus' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Plus' );

          conca.annualOrderCount = 11001;
          conca.aov = 5;
          conca.getPricePlan();
   //19       
 //         System.assertEquals(conca.pplan.Tier__c, 'Plus' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Plus' );

          conca.annualOrderCount = 1000;
          conca.aov = 126;
          conca.getPricePlan();
   //20       
//          System.assertEquals(conca.pplan.Tier__c, 'T1' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Pro' );
 		
 		  conca.forceEntPlan = true;
 		  conca.annualOrderCount = 500;
          conca.aov = 60;
          conca.getPricePlan();
   //21       
          System.assertEquals(conca.pplan.Tier__c, 'T10' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = true;
 		  conca.annualOrderCount = 17500;
          conca.aov = 200;
          conca.getPricePlan();
   //22       
          System.assertEquals(conca.pplan.Tier__c, 'T11' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 12500;
          conca.aov = 20;
          conca.getPricePlan();
   //23       
          System.assertEquals(conca.pplan.Tier__c, 'T20' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 12500;
          conca.aov = 35;
          conca.getPricePlan();
   //24       
          System.assertEquals(conca.pplan.Tier__c, 'T18' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 12500;
          conca.aov = 60;
          conca.getPricePlan();
   //25       
          System.assertEquals(conca.pplan.Tier__c, 'T16' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 12500;
          conca.aov = 100;
          conca.getPricePlan();
   //26       
          System.assertEquals(conca.pplan.Tier__c, 'T13' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 12500;
          conca.aov = 150;
          conca.getPricePlan();
   //27       
          System.assertEquals(conca.pplan.Tier__c, 'T12' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 5000;
          conca.aov = 350;
          conca.getPricePlan();
   //28       
          System.assertEquals(conca.pplan.Tier__c, 'T5' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

 		  conca.forceEntPlan = false;
 		  conca.samReqd = true;
 		  conca.annualOrderCount = 5000;
          conca.aov = 100;
          conca.getPricePlan();
   //29       
          System.assertEquals(conca.pplan.Tier__c, 'T13' );
          System.assertEquals(conca.pplan.Plan_Type__c, 'Enterprise' );

// cancel
		  conca.cancel();

		  conca.annualGMV = 1000000;
		  conca.annualOrderCount = 100;
		  
		  conca.getPricePlan();
		  
		  conca.annualGMV = 1000000;
		  conca.annualOrderCount = 0;
		  conca.getPricePlan();
		  
// get the list of ApexPages.Message
		List<ApexPages.Message> msgList = ApexPages.getMessages();
// or loop over the messages
		for(ApexPages.Message msg :  ApexPages.getMessages()) 
		{
//    		System.assertEquals('Have a nice day', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.FATAL, msg.getSeverity()); 
          
	 	} 
	 	
	 	  conca.annualGMV = 100000000;
	 	  conca.annualOrderCount = 1000000;
		  conca.getPricePlan();
		  
// get the list of ApexPages.Message
		List<ApexPages.Message> msg2List = ApexPages.getMessages();
// or loop over the messages
		for(ApexPages.Message msg :  ApexPages.getMessages()) 
		{
//    		System.assertEquals('Have a nice day', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.FATAL, msg.getSeverity()); 
          
	 	} 
	 }
}