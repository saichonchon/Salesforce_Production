global class  PartnerCommissionSummary implements Database.Batchable<sObject>, Database.Stateful
{
    public String query;
    global Boolean Flag;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {           
        return Database.getQueryLocator(query);     
    }

    //Method where business logic gets executed
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
 	  	Id detailRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Detail').getRecordTypeId();
	    Id SummaryRecordTypeId = Partner_Commission__c.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Summary').getRecordTypeId();
		
 		list<Partner_Commission__c> lstParComs = new list<Partner_Commission__c>();
 		Map <Id, list<Partner_Commission__c>> mapRVPars = new map<Id, list<Partner_Commission__c >>();
 		Map <Id, rvpe__RVAccount__c> mapRVA = new Map  <Id, rvpe__RVAccount__c>();
 		date rundate =Date.Today();
 		
        if (Label.Commissions_Month <> 'Current')
        {
        	rundate = date.parse(Label.Commissions_Month);
        }
        Date lastmonth = rundate.addMonths(-1);
        Integer cyy = lastmonth.year();
        Integer cmm = lastmonth.month();
        
  // get the previous month summary record Today - 2 months
        Date prevmonth = rundate.addMonths(-2);
 		String prevYearMon= String.valueOf(prevMonth).remove('-') ;
	 	prevYearMon = prevYearMon.substring(0,6);
        Integer intprevYearMon = Integer.ValueOf(prevYearMon);
    
 
        
        for(Sobject sObj : scope)
        { 
	        System.Debug('User1 scope size#'+scope.size());
	        rvpe__RVAccount__c obj = ( rvpe__RVAccount__c) sObj;
	        System.Debug('User1 scope '+obj.Id);
			mapRVA.put(obj.Id , obj);
			
        }

		AggregateResult[] revgr = [SELECT RVAccount__c, SUM(Payment__c)total, Count(Id)countRecs 
									FROM Partner_Commission__c  
									where PaymentYear__c = :cyy and PaymentMonth__c = :cmm
									and RecordTypeId= :detailRecordTypeId 
									GROUP BY RVAccount__c ];           
        
        Map <Id, Decimal> mapRVRevenue = new Map <Id, Decimal>();
        Map <Id, Integer> mapRVCount = new Map <Id, Integer>();
        
        for (AggregateResult ar : revgr)  
        {
        	system.debug(' test'+ar.get('RVAccount__c'));
        	system.debug(' test'+ar.get('total'));
        	mapRVRevenue.put((Id)ar.get('RVAccount__c'), (Decimal)ar.get('total') );
        	mapRVCount.put((Id)ar.get('RVAccount__c'), (Integer)ar.get('countRecs') );
        }
                   
        if(mapRVA.size()>0)
        {
            list<Partner_Commission__c> lstSumComs = new list<Partner_Commission__c>();
            list<Partner_Commission__c> lstUpdSumComs = new list<Partner_Commission__c>();
 			Map <Id, Partner_Commission__c> lstPrevSum = new Map<Id, Partner_Commission__c>();
 			List<rvpe__RVAccount__c> updRVA = new List<rvpe__RVAccount__c>();
 
 			
        

 			for (Partner_Commission__c ppc :[Select Id, RVAccount__c, Rollup_Commission__c 
 											from Partner_Commission__c
 											where Summary_YearMonth__c = :intprevyearmon
 											and RecordTypeId = :SummaryRecordTypeId])
 			{
 				lstPrevSum.put(ppc.RVAccount__c, ppc);
 			}

// get the current month summary record if it already ran
			String currYearMon = String.valueOf(lastMonth).remove('-') ;
			currYearMon = currYearMon.substring(0,6);
           
            Integer intcurrYearMon = Integer.ValueOf(currYearMon);
            
			Map <Id, Partner_Commission__c> lstCurrSum = new Map<Id, Partner_Commission__c>();
 		
 			for (Partner_Commission__c ppc :[Select Id, RVAccount__c, Rollup_Commission__c 
 											from Partner_Commission__c
 											where Summary_YearMonth__c = :intcurrYearMon
 											and RecordTypeId = :SummaryRecordTypeId ])
 			{
 				lstCurrSum.put(ppc.RVAccount__c, ppc);
 			}
 // create or update summary record
 			Boolean existing = false;
            for (Id rvaId : mapRVA.KeySet())
            {
            	double rollupCommAmt = 	0;
            	double cumPayments =0;
            	
            	rvpe__RVAccount__c rva = mapRVA.get(rvaId);
 // check if commission payment should be activated           	
            	if (rva.PaymentNotActivated__c == true && rva.PayPal_Account_ID__c <> null 
    	 			&& (rva.Agreement__c == 'Bypass Agreement' || rva.rvpe__RVPrimaryMember__r.rvpe__DateAgreedToTerms__c <> null) )
			    	{
			    		rva.PaymentNotActivated__c = false;
			    	} 
 
                if (mapRVRevenue.get(rvaid)<> null) 
                {
                	 cumPayments = mapRVRevenue.get(rvaid);
                	 system.debug('*** rollup ' +cumPayments);
                	 rollupCommAmt =  rva.Commission__c *cumPayments/100;
                }
                 else {
                 	cumPayments = 0.00;
                 	rollupCommAmt =  0.00;
                }
 				                

// create or update monthly summary record
				Partner_Commission__c summary ;
				if (lstCurrSum.get(rva.Id) == null)
  				{
  					 summary = new Partner_Commission__c(Name = currYearMon, 
														RVAccount__c = rva.Id,
														RecordTypeId = SummaryRecordTypeId
														);
					existing = false;								
  				}
  				else
  				{
  					 summary = lstCurrSum.get(rva.Id);
  					 existing = true;
  				}
				summary.Monthly_Client_Revenue__c = cumPayments;
				summary.Batch_Date__c = Date.Today();
				summary.Summary_YearMonth__c = intcurryearmon;
				if (mapRVCount.get(rvaid) <> null) summary.Count_of_Records__c = mapRVCount.get(rvaid);
				
// rolup commision - add from prev month record if it exists
				if (lstPrevSum.get(rva.Id) <> null)
				{
					rollupCommAmt = rollupCommAmt + lstPrevSum.get(rva.Id).Rollup_Commission__c ;
				}
// if commission is > 100 put it nthe commision amount otherwise store it in the rollup commision				
				if (rollupCommAmt> 100.00 && rva.PaymentNotActivated__c == false)
				{
					summary.Commission_Amount__c = rollupCommAmt;
					summary.Rollup_Commission__c  = 0.00;
				}
				else
				{
					summary.Commission_Amount__c =0.00;
					summary.Rollup_Commission__c = rollupCommAmt;
				}
				
				summary.Commission_Percent__c = rva.Commission__c ;
				if (!existing) 
					lstSumComs.add(summary );         	
            	else
            		{lstUpdSumComs.add(summary );  }
            	rva.Commission_Amount__c = summary.Commission_Amount__c.setScale(2);
            	rva.RollupCommission__c = summary.Rollup_Commission__c.setScale(2);
				if (rva.Commission_Amount__c > 0)
				{rva.Commission_Payment_Status__c = 'In Progress';}
            	updRVA.add(rva);
            }
            
            if (!lstSumComs.isEmpty()) insert lstSumComs;
            if (!lstUpdSumComs.isEmpty()) update lstUpdSumComs;
            
            update updRVA;
            
        }

    }

    global void finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'maggie.frederick@bigcommerce.com'});
        //mail.setReplyTo('batch@acme.com');
        //mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
 
}