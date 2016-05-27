trigger Webinar_Trigger on Webinar__c (before insert, before update) {
	Webinar_TriggerHandler handler = new Webinar_TriggerHandler();

	if(trigger.isInsert){		
		handler.createRelationship(trigger.new); 
	}

	if(trigger.isUpdate){

		for(Webinar__c w : trigger.new){

			if(w.Registrant_Email__c != trigger.oldMap.get(w.Id).Registrant_Email__c){

				handler.createRelationship(trigger.new);
			 	System.debug('isUpdate : Registrant_Email__c has changed');		 	
			}

			//if(w.OwnerId != trigger.oldMap.get(w.Id).OwnerId){
			// 	if(w.Lead__c != null || w.Account__c != null || w.Contact__c != null){
			// 		handler.ownerUpdate(trigger.new, trigger.oldMap);
			// 		System.debug('isUpdate : OwnerId has changed ');
			// 	}			 	
			//}
		}
	}    
}