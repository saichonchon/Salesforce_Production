public  class PartnerCommissionsHelper {
    
    public Id detailRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Detail').getRecordTypeId();
    
    public static void createCommrecords(Map<Id, BI_Data__c> mapOppBi )
    {
        Id detailRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Detail').getRecordTypeId();
        List<Partner_Commission__C> updcommList = new List<Partner_Commission__C>();
        Map<Id, Partner_Commission__C> mapOppComm = new Map<Id, Partner_Commission__C>();
        Set<Id> updRecs = new Set<Id>();
        
        for (Partner_Commission__c pc :[Select Id, Opportunity__r.Id, Opportunity__r.BillingCycle__c, Payment_Date__c ,  Payment__c, PaymentMonth__c, PaymentYear__c, Annual_Billing__c
                                     from Partner_Commission__c
                                     where RecordTypeId = :detailRecordTypeId
                                     and Opportunity__c in :mapOppBi.KeySet()
                                     and (Payment_Date__c = this_month
                                     	or (Payment_Date__c >  this_month and annual_billing__c =true))
                                     ])
        {
        	BI_Data__c bid = mapOppBi.get(pc.Opportunity__r.Id);
        	Boolean annual = false;
//        	if (pc.Opportunity__r.BillingCycle__c == 'Annaully')
			if (bid.Payment_Term__c >1)  
        		annual = true;
        	if (bid.Last_Payment_Date__c.Month() == pc.PaymentMonth__c 
        		&& bid.Last_Payment_Date__c.Year() == pc.PaymentYear__c
        		&& !annual)
        	{
            	pc.Payment__c = bid.Last_Payment_Amount__c;
        		pc.Payment_Date__c = bid.Last_Payment_Date__c;
        		updcommList.add(pc);
        		updRecs.add(pc.Opportunity__r.Id);
        	}
        	else if (annual && pc.annual_billing__c == true)
        	{
        		pc.Payment__c = bid.Last_Payment_Amount__c/12;
        		updcommList.add(pc);
        		updRecs.add(pc.Opportunity__r.Id);
        	}
        }
        
        List<Partner_Commission__C> commList = new List<Partner_Commission__C>();
        List<Partner_Commission__C> anncommList = new List<Partner_Commission__C>();
        
        List< BI_Data__c> mbids = new List<Bi_Data__c>();
        for (Opportunity o :[Select Id, rvpe__RVAccount__c, BillingCycle__c,Product__c  from Opportunity where Id in:mapOppBi.KeySet()])
        {
          if ( !updRecs.contains(o.Id))
          {  
            BI_Data__c bid = mapOppBi.get(o.id);
            String cname = String.valueOf(bid.Last_Payment_Date__c) +' '+ bid.MBA_Subscription_ID__c;
            Partner_Commission__C newc = new Partner_Commission__C(Name = cname, Opportunity__c = o.id, 
                                                                    BIData__c = bid.Id,
                                                                    RVAccount__c = bid.Partner_Account__c,
                                                                    Payment_Date__c = bid.Last_Payment_Date__c,
                                                                    Store_Plan__c = o.Product__c,
                                                                    RecordTypeId = detailRecordTypeId,
                                                                    Payment_Terms__c = bid.Payment_Term__c,
                                                                    IncludeInCurrentMonth__c = true
                                                                    );
            
 //           if (o.BillingCycle__c == 'Annually')
 			if (bid.Payment_Term__c >1)  
            {
            	newc.Payment__c = bid.Last_Payment_Amount__c/12;
            	newc.Annual_Billing__c = true;
                anncommList.add(newc);
            }
            else 
            {
            	newc.Payment__c = bid.Last_Payment_Amount__c;
            }
            commList.add(newc);
          }
        }
        
        if (!anncommList.isEmpty())   
        {
            List<Partner_Commission__C> mcomms = createAnnualCommrecords(anncommList);
            commList.addAll(mcomms);
        }
             
        update updcommList;
        insert commList;
    }

/*
    public static List<Partner_Commission__C> createAnnualCommrecords(List <BI_Data__c> mbids)      
    {
        List<Partner_Commission__C> moncommList = new List<Partner_Commission__C>();
        Id detailRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Detail').getRecordTypeId();
        Integer cyy = Date.Today().year();
        Integer cmm = Date.Today().month();
        
        for (Bi_Data__c  bid :mbids)
            {
                
                Double monthlyamt = bid.Last_Payment_Amount__c/12;
                 for(Integer i=1;i<bid.Payment_Terms__c;i++)
                 {
                    date nextdate = bid.Last_Payment_Date__c.addmonths(i);
                    String cname = String.valueOf(bid.Last_Payment_Date__c) +' '+ bid.MBA_Subscription_ID__c;
                     
                    Partner_Commission__C newc = new Partner_Commission__C(Name = cname, Opportunity__c = bid.Opportunity__c, 
                                                                            BIData__c = bid.Id,
                                                                            RVAccount__c = bid.Partner_Account__c,
                                                                            Payment_Date__c = nextdate,
                                                             //               Store_Plan__c = o.Product__c,
                                                                            Annual_Billing__c = true,
                                                                            RecordTypeId = detailRecordTypeId,
                                                                            Payment__c = monthlyamt);
                     
                    if (cmm == nextdate.month() && cyy == nextdate.Year()) newc.IncludeInCurrentMonth__c = true;
                    moncommList.add(newc);
                 }
                
            }
            
        
        return moncommList;
   
    } 
 */   
    public static List<Partner_Commission__C> createAnnualCommrecords(List<Partner_Commission__C> pcList)      
    {
        List<Partner_Commission__C> moncommList = new List<Partner_Commission__C>();
        Integer cyy = Date.Today().year();
        Integer cmm = Date.Today().month();
        String spaceChar = ' ';
        for (Partner_Commission__c  pc :pcList)
            {
 
                 for(Integer i=1;i<pc.Payment_Terms__c;i++)
                 {
                    date nextdate = pc.Payment_Date__c.addmonths(i);
                    String cname = pc.Name.substringAfter(spaceChar);
                    cname = String.valueOf(pc.Payment_Date__c) +' ' +cname;
                    Partner_Commission__C newc = new Partner_Commission__C(Name = cname, Opportunity__c = pc.Opportunity__c, 
                                                                            BIData__c = pc.BIData__c ,
                                                                            RVAccount__c = pc.RVAccount__c,
                                                                            Payment_Date__c = nextdate,
                                                                            Store_Plan__c = pc.Store_Plan__c,
                                                                            Annual_Billing__c = true,
                                                                            RecordTypeId = pc.RecordTypeId,
                                                                            Payment_Terms__c = pc.Payment_Terms__c,
                                                                            Payment__c = pc.Payment__c);
                     
                    if (cmm == nextdate.month() && cyy == nextdate.Year()) newc.IncludeInCurrentMonth__c = true;
                    moncommList.add(newc);
                 }
                
            }
            
        
        return moncommList;
   
    } 
     
}