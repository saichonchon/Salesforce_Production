public without sharing class SubsForConsole_Controller 
{	
	private String objectType = '';
    private String acctId = '';
    private String contactId = '';
    private String leadId = '';
    private String leadName = '';
    private Id selectedSubId = null;
    private string selectedSubName = null;
    private list<SubscriptionWrapper> Subs = new list<SubscriptionWrapper>();
        
    public static map<String, Schema.RecordTypeInfo> mpCSRTByName = Case.getSObjectType().getDescribe().getRecordTypeInfosByName();
    
    public String passedInSubId {get;set;}
    
    public String getObjectType()
    {
        return objectType;
    }
    
    public void setAcctId(String n)
    {
        acctId = n;
    }
    
    public String getAcctId()
    {
        return acctId;
    }
    
    public void setContactId(String n)
    {
        contactId = n;
    }
    
    public String getContactId()
    {
        return contactId;
    }
    
    public String getLeadId()
    {
        return leadId;
    }
    
    public String getLeadName()
    {
        return leadName;
    }
    
    public String contactPrefix
    {
    	get
    	{
    		return Contact.sObjectType.getDescribe().getKeyPrefix();
    	}
    }
    
    public String accountPrefix
    {
    	get
    	{
    		return Account.sObjectType.getDescribe().getKeyPrefix();
    	}
    }
    
     public String leadPrefix
    {
    	get
    	{
    		return Lead.sObjectType.getDescribe().getKeyPrefix();
    	}
    }
    
    // Generate the URL to open the new subtab in
    public String caseCreateURLPrefix
    {
        get
        {
            if(caseCreateURLPrefix == null)
            {                
                // Prefix to create the case (/500/e)
                PageReference pageRef = new PageReference('/' + Case.sObjectType.getDescribe().getKeyPrefix() + '/e');
                pageRef.getParameters().put('isdtp','vw');
                pageRef.getParameters().put('ent', Case.sObjectType.getDescribe().getName());
                
                caseCreateURLPrefix = pageRef.getURL();             
            }
            system.debug('***SubsForConsole_Controller:caseCreateURLPrefix - caseCreateURLPrefix: ' + caseCreateURLPrefix);
            
            return caseCreateURLPrefix;
        }
        private set;
    }
    
    public String getSelectedSubName()
    {
    	return selectedSubName;
    }
    
    public Id getSelectedSubId()
    {
    	return selectedSubId;
    }
    
    public list<CaseRTWrapper> lstCaseRTWraps
    {
        get
        {
            list<CaseRTWrapper> lstOpt = new list<CaseRTWrapper>();
            CaseRTWrapper cw;           
            
            for (string s : mpCSRTByName.keySet())
            {
                system.debug('@@@ Case RT Name: ' + s);
                
                if (mpCSRTByName.get(s).isAvailable() && s != 'Master')
                {
                    system.debug('@@@ Case RT Name Available: ' + s);
                    system.debug('@@@ Case RT ID Available: ' + string.valueOf(mpCSRTByName.get(s).getRecordTypeId()));
                    
                    cw = new CaseRTWrapper();
                    cw.RTID = string.valueOf(mpCSRTByName.get(s).getRecordTypeId());
                    cw.RTName = s;
                    lstOpt.add(cw);
                }
            }
            
            return lstOpt;
        }
    }
    
    public list<SelectOption> lstCaseRTs
    {
        get
        {
            list<SelectOption> lstOpt = new list<SelectOption>();
            lstOpt.add(new SelectOption('', 'Case Type'));
            
            for (string s : mpCSRTByName.keySet())
            {
                if (mpCSRTByName.get(s).isAvailable() && s != 'Master')
                {
                    lstOpt.add(new SelectOption(mpCSRTByName.get(s).getRecordTypeId(), s));
                }
            }
            
            return lstOpt;
        }
    }
    
    public list<SubscriptionWrapper> getSubs()
    {
        return Subs;
    }
    
    public SubsForConsole_Controller()
    {
    	string recId = ApexPages.currentPage().getParameters().get('Id');
    	acctId = '';
    	contactId = '';
    	leadId = '';
    	objectType = '';
    	
    	// Check which object this page is loading from
    	if (recId != null)
    	{
    		if (recId.startsWith(accountPrefix))
	    	{ 
	    		acctId = recId;
	    		objectType = 'Account';  		
	    	}
	    	else if (recId.startsWith(contactPrefix))
	    	{
	    		contactId = recId;
	    		objectType = 'Contact';
	    		
	    		acctId = [SELECT AccountId FROM Contact WHERE Id = :contactId].AccountId;
	    	}
	    	else if (recId.startsWith(leadPrefix))
	    	{	    		
	    		leadId = recId;
	    		leadName = [SELECT Name FROM Lead WHERE Id = :leadId].Name;
	    		objectType = 'Lead';
	    	}
    	}
    	
    	system.debug('@@@AcctId: ' + acctId);
    	system.debug('@@@ContactId: ' + contactId);
    	system.debug('@@@LeadId: ' + leadId);
    }
    
    public PageReference LoadSubscriptions()
    {
        system.debug('***SubsForConsole_Controller:LoadSubs - Start');       
        
        list<Subscription__c> lstSubs = new list<Subscription__c>();
        Subs = new list<SubscriptionWrapper>();
		SubscriptionWrapper wrapSub;
		
        system.debug('***SubsForConsole_Controller:LoadSubs - acctId: ' + acctId);
        system.debug('***SubsForConsole_Controller:LoadSubs - leadId: ' + leadId);
        
        // If either a Lead or Account Id exist
        if ((leadId != null && leadId != '') || (acctId != null && acctId != ''))
        {        	
        	if (leadId != null && leadId != '')
        	{
				lstSubs = [SELECT Id, Name, StoreName__c, StoreURL__c, Product__c, Status__c, Account__c, Lead__c
	                        FROM Subscription__c
	                        WHERE RecordTypeId = :Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId()
	                            AND Lead__c = :leadId];
        	}
        	else if (acctId != null && acctId != '')
        	{
        		lstSubs = [SELECT Id, Name, StoreName__c, StoreURL__c, Product__c, Status__c, Account__c, Lead__c
	                        FROM Subscription__c
	                        WHERE RecordTypeId = :Subscription__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('MBA Subscription').getRecordTypeId()
	                            AND Account__c = :acctId];
        	}
        	
            for (Subscription__c s : lstSubs)
			{
				wrapSub = new SubscriptionWrapper(s, false);
				Subs.add(wrapSub);
			}
        }
        
        return null;
    }
    
    public void CaptureSub()
	{
		//id subId = ApexPages.currentPage().getParameters().get('passedInId');
		
		system.debug('***SubsForConsole_Controller.CaptureSub - passedInId: ' + passedInSubId);
    	
    	if (passedInSubId != null)
    	{
    		// Set the selected sub variable
    		for (SubscriptionWrapper wrap : Subs)
	    	{	    			    
	    		if (wrap.objSub.Id != passedInSubId)
	    		{
					wrap.isSelected = false;
	    		}
	    		else
	    		{

	    			wrap.isSelected = true;
	    			
    				selectedSubId = wrap.objSub.Id;
    				selectedSubName = wrap.objSub.Name;
	    		}
	    	}
    	} 
	}
    
   	public void SelectSub()
    {
    	id subId = ApexPages.currentPage().getParameters().get('selId');
    	
    	system.debug('***SubsForConsole_Controller.SelectSub - subId: ' + subId);
    	
    	if (subId != null)
    	{
    		// Set the selected sub variable
    		for (SubscriptionWrapper wrap : Subs)
	    	{	    			    
	    		if (wrap.objSub.Id != subId)
	    		{
					wrap.isSelected = false;
	    		}
	    		else
	    		{
	    			// If the sub has just been selected the set the selected sub variable to the sub id, otherwise clear it
	    			if (wrap.isSelected)
	    			{
	    				selectedSubId = wrap.objSub.Id;
	    				selectedSubName = wrap.objSub.Name;
	    			}
	    			else
	    			{
	    				selectedSubId = null;
	    				selectedSubName = null;
	    			}
	    		}
	    		//system.debug('***SubsForConsole_Controller.SelectSub - wrap Sub: ' + wrap.objSub);
	    		//system.debug('***SubsForConsole_Controller.SelectSub - wrap Selected: ' + wrap.isSelected);
	    	}
    	}    	
    }
    
    public class SubscriptionWrapper
    {
    	public boolean isSelected {get; set;} 
    	public Subscription__c objSub {get; set;}  
    	
    	public SubscriptionWrapper (Subscription__c sub, boolean selected)
    	{
    		this.isSelected = selected;
    		this.objSub = sub;
    	}
    }
    
    public class CaseRTWrapper
    {
        public string RTID {get; set;}
        public string RTName {get; set;}       
        
        public CaseRTWrapper ()
        {
        }
    }
}