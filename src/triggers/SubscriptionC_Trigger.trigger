trigger SubscriptionC_Trigger on Subscription__c (after insert, after update) {

   // Subscription_TriggerHandler handler = new Subscription_TriggerHandler();
    
    if(trigger.isInsert ){ 
                    
        Subscription_TriggerHandler.insertTotango(trigger.new);  
        
        System.debug('Calling class when record is created, possible totango record creation');      
    }
    
    if(trigger.isUpdate){ 

        if(!Subscription_TriggerHandler.ALREADY_RAN){
            for(Subscription__c updateRecord : trigger.new){        
            
                if(updateRecord.Status__c != trigger.OldMap.get(updateRecord.Id).Status__c || updateRecord.Product__c != trigger.OldMap.get(updateRecord.Id).Product__c){               
                    Subscription_TriggerHandler.ALREADY_RAN = true;    
                    Subscription_TriggerHandler.insertTotango(trigger.new);   
                    
                    System.debug('Calling class when record is updated, possible totango record creation');         
                }       
            } 
        }                
    }  
}