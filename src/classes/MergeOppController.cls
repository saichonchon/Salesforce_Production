public without sharing class  MergeOppController {

    public Opportunity newOpportunity {get;set;}
    public String dupOppName {get;set;}
    
    public Opportunity theOpp;
    
    public MergeOppController(ApexPages.StandardController stdController) {
        // get the current opp
        theOpp = (Opportunity)stdController.getRecord();
    }
    
    public Opportunity getOpportunity() {
        theOpp = [select id, name from Opportunity
                 where id = :ApexPages.currentPage().getParameters().get('id')]; 
      return theOpp;
    } 

    public pageReference mergeOpp()
    {
       newOpportunity = [Select Id, Name from Opportunity where Name = :dupOppName];
       mergeOpp(theopp.Id, newOpportunity.Id);
       return new PageReference('/' + theopp.id);

    }
    
    public static void mergeOpp ( Id fromOppId, Id toOppId)
    {
        
        Opportunity fromOpp = [Select Id, Name, OwnerId, StageName, CloseDate, MBASubscriptionID__c, AccountId, Subscription__c,  MBAAccountID__c from Opportunity where Id =:fromOppId];
        Opportunity toOpp = [Select Id, Name, MBASubscriptionID__c, Contact__c, AccountId, Subscription__c, MBAAccountID__c, BI_Data__r.Id from Opportunity where Id =:toOppId];
        
        Map<String,Id> mpMBASubOppIds = new Map<String,Id>();
        String fromSubId = fromOpp.MBASubscriptionID__c;
        String toSubId = toOpp.MBASubscriptionID__c;
        
        Opportunity cloneOpp = fromOpp.clone(false, true,false, false);
        cloneOpp.Subscription__c = fromOpp.Subscription__c;
        cloneOpp.Name=  fromOpp.Name + ' - Clone';
        cloneOpp.OwnerId =  fromOpp.OwnerId;
        cloneOpp.MBASubscriptionID__c = fromSubId;
        cloneOpp.CloseDate = fromOpp.CloseDate;
        cloneOpp.Stagename = fromOpp.StageName;
        insert cloneOpp;
        mpMBASubOppIds.put(cloneOpp.MBASubscriptionId__c, cloneOpp.Id);

        // move the from
        
        fromOpp.MBASubscriptionID__c = toSubId;
        fromOpp.AccountId = toOpp.AccountId;
        fromOpp.MBAAccountID__c = toOpp.MBAAccountID__c;
        fromOpp.Contact__c = toOpp.Contact__c;
        fromOpp.Subscription__c = null;
//      fromOpp.BI_Data__c = toOpp.BI_Data__r.Id;
        mpMBASubOppIds.put(fromOpp.MBASubscriptionId__c, fromOpp.Id);
        
        // remove the link to mba from the To.
        
        toOpp.MBASubscriptionID__c = null;
        toOpp.Subscription__c = null;
        toOpp.Name = 'Transferred ' + toOpp.Name;
        toOpp.MonthlyRecurringRevenue__c = 0.00;
        toOpp.Product__c ='';
        toOpp.Status__c = '';
        toOpp.ProductID__c = '';
        update toOpp;
        
        update fromOpp;
        
        List<Opportunity_Product__c> lstOppProd = new List<Opportunity_Product__c>();
        for(Opportunity_Product__c obj : [SELECT Id,OpportunityID__c, RevenueChange__c, StartDate__c, LastVersion__c 
                                                    FROM Opportunity_Product__c 
                                                    WHERE OpportunityID__c =:toOpp.Id
                                                    ])
            {
 //               Opportunity_Product__c cloneOp = obj.clone(false, true,false, false);
        
                obj.OpportunityID__c = fromOpp.Id;
                lstOppProd.add(obj);
            }
        if (!lstOppProd.isEmpty()) update lstOppProd;
        
/*      if (toOpp.BI_Data__r.Id <> null)
        {
            Bi_Data__c bi = [Select Id, Opportunity__c from BI_Data__c where id = :toOpp.BI_Data__r.Id];
            bi.Opportunity__c = fromOpp.Id;
            update bi;
        }
*/      
        if (!mpMBASubOppIds.isEmpty()) OpportunityOperations.syncOppwithMBASub(mpMBASubOppIds)  ;   
    }
    
}