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
public with sharing class TestMBAStagingContact {


// @isTest(seeAllData=true)   <-- need to check the other test code parts first.
// Need to see why I can't seem to see the custom object // NEED to revert back last thing to check

	 static testMethod void createMBAStageContacts() {
	 	        // Create Extra Test Data
			 	TestDataGenerator 			td 				= new TestDataGenerator();
			 	// List of Staging Account Record Tables
			 	List<MBA_Staging_Contact__c> stgConList 	= new List<MBA_Staging_Contact__c>();
			 	Set<String> stgConSet = new Set<String>();
			 	
			 	// Create Map of Contacts Associated with a Staging Account Record  - to Help with Checks
			 	Map<String, Contact>         ConMap         = new Map<String, Contact>();
			 	Map<String, MBA_Staging_Contact__c>stgConMap= new Map<String, MBA_Staging_Contact__c>();  
			 	
			 	
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	// Start Test
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	test.startTest();
			 	
			 	//Initialize the Configuration Object    
		    	td.getStagingToTableMappingSettings();
		    	
		    	
		         //////////////////////////////////////////////////////////////////////////////////////////
		    	 // Create Staging Account Records - Dummy Records
		    	 ////////////////////////////////////////////////////////////////////////////////////////// 
		    	 td.getAccountMBAs(true, true);   // Create Staging Accounts and create accounts
		    	 
		    	 //////////////////////////////////////////////////////////////////////////////////////////
		    	 // Create Staging Contact Records - Dummy Records
		    	 ////////////////////////////////////////////////////////////////////////////////////////// 
		    	 td.getContactMBAs(true, false);  // Create Staging Contacts, But do not create parent contacts


                 //////////////////////////////////////////////////////////////////////////////////////////
                 // First check - Make sure Contact Records are created 
                 //////////////////////////////////////////////////////////////////////////////////////////
			 	List<Contact> conList = [SELECT Id FROM Contact WHERE MailingCity ='TESTCITY_CHECK'];
			 	
			 	// This List should return 5			 	
			 	system.assertEquals(5, conList.size());
			 	
			 	
               // Construct a list of Staging contact and then update the IsPaid Flag to TRUE to force parent contact to create
               for (MBA_Staging_Contact__c l:[Select FirstName__c, LastName__c, MBAAccountID__c,MBAClientID__c, Address__c, City__c ,PostalCode__c,
                                                     State__c, Country__c, IsPaid__c 
                                              FROM MBA_Staging_Contact__c
                                              WHERE City__c = 'TESTCITY_CHECK']){
               	           
               	           l.IsPaid__c = true;
               	           
                           stgConList.add(l);
                           stgConSet.add(l.MBAClientID__c);
                           stgConMap.put(l.MBAClientID__c, l);
                                          	
               }			 	
			 	
			  update stgConList;	
			 	
			 	
                 //////////////////////////////////////////////////////////////////////////////////////////
                 // 2ND check - Make sure the Contact Records are created should be 5, 5 
                 //////////////////////////////////////////////////////////////////////////////////////////
			 	 conList = [SELECT Id, FirstName, LastName,    
                        			MailingStreet,
                        			MailingCity,
                        			MailingState,      
                        			MailingPostalCode,
                        			MailingCountry,
                        			MBAClientID__c
                        	FROM Contact 
                        	WHERE MBACLientID__c IN :stgConSet];
                        			
			 	// This List should return the same number as the Staging Contact Records			 	
			 	 system.assertEquals(stgConList.size(), conList.size());			 
			 	
		    	 //////////////////////////////////////////////////////////////////////////////////////////
                 // Now Loop through check - Check the values are in sync
                 //////////////////////////////////////////////////////////////////////////////////////////
                 for (Contact c:conLIst){
                 	
                 	system.assertEquals(c.MailingStreet, 	stgConMap.get(c.MBAClientID__c).Address__c);   // Check address
					system.assertEquals(c.MailingCity, 		stgConMap.get(c.MBAClientID__c).City__c);        // Check City
					system.assertEquals(c.MailingState, 	stgConMap.get(c.MBAClientID__c).State__c);      // State
					system.assertEquals(c.MailingPostalCode,stgConMap.get(c.MBAClientID__c).PostalCode__c); // Postal
					system.assertEquals(c.MailingCountry, 	stgConMap.get(c.MBAClientID__c).Country__c);       //Country
                 	system.assertEquals(c.MBAClientID__c, 	stgConMap.get(c.MBAClientID__c).MBAClientID__c); //Account
                 	system.assertEquals(c.FirstName, 		stgConMap.get(c.MBAClientID__c).FirstName__c);  // Name
                 	system.assertEquals(c.LastName, 		stgConMap.get(c.MBAClientID__c).LastName__c);  // Name
                 }   
		 
		        test.stopTest();
	 }
     static testMethod void testMBAStageContacts() {
	 	        // Create Extra Test Data
			 	TestDataGenerator 			td 				= new TestDataGenerator();

			 	Set<String> stgConSet = new Set<String>();
			 	
		 	
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	// Start Test
			 	//////////////////////////////////////////////////////////////////////////////////////////
			 	test.startTest();
		    	 
		    	 //////////////////////////////////////////////////////////////////////////////////////////
		    	 // Create Staging Contact Records - Dummy Records
		    	 ////////////////////////////////////////////////////////////////////////////////////////// 
		    	 List<MBA_Staging_Contact__c> stgConList = td.getContactMBAs(false, false);  // Create Staging Contacts, 
					
					stgConList[0].City__c ='testing long string 1234567890123456789012345678901234567890';
					
					insert stgConList[0];
					stgConSet.add(stgConList[0].MBAAccountID__c);
					string shortCity = stgConList[0].City__c.substring(0,40);
					
				    MBA_Staging_Contact__c l =[Select FirstName__c, LastName__c, MBAAccountID__c,MBAClientID__c, Address__c, City__c ,PostalCode__c,
                                                     State__c, Country__c, IsPaid__c 
                                              FROM MBA_Staging_Contact__c
                                              WHERE MBAAccountID__c in :stgConSet];
				
				system.assertEquals(l.City__c, shortCity);
			 	
			 
     }		 	

}