public class BatchProcessPromoterIoFwdedCases implements Database.Batchable<sObject>{
    public string errors;
    public Promoter_io_Callout_Session__c piocs;
    public Database.QueryLocator start(Database.BatchableContext BC){
        promoterioSettings__c pios = promoterioSettings__c.getOrgDefaults();
        Datetime CurrentRun;
        if(pios.Last_Run_On__c!=null){
            CurrentRun = pios.Last_Run_On__c;
        } 
        Boolean Alltime = pios.Fetch_All__c;
        String CaseOrigin = pios.Case_Origin__c;
        String CaseSubjectStarting = pios.Case_Subject_Starting__c;
        String Query;
        Query = 'select id, Promoter_io_Feedback__c, contactid, Promoter_io_Feedback_Date__c from Case ';
        Query += 'where Promoter_io_Feedback__c = null and Origin = \''+string.escapeSingleQuotes(CaseOrigin)+'\' and Subject like \''+string.escapeSingleQuotes(CaseSubjectStarting)+'%'+'\'';//@@ why case origin is not populated?
        if(currentRun!=null){
        	piocs = [select id,Count__c,Errors__c,Number_of_Batches__c,Session_Start_Time__c from Promoter_io_Callout_Session__c 
                where Session_Start_Time__c = :CurrentRun limit 1];
        }
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('>><< scope on BatchProcessPromoterIoFwdedCases at ln 24 = '+scope);
		List<Case> updateCaseList = new List<Case>(JSONParserUtil.assignFeedbackToCase(scope));

            if(!updateCaseList.isEmpty()){
                database.update(updateCaseList,false);
                integer iter=0;
            	Database.saveResult[] saveResultList = database.Update(updateCaseList,false);
                for(database.saveResult res:saveResultList){
                    if(!res.success&&iter<6){
                        for(database.Error err:res.getErrors()){
                            iter = iter+1;
                            if(iter==1&&errors==null){
                                errors = 'BatchProcessPromoterIoFwdedCases:'+'"\n\n';
                            } else if(iter==1&&errors!=null){
                                errors += '"\n\n';
                                errors += 'BatchProcessPromoterIoFwdedCases:'+'"\n\n';
                            }
                            errors += res.getId()+': '+err.getStatusCode() + ': ' + err.getMessage()+'"\n\n';
                            break;
                        }
                    }
                    if(iter==6){ break;}
        		}
            } 
        
    }

    public void finish(Database.BatchableContext BC){
        if(errors!=null){
            piocs.Errors__c = errors;
        	upsert piocs;
        }
    }
}