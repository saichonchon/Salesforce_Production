// ==================================================================================
//   Object: CaseActivityTaskCount
//  Company: BigCommerce
//   Author: Mohan Kumar (Sales Optimizer)
// Comments: When an Task is created, deleted or undeleted, identify the number of 
//			 activities and add the SUM into the Case objects "Number of Replies" field.
// ==================================================================================
//  Changes: 2012-09-25 Initial version.
// ==================================================================================

trigger CaseActivityTaskCount on Task (after delete, after insert, after undelete, after update) 
{
	///////////////////////////////////////////////////////////////////////////
	// 09/27/2013 - Stragtegic Growth (CDB): Code to handle the Roll-Up logic of Five9 (CTI) created Tasks for Case to Cases
	///////////////////////////////////////////////////////////////////////////
	string strCasePrefix = Case.sObjectType.getDescribe().getKeyPrefix();
	
	list<Task> lstTaskForCase = new list<Task>();
	list<Task> lstTaskForCase_Old = new list<Task>();
	list<Task> lstTask = new list<Task>();
	
	Set<Id> caseIds = new Set<Id>();
	Set<Id> stCaseId = new Set<Id>();
	
	string strCaseId;
	
	if (trigger.isDelete)
	{
		lstTask = trigger.old;
	}
	else
	{
		lstTask = trigger.new;
	}
					
	for (Task tsk : lstTask)
	{
		if (tsk.WhatId != null)
		{
			strCaseId = tsk.WhatId;
			
			// Check if the task is for a case
			if (strCaseId.startsWith(strCasePrefix))
			{
				if (trigger.isInsert || trigger.isUnDelete || trigger.isDelete)
				{
					caseIds.add(strCaseId);
				}
				
				// Now ensure the case is a Five9 (CTI) call task
				if (tsk.CallDurationInSeconds <> null && tsk.Subject.contains('Call'))
				{
					stCaseId.add(tsk.WhatId);
					
					lstTaskForCase.add(tsk);
				    if (trigger.oldMap != null) 
				    {
				    	lstTaskForCase_Old.add(trigger.oldMap.get(tsk.Id));
				    }
				}
			}
		}
	}
	
	if (!lstTaskForCase.isEmpty() && !SObjectUtils.lookUpRollUpIsRunning)
	{				
		system.debug('*** In RollUp Trigger Code - Task to Case Rollup');

		SObjectUtils.lookUpRollUpIsRunning = true;
		
		CaseHandle_Helper.rollUpCaseHandleTime(stCaseId);
			
		//Pass in the name of the child record, in this case 'Task' and the name of the parent record, in this case 'Case';   
		LookupRollupHelper lh_Acct = new LookupRollupHelper('Task', 'Case');
				
		if(!lstTaskForCase_Old.isEmpty()) 
		{
			lh_Acct.rollupSummary((list<sObject>)lstTaskForCase, (list<sObject>)lstTaskForCase_Old);   
		} 
		else 
		{
			lh_Acct.rollupSummary((list<sObject>)lstTaskForCase, null);
		}
				
		//SObjectUtils.lookUpRollUpIsRunning = false;
	}
	///////////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////////
	// 09/27/2013 - Strategic Growth - Commented out the below original code in this trigger
	///////////////////////////////////////////////////////////////////////////	
	//Set<Id> caseIds = new Set<Id>();
	
	//if(trigger.isInsert || trigger.isUnDelete) 
	//{
	//	for(Task t : trigger.new) 
	//	{
	//		String cId = t.WhatId;
	//		if(cId != null && cId.startsWith('500')) caseIds.add(cId);		//add if task is related to Case record
	//	}
	//}
	//
	//if(trigger.isDelete) 
	//{
	//	for(Task t : trigger.old) 
	//	{
	//		String cId = t.WhatId;
	//		if(cId != null && cId.startsWith('500')) caseIds.add(cId);		//add if task is related to Case record
	//	}
	//}
	//
	//if(caseIds.size() > 0) CaseActivityCountUtil.calculateCaseActivityCount(caseIds);
	///////////////////////////////////////////////////////////////////////////
}