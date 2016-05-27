@isTest
public class TestBatchTaskController{
    @isTest
    private static void test(){
        Account acc = new Account(Name='Test acc');
        insert acc;
        
        Contact con = new Contact(LastName='Test',AccountId=acc.Id);
        insert con;
        Task tsk = new Task(WhoId=con.Id,Subject='test sub',Description='des');
        insert tsk;
        
        Lead ld = new Lead(LastName='Test Lead',Company='com');
        insert ld;
        
        Campaign cmp = new Campaign(Name='Test cmp');
        insert cmp;
        
        List<CampaignMember> lstCmpMem = new List<CampaignMember>();
        CampaignMember mem1 = new CampaignMember(CampaignId=cmp.Id,ContactId=con.Id);
        CampaignMember mem2 = new CampaignMember(CampaignId=cmp.Id,LeadId=ld.Id);
        lstCmpMem.add(mem1);
        lstCmpMem.add(mem2);
        
        insert lstCmpMem;
        
        Test.startTest();
        ScheduledCreateTask sche = new scheduledCreateTask();
        sche.execute(null);
        Test.stopTest();
    }
}