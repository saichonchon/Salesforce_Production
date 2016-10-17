public class BatchUpdatePromoterIoNPSonContacts implements Database.Batchable<sObject>,Database.Stateful{
    public string errors;
    public Set<Id> contactIds = new Set<Id>();
    public Set<Id> AccountIds = new Set<Id>();
    public Promoter_io_Callout_Session__c piocs;
    public BatchUpdatePromoterIoNPSonContacts(Set<Id> conIds){
        if(!conIds.isEmpty()){
            system.debug('>><< conIds = '+conIds);
        	contactIds = conIds;
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
        Query = 'select id, accountid from Contact where Id IN :contactIds';
		return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Contact> updateContacts = new List<Contact>();
        Set<Id> ConIdSet = new Set<Id>();
		List<Contact> conlist = [select id, accountid, (select posted_date__c, score__c from Promoter_io_Feedbacks__r order by posted_date__c desc limit 1) from contact where id IN :scope];
        for(contact con:conlist){
            for(Promoter_io_Feedback__c pio:con.Promoter_io_Feedbacks__r){
                if(!ConIdSet.contains(con.id)){
                    if(pio.score__c!=null){
                    	con.Last_Promoter_io_NPS__c  = pio.score__c;
                    }
                    updateContacts.add(con);
                    ConIdSet.add(con.id);
                }
            }
            AccountIds.add(con.accountid);
        }
        
        if(!updateContacts.isEmpty()){
            database.update(updateContacts,false);
            integer iter=0;
            Database.saveResult[] saveResultList = database.Update(updateContacts,false);
            for(database.saveResult res:saveResultList){
                if(!res.success&&iter<6){
                    for(database.Error err:res.getErrors()){
                        iter = iter+1;
                        if(iter==1&&errors==null){
                            errors = 'BatchUpdatePromoterIoNPSonContacts Contacts:'+'"\n\n';
                        } else if(iter==1&&errors!=null){
                            errors += '"\n\n';
                            errors += 'BatchUpdatePromoterIoNPSonContacts Contacts:'+'"\n\n';
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
        BatchUpdatePromoterIoNPSonAccounts buNPSacc = new BatchUpdatePromoterIoNPSonAccounts(AccountIds);
        database.executeBatch(buNPSacc,100);
    }
}