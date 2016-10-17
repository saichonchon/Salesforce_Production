public class BatchCreatePromoterIoFeedback implements Database.Batchable<sObject>, Database.AllowsCallOuts, Database.Stateful{
    public List<Promoter_io_Feedback__c> pioFListFinal = new List<Promoter_io_Feedback__c>();
    public Integer count=0;
    public Integer batches=0;
    public Datetime sessiontime;
    public string errors;
    
    public PromoterioSettings__c  pioSettings
    {
        get { return PromoterioSettings__c.getOrgDefaults(); }
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        JSONParserUtil.promoterioCallout();
        Datetime CurrentRun = pioSettings.Last_Run_On__c;
        sessiontime = CurrentRun;
        Boolean Alltime = pioSettings.Fetch_All__c;
        String Query = 'select id, API_URL__c, PageNumber__c, Session_Time__c, Unique_ID__c from Promoter_io_Callout__c where Session_Time__c = :CurrentRun';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){
       	List<Promoter_io_Callout__c> listPicFeedbacks = (List<Promoter_io_Callout__c>)scope;
        List<Promoter_io_Callout__c> updatelistPicFeedbacks = new List<Promoter_io_Callout__c>();

        if(listPicFeedbacks != null && listPicFeedbacks.size() > 0){
            for(Promoter_io_Callout__c pic:listPicFeedbacks){
                List<Promoter_io_Feedback__c> localPioList = new List<Promoter_io_Feedback__c>();
                localPioList.addAll(JSONParserUtil.promoterioJSONParser(Integer.valueOf(pic.PageNumber__c)));
                if(!(localPioList.size()+pioFListFinal.size()>10000)){
                    pioFListFinal.addAll(localPioList);
                }
            }
            batches++;
        } 
    }

    public void finish(Database.BatchableContext BC){
        Promoter_io_Callout_Session__c piocs = new Promoter_io_Callout_Session__c();
        if(!pioFListFinal.isEmpty()){
            Schema.SObjectField f = Promoter_io_Feedback__c.Fields.Feedback_Unique_External_ID__c;
            integer iter=0;
            Database.upsertResult[] upsertResultList = database.Upsert(pioFListFinal,f,false);
            for(database.UpsertResult res:upsertResultList){
                if(!res.success&&iter<6){
                    for(database.Error err:res.getErrors()){
                        iter++;
                        if(iter==1){
                            errors = 'BatchCreatePromoterIoFeedback:'+'"\n\n';
                        }
                        errors += res.getId()+': '+err.getStatusCode() + ': ' + err.getMessage()+'"\n\n';
                        break;
                    }
                }
                if(iter==6){ break;}
        	}
            count = pioFListFinal.size();
            BatchProcessPromoterIoFeedback Bpf = new BatchProcessPromoterIoFeedback();
            database.executeBatch(Bpf, 100);
        } else {
            PromoterioSettings__c ps = PromoterioSettings__c.getOrgDefaults();
            ps.Debug__c = 'pioFListFinal was empty: Last Run on - '+ps.Last_Run_On__c;
            upsert ps;
            BatchProcessPromoterIoFwdedCases bpfc = new BatchProcessPromoterIoFwdedCases();
        	database.executeBatch(bpfc,100);
        }
        if(errors!=null){piocs.Errors__c = errors;}
        piocs.Count__c = count;
        piocs.Number_of_Batches__c = batches;
        piocs.Session_Start_Time__c = sessiontime;
        insert piocs;
    }
}