global class BatchCreateTask implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id from Campaign where Name = :Label.Campaign_Name ]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Campaign> listCampaign = (List<Campaign>)scope;
        if(listCampaign != null && listCampaign.size() > 0){
            String queryString = 'Select t.Id, t.Type, t.Subject, t.OwnerId, t.Status, t.RecordTypeId, t.Priority, t.Description, t.ActivityDate, t.Acquisition_Campaign__c From Task t ';
            if(!Test.isRunningTest()){
                queryString += ' where id =\''+System.Label.TaskLabel+'\'' ;
            }
            List<Task> listTask = Database.query(queryString);
            if(listTask != null && listTask.size() > 0){
                 Set<Id> cmpIds = new Set<Id>();
                for(Campaign cmp : listCampaign){
                    cmpIds.add(cmp.Id);
                }
                List<Task> lstTask = new List<Task>();
                for(CampaignMember cmpMem : [select Id,ContactId,LeadId,CampaignId from CampaignMember where CampaignId in: cmpIds]){
 //                   Task tsk = new Task();
                      Task tsk = listTask[0].clone(false, true,false, false);
                    if(cmpMem.ContactId != null){
                        tsk.WhoId = cmpMem.ContactId;
                    }else if(cmpMem.LeadId != null){
                        tsk.WhoId = cmpMem.LeadId;
                    }
 //                   tsk.Status = 'Completed';
//                    tsk.Subject = listTask[0].Subject;
 //                   tsk.Description = listTask[0].Description;
                    
                    lstTask.add(tsk);
                }
                if(lstTask.size() > 0){
                    insert lstTask;
                }
            }
        } 
    }

    global void finish(Database.BatchableContext BC){
    }
}