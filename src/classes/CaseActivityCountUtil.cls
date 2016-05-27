// ==================================================================================
//   Object: CaseActivityCountUtil
//  Company: BigCommerce
//   Author: Mohan Kumar (Sales Optimizer)
// Comments: Supporting class that contains static method to calcuate the Case Activity 
//			 count(sum of Task & Event records).
// ==================================================================================
//  Changes: 2012-09-25 Initial version.
// ==================================================================================

public class CaseActivityCountUtil {
	
	public static String calculateCaseActivityCount(Set<Id> caseIds) {
		Map<Id, Integer> eventCountMap = new Map<Id, Integer>();
		Map<Id, Integer> taskCountMap = new Map<Id, Integer>();
		try {
			//get events and contruct a map variable to store the event count
			List<Event> eList = [Select Id, WhatId From Event Where WhatId IN :caseIds];
			for(Event e : eList) { 
				Integer eCount = 0;
				if(eventCountMap.containsKey(e.WhatId)) eCount = eventCountMap.get(e.WhatId);
				eCount++;
				eventCountMap.put(e.WhatId, eCount);
			}
			
			//get tasks and contruct a map variable to store the task count
			List<Task> tList = [Select Id, WhatId From Task Where WhatId IN :caseIds];
			for(Task t : tList) {
				Integer tCount = 0;
				if(taskCountMap.containsKey(t.WhatId)) tCount = taskCountMap.get(t.WhatId);
				tCount++;
				taskCountMap.put(t.WhatId, tCount);
			}
			
			//get cases and perform a sum of event & task count and update it to case field
			List<Case> cList = [Select Id, Number_of_Replies__c From Case Where Id IN :caseIds];
			for(Case c : cList) {
				Integer cCount = 0;
				if(eventCountMap.containsKey(c.Id)) {
					cCount = eventCountMap.get(c.Id);
				}
				if(taskCountMap.containsKey(c.Id)) {
					cCount += taskCountMap.get(c.Id);
				}
				c.Number_of_Replies__c = cCount.format();
			}
			
			update cList;
		} catch(Exception ex) { return ex.getMessage(); }
		return null;
	}
}