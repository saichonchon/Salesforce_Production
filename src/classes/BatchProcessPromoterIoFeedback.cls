public class BatchProcessPromoterIoFeedback implements Database.Batchable<sObject>, Database.stateful{
	public Promoter_io_Callout_Session__c piocs;
    public string errors;
    public Set<Id> allContactIds = new Set<Id>();
    public Database.QueryLocator start(Database.BatchableContext BC){
        promoterioSettings__c pios = promoterioSettings__c.getOrgDefaults();
        Datetime CurrentRun;
        if(pios.Last_Run_On__c!=null){
            CurrentRun = pios.Last_Run_On__c;
        }
        Boolean Alltime = pios.Fetch_All__c;
        String Query;
        Query = 'select id, Email__c, Contact_External_ID__c,SF_Account_ID__c,SF_Contact_Id__c,FirstName__c,LastName__c,';
        Query += 'Posted_Date__c, Subscription__c, Store_ID__c, Score__c  from Promoter_io_Feedback__c ';
        Query += 'where (Contact__c = null OR Subscription__c = null)';
        if(!Alltime&&CurrentRun!=null){
            query += ' and Session_Time__c = :CurrentRun';
        }
        if(currentRun!=null){
        	List<Promoter_io_Callout_Session__c> piocsList = new List<Promoter_io_Callout_Session__c>([select id,Count__c,Errors__c,Number_of_Batches__c,Session_Start_Time__c from Promoter_io_Callout_Session__c 
                where Session_Start_Time__c = :CurrentRun limit 1]);
            if(!piocsList.isEmpty()){
                piocs = piocsList[0];
            }
        }

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
       	List<Promoter_io_Feedback__c> listPioFeedbacks = (List<Promoter_io_Feedback__c>)scope;
        List<Promoter_io_Feedback__c> updatelistPioFeedbacks = new List<Promoter_io_Feedback__c>();
        Set<Id> AccountIds = new Set<Id>();
        Set<Id> ContactIds = new Set<Id>();
        Set<String> SubIds = new Set<String>();
        for(Promoter_io_Feedback__c piof:listPioFeedbacks){
            if(piof.SF_Account_Id__c!=null){
            	AccountIds.add(Id.valueOf(piof.SF_Account_Id__c));
            }
            if(piof.SF_Contact_Id__c!=null){
            	AccountIds.add(Id.valueOf(piof.SF_Account_Id__c));
            }
            if(piof.Store_ID__c!=null){
            	SubIds.add(piof.Store_ID__c);
            }
        }
        if(listPioFeedbacks != null && listPioFeedbacks.size() > 0){
			List<Contact> conList = new List<Contact>([select id, email, accountid, LastName, Last_Promoter_io_NPS__c, Account.Last_Promoter_io_NPS__c  from Contact where accountid in :AccountIds]);
            List<Subscription__c> subList = new List<Subscription__c>([select id, MBASubscriptionID__c from Subscription__c where MBASubscriptionID__c in :SubIds]);
			Map<String,id> conEmailToContact = new Map<string,id>();
            Map<String,id> conInfoToContact = new Map<string,id>();   
            Map<String,id> MapMBASubIDtoSFID = new Map<string,id>();
            
            Map<Id,Id> ContoAccountMap = new Map<Id,Id>();
            system.debug('BatchProcessPromoterIoFeedback conList = '+conList);
            for(contact con:conList){
                conInfoToContact.put(con.Email+string.valueOf(con.AccountId).left(15)+con.LastName, con.Id);//@@try spinning a method
                ContoAccountMap.put(con.id,con.AccountId);
                allContactIds.add(con.id);
            }
            for(Subscription__c sub:subList){
                MapMBASubIDtoSFID.put(sub.MBASubscriptionID__c, sub.id);
            }
            for(Promoter_io_Feedback__c piof:listPioFeedbacks){
                if(piof.sf_contact_id__c!=null){
                    piof.contact__c = id.valueOf(piof.sf_Contact_id__c);
                    piof.Account__c = ContoAccountMap.get(piof.contact__c);
                } 
                else if(conInfoToContact.get(piof.Email__c+piof.SF_Account_Id__c.left(15)+piof.LastName__c)!=null){
                    piof.contact__c = conInfoToContact.get(piof.Email__c+piof.SF_Account_Id__c.left(15)+piof.LastName__c);
                    piof.Account__c = ContoAccountMap.get(piof.contact__c);
                } else if(piof.SF_Account_Id__c!=null){
                    piof.account__c = id.valueOf(piof.SF_Account_Id__c);
                }
                if(piof.Store_ID__c!=null&&MapMBASubIDtoSFID.get(piof.Store_ID__c)!=null){
                    piof.Subscription__c = MapMBASubIDtoSFID.get(piof.Store_ID__c);
                }
                updatelistPioFeedbacks.add(piof);
        		
            }
            if(!updatelistPioFeedbacks.isEmpty()){
                database.update(updatelistPioFeedbacks,false);
                integer iter=0;
            	Database.saveResult[] saveResultList = database.Update(updatelistPioFeedbacks,false);
                for(database.saveResult res:saveResultList){
                    if(!res.success&&iter<6){
                        for(database.Error err:res.getErrors()){
                            iter = iter+1;
                            if(iter==1&&errors==null){
                                errors = 'BatchProcessPromoterIoFeedback:'+'"\n\n';
                            } else if(iter==1&&errors!=null){
                                errors += '"\n\n';
                                errors += 'BatchProcessPromoterIoFeedback:'+'"\n\n';
                            }
                            errors += res.getId()+': '+err.getStatusCode() + ': ' + err.getMessage()+'"\n\n';
                            break;
                        }
                    }
                    if(iter==6){ break;}
        		}
            } 
        } 
    }

    public void finish(Database.BatchableContext BC){
        if(errors!=null&&piocs!=null){
            piocs.Errors__c = errors;
        	upsert piocs;
        }
        BatchUpdatePromoterIoNPSonContacts bpfNPSc = new BatchUpdatePromoterIoNPSonContacts(allContactIds);
        database.executeBatch(bpfNPSc,100);
    }
}