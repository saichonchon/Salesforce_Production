public class OppForConsoleController 
{   
    private String objectType = '';
    private String acctId = '';
    private String contactId = '';
    private String leadId = '';
    private String leadName = '';
    private String oppId = '';
    private String oppName = '';
    private String subId = '';
    private Id selectedOppId = null;
    
    private string selectedOppName = null;
    private Id selectedSubId = null;
    private string selectedSubName = null;
    public boolean caseCreated {get;set;}
    public string errorMsg {get;set;}
    
    private list<OpportunityWrapper> Opps = new list<OpportunityWrapper>();
 //   private list<SubscriptionWrapper> Subs = new list<SubscriptionWrapper>();
        
  //  public static map<String, Schema.RecordTypeInfo> mpCSRTByName = Case.getSObjectType().getDescribe().getRecordTypeInfosByName();
    
    public String passedInOppId {get;set;}
    public String passedInSubId {get;set;}
    public Case newCase {get;set;}
    public Id newCaseId {get;set;}
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
    public String getErrorMsg()
    {
        return ErrorMsg;
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
 
 /*   
     public String leadPrefix
    {
        get
        {
            return Lead.sObjectType.getDescribe().getKeyPrefix();
        }
    }
 */   
    public String oppPrefix
    {
        get  { return Opportunity.sObjectType.getDescribe().getKeyPrefix(); }
    }
 /*   // Generate the URL to open the new Opptab in
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
          
       
            system.debug('***OppsForConsole_Controller:caseCreateURLPrefix - caseCreateURLPrefix: ' + caseCreateURLPrefix);
            
            return caseCreateURLPrefix;
        }
        private set;
    }
 */   
    public String getSelectedOppName()
    {
        return selectedOppName;
    }
    
    public Id getSelectedOppId()
    {
        return selectedOppId;
    }
    
    public String getSelectedSubName()
    {
        return selectedSubName;
    }
    
    public Id getSelectedSubId()
    {
        return selectedSubId;
    }
 

    public list<OpportunityWrapper> getOpps()
    {
        return Opps;
    }
    
    public OppForConsoleController()
    {
        system.debug('### new Case id: ' + newCaseId);
         system.debug('### opp id: ' + passedInOppId);
        string recId = ApexPages.currentPage().getParameters().get('Id');
        acctId = '';
        contactId = '';
        errorMsg ='';
         
 //     leadId = '';
        oppId = '';
        objectType = '';
 //       caseCreated = false;
         system.debug(' ### In constructor ' + caseCreated);
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
/*          else if (recId.startsWith(leadPrefix))
            {               
                leadId = recId;
                leadName = [SELECT Name FROM Lead WHERE Id = :leadId].Name;
                objectType = 'Lead';
            } */
            else if (recId.startsWith(oppPrefix))
            {               
                oppId = recId;
                oppName = [SELECT Name FROM Opportunity WHERE Id = :oppId].Name;
                objectType = 'Opportunity';
            }
        }
        
        system.debug('@@@AcctId: ' + acctId);
        system.debug('@@@ContactId: ' + contactId);
 //     system.debug('@@@LeadId: ' + leadId);
        system.debug('@@@oppId: ' + oppId);
        system.debug('@@@case created: ' + caseCreated);
    }
    
    public PageReference CreateCase()
    {
 		 PageReference currentPage = ApexPages.currentPage();    
 //       Id idCSRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
        system.debug('### case created in Case create ' +caseCreated);
 		
        If (caseCreated == true) 
        {
        	errorMsg= 'Case already created, refresh the page to create another case';
        	return null;
        }
        If (selectedOppId == null)
        {
        	errorMsg= 'Please select an Opportunity!';
			system.debug('### no selected');
			newCaseId = null;
			
        }
        else {
        	string sSubject = 'Bigcommerce Support call at '+System.Now().format();

        	Case newCase = new Case(subject = sSubject,
                            origin = 'Phone',
                            accountid= acctId,
                            Documentation_Only__c = true,
  //                          RecordTypeId = idCSRecordType,
                            Opportunity__c = selectedOppId,
                            ContactId = contactId,
                            Change_Owner__c = 'Me', 
                            Subscription__c = selectedSubId
                            );
                                                        
 //      &CF00N18000000GSRJ=' + selectedOppName +  selectedSubName + ;
	         insert newCase;  
	         newCaseId = newCase.Id;
	         errorMsg= 'Case created ....';
	         system.debug('### new case id  '+newCaseId);
	         caseCreated = true;
        }
        return null;
    }
    public PageReference LoadOpportunities()
    {
        system.debug('***OppsForConsole_Controller:LoadOpps - Start');       
        
        list<Opportunity> lstOpps = new list<Opportunity>();
        Opps = new list<OpportunityWrapper>();
        OpportunityWrapper wrapOpp;
        
        Id ProfOppRecordTypeId =  Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId();
        Id UpgradeRecordTypeId = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_Upgrade).getRecordTypeId();
        Id AppRecordTypeId  = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByName().get(Label.Opportunity_RecordType_App).getRecordTypeId();
     
        Set<Id> notStoreRecIds = new Set<Id>();
        notStoreRecIds.add(AppRecordTypeId);
        notStoreRecIds.add(ProfOppRecordTypeId);
        notStoreRecIds.add(UpgradeRecordTypeId);
        
        system.debug('***OppsForConsole_Controller:LoadOpps - acctId: ' + acctId);
        
        // If opp Id exists
        if (oppId != null && oppId != '')
        {           
 
            lstOpps = [SELECT Id, Name, StoreURL__c, New_Product_Plan__c, Product__c, Status__c, AccountId, Subscription__r.Id, Subscription__r.Name, Contact__r.Id
                       FROM Opportunity
                       WHERE RecordTypeId not in :notStoreRecIds
                       AND Id = :oppId];
            
            
            for (Opportunity s : lstOpps)
            {
                acctId = s.AccountId;
                contactId = s.Contact__r.Id;
                passedInOppId = s.Id;
                
                wrapOpp = new OpportunityWrapper(s, false);
                Opps.add(wrapOpp);
            }
            
            CaptureOpp();
        }
        else
        // If  Account Id exist
        if (acctId != null && acctId != '')
        {           
 
            lstOpps = [SELECT Id, Name, StoreURL__c, New_Product_Plan__c, Product__c, Status__c, AccountId, Subscription__r.Id, Subscription__r.Name
                       FROM Opportunity
                       WHERE RecordTypeId not in :notStoreRecIds
                       AND AccountId = :acctId
                       AND Status__c <> 'Cancelled'
                       AND Status__c <> 'Terminated'];
            
            
            for (Opportunity s : lstOpps)
            {
                wrapOpp = new OpportunityWrapper(s, false);
                Opps.add(wrapOpp);
            }
            
            if (lstOpps.size() == 1) 
            {
              	passedInOppId = lstOpps[0].Id;
            	CaptureOpp();
            }
        }
        
        return null;
    }
    
    public void CaptureOpp()
    {
        //id OppId = ApexPages.currentPage().getParameters().get('passedInId');
        
        system.debug('***OppsForConsole_Controller.CaptureOpp - passedInId: ' + passedInOppId);
        
        if (passedInOppId != null)
        {
            // Set the selected Opp variable
            for (OpportunityWrapper wrap : Opps)
            {                       
                if (wrap.objOpp.Id != passedInOppId)
                {
                    wrap.isSelected = false;
                }
                else
                {

                    wrap.isSelected = true;
                    
                    selectedOppId = wrap.objOpp.Id;
                    selectedOppName = wrap.objOpp.Name;
                    selectedSubId = wrap.objOpp.Subscription__r.Id;
                    selectedSubName = wrap.objOpp.Subscription__r.Name;
                    system.debug( 'selected sub '+selectedSubId);
                }
            }
 //           createCase();
        } 
        
        
    }
    
    public void SelectOpp()
    {
        Id  OppId = ApexPages.currentPage().getParameters().get('selId');
        
        system.debug('***OppsForConsole_Controller.SelectOpp - OppId: ' + OppId);
        
        if (OppId != null)
        {
            // Set the selected Opp variable
            for (OpportunityWrapper wrap : Opps)
            {                       
                if (wrap.objOpp.Id != OppId)
                {
                    wrap.isSelected = false;
                }
                else
                {
                    // If the Opp has just been selected the set the selected Opp variable to the Opp id, otherwise clear it
                    if (wrap.isSelected)
                    {
                        selectedOppId = wrap.objOpp.Id;
                        selectedOppName = wrap.objOpp.Name;
                        selectedSubId = wrap.objOpp.Subscription__r.Id;
                        selectedSubName = wrap.objOpp.Subscription__r.Name;
                        system.debug( 'selected sub '+selectedSubId);
 //                       createCase();
                    }
                    else
                    {
                        selectedOppId = null;
                        selectedOppName = null;
                    }
                }
                //system.debug('***OppsForConsole_Controller.SelectOpp - wrap Opp: ' + wrap.objOpp);
                //system.debug('***OppsForConsole_Controller.SelectOpp - wrap Selected: ' + wrap.isSelected);
            }
        }       
    }
    
    public void doNothing()
    {
     return;
    }
    
    public class OpportunityWrapper
    {
        public boolean isSelected {get; set;} 
        public Opportunity objOpp {get; set;}  
        
        public OpportunityWrapper (Opportunity Opp, boolean selected)
        {
            this.isSelected = selected;
            this.objOpp = Opp;
        }
    }
   
   

}