trigger Contact_Trigger on Contact (before insert, before update, After insert, After update) {

	Contact_TriggerHandler handler = new Contact_TriggerHandler();
	
	if(trigger.isBefore)
    {
        if(trigger.isInsert || trigger.isUpdate)
        {
        handler.UpdateTZ(trigger.new);
        }
        if (trigger.isUpdate) handler.updatePhoneNumbers(Trigger.New, Trigger.Old);

    }
    
   if(trigger.isAfter)
   {
 
 /*  	
	 if(trigger.isInsert ){			
		handler.getWebinar(trigger.new);
	   }
		
	 if(trigger.isUpdate){

		for(Contact c : trigger.new){
			
			if(c.Email != trigger.oldMap.get(c.Id).Email){					
				handler.getWebinar(trigger.new);
				System.debug('Contact_Trigger : Email Update ');						
			}								 
		}
	  }
*/
	 if(trigger.isInsert )
	 {
	 	handler.updAcctAppContact(trigger.new);
	 }

// update Subscription	
	
		handler.UpdateSubsContact(trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate,     
      						      trigger.new, trigger.old, trigger.newmap);

		handler.UpdateOppContact(trigger.isBefore, trigger.isAfter, trigger.isInsert, trigger.isUpdate,     
      						      trigger.new, trigger.old, trigger.newmap);
		

 	}

// bmp change 	
 	if (trigger.isAfter)
	{
		Map<String, String> bmpsfIds = new Map<String, String>();
		for(Contact c : trigger.new)
        {
            
            if ((Trigger.isInsert && c.Source__c == 'BMP') ||
                (c.Source__c == 'BMP' && c.MBAClientID__c!= trigger.oldMap.get(c.id).MBAClientID__c)
               )
            {      
              
                 bmpsfIds.put(c.MBAClientID__c, c.Id);                   
            }
                  
        }
        
        if (!bmpsfIds.isEmpty())
        {
	        Map<String, String> mapBmpIdBody = RESTAPIUtility.getJSONBody( bmpsfIds);
	        for (String sendbmpId :mapBmpIdBody.KeySet())
			{
			  RESTAPICallouts.BMPRequest('contact', sendbmpId, mapBmpIdBody.get(sendbmpId));
			}
        }
	}
		
}