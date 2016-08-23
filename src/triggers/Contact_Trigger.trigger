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
}