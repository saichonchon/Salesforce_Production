/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code 
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=false) 
public class TestMBAStagingAccount {

// @isTest(seeAllData=true)   <-- need to check the other test code parts first.
	 static testMethod void createMBAStageAccounts() {
	 	        // Create Extra Test Data
			 	TestDataGenerator 			td 				= new TestDataGenerator();
			 	// List of Staging Account Record Tables
			 	List<MBA_Staging_Account__c> stgAccList 	= new List<MBA_Staging_Account__c>();
			 	Set<String> stgAccSet = new Set<String>();
			 	
			 	// Create Map of Accounts Associated with a Staging Account Record  - to Help with Checks
			 	Map<String, Account>         AccMap         = new Map<String, Account>();
			 	Map<String, MBA_Staging_Account__c>stgAccMap= new Map<String, MBA_Staging_Account__c>();  
			 	
			 	
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	// Start 
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	test.startTest();
			 	
			 	//Initialize the Configuration Object    
		    	td.getStagingToTableMappingSettings();
		    	
		    	 //////////////////////////////////////////////////////////////////////////////////////////
		    	 // Create Staging Account Records - Dummy Records
		    	 ////////////////////////////////////////////////////////////////////////////////////////// 
		    	 td.getAccountMBAs(true, false);  // Create Accounts MBA, but isPaid flag set to false


                 //////////////////////////////////////////////////////////////////////////////////////////
                 // First check - Make sure no Account Records are created 
                 //////////////////////////////////////////////////////////////////////////////////////////
			 	List<Account> accList = [SELECT Id FROM Account WHERE BillingCity ='TESTCITY_CHECK'];
			 	
			 	// This List should return 0			 	
			 	system.assertEquals(0, accList.size());
			 	
			 	
			 	
			 	
               // Construct a list of Staging account and then update the IsPaid Flag to TRUE to force parent accounts to create
               for (MBA_Staging_Account__c l:[Select CompanyName__c, MBAAccountID__c, Address__c, City__c ,PostalCode__c,
                                                     State__c, Country__c, IsPaid__c 
                                              FROM MBA_Staging_Account__c
                                              WHERE City__c = 'TESTCITY_CHECK']){
               	           
               	           l.IsPaid__c = true;
               	           
                           stgAccList.add(l);
                           stgAccSet.add(l.MBAAccountID__c);
                           stgAccMap.put(l.MBAAccountID__c, l);
                                          	
               }			 	
			 	
			  update stgAccList;	
			 	
			 	
                 //////////////////////////////////////////////////////////////////////////////////////////
                 // 2ND check - Make sure the Account Records are created should be 5, 5 
                 //////////////////////////////////////////////////////////////////////////////////////////
			 	 accList = [SELECT Id, Name,    
                        			BillingStreet,
                        			BillingCity,
                        			BillingState,      
                        			BillingPostalCode,
                        			BillingCountry,
                        			MBAAccountID__c 
                        	FROM Account 
                        	WHERE MBAAccountID__c IN :stgAccSet];
                        			
			 	// This List should return the same number as the Staging Account Records			 	
			 	 system.assertEquals(stgAccList.size(), accList.size());			 
			 	
		    	 //////////////////////////////////////////////////////////////////////////////////////////
                 // Now Loop through check - Check the values are in sync
                 //////////////////////////////////////////////////////////////////////////////////////////
                 for (Account a:accLIst){
                 	
                 	system.assertEquals(a.BillingStreet, stgAccMap.get(a.MBAAccountID__c).Address__c);   // Check address
					system.assertEquals(a.BillingCity, stgAccMap.get(a.MBAAccountID__c).City__c);        // Check City
					system.assertEquals(a.BillingState, stgAccMap.get(a.MBAAccountID__c).State__c);      // State
					system.assertEquals(a.BillingPostalCode, stgAccMap.get(a.MBAAccountID__c).PostalCode__c); // Postal
					system.assertEquals(a.BillingCountry, stgAccMap.get(a.MBAAccountID__c).Country__c);       //Country
                 	system.assertEquals(a.MBAAccountID__c, stgAccMap.get(a.MBAAccountID__c).MBAAccountID__c); //Account
                 	system.assertEquals(a.Name, stgAccMap.get(a.MBAAccountID__c).CompanyName__c);             // Name

                 }
		 
		        test.stopTest();
	 }


}