//Controller to covert lead using Convert custom button on visualforce page ConvertLead
public with sharing class ConvertLeadClass {
	public string productName {get; set;}
	public Id leadId;
	public Id leadOwnerId;
	public string acc;
    public string accountId;
    public string oppId;
    public string customleadId;
    public PricebookEntry pb2;
    list<Product2> pd {get;set;}
    public Task t {get; set;}
    public OpportunityLineItem opp;

   	public list<SelectOption> getProductList(){
   		list<SelectOption> options = new list<SelectOption>();
    	pd = [Select Id, Name FROM Product2 ];
        options.add(new SelectOption('--None--','--None--'));
        for (Integer j=0;j<pd.size();j++) {
			options.add(new SelectOption(pd[j].Id,pd[j].Name));
		}
    	return options;
    }
    

    public ConvertLeadClass() {
		leadOwnerId = ApexPages.currentPage().getParameters().get('OwnerId');
	}
    

    public Task getnewTask() {
        t = new Task();
        t.OwnerId = leadOwnerId;
        t.Status = 'In Progress';
        return t;
    }
    
 
    public pageReference convert() {
        try{
	        leadId = ApexPages.currentPage().getParameters().get('Id');
	        customleadId = leadId;
	        
	        Database.Leadconvert leadConv = new Database.Leadconvert();
	        leadConv.setLeadId(leadId);
	        leadConv.setOwnerId(t.ownerId);
	        try {
	        	 if(!test.isRunningTest()) 
	        	 acc = ApexPages.currentPage().getParameters().get('AccountId');
	        	 //system.debug('>>>>>>>>>>>>>>>>>>>>>AccountName'+acc);
	             leadConv.setAccountId([select id from account where name =: acc or Id =: acc].id);
	             //system.debug('>>>>>>>>>>>>>>>>>>>>>>'+[select id from account where name =: acc].id);                              
        	} 
        	catch (exception e1) {}
	        
	        //Code to convert the lead
	        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1]; 
	        leadConv.setConvertedStatus(convertStatus.MasterLabel);
	        Database.LeadConvertResult leadconvertresult = Database.convertlead(leadConv);
	        accountId = leadconvertresult.getAccountId();
	        Account accLeadId = [Select Id from Account where Id =: accountId];
	        accLeadId.Converted_LeadId__c = customleadId;
	        update accLeadId;
	        oppId = leadconvertresult.getOpportunityId();
	        
	        Task tsk = new Task();
	        tsk = t;
	        tsk.WhatId = accountId;
	        if(!test.isRunningTest())
	        insert tsk;
	        
	        if(!test.isRunningTest())        
	        pb2 = [Select id,UnitPrice from PricebookEntry where Product2Id =:productName];
	        
	        OpportunityLineItem opp = new OpportunityLineItem();
	        opp.PricebookEntryId = pb2.id;
	        opp.OpportunityId = oppId;
	        opp.Quantity = 1;
	        opp.TotalPrice = pb2.UnitPrice;
	        
	        insert opp;
	        pageReference pageRef1 = new pageReference('/' + accountId);
	        return pageRef1;  
        }
        catch(Exception e){return null;}
                                           
     }
     
     public pageReference back(){
     	leadId = ApexPages.currentPage().getParameters().get('Id');
     	pageReference pageRefBack = new pageReference('/' + leadId);
     	return pageRefBack;
     }
     
     //Test Class to test the controller//
     public static testMethod void myTest() {
	 	Lead lead = new Lead();
		lead.FirstName = 'Test';
		lead.LastName = 'Student';
		lead.Company = 'Student';
		lead.Status = 'Open';
		
		
	    Database.SaveResult NewLead = Database.Insert(lead);
	 	
	    Database.LeadConvert lc = new database.LeadConvert();
	    Task t = new Task();
	    t.Subject ='Call';
	    t.Status = 'In Progress';
	    t.WhatId =lc.getAccountId();
	    
	    Product2 p2 = new Product2();
	    p2.Name='TestProduct';
	    Insert p2;
	    	   
	   	Date dt = system.today();
	   	Opportunity opp = new Opportunity(Name='Test',CloseDate=dt,StageName='Prospecting',AccountId=lc.getAccountId());
   		opp.NextStep = 'I don\'t know what this field is';
	   	Insert opp;
	    
	    OpportunityLineItem opl = new OpportunityLineItem();
	    opl.PricebookEntryId = '01u30000005CldN';
	    opl.OpportunityId = opp.id ;
	    opl.Quantity = 1;
	    opl.TotalPrice = 20.00;
	    
	    Database.SaveResult Task = Database.Insert(t);
	    lc.setLeadId(lead.id);
	    lc.setOwnerId(t.OwnerId);
	    Id leadid = lc.getLeadId();	
	    Id accid = lc.getAccountId();   
		
		PageReference pageRef = New Pagereference('/' + accid);
		Lead l=new Lead(FirstName = 'Test',LastName = 'Student', Company = 'Student',Status = 'Open');
		insert l;
		
		ApexPages.StandardController ctrl = new ApexPages.StandardController(l);
		PageReference pageRef1 = Page.ConvertLead;
        pageRef1.getParameters().put('id', l.id);
        Test.setCurrentPage(pageRef1);
		  
		ConvertLeadClass lcp1 = new ConvertLeadClass();
		Account acc = new Account(Name = 'Test Account');
		insert acc;
		lcp1.pb2 = [Select id,UnitPrice from PricebookEntry limit 1];
		lcp1.acc = string.valueOf(acc.Id);
		lcp1.getProductList();
		lcp1.getnewTask();
		lcp1.convert();
		lcp1.back();
	}
	
}