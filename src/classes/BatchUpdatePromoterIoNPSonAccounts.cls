public class BatchUpdatePromoterIoNPSonAccounts implements Database.Batchable<sObject>,Database.Stateful{
    public string errors;
    public Set<Id> accountIds = new Set<Id>();
    public Promoter_io_Callout_Session__c piocs;
    public BatchUpdatePromoterIoNPSonAccounts(Set<Id> accIds){
        if(!accIds.isEmpty()){
        	accountIds = accIds;
        }
    }
    /**
     * @author Bala Rajagopal
     * @date   2016-09-02
     * @ticket link       https://jira.bigcommerce.com/browse/BAP-3171
     * @param
     * @return
     */
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        promoterioSettings__c pios = promoterioSettings__c.getOrgDefaults();
        Datetime CurrentRun;
        if(pios.Last_Run_On__c!=null){
            CurrentRun = pios.Last_Run_On__c;
        } 
        if(currentRun!=null){
        	List<Promoter_io_Callout_Session__c> piocsList = new List<Promoter_io_Callout_Session__c>([select id,Count__c,Errors__c,Number_of_Batches__c,Session_Start_Time__c from Promoter_io_Callout_Session__c 
                where Session_Start_Time__c = :CurrentRun limit 1]);
            if(!piocsList.isEmpty()){
                piocs = piocsList[0];
            }
        }
        
        String Query;
        Query = 'select id from Account where Id IN :accountIds';
		return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account> updateAccounts = new List<Account>();
        Set<Id> AccountIdSet = new Set<Id>();
		List<Account> acclist = [select id, (select posted_date__c, score__c from Promoter_io_Feedbacks__r order by posted_date__c desc limit 1) from Account where id IN :scope];
        for(Account acc:acclist){
            for(Promoter_io_Feedback__c pio:acc.Promoter_io_Feedbacks__r){
                if(!AccountIdSet.contains(acc.id)){
                    if(pio.score__c!=null){
                    	acc.Last_Promoter_io_NPS__c  = pio.score__c;
                    }
                    updateAccounts.add(acc);
                    AccountIdSet.add(acc.id);
                }
            }
        }
        
        if(!updateAccounts.isEmpty()){
            database.update(updateAccounts,false);
            integer iter=0;
            Database.saveResult[] saveResultList = database.Update(updateAccounts,false);
            for(database.saveResult res:saveResultList){
                if(!res.success&&iter<6){
                    for(database.Error err:res.getErrors()){
                        iter = iter+1;
                        if(iter==1&&errors==null){
                            errors = 'BatchUpdatePromoterIoNPSonContacts Accounts:'+'"\n\n';
                        } else if(iter==1&&errors!=null){
                            errors += '"\n\n';
                            errors += 'BatchUpdatePromoterIoNPSonContacts Accounts:'+'"\n\n';
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
        if(errors!=null&&piocs!=null){
            piocs.Errors__c = errors;
        	upsert piocs;
        }
        BatchProcessPromoterIoFwdedCases bpfc = new BatchProcessPromoterIoFwdedCases();
        database.executeBatch(bpfc,100);
    }
}