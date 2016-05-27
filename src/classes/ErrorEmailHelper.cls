/* ============================================================
 * Contributor: Caleb Sidel
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
public class ErrorEmailHelper {

	public static Set<String> getEmailAddresses(String className, String exceptionName) {
		Set<String> emailAddresses = new Set<String>();
		
		try {
			Map<String,Custom_Apex_Error_Handler__c> settings = Custom_Apex_Error_Handler__c.getAll();
			System.debug('*** ErrorEmailHelper: getEmailAddresses: settings = ' + settings);
			for(Custom_Apex_Error_Handler__c setting : settings.values()) {
				
				System.debug('*** setting.Single_Apex_Class ' + setting.Single_Apex_Class__c);
				System.debug('***                 className ' + className);
				
				Boolean noApexClass = false;
				Boolean noSingleException = false;
				Boolean sendEmail = false;
								
				if(setting.Single_Apex_Class__c == null || setting.Single_Apex_Class__c.length() == 0) {
					noApexClass = true;
				}
				
				if(setting.Single_Exception__c == null || setting.Single_Exception__c.length() == 0) {
					noSingleException = true;
				}
				
				if(noApexClass && noSingleException) {
					//no apex class or exception specified, send email
					sendEmail = true;
				} else if(!noApexClass && !noSingleException) {
					//send email only if exception and class match 
					if ((className != null && className.equalsIgnoreCase(setting.Single_Apex_Class__c))
				   		&&
				   		(exceptionName != null && exceptionName.equalsIgnoreCase(setting.Single_Exception__c)) ) {
				   			sendEmail = true;
				   			
				   		}
				} else if(!noApexClass && noSingleException) {
					//only an Apex Class, then send exception if class match
					//send email only if exception and class match 
					if ((className != null && className.equalsIgnoreCase(setting.Single_Apex_Class__c))) {
				   			sendEmail = true;				   			
				   	}
				} else {
					sendEmail = false;
				}
				
				
				
				if( sendEmail ) {
					
					if(setting.Email__c != null && !setting.Name.startsWith('CurrentUser')) {
						System.debug('*** Not current user, adding email address.');
						emailAddresses.add( setting.Email__c );
					} else if(setting.Name.startsWith('CurrentUser')) {
						System.debug('*** Trying to email current user.');
						if(UserHelper.getCurrentUser() != null) {
							System.debug('*** Current user identified.');
							String email = UserHelper.getCurrentUser().Email;
							if(email != null && email.length() > 0) {
								System.debug('*** Current user email added.');
								emailAddresses.add( email );
							}
						} 
					}
				}	
			}
			
		} catch (Exception exp) {
			//Never throw an exception, simply return the default value
			System.debug('@@@ErrorEmailHelper: getEmailAddresses: Exception: ' + exp.getMessage());
		}
		
		System.debug('*** ErrorEmailHelper: getEmailAddresses: emailAddresses ' + emailAddresses);
		return emailAddresses;
	}

	private static void notifyOnError(String className, String subject, String errorMessage, List<String> emailAddresses) {
		if(Limits.getEmailInvocations() == Limits.getLimitEmailInvocations()) {
			System.debug('@@@ Can not send any more emails on errors in this context: className ' + className + ' subject ' + subject + ' errorMessage ' + errorMessage);
			return;
		} else if(Limits.getEmailInvocations() + 1 == Limits.getLimitEmailInvocations()) {    		
	        errorMessage = 'WARNING: Email Invocation Limit Reached. No more emails can be sent for this context. If there are further emails for this context they will not be sent. \n' + errorMessage;
	        System.debug('@@@ ' + errorMessage + ' Context: className ' + className + ' subject ' + subject + ' errorMessage ' + errorMessage);		
	        		    
		}
        
        EmailUtils.sendTextEmail(emailAddresses, subject, errorMessage);
	}

	public static void notifyOnError(String className, String exceptionName, String subject, String errorMessage) {
		List<String> emailAddresses = new List<String>();
		emailAddresses.addAll(getEmailAddresses(className, exceptionName));
//		notifyOnError(className, subject, errorMessage, emailAddresses);
		notifyChatGroup(className, subject, exceptionName, errorMessage);	
	}
	
	public static void notifyOnError(String className, String exceptionName, String subject, String errorMessage, Set<Id> userIds) {
		List<String> emailAddresses = new List<String>();
		emailAddresses.addAll(getEmailAddresses(className, exceptionName));
		
		for(User usr : UserHelper.getUsersFromIds(userIds)) {
			emailAddresses.add(usr.Email);
		}
		
//		notifyOnError(className, subject, errorMessage, emailAddresses);
		 notifyChatGroup(className, subject, exceptionName, errorMessage);	
	}
	
	public static void notifyChatGroup (String className, String subject, String exceptionName, String errorMessage) 
	{	
		try {

      			FeedItem post = new FeedItem();
      			post.ParentId = Label.SFDC_Errors_ChatGroup; //Chatter Group

      			post.Body = className +'\n' + subject + '\n' + errorMessage;

				if(!Test.isRunningTest())insert post;

    		} catch (Exception e) {
    				List<String> emailAddresses = new List<String>();
					emailAddresses.addAll(getEmailAddresses(className, exceptionName));
					notifyOnError(className, subject, errorMessage, emailAddresses);
    		}
	}
}