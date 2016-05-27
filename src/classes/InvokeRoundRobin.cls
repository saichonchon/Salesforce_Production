/**********************************************************************
Name:  
============================================================
 Purpose: Round Robin objects


============================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 4/25/2015  Initial development
2.0 Maggie Frederick 9/5/2015   Capture who and when it was invoked.
***********************************************************************/    
public class InvokeRoundRobin {

/*
    // Constructor - this only really matters if the autoRun function doesn't work right
    private final Account theAccount;
    
   
    public AccountButtonController(ApexPages.StandardController stdController) {
        // get the current Account
        theAccount = (Account)stdController.getRecord();
    }
*/ 
    public Id theID;
    // Calling autorun method.
    public PageReference autoRun()
    {
        Id objId;
        theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('theId'+theId);
        Schema.SObjectType sobjectType = theId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        system.debug('my object'+sobjectname);

        if (ApexPages.currentPage().getUrl().containsIgnoreCase ('QualifyButton'))
        {
            qualifyAccount(theId);
            return new PageReference('/' + theid);
        }
        if (sobjectName =='Account') 
        {
         
          roundrobinAccount(theId);
        }
/*      else if (sobjectName =='Opportunity') 
        {
         
          roundrobinOpp(theId);
        } */
        return new PageReference('/' + theid);
    }
    
    public static void roundrobinAccount(Id accId)
    {
        List<Account> accts = new List<Account>([select Id, ownerId, Projected_Annual_Revenue__c, Assign_To_Team__c from Account where id =:accId]);
        String queuename ='';
/*      
        if (accts[0].Projected_Annual_Revenue__c =='Less than $100,000') queuename = 'Direct Sales Accounts Queue';
        else if (accts[0].Projected_Annual_Revenue__c =='Less than $500,000' || accts[0].Projected_Annual_Revenue__c =='$100,000 - $500,000') 
                { queuename = 'Acquisition Accounts Queue';}
        else  queuename = 'Enterprise Accounts Queue';
*/      
        if (accts[0].Assign_To_Team__c =='Enterprise') queuename = 'Enterprise Accounts Queue';
        else if (accts[0].Assign_To_Team__c =='Acquisition' ) 
                { queuename = 'Acquisition Accounts Queue';}
        else if (accts[0].Assign_To_Team__c =='ApAC enterprise' ) 
                { queuename = 'APAC Enterprise Accounts Queue';}
        else if (accts[0].Assign_To_Team__c =='APAC Direct' ) 
                { queuename = 'APAC Direct Accounts Queue';}
        else  queuename = 'Direct Sales Accounts Queue';
        
        // assign using Round Robin
         
          RoundRobin.RoundRobinForAccount(accts, queuename);
          // revision aug 15
          StaticVariables.runningAccRoundRobin = true;
          for (Account a:accts)
          {
            a.Sales_Decision__c = 'Open';
            a.Qualifier__c = UserInfo.getUserId();
            a.Qualified_Date__c = Date.Today();
          }     
          update accts;
          addOppTeam(accts);
    }


    public static void addOppTeam(List<Account> accts)
    {
        
        List<OpportunityTeamMember> otms = new List<OpportunityTeamMember>();
        List<Opportunity> opps = [Select Id, AccountId, Stagename from Opportunity where AccountId in :accts and isClosed = false];
        for (Opportunity o :opps)
          {
            OpportunityTeamMember tm = new OpportunityTeamMember(OpportunityId=o.Id,TeamMemberRole ='Qualifier', UserId = UserInfo.getUserId() );
            otms.add(tm);
          }
        
        insert otms;
        
    }
    
    public static void qualifyAccount(Id accId)
    {
        List<Account> accts = new List<Account>();
        Account a = new Account(id = accid);
            a.Sales_Decision__c = 'Open';
            a.Qualifier__c = UserInfo.getUserId();
            a.Qualified_Date__c = Date.Today();
               
          update a;
          accts.add(a);
          addOppTeam(accts);
    }
  
/* 
    public static void roundrobinOpp(Id oppId)
    {
        List<Opportunity> opps = new List<Opportunity>([select Id, ownerId, Projected_Annual_Revenue__c from Opportunity where id =:oppId]);
        String queuename ='';
        
        if (opps[0].Projected_Annual_Revenue__c =='Less than $100,000') queuename = 'Direct Sales Queue';
        else if (opps[0].Projected_Annual_Revenue__c =='Less than $500,000') queuename = 'Acquisition Queue';
        else  queuename = 'Enterprise Accounts Queue';
        // assign using Round Robin
          RoundRobin.RoundRobinForOpportunity(opps, queuename );
          update opps;
    }
*/
}