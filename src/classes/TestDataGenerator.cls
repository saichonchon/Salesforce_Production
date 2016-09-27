public class TestDataGenerator 
{
	//Always allow for the creation of one or more users
	public list<User> users;
	public map<String,list<User>> profileToUserMap;      
 
	public list<Account> accounts;
	public list<Opportunity> opportunities; 
	public list<Contact> contacts;
	public list<Lead> leads;  

	public list<MBA_Staging_Account__c> AccountMBAs;
	public list<MBA_Staging_Contact__c> ContactMBAs;
	public list<MBA_Staging_Subscription__c> lstStagingSubscriptions;
	public list<Terms_Conditions__c> lstTermsConditions;
	public list<Marketing_Material__c> lstMarketingMaterials;
	public list<Subscription__c> lstSubscriptions;
	
	      
	public Integer userNum;
	public Integer accountNum;
	public Integer contactNum;
	public Integer opptyNum;
	public Integer leadNum;      
	public Integer AccountMBANum;
	public Integer ContactMBANum;      
	public Integer subscriptionNum;
	

	public list<StagingToTableMapping__c> StagingToTableMapping2 = new list<StagingToTableMapping__c>();   // StagingToTableMapping Configuration
      
	public TestDataGenerator()
	{
		userNum = 5;
		accountNum = 5;
		contactNum = 5;  // Contacts count should be equal to opptynum size
		opptyNum = 5;
		leadNum = 5;
		subscriptionNum = 5;
		AccountMBANum= 5;
		ContactMBANum= AccountMBANum;  // This Contact MBA should be the same as AccountMBANum 1:1 link for testing
        
        if(AccountMaxSubRollup__c.getInstance('Fields') == null)
        {
        	AccountMaxSubRollup__c amsr = new AccountMaxSubRollup__c();
			amsr.FieldList1__c = 'product__c,monthlyrecurringrevenue__c,purchasedate__c,istrial__c,status__c,purchase_team__c,startdate__c,expirationdate__c,billingcycle__c,billingamount__c';
			amsr.Name = 'Fields';
			insert amsr;
        }
	}
      
      public list<StagingToTableMapping__c> getStagingToTableMappingSettings()
      {      	
      	// Create one Custom Setting to Sync the records for testing
		StagingToTableMapping__c Temp = new StagingToTableMapping__c();   // Temp activationSettings Configuration
      	
		//if(myCS == null) {
			
			        ///////////////////////////////////////////////////////////////////////////////////////////////
			        // ACCOUNTS
			        ///////////////////////////////////////////////////////////////////////////////////////////////
                    // Check if the value already exists in the StagingToTableMapping__c object
                    StagingToTableMapping__c myCS = StagingToTableMapping__c.getValues('MBA Staging Account - MBA Account ID');   // Check for values		            
		            
		            if(myCS == null) {
				            Temp = new StagingToTableMapping__c();
				            Temp.Name      = 'MBA Staging Account - MBA Account ID';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'MBAAccountID__c';
				            Temp.Object_Name_API__c 				=  'Account';
				            Temp.Object_Field_Name_API__c 			=  'MBAAccountID__c';
				            StagingToTableMapping2.add(temp);		              
		            }
                

                    // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - Address');   // Check for values		            
		            if(myCS == null) {
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Account - Address';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	=  'Address__c';
				            Temp.Object_Name_API__c 				=  'Account';
				            Temp.Object_Field_Name_API__c 			=  'BillingStreet';
				            StagingToTableMapping2.add(temp);
		            }
		            


                    // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - City');   // Check for values		            
		            if(myCS == null) {
				            Temp = new StagingToTableMapping__c();		            
		                    Temp.Name      = 'MBA Staging Account - City';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'City__c';
				            Temp.Object_Name_API__c 				= 'Account';
				            Temp.Object_Field_Name_API__c 			= 'BillingCity';
				            StagingToTableMapping2.add(temp);
		            }

                    // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - Company Name');   // Check for values		            
		            if(myCS == null) {		            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Account - Company Name';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'CompanyName__c';
				            Temp.Object_Name_API__c 				= 'Account';
				            Temp.Object_Field_Name_API__c 			=  'Name';
				            StagingToTableMapping2.add(temp);
		            }


                    // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - Country');   // Check for values		            
		            if(myCS == null) {		 		                   
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Account - Country';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'Country__c';
				            Temp.Object_Name_API__c 				=  'Account';
				            Temp.Object_Field_Name_API__c 			=  'BillingCountry';
				            StagingToTableMapping2.add(temp);
		            }
		            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - Postal Code');   // Check for values		            
		            if(myCS == null) {		           
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Account - Postal Code';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'PostalCode__c';
				            Temp.Object_Name_API__c 				=  'Account';
				            Temp.Object_Field_Name_API__c 			=  'BillingPostalCode';
				            StagingToTableMapping2.add(temp);
		            }       
				
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Account - State');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Account - State';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Account__c';
				            Temp.Staging_Object_Field_Name_API__c 	='State__c';
				            Temp.Object_Name_API__c 				= 'Account';
				            Temp.Object_Field_Name_API__c 			=  'BillingState';
				            StagingToTableMapping2.add(temp);
		            }        

		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - Address');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - Address';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'Address__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MailingStreet';
				            StagingToTableMapping2.add(temp);
		            } 
				            
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - City');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - City';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'City__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MailingCity';
				            StagingToTableMapping2.add(temp);
		            } 
				     
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - Country');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - Country';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'Country__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MailingCountry';
				            StagingToTableMapping2.add(temp);
		            }        
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - Email');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - Email';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'Email__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'Email';
				            StagingToTableMapping2.add(temp);
		            } 
				     
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - First Name');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - First Name';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'FirstName__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'FirstName';
				            StagingToTableMapping2.add(temp);
		            } 
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - LastName');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - LastName';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'LastName__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'LastName';
				            StagingToTableMapping2.add(temp);
		            } 
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - MBA Account ID');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - MBA Account ID';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'MBAAccountID__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MBAAccountID__c';
				            StagingToTableMapping2.add(temp);
		            } 
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - MBA Client ID');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - MBA Client ID';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'MBAClientID__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MBAClientID__c';
				            StagingToTableMapping2.add(temp);
		            } 
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - Phone');   // Check for values		            
		            if(myCS == null) {				            
				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - Phone';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'Phone__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'Phone';
				            StagingToTableMapping2.add(temp);
		            } 
				     
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - Postal Code');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - Postal Code';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'PostalCode__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MailingPostalCode';
				            StagingToTableMapping2.add(temp);
		            }       
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Contact - State');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Contact - State';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Contact__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'State__c';
				            Temp.Object_Name_API__c 				=  'Contact';
				            Temp.Object_Field_Name_API__c 			=  'MailingState';
				            StagingToTableMapping2.add(temp);
		            }       

		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Ad Group');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Ad Group';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'AdGroup__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'AdGroup__c';
				            StagingToTableMapping2.add(temp);
		            }   
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Ad Keywords');   // Check for values		            
		            if(myCS == null) {				            
		                    Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Ad Keywords';
							Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'AdKeywords__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'AdKeywords__c';
				            StagingToTableMapping2.add(temp);
		            }       
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Affiliate');   // Check for values		            
		            if(myCS == null) {				            
		                    Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Affiliate';   
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	=  'Affiliate__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'Affiliate__c';
				            StagingToTableMapping2.add(temp);
		            }       
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Bill Amount');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Bill Amount';
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	=  'BillingAmount__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'BillingAmount__c';
				            StagingToTableMapping2.add(temp);
		            }       
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Bill Cycle');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Bill Cycle';            		            
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'BillingCycle__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'BillingCycle__c';
				            StagingToTableMapping2.add(temp);
		            }        
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Cancel Date');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Cancel Date';    
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'CancellationDate__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'CancellationDate__c';
				            StagingToTableMapping2.add(temp);
		            }
				            
		            // Check if the value already exists in the StagingToTableMapping__c object
                    myCS = StagingToTableMapping__c.getValues('MBA Staging Subscription - Cancel Req');   // Check for values		            
		            if(myCS == null) {				            
				            Temp = new StagingToTableMapping__c();
		                    Temp.Name      = 'MBA Staging Subscription - Cancel Req';            
				            Temp.Active__c = true; 
				            Temp.Staging_Object_Name_API__c 		= 'MBA_Staging_Subscription__c';
				            Temp.Staging_Object_Field_Name_API__c 	= 'CancellationRequestDate__c';
				            Temp.Object_Name_API__c 				=  'Subscription__c';
				            Temp.Object_Field_Name_API__c 			=  'CancellationRequestDate__c';
				            StagingToTableMapping2.add(temp);
		            }
		         // If there is any records to insert try.
		         if (StagingToTableMapping2.size()>0){   
				         try{
				         	  insert StagingToTableMapping2;
				         	  } catch (Exception e) {
				         	  	                   system.debug('Values Already Exists : ' + e);
				         	  	                   }          
		         }
		            
		//	}  /// END OF IF   --> if(myCS == null) 
         
		return StagingToTableMapping2;
	  }
            
      public map<String,list<User>> getProfileToUserMap(list<String> profileNames) 
      {
            System.debug('*** getProfileToUserMap');
            getUsers(profileNames);
            return profileToUserMap;
      }
      
      //A user need a profile
      public list<User> getUsers(list<String> profileNames)
      {
            System.debug('*** getUsers');
            if(users == null) {
                  users = new list<User>();
                  
                  //There are 3 classes of users, create at least one of each
                  if(profileNames == null || profileNames.size() == 0) {
                        profileNames = new list<String>();
                        profileNames.add('Standard User');        
                  }
                  
                  System.debug('*** profileNames: ' + profileNames);
                  
                  map<Id,Profile> profileMap;               
                  try {       
                        profileMap = new map<Id,Profile>([select id, Name from profile where name IN :profileNames]);
                  } catch (Exception exp) {
                        //Can not test exceptions
                        System.debug('*** Could not find profiles: ' + exp.getMessage());                        
                  }
                  
                  if(profileMap == null || profileMap.size() == 0) {
                        profileMap = new map<Id,Profile>([select id, Name from profile where name = 'Standard User']);
                  }
                  
                  System.debug('*** profileMap: ' + profileMap);
                  
                  //Untested - this should never happen, just 3x checking
                  if(profileMap == null || profileMap.size() == 0) {
                        System.assert(false,'Could not find profiles');
                        return null;
                  }
                                                      
                  if(userNum == null || userNum < profileMap.size()) {
                        userNum = profileMap.size();
                  }
                              
                  for(Integer i = 0; i < userNum; i++) {
                        Integer profilePosition = Math.mod(i,profileMap.size());
                        Integer random = Math.random().intValue();
                        User u = getUser(profileMap.values()[profilePosition], 'User' + i.format() + random.format());
                        users.add(u);                                   
                  }
                  
                  System.debug('*** inserting users');
                  insert users;
                  
                  //Now build the user map
                  profileToUserMap = new map<String,list<User>>();
                  
                  for(User u : users) {
                        if(profileToUserMap.containsKey(profileMap.get(u.ProfileId).Name)) {
                              profileToUserMap.get(profileMap.get(u.ProfileId).Name).add(u);
                        } else {
                              list<User> tmpUsers = new list<User>();
                              tmpUsers.add(u);
                              profileToUserMap.put(profileMap.get(u.ProfileId).Name,tmpUsers);
                        }
                  }
            }           
            return users;
      }
      
      public User getUser(Profile p, String uniqueName)
      {
            System.debug('*** getUser');
                        
            String orgId = (String)Userinfo.getOrganizationId();        
            String uniqueEmail = uniqueName + '@' + orgId + '.net.test';
            
            User u = new User(alias = 'standt', 
                              email=uniqueEmail,
                              emailencodingkey='UTF-8', 
                              lastname='Testing', 
                              languagelocalekey='en_US',
                              localesidkey='en_US', 
                              profileid = p.Id,
                              timezonesidkey='America/Los_Angeles',
                              username=uniqueEmail);
            return u;
      }
            
      public list<Account> getAccounts(Boolean xCommit) 
      {
            if(accounts == null) {
                  accounts = new list<Account>();
                  for(Integer i = 0; i < accountNum; i++) {
                        Account a = new Account();
                        a.Name = 'Test ' + i;   
                        a.BillingStreet='Main St';
                        a.BillingCity='Dallas';
                        a.BillingState = 'TX';      
                        a.BillingPostalCode='70000';
                        a.BillingCountry = 'US';
                        accounts.add(a);
                  }
                  if(xCommit) insert accounts;
            }
            
            if(xCommit && accounts.size() > 0 && accounts[0].Id == null) insert accounts;                                            
            
            return accounts;
      }
      
       public list<Contact> getContacts(Boolean xCommit) 
       {
            if(contacts == null) {
                  contacts = new list<Contact>();
                  for(Integer i = 0; i < contactNum; i++) {
                        Contact c = new Contact();
                        c.FirstName = 'First ' + i;
                        c.LastName = 'Last ' + i;
                        c.MailingCountry ='US';
                        Integer j = Math.mod(i,getAccounts(true).size());
                        c.Email = 'testmail' + i + '@bigcommerce.com';
                        c.Account = getAccounts(true)[j];
                        
                        contacts.add(c);
                  }
                  if(xCommit) insert contacts;
            }
            
            if(xCommit && contacts.size() > 0 && contacts[0].Id == null) insert contacts;
            
            return contacts;
      }
      
      public list<MBA_Staging_Account__c> getAccountMBAs(Boolean xCommit, Boolean IsPaidFlag) 
      {
      	
            if(AccountMBAs == null) {
                  AccountMBAs = new list<MBA_Staging_Account__c>();
                  for(Integer i = 0; i < accountMBANum; i++) {
                        MBA_Staging_Account__c a = new MBA_Staging_Account__c();
                        a.CompanyName__c = 'Company ' +i;
                        a.MBAAccountID__c = '800011111'+string.valueof(i);
                        a.Address__c='Main St ' + i;
                        a.City__c='TESTCITY_CHECK';
                        a.PostalCode__c='70000';
                        a.State__c = 'TX';
                        a.Country__c = 'US';
                        a.IsPaid__c = IsPaidFlag;  // Is true or False
                        AccountMBAs.add(a);
                  }
                  if(xCommit) insert AccountMBAs;
            }
            
            if(xCommit && AccountMBAs.size() > 0 && AccountMBAs[0].Id == null) insert AccountMBAs;                                            
            
            return AccountMBAs;
      }

	  public list<MBA_Staging_Contact__c> getContactMBAs(Boolean xCommit, Boolean IsPaidFlag) 
	  { 	
            if(ContactMBAs == null) {
                  ContactMBAs = new list<MBA_Staging_Contact__c>();
                  for(Integer i = 0; i < ContactMBANum; i++) {
                        MBA_Staging_Contact__c a = new MBA_Staging_Contact__c();
                        a.FirstName__c = 'FirstName ' +i;
                        a.LastName__c = 'LastName ' +i;
                        a.MBAAccountID__c = getAccountMBAs(true, true)[0].MBAAccountID__c;     // Link this up to an existing Account.
                        a.MBAClientID__c = '800055555'+string.valueof(i);                        
                        a.Address__c='Main St ' + i;
                        a.City__c='TESTCITY_CHECK';
                        a.PostalCode__c='70000';
                        a.State__c = 'TX';
                        a.Country__c = 'US';
                        a.IsPaid__c = IsPaidFlag;  // True or False
                        a.Email__c = 'testingMethodContact' + i + '@testContact.com';
                        ContactMBAs.add(a);
                  }
                  if(xCommit) insert ContactMBAs;
            }
            
            if(xCommit && ContactMBAs.size() > 0 && ContactMBAs[0].Id == null) insert ContactMBAs;                                            
            
            return ContactMBAs;
      }            
                  
	public list<MBA_Staging_Subscription__c> getStagingSubscriptions (boolean xCommit, boolean isTrial, string MBAAccountID, integer intStartMBASubID)
	{
		if(lstStagingSubscriptions == null) 
		{
			lstStagingSubscriptions = new list<MBA_Staging_Subscription__c>();
			
			for(Integer i = 0; i < 10; i++) 
			{
				MBA_Staging_Subscription__c sub = new MBA_Staging_Subscription__c();
				sub.MBASubscriptionID__c = string.valueOf(intStartMBASubID + i);
				sub.MBAAccountID__c = MBAAccountID;
				sub.isTrial__c = isTrial;
				sub.AdGroup__c = 'Ad Group';
				sub.AdKeywords__c = 'Ad Key Words';
				sub.Affiliate__c = 'Test Method Affiliate';
				sub.BillingAmount__c = 100;
				sub.BillingCycle__c = 'Monthly';
				sub.PaymentStatus__c = 'Status';
				sub.Product__c = 'Gold';
				sub.PurchaseDate__c = system.Today();
				sub.StartDate__c = system.Today();
				
				lstStagingSubscriptions.add(sub);
			}
			
			if(xCommit) 
				insert lstStagingSubscriptions;
		}
			
		if(xCommit && lstStagingSubscriptions.size() > 0 && lstStagingSubscriptions[0].Id == null) 
			insert lstStagingSubscriptions;                                            
			
		return lstStagingSubscriptions;
	}
			
	public list<Terms_Conditions__c> getTermsConditions (boolean xCommit)
	{
		if(lstTermsConditions == null) 
		{
			lstTermsConditions = new list<Terms_Conditions__c>();
			
			// Create a new Terms & Conditions record
	    	Terms_Conditions__c tc1 = new Terms_Conditions__c();
	    	tc1.Type__c = 'Testing This';
	    	tc1.Active_Date__c = Date.today();
	    	tc1.Expiration_Date__c = Date.today() + 30;
	    	tc1.T_C_Text__c = 'Testing 1234';
	    		
			lstTermsConditions.add(tc1);
			
			if(xCommit) 
				insert lstTermsConditions;
		}
			
		if(xCommit && lstTermsConditions.size() > 0 && lstTermsConditions[0].Id == null) 
			insert lstTermsConditions;                                            
			
		return lstTermsConditions;
	}
	
	public list<Marketing_Material__c> getMarketingMaterials (boolean xCommit)
	{		
		if(lstMarketingMaterials == null) 
		{
			lstMarketingMaterials = new list<Marketing_Material__c>();
			
			string strType;
			
			for(Integer i = 0; i < 10; i++) 
			{
				if (i >= 0 && i < 2)
				{
					strType = 'Logo';
				}
				else if (i >= 2 && i < 4)
				{
					strType = 'Web Page';
				}
				else if (i >= 4 && i < 6)
				{
					strType = 'Text Link';
				}
				else if (i >= 6 && i < 8)
				{
					strType = 'Email Link';
				}
				else if (i >= 8 && i < 10)
				{
					strType = 'Email Template';
				}
				
				Marketing_Material__c mm = new Marketing_Material__c();
				mm.Type__c = strType;
				mm.Name__c = 'Testing ' + i;
				mm.Description__c = 'Testing ' + i;
				mm.Size__c = 'Testing ' + i;
				mm.Source_Code__c = 'Testing {!PartnerId} and {!PartnerFName} ' + i;
				mm.Text_Version__c = 'Testing {!PartnerId} and {!PartnerFName} ' + i;
				mm.Target_URL__c = 'http://www.bigcommerce.com';
				mm.View_Order__c = i;
				mm.Active__c = true;
				
				lstMarketingMaterials.add(mm);
			}
			
			if(xCommit) 
				insert lstMarketingMaterials;
		}
			
		if(xCommit && lstMarketingMaterials.size() > 0 && lstMarketingMaterials[0].Id == null) 
			insert lstMarketingMaterials;                                            
			
		return lstMarketingMaterials;
	}
	
	public list<Subscription__c> getSubscriptions (boolean xCommit)  
    {
		if(lstSubscriptions == null) 
		{
			lstSubscriptions = new list<Subscription__c>();
			for(Integer i = 0; i < subscriptionNum; i++) 
			{
				Subscription__c sub = new Subscription__c();
				sub.RecordTypeId = Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId();
				sub.MBASubscriptionID__c = '12345-' + i;
				sub.Status__c = 'Active';
				sub.ProductType__c = 'Store';
				sub.Product__c = 'Silver Store';
				sub.StoreURL__c = 'http://www.testingthis.com';
							
				lstSubscriptions.add(sub);
			}
  			
  			if(xCommit) insert lstSubscriptions;
		}

		if(xCommit && lstSubscriptions.size() > 0 && lstSubscriptions[0].Id == null) insert lstSubscriptions;

		return lstSubscriptions;
	}

	public list<Opportunity> getOpportunities(Boolean xCommit) 
	{
		if(opportunities == null) 
		{
			opportunities = new list<Opportunity>();
			for(Integer i = 0; i < opptyNum; i++) 
			{
				Opportunity o = new Opportunity();
				o.Name = 'Test ' + i;
				o.CloseDate = Date.today().addDays(1);
				o.StageName = '01-New';
				Integer j = Math.mod(i,getAccounts(true).size());
				o.Account = getAccounts(true)[i];
				opportunities.add(o);
			}
			
			if(xCommit) insert opportunities;
		}
		            
		if(xCommit && opportunities.size() > 0 && opportunities[0].Id == null) insert opportunities;
		            
		return opportunities;
	}
     
	public list<Lead> getLeads(Boolean xCommit) 
	{
		if(leads == null) 
		{
			leads = new list<Lead>();
			for(Integer i = 0; i < leadNum; i++) 
			{
				Lead lead = new Lead();
				lead.FirstName = 'First ' + i;
				lead.LastName = 'Last ' + i;
				lead.Email = 'email' + i + '@test.com';
				lead.Phone = '555-555-555' + i;
				lead.Company = 'Test Company' + i;
				lead.Country = 'US';
				            
				leads.add(lead);
			}
			
			if(xCommit) insert leads;
		}
		
		if(xCommit && leads.size() > 0 && leads[0].Id == null) insert leads;
		
		return leads;
	}
	
	public Case createCase(Id AcctId, string strCaseQueue, Boolean xCommit)
	{
		// Create a new case for the account
    	Case c = new Case();
    	
    	if (AcctId != null)
    	{
    		c.AccountId = AcctId;
    	}
    	else
    	{
    		c.AccountId = getAccounts(true)[0].Id;
    	}
    	c.RecordTypeId = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
    	c.Status = 'New';
    	c.Origin = 'Sales Rep';
    	c.Reason = 'Invoice';
    	c.Subject = 'Test Case';
    	c.Description = 'Test Case';
    	if (strCaseQueue != null && strCaseQueue != '')
    	{
    		c.OwnerId = getCaseQueue(strCaseQueue);
    	}
    	
    	if(xCommit) insert c;
    	
    	return c;
	}

	public Id getCaseQueue (string strCaseQueue) 
	{
		Id retVal = null;
		
		// Query for the queues to create the map of Ids to Names
		for (QueueSobject q : SObjectUtils.lstQueues4Object('Case'))
		{
			retVal = q.QueueId;
			
			if (q.Queue.Name == strCaseQueue)
			{
				break;
			}
		}
		
		return retVal;
	}
      
	public void initAllTestData() 
	{
		getStagingToTableMappingSettings();
		  	    
		getUsers(null);
		getLeads(true);
		getAccounts(true);
		getContacts(true);
		getOpportunities(true);
		getTermsConditions(true);
		getMarketingMaterials(true);
		getSubscriptions(true);
		getCaseQueue('Support');
		                
	}      
 
	static testMethod void TestDataGeneratorUnitTest() 
	{
        TestDataGenerator data = new TestDataGenerator();
        data.initAllTestData();                                   
    }
}