trigger Lead_Trigger on Lead (after insert, after update) {

/*  
    Lead_TriggerHandler handler = new Lead_TriggerHandler();    

    if(trigger.isInsert ){          
        handler.getWebinar(trigger.new);
    }
        
    if(trigger.isUpdate){

        for(Lead l : trigger.new){
          
            if(l.Email != trigger.oldMap.get(l.id).Email){      
                
                handler.getWebinar(trigger.new);
                System.debug('Lead_Trigger : Record Update ');                      
            }
            if(l.IsConverted && !trigger.oldMap.get(l.Id).isConverted) {
                
                handler.newLeadIsConverted(trigger.new);                
                System.debug('Lead_Trigger : newLeadIsConverted ');             
            }            
        }
    }
 */   
 
        
            
            DatanyzeLeadHandler.AfterDatanyze(trigger.New);
         
 
    if (trigger.isUpdate && trigger.isAfter)
    {
        Map <Id, Id> mapleadowner = new Map <Id, Id>();
// Map to Hold Lead Id and Lead Object.
        Map<Id,Lead> mpLeadIdToLead = new Map<Id,Lead>();
 // for chats       
        Map<Id,Lead> mpcLeadIdToLead = new Map<Id,Lead>();
        
        for(Lead l : trigger.new)
        {
   /*           
            if(l.IsConverted == false && l.OwnerId!= trigger.oldMap.get(l.id).OwnerId)
            {      
                
              mapleadowner.put(l.Id, l.OwnerId);
                                    
            }

Modified By:-Laxmikant Kurmi.
Modified Date:-05/08/2014.
When Lead is converted manually by user other than API User set teh sub's Account and contact
*/          
     if(l.IsConverted && !trigger.oldMap.get(l.Id).isConverted) 
      {
           system.debug('newLeadIsConverted '); 
// check for chats 
                mpcLeadIdToLead.put(l.Id,l); 
            
                system.debug('Check for a User');
                if(!UserInfo.getProfileId().equals(Label.API_User_Profile))
                {   
                    system.debug('User is not an API User');
               
                    mpLeadIdToLead.put(l.Id,l); 
                }
            }

        }
        
//      if (mapleadowner.size() > 0) Lead_TriggerHandler.UpdateSubOwner(mapleadowner);
        
        if(mpLeadIdToLead.size()>0)
        {   
            system.debug('Calling class mrthod for converted Lead');
            Lead_TriggerHandler.updateSubAccountandContact(mpLeadIdToLead);
        }
        if(mpcLeadIdToLead.size()>0)
        {   
            system.debug('Calling class mrthod for converted Lead chat');
            Lead_TriggerHandler.updateChatTranscript(mpLeadIdToLead);
        }
    }
}