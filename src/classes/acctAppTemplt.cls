public  class acctAppTemplt
{
    public Id accountId {get;set;}
    public List<Opportunity> getopptys()
    {
        List<Opportunity> opptylist;
        
        Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
        String published = 'Published';         
        opptylist = [SELECT Name, StageName,App_Rev_Share_Payment_Date__c, AppRev_Share_Payment_Amount__c FROM Opportunity WHERE Accountid =: accountId AND RecordTypeId = :AppRecordTypeId AND STAGENAME =:published];
        return opptylist;
    }
}