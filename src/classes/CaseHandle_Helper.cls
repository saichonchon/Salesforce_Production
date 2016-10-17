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
  
    public static void case_StartWorking(set<Id> stCaseIds)
    {
        
        list<Case> lstCasesToUpdate = new list<Case>();
        list<Case_Time_Worked__c> lstWorked = new list<Case_Time_Worked__c>();
        Case_Time_Worked__c objCTW;
        
        // Loop through all the cases and create a new Case Time Worked record if necessary
        for (Case c : getCaseList(stCaseIds))
        {
            
            // Make sure the case is NOT already owned by the current user, is in fact owned by a queue, and is NOT Closed
 //           if (!c.IsClosed && c.OwnerId != USERID && c.Owner.Type == 'Queue')
 			if (!c.IsClosed )
            {
  //              objCTW = createTimeWorkedFromCase(c, false);
                lstWorked.add(objCTW);
                if (c.OwnerId <> USERID)
                {
	                c.OwnerId = USERID;
	                lstCasesToUpdate.add(c);
 
                }
            }
            else
            {

            }
        }
        
        // Check if any records need to be inserted or updated
        if (!lstWorked.isEmpty())
        {

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
	    	
            map<Id, List<WorkIt2__Timing__c>> mpCaseToCWList = loadCaseToCWList(stCaseId);
	    	map<Id, list<LiveChatTranscript>> mpCaseToLCTList = loadCaseToLCTList(stCaseId);
	    	map<Id, list<CallTaskWrapper>> mpCaseToCallList = loadCaseToCallList(stCaseId);
	    	map<Id, list<RepTimeWrapper>> mpCaseToUserTimeList = loadCaseToUserTimeList(stCaseId);
	    	
	    	boolean updateCase = false;
	    	Id primaryRep;
	    	decimal repTime = 0;
	    	decimal totHandleTime = 0;
	    	long overLapTime = 0;  	
	    	
	    	// Loop through all the case Ids passed in
			for (Case objC :lstCase)
//	    	for (string csId : stCaseId)
	    	{
	    		updateCase = false;

	    		string csId = objC.Id;
	    		primaryRep = objC.Primary_Case_Rep__c;
	    		repTime = 0;
	    		
	    		// Figure out the primary rep for the case if records exist
	    		if (mpCaseToUserTimeList != null && mpCaseToUserTimeList.containsKey(csId))
	    		{

	    			// Loop through each rep record to see who has the most time
	    			for (RepTimeWrapper rep : mpCaseToUserTimeList.get(csId))
	    			{
	    				
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
					    				overLapTime = getOverlapTimeInMinutes(cTime.WorkIt2__Start__c, cTime.WorkIt2__End__c, cCall.dtStart, cCall.dtEnd);
					    				totHandleTime = totHandleTime - overLapTime;
					    			}
				    			}
				    		}
		    	    }
	    		}	    		
	    		    		
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
		update alist;
    }
    
    public static void updateEIGCase(List<Case> newList)
    {
		Id idCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
		Id idCSCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();//@Author Bala - @Date 08/26/16
        Id idCancelCaseRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Cancellations').getRecordTypeId();//@Author Bala - @Date 08/26/16
        string soqlWHERE_SBDStoreIDs = '';
		Map <Id, String> mpCaseStore = new Map<Id, String>();
        Map<String,Id> MapEmailtoContact = new Map<String,Id>();
        Map<Id,String> MapEmailtoCase = new Map<Id,String>();
        Map<Id,String> MapEmailandPostedDdatetoCase = new Map<Id,String>();
 		PromoterioSettings__c pios = PromoterioSettings__c.getOrgDefaults();
        String caseSubjectStarting;
        String caseOrigin;
        String caseReason;
        string caseCategory;
        if(pios.Case_Subject_Starting__c != null){
            caseSubjectStarting = pios.Case_Subject_Starting__c;
        } else {
            caseSubjectStarting = 'NPS Survey Response from';
        }
        if(pios.Case_Origin__c != null){
            caseOrigin = pios.Case_Origin__c;
        } else {
            caseOrigin = 'Promoter.io';
        }
        if(pios.Case_Reason__c != null){
            caseReason = pios.Case_Reason__c;
        } else {
            caseReason = 'Surveys';
        }
        if(pios.Case_Category__c != null){
            caseCategory = pios.Case_Category__c;
        } else {
            caseCategory = 'Company NPS';
        }
 		for (Case c :newList)
		{
			if (c.RecordTypeId == idCaseRecordType && c.Origin == 'EIG Billing'
				&& c.Subscription__c == null)
			{
					String[] emailBody = c.Description.split('\n', 0);
					for (String s :emailBody)
					{
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
            
            if(c.subject!=null){
                if(c.RecordTypeId == idCSCaseRecordType && c.Subject.startsWithIgnoreCase(caseSubjectStarting)){
                    String email;
                    String postedDateString;
                    Date postedDate;
                    email = c.Description.substringBetween('Contact Email: ', 'Date:').trim().replace('<br>','');
                    postedDateString = c.Description.substringBetween('Date: ', 'Score:').trim().replace('<br>','');
                    if(!string.isBlank(postedDateString)){
                        try{
                            postedDate = utilities.formattedDate(postedDateString);
                        } catch (exception e) {
                            system.debug('>><< postedDate error on CaseHandle_Helper at ln 810 = '+e );
                        }
                    }
                    c.Origin = caseOrigin;
                    c.Reason = caseReason;
                    c.Category__c = caseCategory;
               
                    if(postedDate!=null){
                        c.Promoter_io_Feedback_Date__c = postedDate;
                    }
                    if(email!=null){
                        MapEmailtoCase.put(c.id,email);
                    
                        if(postedDate!=null){
                            MapEmailandPostedDdatetoCase.put(c.id,email+'-'+string.valueof(postedDate));//@@ separate method
                        }
                    }
                }
        	}
		}

        List<Contact> conList = new List<Contact>([select id, email from contact where email in :MapEmailtoCase.values()]);
        for(Contact con:conList){
            if(con.email!=null){
            	MapEmailtoContact.put(con.email,con.id);
            }
        }
        for (Case c :newList){
            if(c.contactid==null&&MapEmailtoCase.get(c.id)!=null){
                if(MapEmailtoContact.get(MapEmailtoCase.get(c.id))!=null){
                	c.ContactId = MapEmailtoContact.get(MapEmailtoCase.get(c.id));
                }
            }
        }

        List<Case> newList2 = new List<Case>();
        newList2.addAll(JSONParserUtil.assignFeedbackToCase(newList));

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
   			string cBody = label.CaseAutoComment;
            if(c.Contact_First_Name__c!=null){
                cBody = cBody.replace('#CLIENTNAME',c.Contact_First_Name__c);
            } else{
                cBody = cBody.replace('#CLIENTNAME','Sir/Madam');
            }
            cBody = cBody.replace('#CASENUMBER',c.CaseNumber);
            if(c.Subject != null){
            	cBody = cBody.replace('#CASESUBJECT',c.Subject);
            }
            cBody = cBody.replace('#AGENTFIRSTNAME',userinfo.getFirstName());
            if(c.Current_User_Title__c!=null){
                cBody = cBody.replace('#JOBTITLE',c.Current_User_Title__c);
            } else {
                cBody = cBody.replace('#JOBTITLE','BigCommerce Team');
            }
   			CaseComment newCom = new CaseComment(ParentId = c.Id, isPublished= false, commentBody = cBody);
   			lstComments.add(newCom);
   		}
   		insert lstComments;
   }

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
	
    	// Find the sum of time per user per case from Case Time Worked records
    	
    	for ( WorkIt2__Timing__c ar :[Select w.WorkIt2__Time_In_Minutes__c, w.WorkIt2__Case__c, w.OwnerId 
    	                              From WorkIt2__Timing__c w
    	                              Where WorkIt2__Case__c IN :stCaseId ])

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