public without sharing class RoundRobin
{
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	// Private Static Variables
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	private static list<Round_Robin_Settings__c> lstSettings;
		
	private static string UserStatusSelect = 'SELECT Status__c, Round_Robin_Queue__c, Round_Robin_Number_Num__c, SalesRep__c, OwnerId, Name, Id ' +
											' FROM User_Status__c ' +
											' WHERE Status__c = \'In the Office\' ';


	/////////////////////////////////////////////////////////////////////////////////////////////////////
	// Private Static methods
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	private static map<Id, string> LoadQueueIdToNameMap(String objType)
	{
		system.debug('***RoundRobin - LoadQueueIdToNameMap');
		map<Id, string> mpRetVal = new map<Id, string>();
		
		set<string> stQueueName = new set<string>();
		
		// Find the unique list of Queue Names from the custom setting
		for (Round_Robin_Settings__c s : lstSettings)
		{
			stQueueName.add(s.Queue_Name__c);
		}
		
		// Query for the queues to create the map of Ids to Names
		for (QueueSobject q : SObjectUtils.lstQueues4Object(objType))
		{
			if (stQueueName.contains(q.Queue.Name))
			{
				mpRetVal.put(q.QueueId, q.Queue.Name);
			}
		}
		
		return mpRetVal;
	}
	
	//private static map<string, decimal> RoundRobinStartingPoints (set<string> stQueues, String objType)
	private static map<string, Round_Robin_Settings__c> RoundRobinStartingPoints (set<string> stQueues, String objType)
	{
		system.debug('***RoundRobin - RoundRobinStartingPoints');
		//map<string, decimal> mpRetVal = new map<string, decimal>();
		map<string, Round_Robin_Settings__c> mpRetVal = new map<string, Round_Robin_Settings__c>();
		
		for (Round_Robin_Settings__c s : lstSettings)
		{
			if (s.Object_API_Name__c == objType && stQueues.contains(s.Queue_Name__c))
			{
				//mpRetVal.put(s.Queue_Name__c, s.Last_Number_Used__c);
				mpRetVal.put(s.Queue_Name__c, s);
			}
		}
		
		return mpRetVal;
	}
	
	private static map<string, list<User_Status__c>> LoadQueueToUserStatusMap (set<string> stQueues)
	{
		system.debug('***RoundRobin - LoadQueueToUserStatusMap');
		map<string, list<User_Status__c>> retVal = new map<string, list<User_Status__c>>();
		list<User_Status__c> lst = new list<User_Status__c>();
		string strQueueList = '';
		
		for (string s : stQueues)
		{
			strQueueList += (strQueueList.trim().length() > 0 ? ', ' : '') + '\'' + s + '\'';
		}
		
		string strQuery = UserStatusSelect + ' AND Round_Robin_Queue__c IN (' + strQueueList + ')' +
						' ORDER BY Round_Robin_Queue__c, Round_Robin_Number_Num__c';
		
		system.debug('***RoundRobin: LoadQueueToUserStatus - strQuery: ' + strQuery);
		
		for (User_Status__c u : database.query(strQuery))
		{
			if (retVal.containsKey(u.Round_Robin_Queue__c))
			{
				lst = retVal.get(u.Round_Robin_Queue__c);
				lst.add(u);
			}
			else
			{
				lst = new list<User_Status__c>();
				lst.add(u);
			}
			
			retVal.put(u.Round_Robin_Queue__c, lst);
		}
		
		return retVal;
	}
		
		
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	// Public Static Methods
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	@future
	public static void SetupForRoundRobin (set<Id> stRecordIds)
	{
		SObjectUtils.RoundRobinLogicRunning = true;
		
		list<Lead> lstLeads = new list<Lead>();
		
		for (Lead l : [SELECT Id, Name
						FROM Lead
						WHERE Id IN :stRecordIds
							AND IsConverted = false
						FOR UPDATE])
		{
			lstLeads.add(l);
		}
		
		if (!lstLeads.isEmpty())
		{
			database.update(lstLeads, true);
		}
	}
		
	public static void RoundRobinForLead (list<Lead> lstLead)
	{
		system.debug('***RoundRobin - RunRoundRobin for Leads: ' + lstLead);		
		
		map<Id, Lead> mpLeadIdtoLead = new map<Id, Lead>();
		
		set<string> stQueues = new set<string>();
		string strOwnerId;
		boolean blnNoAssign;
		
		//  Query the Custom Setting for Round Robin Settings
		lstSettings = [SELECT Last_Number_Used__c, Object_API_Name__c, Queue_Name__c
						FROM Round_Robin_Settings__c
						WHERE Object_API_Name__c = 'Lead'];
		
		system.debug('***RoundRobin - RunRoundRobin;lstSettings: ' + lstSettings);
		
		try
		{
			if (!lstSettings.isEmpty())
			{
				// Load the QueueId to Name map
				map<Id, string> mpQueueIdToName = LoadQueueIdToNameMap('Lead');
				
				list<Lead> lstRecordsToAssign = new list<Lead>();
				
				// Loop through all the records passed in to find out the unique set of Queues and the records that qualify for assignment
				for (Lead rcrd : lstLead)
				{
					strOwnerId = rcrd.OwnerId;

					blnNoAssign = rcrd.No_Assign__c;
									
					// Ensure the Lead is both assigned to a Round Robin Queue and is available to be assigned via Round Robin
					if (mpQueueIdToName.containsKey(strOwnerId) && !blnNoAssign && rcrd.IsConverted == false)
					{
						// Add the lead to the list to be assigned
						lstRecordsToAssign.add(rcrd);
						
						// Capture the lead in the lead id to lead map so subscriptions can be re-assigned as well
						mpLeadIdtoLead.put(rcrd.Id, rcrd);
												
						// Capture the Queue needing assignment
						stQueues.add(mpQueueIdToName.get(strOwnerId));
					}	
				}
				
				system.debug('***RoundRobin - RunRoundRobin;lstRecordsToAssign: ' + lstRecordsToAssign);
				
				// Ensure there are records to assign before moving on
				if (!lstRecordsToAssign.isEmpty())
				{
					system.debug('@@@ Running Round Robin on Leads: ' + lstRecordsToAssign); 
					
					// Build a map of Queues to List of User Status Records for the queues needing assignemnt
					map<string, list<User_Status__c>> mpQueueToUserStatus = LoadQueueToUserStatusMap(stQueues);
					
					// Build a map of Queues to current round robin value
					//map<string, decimal> mpQueuePoints = RoundRobinStartingPoints(stQueues, 'Lead');
					map<string, Round_Robin_Settings__c> mpQueuePoints = RoundRobinStartingPoints(stQueues, 'Lead');
					
					system.debug('***RoundRobin - mpQueuePoints: ' + mpQueuePoints);
					
					string strQueue = '';
					//decimal intQueuePoint = 0;
					Round_Robin_Settings__c rrSetting;
					boolean isOwnerFound = false;
					
					// Ensure user status records exist as well as starting points for the queues
					if (!mpQueueToUserStatus.isEmpty() && !mpQueuePoints.isEmpty())
					{
						system.debug('***RoundRobin - RunRoundRobin;Looping to Assign Records');
						// Now loop through the records to Assign and assign them
						for (Lead rcrd : lstRecordsToAssign)
						{
							strOwnerId = rcrd.OwnerId;
							
							strQueue = mpQueueIdToName.get(strOwnerId);
							//intQueuePoint = mpQueuePoints.get(strQueue);
							//system.debug('@@@ Queue: ' + strQueue + ' next Queue Point Number: ' + intQueuePoint)
							rrSetting = mpQueuePoints.get(strQueue);
							system.debug('@@@ Queue: ' + strQueue + ' Queue Point Setting: ' + rrSetting);							
							
							if (mpQueueToUserStatus.containsKey(strQueue))
							{
								isOwnerFound = false;
								
								for (User_Status__c u : mpQueueToUserStatus.get(strQueue))
								{
									//if (u.Round_Robin_Number_Num__c > intQueuePoint)
									if (u.Round_Robin_Number_Num__c > rrSetting.Last_Number_Used__c)
									{
										isOwnerFound = true;
										
										rcrd.OwnerId = u.OwnerId;
										//intQueuePoint = u.Round_Robin_Number_Num__c;
										rrSetting.Last_Number_Used__c = u.Round_Robin_Number_Num__c;
										
										system.debug('***RoundRobin - RunRoundRobin; Number Used: ' + u.Round_Robin_Number_Num__c);
										break;
									}
								}
								
								// If no new owner has been found then pull the first record from the map because we've reached the larget Round Robin Queue Number
								if (!isOwnerFound)
								{
									User_Status__c u = mpQueueToUserStatus.get(strQueue)[0];
									rcrd.OwnerId = u.OwnerId;
									rrSetting.Last_Number_Used__c = u.Round_Robin_Number_Num__c;
									
									system.debug('***RoundRobin - RunRoundRobin; Number Used: ' + u.Round_Robin_Number_Num__c);
								}
									
								system.debug('@@@ Queue: ' + strQueue + ' Queue Point Setting After Round Robin: ' + rrSetting);
							}
							else
							{
								system.debug('***RunRoundRobin: Error.....Unable to find User Status Records for Queue: ' + strQueue);
							}							
						}
						
						integer intTries = 1;
						
						// Update the Custom setting with the proper starting point for next run
						for (Round_Robin_Settings__c r : lstSettings)
						{
							if (r.Object_API_Name__c == 'Lead' && mpQueuePoints.containsKey(r.Queue_Name__c))
							{								
								r.Last_Number_Used__c = mpQueuePoints.get(r.Queue_Name__c).Last_Number_Used__c;
								system.debug('@@@ Queue Point Number To Be Updated: ' + r.Last_Number_Used__c);
							}
						}
						
						while (intTries < 4)
						{
							try
							{
								// Update the records
								update lstSettings;
								intTries = 4;
							}
							catch (Exception exc)
							{
								if (exc.getMessage().contains('UNABLE_TO_LOCK_ROW'))
								{
									system.debug('***RunRoundRobin: Error.....Unable to update Round Robin Settings - Try #: ' + string.valueOf(intTries));
									if (intTries == 3)
									{
										ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error - Custom Setting issue', 'Unable to update Round Robin Settings - Final Try');
									}
									intTries++;
								}
								else
								{
									intTries = 4;
									system.debug('***RunRoundRobin: Error.....Unable to update Round Robin Settings - NO RETRY, with Error: ' + exc.getMessage());
									ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error - Custom Setting issue', 'Unable to update Round Robin Settings - NO RETRY, with Error: ' + exc.getMessage());
								}
							}
						}
					}
					else
					{
						system.debug('***RunRoundRobin: Error.....Unable to find User Status Records for Queues: ' + mpQueueToUserStatus + ' -- or Starting Points: ' + mpQueuePoints);
						ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', 'Unable to find User Status Records for Queues: ' + mpQueueToUserStatus + ' -- or Starting Points: ' + mpQueuePoints);
					}
				}
				else
				{
					system.debug('***RunRoundRobin: Error.....no records to assign');
				}
			}
			else
			{
				system.debug('***RunRoundRobin: Error.....Unable to find custom settings for Lead Round Robin');
				ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', 'Unable to find custom settings for Lead Round Robin');
			}
		}
		catch (Exception exc)
		{
			ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', exc.getMessage() + '; Stack Trace: ' + exc.getStackTraceString());
		}
	}
	
	public static void RoundRobinForAccount (list<Account> lstRecordsToAssign, String QueueName)
	{
	
		set<string> stQueues = new set<string>();
		// Capture the Queue needing assignment
		stQueues.add(QueueName);
		
//		string strOwnerId;
		
		//  Query the Custom Setting for Round Robin Settings
		lstSettings = [SELECT Last_Number_Used__c, Object_API_Name__c, Queue_Name__c
						FROM Round_Robin_Settings__c
						WHERE Object_API_Name__c = 'Account'];
		
		system.debug('***RoundRobin - RunRoundRobin;lstSettings: ' + lstSettings);
		
		try
		{
			if (!lstSettings.isEmpty())
			{
				// Load the QueueId to Name map
				map<Id, string> mpQueueIdToName = new map<Id, string> ();

				// Ensure there are records to assign before moving on
				if (!lstRecordsToAssign.isEmpty())
				{
					system.debug('@@@ Running Round Robin on Accounts: ' + lstRecordsToAssign); 
					
					// Build a map of Queues to List of User Status Records for the queues needing assignemnt
					map<string, list<User_Status__c>> mpQueueToUserStatus = LoadQueueToUserStatusMap(stQueues);
					
					// Build a map of Queues to current round robin value
					map<string, Round_Robin_Settings__c> mpQueuePoints = RoundRobinStartingPoints(stQueues, 'Account');
					
					system.debug('***RoundRobin - mpQueuePoints: ' + mpQueuePoints);
					
					string strQueue = '';
					//decimal intQueuePoint = 0;
					Round_Robin_Settings__c rrSetting;
					boolean isOwnerFound = false;
					
					// Ensure user status records exist as well as starting points for the queues
					if (!mpQueueToUserStatus.isEmpty() && !mpQueuePoints.isEmpty())
					{
						system.debug('***RoundRobin - RunRoundRobin;Looping to Assign Records');
						// Now loop through the records to Assign and assign them
						for (Account rcrd : lstRecordsToAssign)
						{
							strQueue = QueueName;
							rrSetting = mpQueuePoints.get(strQueue);
							system.debug('@@@ Queue: ' + strQueue + ' Queue Point Setting: ' + rrSetting);							
							
							if (mpQueueToUserStatus.containsKey(strQueue))
							{
								isOwnerFound = false;
								
								for (User_Status__c u : mpQueueToUserStatus.get(strQueue))
								{
									if (u.Round_Robin_Number_Num__c > rrSetting.Last_Number_Used__c)
									{
										isOwnerFound = true;
										
										rcrd.OwnerId = u.SalesRep__c;
										rrSetting.Last_Number_Used__c = u.Round_Robin_Number_Num__c;
										
										system.debug('***RoundRobin - RunRoundRobin; Number Used: ' + u.Round_Robin_Number_Num__c);
										break;
									}
								}
								
								// If no new owner has been found then pull the first record from the map because we've reached the larget Round Robin Queue Number
								if (!isOwnerFound)
								{
									User_Status__c u = mpQueueToUserStatus.get(strQueue)[0];
									rcrd.OwnerId = u.SalesRep__c;
									rrSetting.Last_Number_Used__c = u.Round_Robin_Number_Num__c;
									
									system.debug('***RoundRobin - RunRoundRobin; Number Used: ' + u.Round_Robin_Number_Num__c);
								}
									
								system.debug('@@@ Queue: ' + strQueue + ' Queue Point Setting After Round Robin: ' + rrSetting);
							}
							else
							{
								system.debug('***RunRoundRobin: Error.....Unable to find User Status Records for Queue: ' + strQueue);
							}							
						}
						
						updateSetting(mpQueuePoints);
					}
					else
					{
						system.debug('***RunRoundRobin: Error.....Unable to find User Status Records for Queues: ' + mpQueueToUserStatus + ' -- or Starting Points: ' + mpQueuePoints);
						ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', 'Unable to find User Status Records for Queues: ' + mpQueueToUserStatus + ' -- or Starting Points: ' + mpQueuePoints);
					}
				}
				else
				{
					system.debug('***RunRoundRobin: Error.....no records to assign');
				}
			}
			else
			{
				system.debug('***RunRoundRobin: Error.....Unable to find custom settings for Account Round Robin');
				ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', 'Unable to find custom settings for Account Round Robin');
			}
		}
		catch (Exception exc)
		{
			ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error', exc.getMessage() + '; Stack Trace: ' + exc.getStackTraceString());
		}
	}

	private static void updateSetting(map<string, Round_Robin_Settings__c> mpQueuePoints)
	{
		
		integer intTries = 1;
						
		// Update the Custom setting with the proper starting point for next run
		for (Round_Robin_Settings__c r : lstSettings)
		{
			if (r.Object_API_Name__c == 'Account' && mpQueuePoints.containsKey(r.Queue_Name__c))
			{								
				r.Last_Number_Used__c = mpQueuePoints.get(r.Queue_Name__c).Last_Number_Used__c;
				system.debug('@@@ Queue Point Number To Be Updated: ' + r.Last_Number_Used__c);
			}
		}
						
		while (intTries < 4)
		{
			try
			{
				// Update the records
				update lstSettings;
				intTries = 4;
			}
			catch (Exception exc)
			{
				if (exc.getMessage().contains('UNABLE_TO_LOCK_ROW'))
				{
					system.debug('***RunRoundRobin: Error.....Unable to update Round Robin Settings - Try #: ' + string.valueOf(intTries));
					if (intTries == 3)
					{
						ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error - Custom Setting issue', 'Unable to update Round Robin Settings - Final Try');
					}
					intTries++;
				}
				else
				{
					intTries = 4;
					system.debug('***RunRoundRobin: Error.....Unable to update Round Robin Settings - NO RETRY, with Error: ' + exc.getMessage());
					ErrorEmailHelper.notifyOnError('RoundRobin', 'Round Robin Error', 'Round Robin Error - Custom Setting issue', 'Unable to update Round Robin Settings - NO RETRY, with Error: ' + exc.getMessage());
				}
			}
		}
	}
	
}