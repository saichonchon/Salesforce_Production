/*======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 11/20/14  add forever consulting cases and opp update for Cases
2.0 Maggie Frederick 2/17/15   change to platinum plus products and check if active status
3.0 Maggie Frederick 3/5/15 	Changes for Cronsights
4.0 Maggie Frederick 5/14/15 	Remove creating PS cases
5.0 Maggie Frederick 5/14/15    EIG Billing add Opportunity
 
***********************************************************************/


public without sharing class CaseHandle_Helper 
{
    private static final Id USERID = UserInfo.getUserId();
    private static final User CURUSER = [SELECT Id, Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
    public static Id idMigCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
    public static Boolean ALREADY_RAN = false;      

    public static list<Case> getCaseList(set<Id>stCaseIds)
    {
    	return [SELECT Id, OwnerId, Owner.Name, Owner.Type, Owner.UserRole.Name, Status, IsClosed, Category__c, Department__c, Origin, Reason, 
    				RecordTypeId, RecordType.Name
                FROM Case
                WHERE Id IN :stCaseIds];
    }
    
    public static void account_LastSurveyDate(set<Id> stAcctIds)
    {
    	if (stAcctIds != null && !stAcctIds.isEmpty())
    	{
    		list<Account> lstAcctToUpdate = new list<Account>();
    		map<Id, Account> mpAcctIdtoAcct = new map<Id, Account>();
    		Account objA;
    		Date lastSurvey;
    		
    		for (Account a : [SELECT Id, Date_of_Last_Survey_Sent__c
    						FROM Account
    						WHERE Id IN :stAcctIds])
    		{
    			mpAcctIdtoAcct.put(a.Id, a);
    		}
    		
    		for (AggregateResult ar : [SELECT AccountId, MAX(Survey_Completion_Date__c)lastSurvey
    									FROM Case 
    									WHERE AccountId IN :stAcctIds
    									GROUP BY AccountId])
    		{
    			lastSurvey = date.valueOf(ar.get('lastSurvey'));    			
    			objA = mpAcctIdtoAcct.get(string.ValueOf(ar.get('AccountId')));
    			
    			if (objA.Date_of_Last_Survey_Sent__c != lastSurvey)
    			{
	    			objA.Date_of_Last_Survey_Sent__c = lastSurvey;
    			
    				lstAcctToUpdate.add(objA);
    			}
    		}
    		
    		if (!lstAcctToUpdate.isEmpty())
    		{
    			update lstAcctToUpdate;
    		}
    	}	
    }
/*    
    public static void lead_LastSurveyDate(set<Id> stLeadIds)
    {
    	if (stLeadIds != null && !stLeadIds.isEmpty())
    	{
    		list<Lead> lstLeadToUpdate = new list<Lead>();
    		map<Id, Lead> mpLeadIdtoLead = new map<Id, Lead>();
    		Lead objL;
    		Date lastSurvey;
    		
    		for (Lead l : [SELECT Id, IsConverted, Last_Case_Survey_Date__c
    						FROM Lead
    						WHERE Id IN :stLeadIds])
    		{
    			mpLeadIdtoLead.put(l.Id, l);
    		}
    		
    		
    		for (AggregateResult ar : [SELECT Lead__c, MAX(Survey_Completion_Date__c)lastSurvey
    									FROM Case 
    									WHERE Lead__c IN :stLeadIds
    									GROUP BY Lead__c])
    		{
    			lastSurvey = date.valueOf(ar.get('lastSurvey'));    			
    			objL = mpLeadIdtoLead.get(string.ValueOf(ar.get('Lead__c')));
    			
    			if (!objL.IsConverted && objL.Last_Case_Survey_Date__c != lastSurvey)
    			{
    				objL.Last_Case_Survey_Date__c = lastSurvey;
    				    			
    				lstLeadToUpdate.add(objL);
    			}
    		}
    		
    		if (!lstLeadToUpdate.isEmpty())
    		{
    			update lstLeadToUpdate;
    		}
    	}
    }
    
    @future
    public static void case_StartWorkingNewCase(set<Id> stCaseIds)
    {
        list<Case_Time_Worked__c> lstWorked = new list<Case_Time_Worked__c>();
        Case_Time_Worked__c objCTW;
        
        map<String, Case_RecordTypes_for_Time_Worked__c> mpCSRecTypes = Case_RecordTypes_for_Time_Worked__c.getAll();
        
        // Loop through all the cases and if necessary create a new Case Time Worked record
        for (Case c : getCaseList(stCaseIds))
        {
            system.debug('***CaseHandle_Helper:case_StartWorkingNewCase - Case isClosed: ' + c.IsClosed);
            system.debug('***CaseHandle_Helper:case_StartWorkingNewCase - Case Owner Id: ' + c.OwnerId);
            system.debug('***CaseHandle_Helper:case_StartWorkingNewCase - Case User Type: ' + c.Owner.Type);
            
            // Make sure this new case is NOT closed and is owned by a User (not a queue), and is a record type included in the logic
            if (!c.IsClosed && c.Owner.Type == 'User' && mpCSRecTypes.containsKey(c.RecordType.Name))
            {
                objCTW = createTimeWorkedFromCase(c, true);
                lstWorked.add(objCTW);
                system.debug('***CaseHandle_Helper:case_StartWorkingNewCase - objCTW: ' + objCTW);
            }
        }
        
        // Check if any records need to be inserted or updated
        if (!lstWorked.isEmpty())
        {
            insert lstWorked;
        }
    }
  */  
    public static void case_StartWorking(set<Id> stCaseIds)
    {
        system.debug('***CaseHandle_Helper:case_StartWorking - stCaseIds: ' + stCaseIds);
        
        list<Case> lstCasesToUpdate = new list<Case>();
        list<Case_Time_Worked__c> lstWorked = new list<Case_Time_Worked__c>();
        Case_Time_Worked__c objCTW;
        
        // Loop through all the cases and create a new Case Time Worked record if necessary
        for (Case c : getCaseList(stCaseIds))
        {
            //system.debug('***CaseHandle_Helper:case_StartWorking - Case: ' + c);
            system.debug('***CaseHandle_Helper:case_StartWorking - Case isClosed: ' + c.IsClosed);
            system.debug('***CaseHandle_Helper:case_StartWorking - Case Owner Id: ' + c.OwnerId);
            system.debug('***CaseHandle_Helper:case_StartWorking - Running User Id: ' + USERID);
            system.debug('***CaseHandle_Helper:case_StartWorking - Case User Type: ' + c.Owner.Type);
            
            // Make sure the case is NOT already owned by the current user, is in fact owned by a queue, and is NOT Closed
 //           if (!c.IsClosed && c.OwnerId != USERID && c.Owner.Type == 'Queue')
 			if (!c.IsClosed )
            {
  //              objCTW = createTimeWorkedFromCase(c, false);
                lstWorked.add(objCTW);
                system.debug('***CaseHandle_Helper:case_StartWorking - objCTW: ' + objCTW);
                if (c.OwnerId <> USERID)
                {
	                c.OwnerId = USERID;
	                lstCasesToUpdate.add(c);
	                system.debug('***CaseHandle_Helper:case_StartWorking - updated case: ' + c);
 
                }
            }
            else
            {
            	system.debug('***CaseHandle_Helper:case_StartWorking - Case did NOT Meet Requirements for creating Time Worked Record');
            }
        }
        
        // Check if any records need to be inserted or updated
        if (!lstWorked.isEmpty())
        {
//            insert lstWorked;
        }
        
        if (!lstCasesToUpdate.isEmpty())
        {
        	// Make sure to set the DML Options to not send any emails
        	database.Dmloptions dml = new database.Dmloptions();
        	dml.emailHeader.triggerAutoResponseEmail = false;
        	dml.emailHeader.triggerUserEmail = false;
        	dml.emailHeader.triggerOtherEmail = false;
            database.update(lstCasesToUpdate, dml);
        }
    }
  /*  
    public static void case_StopWorking (Case objC)
    {
    	system.debug('***CaseHandle_Helper:case_StopWorking - starting for Case: ' + objC);
    	
        list<Case_Time_Worked__c> lstCTW = new list<Case_Time_Worked__c>();
        
        for (Case_Time_Worked__c ctw : [SELECT Id, Case__c, Stop_Time__c
                                        FROM Case_Time_Worked__c
                                        WHERE Case__c = :objC.Id
                                            AND Owner_to_ID__c = :USERID
                                            AND Stop_Time__c = null])
        {
        	system.debug('***CaseHandle_Helper:case_StopWorking - stoping CTW: ' + ctw);
            ctw.Stop_Time__c = system.now();
            lstCTW.add(ctw);
        }
        
        if (!lstCTW.isEmpty())
        {
            update lstCTW;
        }
    }
    
    public static void case_StopWorkingAllOpenTime (set<Id> stCaseId)
    {
        list<Case_Time_Worked__c> lstCTW = new list<Case_Time_Worked__c>();
        
        for (Case_Time_Worked__c ctw : [SELECT Id, Case__c, Stop_Time__c
                                        FROM Case_Time_Worked__c
                                        WHERE Case__c = :stCaseId
                                            AND Stop_Time__c = null])
        {
            ctw.Stop_Time__c = system.now();
            lstCTW.add(ctw);
        }
        
        if (!lstCTW.isEmpty())
        {
            update lstCTW;
        }
    }
  
    public static Case_Time_Worked__c createTimeWorkedFromCase (Case objC, boolean isInsert)
    {
        // Create the Time Worked record
        Case_Time_Worked__c objCTW = new Case_Time_Worked__c();
        
        objCTW.Case__c = objC.Id;
        objCTW.Case_Category__c = objC.Category__c;
        objCTW.Case_Department__c = objC.Department__c;
        objCTW.Case_Origin__c = objC.Origin;
        objCTW.Case_Reason__c = objC.Reason;
        objCTW.Case_Status__c = objC.Status;        
        objCTW.Owner_from_ID__c = isInsert ? null : objC.OwnerId;
        objCTW.Owner_from_Name__c = isInsert ? null : objC.Owner.Name;
        objCTW.Owner_Role__c = isInsert ? objC.Owner.UserRole.Name : CURUSER.UserRole.Name;
        objCTW.Owner_to_ID__c = isInsert ? objC.OwnerId : CURUSER.Id;
        objCTW.Owner_to_Name__c = isInsert ? objC.Owner.Name : CURUSER.Name;     
        objCTW.Start_Time__c = system.now();
                
        return objCTW;
    }
    
    public static Case_Time_Worked__c findLastQueueForCase (Id caseId)
    {
        Case_Time_Worked__c objCTW = null;
        
        for (Case_Time_Worked__c ctw : [SELECT Id, Case__c, Owner_from_Name__c, Owner_from_ID__c
                                        FROM Case_Time_Worked__c
                                        WHERE Case__c = :caseId
                                            AND Owner_to_ID__c = :USERID
                                            AND Stop_Time__c = null])
        {
            objCTW = ctw;
            break;
        }
        
        return objCTW;
    }
 */     
    public static long getDateDiffInMinutes(datetime earlyDT, datetime lateDT)
    {  
    	//getTime gives us milliseconds, so divide by 1000 for seconds, and again by 60 for minutes
		long dt1 = earlyDT.getTime() / 1000 / 60;    
		long dt2 = lateDT.getTime() / 1000 / 60;
		long diff = dt2 - dt1;
		return diff;
	}
	
	public static long getOverlapTimeInMinutes(DateTime dtObj1Start, DateTime dtObj1End, DateTime dtObj2Start, DateTime dtObj2End)
	{
		long overLap = 0;
		
		// (1) Front Overlap where Object 2 starts before Object 1 but ends before Object 1 ends
		if (dtObj2Start < dtObj1Start && dtObj2End > dtObj1Start && dtObj2End <= dtObj1End)
		{
			// Since this is a front overlap, return the length of the block of the Object 2 record that is overlapping
			overLap = getDateDiffInMinutes(dtObj1Start, dtObj2End); 
		}	    				
		// (2) Middle Overlap where Object 2 starts after or at the same time as Object 1 and Ends at same time or before Object 1 ends
		else if (dtObj2Start >= dtObj1Start && dtObj2Start < dtObj1End && dtObj2End <= dtObj1End)
		{
			// Since this is a middle overlap, return the length of the entire Object 2
			overLap = getDateDiffInMinutes(dtObj2Start, dtObj2End);
		}
		// (3) Back Overlap where Object 2 starts after or at the same time as Object 1 and Ends after Object 1 ends
		else if (dtObj2Start >= dtObj1Start && dtObj2Start < dtObj1End && dtObj2End > dtObj1End)
		{
			// Since this is a back overlap, return the length of the block of the Object 1 record that is overlapping
			overLap = getDateDiffInMinutes(dtObj2Start, dtObj1End);
		}
		// (4) Complete Overlap where Object 2 starts before Object 1 and Ends after Object 1
		else if (dtObj2Start < dtObj1Start && dtObj2Start < dtObj1End && dtObj2End > dtObj1End)
		{
			// Since this is a complete overlap, return the length of the entire Object 1
			overLap = getDateDiffInMinutes(dtObj1Start, dtObj1End);
		}
		
		return overLap;
	}
    
    public static void rollUpCaseHandleTime (set<Id> stCaseId  )
    {
     	Id idCSCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
 
 		list<Case> lstCaseToUpdate = new list<Case>();
		
    	for (Case c : [SELECT Id, CaseNumber, RecordTypeId, Total_Case_Handle_Time__c, Total_Case_Time_Worked__c, Total_Call_CTI_Time__c, Total_Chat_Time__c, Total_Case_Time__c, Primary_Case_Rep__c
						FROM Case
						WHERE Id IN :stCaseId])
		{
			if (c.RecordTypeId == idCSCaseRecordType)
				lstCaseToUpdate.add(c);
		}
		
		rollUpCaseHandleTimeCases(true, lstCaseToUpdate );
    	
    }
    
    public static void rollUpCaseHandleTimeCases (Boolean updateCases, list<Case> lstCase  )
    {
 		
    	set<Id> stCaseId = new set<Id>();
    	if (!lstCase.IsEmpty())
    	{
    		list<Case> lstCaseToUpdate = new list<Case>();
    		map<Id, Case> mpCaseIdToCase = new map<Id, Case>();
	    	for (Case c : lstCase)
			{
				mpCaseIdToCase.put(c.Id, c);
				stCaseId.add(c.Id);
			}
	    	
// replace	    	map<Id, list<Case_Time_Worked__c>> mpCaseToCTWList = loadCaseToCTWList(stCaseId);
            map<Id, List<WorkIt2__Timing__c>> mpCaseToCWList = loadCaseToCWList(stCaseId);
	    	map<Id, list<LiveChatTranscript>> mpCaseToLCTList = loadCaseToLCTList(stCaseId);
	    	map<Id, list<CallTaskWrapper>> mpCaseToCallList = loadCaseToCallList(stCaseId);
	    	map<Id, list<RepTimeWrapper>> mpCaseToUserTimeList = loadCaseToUserTimeList(stCaseId);
	    	
	    	boolean updateCase = false;
	    	Id primaryRep;
	    	decimal repTime = 0;
	    	decimal totHandleTime = 0;
	    	long overLapTime = 0;
//	    	Case objC;    	
	    	
	    	// Loop through all the case Ids passed in
			for (Case objC :lstCase)
//	    	for (string csId : stCaseId)
	    	{
	    		updateCase = false;
	    		
//	    		objC = mpCaseIdToCase.get(csId);
	    		string csId = objC.Id;
	    		primaryRep = objC.Primary_Case_Rep__c;
	    		repTime = 0;
	    		
	    		// Figure out the primary rep for the case if records exist
	    		if (mpCaseToUserTimeList != null && mpCaseToUserTimeList.containsKey(csId))
	    		{
//	    			system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - RepTimeMap for Case: ' + mpCaseToUserTimeList.get(csId));
	    			
	    			// Loop through each rep record to see who has the most time
	    			for (RepTimeWrapper rep : mpCaseToUserTimeList.get(csId))
	    			{
	    				system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - RepTimeMap for Rep: ' + rep);
	    				
	    				// If this is a different rep than already on the Case or than the last highest rep time 
	    				if (rep.RepId != primaryRep && (rep.RepTimeInMinutes > repTime || primaryRep == null))
	    				{
	    					primaryRep = rep.RepId;
	    					repTime = rep.RepTimeInMinutes;
	    				}
	    			}
	    			
	    			// If the primary rep found is different than what was already on the case
	    			if (primaryRep != objC.Primary_Case_Rep__c)
	    			{
	    				objC.Primary_Case_Rep__c = primaryRep;
	    				updateCase = true;
	    			}
	    		}
	    		
	    		totHandleTime = 0;
// replace	    		
	    		// Capture the total case time from Case Time Woked
	    		if (mpCaseToCWList != null && mpCaseToCWList.containsKey(csId))
	    		{
	    			for (WorkIt2__Timing__c cTime : mpCaseToCWList.get(csId))
		    		{
		    			if (cTime.WorkIt2__Time_In_Minutes__c != null)
		    			{
		    				totHandleTime += cTime.WorkIt2__Time_In_Minutes__c;
		    			}
		    		}
	    		} 
	    		
	    		// Capture the total case time from Live Chat
	    		if (mpCaseToLCTList != null && mpCaseToLCTList.containsKey(csId))
    			{
    				for (LiveChatTranscript cChat : mpCaseToLCTList.get(csId))
			    	{
			    		if (cChat.Chat_Duration_Minutes__c != null)
		    			{
			    			totHandleTime += cChat.Chat_Duration_Minutes__c;
		    			}
			    	}
    			}
    			
    			// Capture the total case time from Calls
    			if (mpCaseToCallList != null && mpCaseToCallList.containsKey(csId))
    			{
	    			for (CallTaskWrapper cCall : mpCaseToCallList.get(csId))
	    			{
	    				if (cCall.objTask.Call_Duration_Minutes__c != null)
		    			{
	    					totHandleTime += cCall.objTask.Call_Duration_Minutes__c;
		    			}
	    			}
    			}
	    			    		
	    		system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - initial Handle Time: ' + totHandleTime);
// replace	    		
	    		// Now loop through all the Case Time Worked records for the case and see if anything overlaps
	    		if (mpCaseToCWList != null && mpCaseToCWList.containsKey(csId))
	    		{
		    		
		    		List<WorkIt2__Timing__c> timings = mpCaseToCWList.get(csId);
		    	    for (WorkIt2__Timing__c timing :timings)
		    	    {
				    		for ( WorkIt2__Time_Entry__c cTime : timing.WorkIt2__Time_Entries__r)
				    		{
				    			overLapTime = 0;
				    				    			
				    			// See if there are any Chats that overlap with this case time record
				    			if (mpCaseToLCTList != null && mpCaseToLCTList.containsKey(csId))
				    			{
					    			for (LiveChatTranscript cChat : mpCaseToLCTList.get(csId))
					    			{
					    				overLapTime = getOverlapTimeInMinutes(cTime.WorkIt2__Start__c, cTime.WorkIt2__End__c, cChat.StartTime, cChat.EndTime);
					    				totHandleTime = totHandleTime - overLapTime;
					    			}
				    			}
				    			
				    			// See if there are any CTI Tasks that overlap with this case time record
				    			if (mpCaseToCallList != null && mpCaseToCallList.containsKey(csId))
				    			{
					    			for (CallTaskWrapper cCall : mpCaseToCallList.get(csId))
					    			{
					    				system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - CTI Call record: ' + cCall);
					    				overLapTime = getOverlapTimeInMinutes(cTime.WorkIt2__Start__c, cTime.WorkIt2__End__c, cCall.dtStart, cCall.dtEnd);
					    				system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - CTI Call overLapTime: ' + overLapTime + ' for record: ' + cCall);
					    				totHandleTime = totHandleTime - overLapTime;
					    			}
				    			}
				    		}
		    	    }
	    		}	    		
	    		
	    		system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - final Handle Time: ' + totHandleTime);
	    		system.debug('@@@ CaseHandle_Helper:rollUpCaseHandleTime - Case Handle Time: ' + objC.Total_Case_Handle_Time__c);
	    		
	    		if (objC.Total_Case_Handle_Time__c != totHandleTime)
	    		{
	    			objC.Total_Case_Handle_Time__c = totHandleTime;
	    			updateCase = true;
	    		}
	    		
	    		if (updateCases )
				{
					lstCaseToUpdate.add(objC);
	    		}
	    	}
	    	
	    	// If there are cases to update
	    	if (!lstCaseToUpdate.isEmpty())
	    	{
	    		update lstCaseToUpdate;
	    	}
    	}	
    }
    
    public static void rollupMigrations(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isDelete, Boolean isUpdate,
                                        List<Case> newList,  List<Case> oldList, Map<Id, Case> newMap)
    
    {
//    	Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
        
        Set<Id> allaccts     = new Set<Id>();
        if (isDelete)
 		{
 			for (integer i = 0; i < oldList.size(); i++)
    		{
    			if ( oldList[i].RecordTypeId == idMigCaseRecordType )
    			{ allaccts.add(oldList[i].AccountId);}
 			}
 		}
        else {

	    	for (integer i = 0; i < newList.size(); i++)
	    	{
	    		if ( newList[i].RecordTypeId == idMigCaseRecordType )
	    		{ allaccts.add(newList[i].AccountId);}
	 		}
        }
        	
    	if(!allaccts.isEmpty()) updateAccountCount(allaccts);
    	  
    }
 
 /*  
    public static void createSSCase(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isDelete, Boolean isUpdate,
                                        List<Case> newList,  List<Case> oldList, Map<Id, Case> newMap)
    
    {
    	if (!TriggerRecursionController.casesCreatedFromPSCase)
    	{
	    	Id idPSCaseRecordType = Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
	    	List<Case> clcases = new List<Case>();
	
	    	for (integer i = 0; i < newList.size(); i++)
		    	{
		    		if ( ((newList[i].RecordTypeId == idMigCaseRecordType  && newList[i].Needs_Store_Setup__c == true)
//		    		        || (newList[i].RecordTypeId == idPSCaseRecordType  
//		    		         	&& (newList[i].Outcome__c == 'Platinum Plus Store Setup'  || newList[i].Outcome__c == 'Consultation Complete')
//				                && (newList[i].Consultation_Hours_Available__c == 'Forever' || newList[i].Product__c == 'Platinum Plus')
//		    		         	)
		    		       )
		    		     && (newList[i].Status == 'Closed' 
		    		     && ( isInsert || newList[i].Status <> oldList[i].Status))
	//	    		     && newList[i].Origin == 'Orion Request' 
	           	    		   )
		    		{ clcases.add(newList[i]);}
		 		}
	        
	        if (clcases.isEmpty()) return;
	        
	        Map<Id, Case> mapCaseAcct = new Map<Id, Case>([select Id, Account.Id, Account.Ltc__c, Needs_Store_Setup__c,  Consultation_Hours_Available__c, RecordTypeId, Account.SBD_Segment__c, Product__c, OwnerId, Subscription__r.Status__c, Outcome__c from Case where Id in :clcases]);
	        List<Case> sscases = new List<Case>();
	        
	        Id caseId;
	        for (Case c :clcases)
	        {
	        	Case clc = mapCaseAcct.get(c.Id);
	        	if (clc.Subscription__r.Status__c == 'Active')
	        	{
			                caseId = c.Id;
			            	Case newCase = new Case();
				            newCase.Origin = 'Internal Request';
				            newCase.Subject = 'Client purchase';
				            newCase.OwnerId= Label.PS_Queue;
				            if (clc.Needs_Store_Setup__c == true )
				            {
					            newCase.Reason = 'Store Setup';
					            newCase.Description = 'Store Setup for Client ' ;
				            }
				            else  if (clc.RecordTypeId == idPSCaseRecordType 
				            		&& clc.Subscription__r.Status__c == 'Active'
				            		&& (clc.Consultation_Hours_Available__c == 'Forever'
				                       || clc.Product__c == 'Platinum Plus')
				                    && (clc.Outcome__c == 'Platinum Plus Store Setup'  || clc.Outcome__c == 'Consultation Complete')
				                       )
				            {
					            newCase.Reason = 'Consultation Hours Available';
					            newCase.Description = 'Additional Consultation Services for Client ' ;
					            newCase.Consultation_Hours_Available__c = 'Forever';
					            newCase.OwnerId= clc.OwnerId;
				            }

				            newCase.Department__c = 'Professional Services';
				            newCase.AccountId = clc.Account.Id;
				            newCase.Subscription__c = c.Subscription__c;
				            newCase.ContactId = c.ContactId ;
				            newCase.RecordTypeId = idPSCaseRecordType;
				            newCase.Current_Store_URL__c = c.Current_Store_URL__c;
				           
			 /           	if (clc.Account.Ltc__c<> null) 
			            	{ 
			            		newCase.OwnerId =clc.Account.Ltc__c;
			            	}
			            	else
			 
			            	{
			            		
			            		newCase.OwnerId= Label.PS_Queue;
			            	}
			 /
			                ssCases.add(newCase);      
	        	} 
	         }      
	              
	        Try
	        { 
	        	insert ssCases; 
	        	TriggerRecursionController.casesCreatedFromPSCase = true;
	        }
	        catch (Exception e)
	        {
	           ErrorEmailHelper.notifyOnError('Case Trigger Handler', 'Create SS Case', 'Error in Case Trigger Handler - Create Case', 'Error Creating case for: ' + caseId);
	           system.debug('Error in CaseTrigger Handler - Create SS Case');
	                          	
	        }
    	}  
    }
    
*/
    
    public static void updateLead(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isDelete, Boolean isUpdate,
                                        List<Case> newList,  List<Case> oldList, Map<Id, Case> newMap)
    
    {
    	
    	Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();

        Set<Id> leadIds = new Set<Id>();
        Set<id> acctIds = new Set<Id>();

        if (!isDelete && isAfter)
 		{
 			for (integer i = 0; i < newList.size(); i++)
    		{
    			system.debug('acct' +newList[i].AccountId);
    			if ( 
    			    newList[i].RecordTypeId == idCaseRecordType &&
    				  (newList[i].Lead__c <> null || newList[i].AccountId <> null)
    				&& ((!isInsert && newList[i].Status == 'Closed'  && oldList[i].Status <> 'Closed')
    				    || (isInsert &&  newList[i].Status == 'Closed'))
    			)
    			{ 
    				if (newList[i].Lead__c <> null) leadIds.add(newList[i].Lead__c);
    				if (newList[i].AccountId <> null) acctIds.add(newList[i].AccountId);
    			}
 			}
 		}
		
		system.debug(acctIds.size());
		if (!acctIds.isEmpty()) updateOpps(acctIds);	
	
		if (!leadIds.isEmpty()) updateLeads(leadIds);
    
    }
    
    private static void updateLeads(Set<Id> leadIds)
	{
        
        List <Lead> updLeads = new List<Lead>();
        
        for (Lead le :[Select Id,Temperature__c, Stage__c, isConverted from Lead where id in :leadIds])
    	{
    		if ( !le.isConverted  && (le.Temperature__c <> 'Hot' || le.Stage__c <> 'Engaged'))
	    	{
	    		le.Temperature__c = 'Hot';
	    		le.Stage__c = 'Engaged';
	    		updLeads.add(le);
	    	}
    		
    	}
    	try {
    		update updLeads;
    	}
    	catch (exception e)
    	{
    		system.debug(' Error in updatin glead '+e);
    	}
    
	}
    private static void updateOpps(Set<Id> acctIds)
	{
		List <Opportunity> updOpps = new List<Opportunity>();
	    Id TrialRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Trial).getRecordTypeId();


		for (Opportunity o :[Select Id,Temperature__c  from Opportunity where Accountid in :acctIds and RecordTypeId = :TrialRecordTypeId])
    	{
    		if ( o.Temperature__c <> 'Hot' )
	    	{
	    		o.Temperature__c = 'Hot';
//	    		le.Stage__c = 'Engaged';
	    		updOpps.add(o);
	    	}
    		
    	}
    	try {
    		update updOpps;
    	}
    	catch (exception e)
    	{
    		system.debug(' Error in updating Opportunity '+e);
    	}
		
	}
     
     
    private static void updateAccountCount(Set<Id> acctIds)
    {
    	Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
       
    	List <Account> cs = new List<Account>([Select a.Open_Migration_Cases__c, a.Id, a.Closed_Migration_Cases__c, (Select RecordTypeId, Status From Cases where RecordTypeId =:idCaseRecordType ) From Account a where  Id in :acctIds]);

 		List <Account> alist = new List <Account>();
		for ( Account a:cs)
		{
			integer newopencount = 0;
			integer newclosedcount = 0;
		
			for (case c :a.Cases)
			{
			   if (c.status == 'Closed' || c.status == 'Completed') newClosedCount++;
			   else newopenCount++;
			}
			
			if (a.Open_Migration_Cases__c <> newOpenCount || a.Closed_Migration_Cases__c <> newClosedCount)
			  	 {
			  	 	if (a.Open_Migration_Cases__c <> newopencount) a.Open_Migration_Cases__c = newopencount;
			  	 	if (a.Closed_Migration_Cases__c <> newclosedcount) a.Closed_Migration_Cases__c = newclosedcount;
			  	 	alist.add(a);
			  	 }

	}
		system.debug(' size '+alist.size());
		update alist;
    }
    
    public static void updateEIGCase(List<Case> newList)
    {
		Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        string soqlWHERE_SBDStoreIDs = '';
		Map <Id, String> mpCaseStore = new Map<Id, String>();
 
 		for (Case c :newList)
		{
			if (c.RecordTypeId == idCaseRecordType && c.Origin == 'EIG Billing'
				&& c.Subscription__c == null)
			{
					String[] emailBody = c.Description.split('\n', 0);
					for (String s :emailBody)
					{
//					  system.debug(' string '+s);
						if (s <> '' && s.length()> 7 )
							
						{  
							String[] splits = s.split(':',2);
							if (splits[0].containsIgnoreCase('STORE_ID'))
							{
								system.debug( 'found store id '+splits[1]);
								// trim teh store id
								mpCaseStore.put(c.Id, splits[1].trim());
								soqlWHERE_SBDStoreIDs += (soqlWHERE_SBDStoreIDs.length()  == 0 ? '' : ', ') + '\'' + splits[1].trim() + '\'';
		                     }
							if (splits[0].containsIgnoreCase('CANCELLATION_REASON')) c.Cancellation_Reason__c = splits[1];
							if (splits[0].containsIgnoreCase('REQUEST_TYPE')) c.Reason = splits[1];
					    }
					}
					c.Requesting_Department__c = 'Strategic Partner Sales';
			}
		}

/*		
		if (soqlWHERE_SBDStoreIDs <> '')
		{
			map<string, Subscription__c> mpSubByStoreId = LoadSubByStoreId(soqlWHERE_SBDStoreIDs);
			
			for (Case updc :newList)
			{
				Subscription__c sub = new Subscription__c();
				if (mpCaseStore.get(updc.Id) <> null)
					sub = mpSubByStoreId.get(mpCaseStore.get(updc.Id));
				if (sub <> null)
				{
					updc.Subscription__c = sub.Id;
					updc.AccountId = sub.Account__r.Id;
					updc.ContactId = sub.Contact__r.Id;
					
				}
		 		
			}
		}
*/
		if (soqlWHERE_SBDStoreIDs <> '')
		{
			map<string, Opportunity> mpOppByStoreId = LoadOppByStoreId(soqlWHERE_SBDStoreIDs);
			
			for (Case updc :newList)
			{
				Opportunity opp = new Opportunity();
				if (mpCaseStore.get(updc.Id) <> null)
					opp = mpOppByStoreId.get(mpCaseStore.get(updc.Id));
				if (opp <> null)
				{
					updc.Subscription__c = opp.Subscription__c;
					updc.AccountId = opp.AccountId;
					updc.ContactId = opp.Contact__r.Id;
					updc.Opportunity__c = opp.Id;
					
				}
		 		
			}
 
		}
		
    }
 /*  
    private static map<string, Subscription__c> LoadSubByStoreId(string soqlStoreId)
    {
        map<string, Subscription__c> mpSubByStoreId = new map<string, Subscription__c>();
        
        if (soqlStoreId.trim().length() > 0)
        {       
            string strSOQL = 'Select  Id, Account__r.Id, Contact__r.Id, SBD_Store_id__c From Subscription__C WHERE SBD_Store_ID__c IN (' + soqlStoreId + ')' ;
            
            system.debug('**** By Store Id: ' + strSOQL);
                    
            // Grab all  that match the account id
            for (Subscription__c  s: database.query(strSOQL))
            {
                mpSubByStoreId.put(s.SBD_Store_ID__c, s);
            }
        }
        return mpSubByStoreId;
    }
 */  
    private static map<string, Opportunity> LoadOppByStoreId(string soqlStoreId)
    {
        map<string, Opportunity> mpOppByStoreId = new map<string, Opportunity>();
        
        if (soqlStoreId.trim().length() > 0)
        {       
            string strSOQL = 'Select  Id, AccountId, Contact__r.Id, SBD_Store_id__c, Subscription__c From Opportunity WHERE SBD_Store_ID__c IN (' + soqlStoreId + ')' ;
            
            system.debug('**** By Store Id: ' + strSOQL);
            Try
            {       
	            // Grab all  that match the account id
	            for (Opportunity o: database.query(strSOQL))
	            {
	                mpOppByStoreId.put(o.SBD_Store_ID__c, o);
	            }
            }
            catch (exception e)
            {
            	ErrorEmailHelper.notifyOnError('Case Trigger Handler', 'Create EIG Case', 'Error in Case Trigger Handler - Create Case', 'Error Creating case for: ' + strSOQL);
             	system.debug('Error in CaseTrigger Handler - Create EIG Case');
            }
        }
        return mpOppByStoreId;
    }
   
   public static void addPublicCaseComment(List<Case> emailCases)
   {
   		List<CaseComment> lstComments = new List<CaseComment>();
   		for (Case c:emailCases)
   		{
   			string cBody = 'Email Sent \n Subject: '+c.Subject +'\n '+ 'Description: '+c.Description;
   			CaseComment newCom = new CaseComment(ParentId = c.Id, isPublished= true, commentBody = cBody);
   			lstComments.add(newCom);
   		}
   		insert lstComments;
   }
   /* replace 
    private static map<Id, list<Case_Time_Worked__c>> loadCaseToCTWList (set<Id> stCaseId)
    {
    	map<Id, list<Case_Time_Worked__c>> mpCaseToCTWList = new map<Id, list<Case_Time_Worked__c>>(); 
    	
    	list<Case_Time_Worked__c> lstCTW = new list<Case_Time_Worked__c>();
    	
    	// Get all the Case Time Worked records for each case
    	for (Case_Time_Worked__c ctw : [SELECT Id, Case__c, Start_Time__c, Stop_Time__c, Time_Worked_in_Minutes__c, Owner_to_ID__c  
    									FROM Case_Time_Worked__c
    									WHERE Case__c IN :stCaseId
    										AND Time_Worked_in_Minutes__c <> null
    									ORDER BY Case__c, Start_Time__c])
    	{
    		if (mpCaseToCTWList.containsKey(ctw.Case__c))
    		{
    			lstCTW = mpCaseToCTWList.get(ctw.Case__c);    			
    		}
    		else
    		{
    			lstCTW = new list<Case_Time_Worked__c>();
    		}
    		
    		lstCTW.add(ctw);
    		mpCaseToCTWList.put(ctw.Case__c, lstCTW);    		
    	}
    	
    	return mpCaseToCTWList;
    }
 */   
    private static map<Id, List<WorkIt2__Timing__c>> loadCaseToCWList (set<Id> stCaseId)
    {
    	map<Id, List<WorkIt2__Timing__c>> mpCaseToCWList = new map<Id, List<WorkIt2__Timing__c>>(); 
    	
    	list<WorkIt2__Timing__c> lstCW = new list<WorkIt2__Timing__c>();
    	
    	// Get all the Case Time Worked records for each case
    	for (WorkIt2__Timing__c cw : [Select w.WorkIt2__Case__c, w.OwnerId, WorkIt2__Time_In_Minutes__c,
    									(Select WorkIt2__End__c, WorkIt2__Start__c, WorkIt2__Time_In_Minutes__c 
    									 From WorkIt2__Time_Entries__r ORDER BY WorkIt2__Start__c) 
    								 From WorkIt2__Timing__c w where WorkIt2__Case__c IN :stCaseId
    								 ORDER BY WorkIt2__Case__c
    									])
    	{
    		if (mpCaseToCWList.containsKey(cw.WorkIt2__Case__c))
    		{
    			lstCW = mpCaseToCWList.get(cw.WorkIt2__Case__c);    			
    		}
    		else
    		{
    			lstCW = new list<WorkIt2__Timing__c>();
    		}
    		
    		lstCW.add(cw);
    		mpCaseToCWList.put(cw.WorkIt2__Case__c, lstCW);    		
    	}
    	
    	return mpCaseToCWList;
    }
    private static map<Id, list<LiveChatTranscript>> loadCaseToLCTList (set<Id> stCaseId)
    {
    	map<Id, list<LiveChatTranscript>> mpCaseToLCTList = new map<Id, list<LiveChatTranscript>>();    	
    	list<LiveChatTranscript> lstLCT = new list<LiveChatTranscript>();
    	    	
    	// Get all the Live Chat Transcript records for each case
    	for (LiveChatTranscript lct : [SELECT Id, CaseId, StartTime, EndTime, Chat_Duration_Minutes__c, OwnerId 
    									FROM LiveChatTranscript
    									WHERE CaseId IN :stCaseId
    									ORDER BY CaseId, StartTime])
    	{
    		if (mpCaseToLCTList.containsKey(lct.CaseId))
    		{
    			lstLCT = mpCaseToLCTList.get(lct.CaseId);    			
    		}
    		else
    		{
    			lstLCT = new list<LiveChatTranscript>();
    		}
    		
    		lstLCT.add(lct);
    		mpCaseToLCTList.put(lct.CaseId, lstLCT);    		
    	}
    	
    	return mpCaseToLCTList;
    }
    
    private static map<Id, list<CallTaskWrapper>> loadCaseToCallList (set<Id> stCaseId)
    {
    	map<Id, list<CallTaskWrapper>> mpCaseToCallList = new map<Id, list<CallTaskWrapper>>(); 
    	list<CallTaskWrapper> lstCall = new list<CallTaskWrapper>();    	
    	CallTaskWrapper clsCTW;    	
    	
    	// Get all the Call records for each case
    	for (Task call : [SELECT Id, WhatId, Subject, CallType, CallDurationInSeconds, Call_Duration_Minutes__c, OwnerId
    					FROM Task 
    					WHERE WhatId IN :stCaseId
    						AND CallDurationInSeconds <> null
    						AND Subject LIKE '%Call%'
    					ORDER BY WhatId, Subject])
    	{
    		if (mpCaseToCallList.containsKey(call.WhatId))
    		{
    			lstCall = mpCaseToCallList.get(call.WhatId);    			
    		}
    		else
    		{
    			lstCall = new list<CallTaskWrapper>();
    		}
    		
    		clsCTW = new CallTaskWrapper(call); 
    		lstCall.add(clsCTW);
    		mpCaseToCallList.put(call.WhatId, lstCall);    		
    	}
    	
    	return mpCaseToCallList;
    }
    
    private static map<Id, list<RepTimeWrapper>> loadCaseToUserTimeList (set<Id> stCaseId)
    {
    	map<Id, list<RepTimeWrapper>> mpCaseToUserTimeList = new map<Id, list<RepTimeWrapper>>();
    	list<RepTimeWrapper> lstRepTime = new list<RepTimeWrapper>();
    	RepTimeWrapper clsRepTime;
    	string caseId;
    	string repId;
    	decimal repTime;
 // replace   	
    	// Find the sum of time per user per case from Case Time Worked records
    	
    	for ( WorkIt2__Timing__c ar :[Select w.WorkIt2__Time_In_Minutes__c, w.WorkIt2__Case__c, w.OwnerId 
    	                              From WorkIt2__Timing__c w
    	                              Where WorkIt2__Case__c IN :stCaseId ])
  /*  	for (AggregateResult ar : [SELECT Case__c, Owner_to_ID__c, sum(Time_Worked_in_Minutes__c)totTime   
									FROM Case_Time_Worked__c
									WHERE Case__c IN :stCaseId
										AND Time_Worked_in_Minutes__c <> null
			    					GROUP BY Case__c, Owner_to_ID__c])
*/
    	{
    		caseId = ar.WorkIt2__Case__c;
    		repId = ar.OwnerId ;
    		repTime = ar.WorkIt2__Time_In_Minutes__c;
    		
    		if (mpCaseToUserTimeList.containsKey(caseId))
    		{
    			lstRepTime = mpCaseToUserTimeList.get(caseId);    			
    		}
    		else
    		{
    			lstRepTime = new list<RepTimeWrapper>();
    		}
    		
    		clsRepTime = new RepTimeWrapper(repId, repTime); 
    		lstRepTime.add(clsRepTime);
    		mpCaseToUserTimeList.put(caseId, lstRepTime);    	   		
    	}
    	
    	// Find the sum of time per user per case from LiveAgent Records
    	for (AggregateResult ar : [SELECT CaseId, OwnerId, sum(Chat_Duration_Minutes__c)totTime 
									FROM LiveChatTranscript
									WHERE CaseId IN :stCaseId 
			    					GROUP BY CaseId, OwnerId])
    	{
    		caseId = (string)ar.get('CaseId');
    		repId = (string)ar.get('OwnerId');
    		repTime = decimal.valueOf(string.valueOf(ar.get('totTime')));
    		
    		if (mpCaseToUserTimeList.containsKey(caseId))
    		{
    			lstRepTime = mpCaseToUserTimeList.get(caseId);    			
    		}
    		else
    		{
    			lstRepTime = new list<RepTimeWrapper>();
    		}
    		
    		clsRepTime = new RepTimeWrapper(repId, repTime); 
    		lstRepTime.add(clsRepTime);
    		mpCaseToUserTimeList.put(caseId, lstRepTime);    	   		
    	}
    	
    	// Find the sum of time per user per case from CTI Tasks
    	for (AggregateResult ar : [SELECT WhatId, OwnerId, sum(Call_Duration_Minutes__c)totTime 
			    					FROM Task 
			    					WHERE WhatId IN :stCaseId
			    						AND CallDurationInSeconds <> null
			    						AND Subject LIKE '%Call %'
			    					GROUP BY WhatId, OwnerId])
    	{
    		caseId = (string)ar.get('WhatId');
    		repId = (string)ar.get('OwnerId');
    		repTime = decimal.valueOf(string.valueOf(ar.get('totTime')));
    		
    		if (mpCaseToUserTimeList.containsKey(caseId))
    		{
    			lstRepTime = mpCaseToUserTimeList.get(caseId);    			
    		}
    		else
    		{
    			lstRepTime = new list<RepTimeWrapper>();
    		}
    		
    		clsRepTime = new RepTimeWrapper(repId, repTime); 
    		lstRepTime.add(clsRepTime);
    		mpCaseToUserTimeList.put(caseId, lstRepTime);    	   		
    	}
    	
    	return mpCaseToUserTimeList;
    }
    
    public class CallTaskWrapper
    {
    	public Task objTask {get; set;}
    	    	
    	public DateTime dtStart
    	{
    		get
    		{
    			DateTime retVal = null;
    			
    			if (objTask != null)
    			{
    				string sub = objTask.Subject;
    				string strOutBnd = 'Outbound Call ';
    				string strCall = 'Call ';
    				string strStart = '';
    				
    				// Try to parse the Subject to get the start time
    				if (sub.trim().startsWithIgnoreCase('Outbound Call'))
    				{
    					strStart = sub.substring(strOutBnd.length());
    				}
    				else if (sub.trim().startsWithIgnoreCase('Call '))
    				{ 
    					strStart = sub.substring(strCall.length());
    				}
    				
    				if (strStart != null && strStart != '')
	    			{
	    				retVal = DateTime.parse(strStart);
	    			}
    			}
    			
    			return retVal;
    		}
    	}
    	
    	public DateTime dtEnd
    	{
    		get
    		{
    			DateTime retVal = null;
    			
    			if (objTask != null && objTask.Call_Duration_Minutes__c != null && dtStart != null)
    			{
    				return dtStart.addMinutes(Integer.valueOf(objTask.Call_Duration_Minutes__c));
    			}
    			
    			return retVal;
    		}
    	}
    	
    	public CallTaskWrapper (Task tsk)
    	{
    		objTask = tsk;
    	}
    }
    
    public class RepTimeWrapper
    {
    	public Id RepId {get; set;}
    	public decimal RepTimeInMinutes {get; set;}
    	
    	public RepTimeWrapper(Id uId, decimal uTimeInMinutes)
    	{
    		RepId = uId;
    		RepTimeInMinutes = uTimeInMinutes;
    	}
    }
}