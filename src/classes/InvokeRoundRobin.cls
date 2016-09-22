/**********************************************************************
Name:  
============================================================
 Purpose: Round Robin objects


============================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 4/25/2015  Initial development
2.0 Maggie Frederick 9/5/2015   Capture who and when it was invoked.
3.0 Nicole Smith     9/12/2016  Update queue names to curren naming conventions (BAP-4012).
***********************************************************************/    
public class InvokeRoundRobin {

/*
    // Constructor - this only really matters if the autoRun function doesn't work right
*/ 
    public Id theID;
    // Calling autorun method.
    public PageReference autoRun()
    {
        System.debug('Entering autoRun');
        Id objId;
        theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('theId'+theId);
        Schema.SObjectType sobjectType = theId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        system.debug('my object'+sobjectname);

        boolean runQualify = ApexPages.currentPage().getUrl().containsIgnoreCase('QualifyButton');
        boolean isAccount = (sobjectName =='Account');

        System.debug('runQualify=' + runQualify);
        System.debug('isAccount=' + isAccount);

        if (runQualify)
        {
            qualifyAccount(theId);
        }
        else if (isAccount) 
        {
            roundrobinAccount(theId);
        }
        return new PageReference('/' + theid);
    }
 
    /**
     * RoundrobinAccount used for the Round Robin button the Opportunity to assign an Account/Opportunity to a particular team
     * @author Nicole Smith
     * @date   2016-09-12
     * @ticket link       https://jira.bigcommerce.com/browse/BAP-4012
     * @param  accId      AccountId
     */
    
    private void roundrobinAccount(Id accId)
    {
        System.debug('Entering roundrobinAccount');
        List<Account> accts = new List<Account>([select Id, ownerId, Projected_Annual_Revenue__c, Assign_To_Team__c from Account where id =:accId]);
        String queuename ='';
        Set<String> assignmentQueues = new Set<String>();
        assignmentQueues.add('Sr. Midmarket');
        assignmentQueues.add('Midmarket');
        assignmentQueues.add('APAC Midmarket');
        assignmentQueues.add('APAC Small Business');

        if (assignmentQueues.contains(accts[0].Assign_To_Team__c))
        {
            queuename = accts[0].Assign_To_Team__c + ' Sales Queue';
        }
        else
        {
            queuename = 'Small Business Sales Queue';
        }

        System.debug('Queuename = ' + queuename);

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


    private void qualifyAccount(Id accId)
    {
        System.debug('Entering qualifyAccount');
        List<Account> accts = new List<Account>();
        Account a = new Account(id = accid);
            a.Sales_Decision__c = 'Open';
            a.Qualifier__c = UserInfo.getUserId();
            a.Qualified_Date__c = Date.Today();
               
          update a;
          accts.add(a);
          addOppTeam(accts);
    }

    private void addOppTeam(List<Account> accts)
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
}