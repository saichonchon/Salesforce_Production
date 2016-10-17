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
    public String CaseSubject {get; set;}
    public String CallerName {get; set;}
    public List<String> ContactNames {get; set;}
    public string errorMsgCaseSubject {get;set;}
    
    private list<OpportunityWrapper> Opps = new list<OpportunityWrapper>();

    public String passedInOppId {get;set;}
    public String passedInSubId {get;set;}
    public Case newCase {get;set;}
    public Id newCaseId {get;set;}
    public Id caseRecordTypeId {get;set;}
    public String getObjectType()
    {
        return objectType;
    }
    public String getCaseSubject() 
    { 
        return CaseSubject; 
    } 
    public String getCallerName() 
    { 
        return CallerName; 
    } 
	public List<String> getContactNames() 
    { 
        return ContactNames; 
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
 
    public String oppPrefix
    {
        get  { return Opportunity.sObjectType.getDescribe().getKeyPrefix(); }
    }
    
    //Map all Recordtype Id and Name
    public Map<Id,String> caseRecordTypeName
    {
        get{
            Map<Id, String> CaseRecordTypesMap = new Map<Id,String>();
        	Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            if(RT.size()>1){
                for(RecordTypeInfo rec:RT){
                    CaseRecordTypesMap.put(rec.getRecordTypeId(),rec.getName());                
                }
            }
            return CaseRecordTypesMap;
        }
        
    }
    
    //Get the Custom Settings that has holds the defenition of what 
    //Opportunities to show during case creation
    public Opp_RecordTypes_for_Case_Creation__c getOppstoShow
    {
        get { return Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults(); }
    }
    
    //Get the Opportunity Record Types we want to show during case creation
    //This is defined in a custom setting Opp_RecordTypes_for_Case_Creation 
    public Set<String> OppRTstoShow
    {
        get {
            Set<String> setString = new Set<String>();
            if(getOppstoShow.Opp_RecordTypes_to_Show__c!=null){
                for(String key:getOppstoShow.Opp_RecordTypes_to_Show__c.split(',')){
                    setString.add(key);
                }
            }
            return setString;
        }
    }
    
    //Get the Opportunity Statuses we want to show during case creation
    //This is defined in a custom setting Opp_RecordTypes_for_Case_Creation 
    public Set<String> OppStatusestoShow
    {
        get {
            Set<String> setString = new Set<String>();
            if(getOppstoShow.Opp_Statuses_to_show__c!=null){
                for(String key:getOppstoShow.Opp_Statuses_to_show__c.split(',')){
                    setString.add(key);
                }
            }
            if(getOppstoShow.Show_Opps_with_Blank_Status__c){
                setString.add('');
                setString.add(null);
            }
            return setString;
        }
    }
  
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
        string recId = ApexPages.currentPage().getParameters().get('Id');
        acctId = '';
        contactId = '';
        errorMsg ='';
        oppId = '';
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
                
                List<Contact> cList= new List<contact>([select name from contact where accountid = :acctId]);
                ContactNames = new List<String>();
                if(!cList.isEmpty()){
                    for(contact con:cList){
                        ContactNames.add(con.Name);    
                    }
                }
            }

            else if (recId.startsWith(oppPrefix))
            {               
                oppId = recId;
                oppName = [SELECT Name FROM Opportunity WHERE Id = :oppId].Name;
                objectType = 'Opportunity';
            }
        }
    }
    
    public PageReference CreateCase()
    {
 		PageReference currentPage = ApexPages.currentPage();    
        Map<String,Id> caseQueueMap = new Map<String,Id>();
        List<CaseQueueRouting__c> csList = CaseQueueRouting__c.getAll().values();
        for(CaseQueueRouting__c cs:csList){
            caseQueueMap.put(cs.Queue_Name__c, cs.Queue_ID__c);
        }
        If (caseCreated == true) 
        {
        	errorMsg= 'Case already created, refresh the page to create another case';
        	return null;
        }
        If(CaseSubject == null || CaseSubject == ''){
            errorMsgCaseSubject = 'Please enter a Subject for the Case';
        	newCaseId = null;
        } else{
            If(CaseSubject.length()>255){
                errorMsgCaseSubject = 'Please type in 255 characters or less in the Subject';
            } else {
                        If (selectedOppId == null)
                        {
                            errorMsg= 'Please select an Opportunity!';
                            system.debug('### no selected');
                            newCaseId = null;
                            
                        }
                        else {

                            Case newCase = new Case(subject = CaseSubject,
                                            Caller_name__c = CallerName,
                                            origin = 'Phone',
                                            accountid= acctId,
                                            Opportunity__c = selectedOppId,
                                            ContactId = contactId,
                                            Change_Owner__c = 'Tier 2', 
                                            Subscription__c = selectedSubId,
                                            RecordTypeId = caseRecordTypeId
                                            );

                            if(caseRecordTypeName.get(caseRecordTypeId)=='Billing'||caseRecordTypeName.get(caseRecordTypeId)=='Cancellations'){
                                newCase.Ownerid = caseQueueMap.get('Billing');
                            } else {
                                newCase.Ownerid = caseQueueMap.get('Tier 2 Support Queue');
                            }
                             insert newCase;  
                             newCaseId = newCase.Id;
                             errorMsg= 'Case created ....';
                             system.debug('### new case id  '+newCaseId);
                             caseCreated = true;
                            }
            	}
            }
            return null;
    }
    public PageReference LoadOpportunities()
    {
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

        if (oppId != null && oppId != '')
        {           
            lstOpps = [SELECT Id, Name, StoreURL__c, New_Product_Plan__c, Product__c, Status__c, AccountId, Subscription__r.Id, Subscription__r.Name, Contact__r.Id, RecordType.Name, OppSortNumber__c
                       FROM Opportunity
                       WHERE RecordType.Name in :OppRTstoShow
                       AND Id = :oppId
                       ORDER BY OppSortNumber__c ASC];//Sort the Opportunities listed based on this field
            
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
        if (acctId != null && acctId != '')
        {           
            lstOpps = [SELECT Id, Name, StoreURL__c, New_Product_Plan__c, Product__c, Status__c, AccountId, Subscription__r.Id, Subscription__r.Name, RecordType.Name, OppSortNumber__c
                       FROM Opportunity
                       WHERE RecordType.Name in :OppRTstoShow
                       AND AccountId = :acctId
                       AND Status__c in :OppStatusestoShow
                       ORDER BY OppSortNumber__c ASC];
            
            
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
        
        Schema.DescribeSObjectResult R = Case.SObjectType.getDescribe();
		List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        if(RT.size()>1){
            for(RecordTypeInfo rec:RT){
                //isMaster() method failed with the error :Method does not exist or incorrect signature: [Schema.RecordTypeInfo].isMaster() 
                //So using the getName() in the condition 
                if(rec.isAvailable()&&rec.getName()!='Master'&&rec.isDefaultRecordTypeMapping()){
                    caseRecordTypeId = rec.getRecordTypeId();
                }
            }
        } else {
            caseRecordTypeId = RT[0].getRecordTypeId();
        }
        
        return null;
    }
    
    public void CaptureOpp()
    {
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
                }
            }

        } 
        
        
    }
    
    public void SelectOpp()
    {
        Id  OppId = ApexPages.currentPage().getParameters().get('selId');

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
                    }
                    else
                    {
                        selectedOppId = null;
                        selectedOppName = null;
                    }
                }
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
        public boolean isSelectable {get; set;} 
        public String OppRecordType {get; set;} 
        public Opportunity objOpp {get; set;} 
        public Opp_RecordTypes_for_Case_Creation__c getOppstoShow
    	{
        	get { return Opp_RecordTypes_for_Case_Creation__c.getOrgDefaults(); }
    	}
        
        //Get the Opportunity Record Types that are selectable on the Case Form. 
        //These are defined in the Custom Setting Opp_RecordTypes_for_Case_Creation__c
        public Set<String> SelectableOppRTs
        {
            get {
                Set<String> setString = new Set<String>();
                if(getOppstoShow.Selectable_Opp_RecordTypes__c!=null){
                    for(String key:getOppstoShow.Selectable_Opp_RecordTypes__c.split(',')){
                        setString.add(key);
                    }
                }
                return setString;
            }
        }
        
        //Get the Opportunity Statuses that are selectable on the Case Form. 
        //These are defined in the Custom Setting Opp_RecordTypes_for_Case_Creation__c
        public Set<String> SelectableOppStatuses
        {
            get {
                Set<String> setString = new Set<String>();
                if(getOppstoShow.Selectable_Opp_Statuses__c!=null){
                    for(String key:getOppstoShow.Selectable_Opp_Statuses__c.split(',')){
                        setString.add(key);
                    }
                }
                if(getOppstoShow.Select_Opps_with_Blank_Status__c){
                	setString.add('');
                    setString.add(null);
            	}
                return setString;
            }
        }
        
        //Based on the Selectable Opportunity Record Types and Statuses 
        //set the attribute isSelectable which will be used in the OppForConsole VF Page
        //to decide whether it's a selectable opportunity or not
        public OpportunityWrapper (Opportunity Opp, boolean selected)
        {
            this.isSelected = selected;
            if(SelectableOppRTs.contains(opp.RecordType.Name)&&SelectableOppStatuses.contains(opp.Status__c)){
                this.isSelectable = true;
            } else {
                this.isSelectable = false;
            }
            this.OppRecordType = opp.RecordType.Name;
            this.objOpp = Opp;
        }
    }
   
    //@author: Bala Rajagopal
    //@date: 08/11/16
    //Get all the Case Record Types accessible by the current user for selection during case creation in the service console.
    public static Map<String, Id> getAvailableCaseRecordTypes(){
        Schema.DescribeSObjectResult Res = Case.SObjectType.getDescribe();
		List<Schema.RecordTypeInfo> RT = Res.getRecordTypeInfos();
        List<String> names = new List<String>();
        Map<String,id> RTmap = new Map<String,id>();
        if(RT.size()>1){
            for(RecordTypeInfo rec:RT){
                //isMaster() method failed with the error :Method does not exist or incorrect signature: [Schema.RecordTypeInfo].isMaster() 
                //So using the getName() in the condition 
                if(rec.isAvailable()&&rec.getName()!='Master'){
                    names.add(rec.getName());
                    RTmap.put(rec.getName(),rec.getRecordTypeId());
                }
            }
        } else {
            RTmap.put(RT[0].getName(),RT[0].getRecordTypeId());
        }
        return RTmap;
    }

}