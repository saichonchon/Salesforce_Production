public without sharing class PartnerHome 
{    
    public boolean InvalidUser
    {
        get;
        set;
    }
    
    public PartnerHome()
    {
        system.debug('***PartnerHome: begin');
        
        ClientStores_Load(null);
        ActiveTrials_Load(null);
    }
    
    public pageReference PartnerStart()
    {   	
        // Validate the current Partner Account has signed off on the T&A
        if (!PartnerPortalHelper.HasPartnerAcceptedCurrentTerms())
        {   
        	system.debug('***PartnerHome:PartnerStart - Partner Has Accepted Terms');     	
            // Ensure this is a valid user
            if (PartnerPortalHelper.PartnerAccount != null)
            {
                InvalidUser = false;
                pageReference pr = Page.TermsConditions;
                pr.getParameters().put('id', PartnerPortalHelper.PartnerPortalTC.Id);
                pr.getParameters().put('partId', PartnerPortalHelper.PartnerAccount.Id);
                
                return pr;
                //return null;
            }
            else
            {
                InvalidUser = true;
            }
        }
        else
        {
        	system.debug('***PartnerHome:PartnerStart - Partner Account: ' + PartnerPortalHelper.PartnerAccount);
            // Ensure this is a valid user
            if (PartnerPortalHelper.PartnerAccount != null)
            {
                InvalidUser = false;    
            }
            else
            {
                InvalidUser = true;
            }
        }
        
        return null;
    }

    public decimal PurchasedStoresCount_Total {get; set;}
    
    public decimal PurchasedStoresMRR_Total {get; set;}
    
    public decimal PurchasedStoresMRR_Avg 
    {
        get
        {
            if (PurchasedStoresMRR_Total == null || PurchasedStoresCount_Total == null || PurchasedStoresCount_Total == 0)
            {
                return 0;
            }
            else
            {
                return PurchasedStoresMRR_Total / PurchasedStoresCount_Total;
            }
        }
    }
        
    public list<SubByProduct> PurchasedStoresByProduct
    {
        get
        {
            system.debug('***PurchasedStoresByProduct: begin');
            SubByProduct clsSub;
            list<SubByProduct> lstSub = new list<SubByProduct>();

            PurchasedStoresMRR_Total = 0;
            PurchasedStoresCount_Total = 0;
            
            for (AggregateResult ar : [SELECT Product__c prod, Count(Id) Num, SUM(MonthlyRecurringRevenue__c) SumMRR
                                        FROM Subscription__c 
                                        //WHERE MBAPartnerID__c = :String.valueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c)
                                        WHERE Channel_Partner__c = :String.valueOf(PartnerPortalHelper.PartnerAccount.Id)
                                        	AND IsTrial__c = false
                                            AND Status__c = 'Active'
                                            AND ProductType__c IN ('Store', null, '')
                                        GROUP BY Product__c])
            {
                clsSub = new SubByProduct();
                clsSub.ProdName = string.valueOf(ar.get('Prod'));
                clsSub.Count_Store = integer.valueOf(ar.get('Num'));
                clsSub.MRR = (ar.get('SumMRR') == null ? 0 : (decimal)(ar.get('SumMRR')));
                
                lstSub.add(clsSub);
                
                PurchasedStoresCount_Total = PurchasedStoresCount_Total + integer.valueOf(ar.get('Num'));
                PurchasedStoresMRR_Total = PurchasedStoresMRR_Total + (ar.get('SumMRR') == null ? 0 : (decimal)(ar.get('SumMRR')));
            }                                       
            
            return lstSub;
        }
    }
    
    public list<SubByMonth> SubsByMonth
    {
        get
        {
            system.debug('***SubsByMonth: begin');
            SubByMonth clsSub;          
            map<string, SubByMonth> mpMonthToSub = new map<string, SubByMonth>();
            integer lastMonthOrder = 0;
            
            string strMonth = '';
            
            // Figure out what month was 5 months ago (So 6 months will show because it will include the current month)
            Date dtPast = Date.today().toStartOfMonth().addMonths(-5);
            
            // Now build the initial list with 0 for the count for the last 6 months
            for (integer x = 0; x < 6; x++)
            {
                strMonth = SObjectUtils.MonthNameFromVal(dtPast.addMonths(x).Month());
                system.debug('***Month being added: ' + strMonth);
                
                clsSub = new SubByMonth();
                clsSub.MonthName = strMonth;
                clsSub.Count_Store = 0;
                clsSub.Count_Trial = 0;
                clsSub.MonthOrder = x;
                lastMonthOrder = x;
                
                mpMonthToSub.put(strMonth, clsSub);
            }
            
            system.debug('***Months to SubByMonth Map - Initiated: ' + mpMonthToSub);

            for (AggregateResult ar : [SELECT Start_Month__c, Start_Year_Month__c, isTrial__c, COUNT(Id) subs 
										FROM Subscription__c  
										//WHERE MBAPartnerID__c = :String.valueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c)
										WHERE Channel_Partner__c = :String.valueOf(PartnerPortalHelper.PartnerAccount.Id)																
											AND StartDate__c >= LAST_N_MONTHS:5 
											AND ProductType__c IN ('Store', null, '') 
										GROUP BY Start_Month__c, Start_Year_Month__c, isTrial__c
										ORDER BY Start_Year_Month__c])
            { 
                strMonth = (string)ar.get('Start_Month__c');                
                
                if (mpMonthToSub.containsKey(strMonth))
                {
                    clsSub = mpMonthToSub.get(strMonth);
                }
                else
                {
                    lastMonthOrder++;
                    clsSub = new SubByMonth();
                    clsSub.MonthName = strMonth;
                    clsSub.MonthOrder = lastMonthOrder;                 
                }
                
                if ((boolean)ar.get('isTrial__c'))
                {
                    clsSub.Count_Trial = (integer)ar.get('subs');
                }
                else
                {
                    clsSub.Count_Store = (integer)ar.get('subs');
                }
                
                mpMonthToSub.put(strMonth, clsSub);
            }
            
            system.debug('***Months to SubByMonth Map - Final: ' + mpMonthToSub);
            
            list<SubByMonth> lstSub = new SubByMonth[mpMonthToSub.size()];
            
            // Now sort the list in proper month order          
            for (SubByMonth s : mpMonthToSub.values())
            {
                lstSub.set(s.MonthOrder, s);
            }
            
            system.debug('***Final List of Subs: ' + lstSub);
            
            return lstSub;
        }
    }
    
    //------------------------------------------------------------------------------------
    // Client Stores Properties and Methods - START
    //------------------------------------------------------------------------------------
    public ApexPages.StandardSetController conClientStores{get; set;}
    
    public void ClientStores_Load(string strOrderByFields)
    {
        system.debug('***ClientStores_Load: begin');
        string strSOQL = 'SELECT Id, Account__r.Name, StoreURL__c, Status__c, Product__c, MonthlyRecurringRevenue__c, CreatedDate, PurchaseDate__c ' +
                        ' FROM Subscription__c ' +
                        //' WHERE MBAPartnerID__c = \'' + String.valueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c) + '\'' +
                        ' WHERE Channel_Partner__c = \'' + String.valueOf(PartnerPortalHelper.PartnerAccount.Id) + '\'' +
                        '   AND IsTrial__c = false ' +
                        '   AND ProductType__c IN (\'Store\', null, \'\') ' +
                        ' ORDER BY ';
                        
        string strLimit = ' LIMIT 500';
        
        if (strOrderByFields == null || strOrderByFields == '') 
        {
            strOrderByFields = ' PurchaseDate__c DESC ';
            ClientStores_SortedBy = 'PurchaseDate';
            ClientStores_SortDir = 'DESC';
        }       
                        
        conClientStores = new ApexPages.StandardSetController(Database.getQueryLocator(strSOQL + strOrderByFields + strLimit));     
        
        setClientStores_PageSize(getClientStores_PageSize()); 
    }
    
    public list<Subscription__c> ClientStores
    {
        get
        {
            system.debug('***ClientStores: begin');         
            if(conClientStores == null)  
            {
                ClientStores_Load(null);
            }
            
            return (list<Subscription__c>)conClientStores.getRecords();
        }
    }
    
    public string ClientStores_PageSize;
    
    public string getClientStores_PageSize()
    {
            if (ClientStores_PageSize != null)
                return ClientStores_PageSize;
            else
                return '25';
    }

    public void setClientStores_PageSize(string value)
    {
        ClientStores_PageSize = value;
        conClientStores.setPageSize(integer.valueOf(value));    
    }
    
    public list<selectOption> ClientStores_PageNumber_All
    {
        get
        {
            system.debug('***ClientStores_PageNumber_All: begin');
            list<selectOption> options = new list<selectOption>();
                        
            if (conClientStores != null && conClientStores.getResultSize() > 0)
            {
                for (integer x = 1; x <= ClientStores_PageNumber_Total; x++)
                {
                    options.add(new selectOption(string.valueOf(x), string.valueOf(x)));
                }
            }
            else
            {
                options.add(new selectOption('0', '0'));
            } 
               
            return options;
        }
    }
    
    public Integer ClientStores_PageNumber_Total  
    {  
        get  
        {  
            system.debug('***ClientStores_PageNumber_Total: begin');
            if (conClientStores != null && conClientStores.getResultSize() > 0)
            {
                integer retVal = conClientStores.getResultSize() / conClientStores.getPageSize();
                if (Math.mod(conClientStores.getResultSize(), conClientStores.getPageSize()) > 0)
                    return retVal + 1;
                else
                    return retVal;
            }
            else 
                return 0;   
        }  
        set;  
    }
    
    public string ClientStores_PageNumber_Cur
    {
        get  
        {  
            if (conClientStores != null && conClientStores.getResultSize() > 0)
            {
                return string.valueOf(conClientStores.getPageNumber());
            }
            else
            {
                return '0';
            }  
        }  
        set
        {
            conClientStores.setPageNumber(integer.valueOf(value));
        }
    }  
    
    public integer ClientStores_TotalRecords
    {
        get
        {
            if (conClientStores != null)
            {
                return conClientStores.getResultSize();
            }
            else
            {
                return 0;
            }
        }
    }
    
    //Boolean to check if there are more records after the present displaying records  
    public Boolean ClientStores_HasNext  
    {  
        get  
        {  
            if (conClientStores != null)
            {
                return conClientStores.getHasNext();
            }
            else
            {
                return false;
            }  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean ClientStores_HasPrevious 
    {  
        get  
        {  
            if (conClientStores != null)
            {
                return conClientStores.getHasPrevious();
            }
            else
            {
                return false;
            }  
        }  
        set;  
    }  
    
    //Returns the previous page of records  
    public void ClientStores_Previous()  
    {  
        conClientStores.previous();  
    }  
   
    //Returns the next page of records  
    public void ClientStores_Next()  
    {  
        conClientStores.next();  
    }
    
    //Returns the previous page of records  
    public void ClientStores_First()  
    {  
        conClientStores.first();  
    }  
   
    //Returns the next page of records  
    public void ClientStores_Last()  
    {  
        conClientStores.last();  
    }
    
    public string ClientStores_SortedBy {get; set;}
    public string ClientStores_SortDir {get; set;}
    
    public void ClientStores_Sort()
    {
        string strSortBy = ApexPages.currentPage().getParameters().get('CSsrtBy');
        string strCol = 'PurchaseDate';
        string strDir = 'DESC';
        
        // Check if the new column for sorting matches the one already chosen
        if (strSortBy == ClientStores_SortedBy)
        {
            // Since this is for a column already selected, figure out which direction it is changing to
            if (ClientStores_SortDir == 'ASC')
            {
                strDir = 'DESC';
            }
            else
            {
                strDir = 'ASC';
            }
        }  
        
        // For security, check which column is being sorted and then set it instead of just copying the parameter
        if (strSortBy == 'AccountName')
        {
            strCol = 'Account__r.Name';
        }
        else if (strSortBy == 'URL')
        {
            strCol = 'StoreURL__c';
        }
        else if (strSortBy == 'Status')
        {
            strCol = 'Status__c';
        }
        else if (strSortBy == 'Plan')
        {
            strCol = 'Product__c';
        }
        else if (strSortBy == 'Bill')
        {
            strCol = 'MonthlyRecurringRevenue__c';
        }
        else
        {
            strSortBy = 'PurchaseDate';
            strCol = 'PurchaseDate__c';
        }
        
        ClientStores_SortedBy = strSortBy;
        ClientStores_SortDir = strDir;
        
        ClientStores_Load(strCol + ' ' + strDir);
    }
    //------------------------------------------------------------------------------------
    // Client Stores Properties and Methods - END
    //------------------------------------------------------------------------------------
    
    
    //------------------------------------------------------------------------------------
    // Active Trials Properties and Methods - START
    //------------------------------------------------------------------------------------
    public ApexPages.StandardSetController conActiveTrials{get; set;}
    
    public void ActiveTrials_Load(string strOrderByFields)
    {
        system.debug('***ActiveTrials_Load: begin');
        string strSOQL = 'SELECT Id, Lead__r.Name, Account__r.Name, Account_Name__c, StoreURL__c, Status__c, Product__c, CreatedDate, ExpirationDate__c, Phone__c, Email__c, Day_of_Trial__c, Trial_Days_Remaining__c ' +
                        ' FROM Subscription__c ' +
                        //' WHERE MBAPartnerID__c = \'' + String.valueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c) + '\'' +
                        ' WHERE Channel_Partner__c = \'' + String.valueOf(PartnerPortalHelper.PartnerAccount.Id) + '\'' +
                        '   AND IsTrial__c = true ' +
                        '   AND ProductType__c IN (\'Store\', null, \'\') ' +
                        '   AND Status__c = \'Active\' ' +
                        ' ORDER BY ';
                        
        string strLimit = ' LIMIT 500';
        
        if (strOrderByFields == null || strOrderByFields == '') 
        {
            strOrderByFields = ' ExpirationDate__c DESC ';
            ActiveTrials_SortedBy = 'Expiration';
            ActiveTrials_SortDir = 'DESC';
        }       
                        
        conActiveTrials = new ApexPages.StandardSetController(Database.getQueryLocator(strSOQL + strOrderByFields + strLimit));     
        
        setActiveTrials_PageSize(getActiveTrials_PageSize());
    }
    
    public list<Subscription__c> ActiveTrials
    {
        get
        {
            system.debug('***ActiveTrials: begin');         
            if(conActiveTrials == null)  
            {
                ActiveTrials_Load(null);
            }
            
            return (list<Subscription__c>)conActiveTrials.getRecords();
        }
    }
    
    public string ActiveTrials_PageSize;
    
    public string getActiveTrials_PageSize()
    {
            if (ActiveTrials_PageSize != null)
                return ActiveTrials_PageSize;
            else
                return '25';
    }

    public void setActiveTrials_PageSize(string value)
    {
        ActiveTrials_PageSize = value;
        conActiveTrials.setPageSize(integer.valueOf(value));    
    }
    
    public list<selectOption> ActiveTrials_PageNumber_All
    {
        get
        {
            system.debug('***ActiveTrials_PageNumber_All: begin');
            list<selectOption> options = new list<selectOption>();
                        
            if (conActiveTrials != null && conActiveTrials.getResultSize() > 0)
            {
                for (integer x = 1; x <= ActiveTrials_PageNumber_Total; x++)
                {
                    options.add(new selectOption(string.valueOf(x), string.valueOf(x)));
                }
            }
            else
            {
                options.add(new selectOption('0', '0'));
            } 
               
            return options;
        }
    }
    
    public Integer ActiveTrials_PageNumber_Total  
    {  
        get  
        {  
            system.debug('***ActiveTrials_PageNumber_Total: begin');
            if (conActiveTrials != null && conActiveTrials.getResultSize() > 0)
            {
                integer retVal = conActiveTrials.getResultSize() / conActiveTrials.getPageSize();
                if (Math.mod(conActiveTrials.getResultSize(), conActiveTrials.getPageSize()) > 0)
                    return retVal + 1;
                else
                    return retVal;
            }
            else 
                return 0;   
        }  
        set;  
    }
        
    public string ActiveTrials_PageNumber_Cur  
    {
        get  
        {  
            if (conActiveTrials != null && conActiveTrials.getResultSize() > 0)
            {
                return string.valueOf(conActiveTrials.getPageNumber());
            }
            else
            {
                return '0';
            }  
        }  
        set
        {
        	conActiveTrials.setPageNumber(integer.valueOf(value));
        }     
    }
  
    public integer ActiveTrials_TotalRecords
    {
        get
        {
            if (conActiveTrials != null)
            {
                return conActiveTrials.getResultSize();
            }
            else
            {
                return 0;
            }
        }
    }
    
    //Boolean to check if there are more records after the present displaying records  
    public Boolean ActiveTrials_HasNext  
    {  
        get  
        {  
            if (conActiveTrials != null)
            {
                return conActiveTrials.getHasNext();
            }
            else
            {
                return false;
            }  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean ActiveTrials_HasPrevious 
    {  
        get  
        {  
            if (conActiveTrials != null)
            {
                return conActiveTrials.getHasPrevious();
            }
            else
            {
                return false;
            }  
        }  
        set;  
    }  
    
    //Returns the previous page of records  
    public void ActiveTrials_Previous()  
    {  
        conActiveTrials.previous();  
    }  
   
    //Returns the next page of records  
    public void ActiveTrials_Next()  
    {  
        conActiveTrials.next();  
    }
    
    //Returns the previous page of records  
    public void ActiveTrials_First()  
    {  
        conActiveTrials.first();  
    }  
   
    //Returns the next page of records  
    public void ActiveTrials_Last()  
    {  
        conActiveTrials.last();  
    }
    
    public string ActiveTrials_SortedBy {get; set;}
    public string ActiveTrials_SortDir {get; set;}
    
    public void ActiveTrials_Sort()
    {
        string strSortBy = ApexPages.currentPage().getParameters().get('ATsrtBy');
        string strCol = 'ExpirationDate__c';
        string strDir = 'ASC';
        
        // Check if the new column for sorting matches the one already chosen
        if (strSortBy == ActiveTrials_SortedBy)
        {
            // Since this is for a column already selected, figure out which direction it is changing to
            if (ActiveTrials_SortDir == 'ASC')
            {
                strDir = 'DESC';
            }
            else
            {
                strDir = 'ASC';
            }
        }  
        
        // For security, check which column is being sorted and then set it instead of just copying the parameter
        if (strSortBy == 'Name')
        {
            strCol = 'Account_Name__c';
        }
        else if (strSortBy == 'URL')
        {
            strCol = 'StoreURL__c';
        }
        else if (strSortBy == 'Phone')
        {
            strCol = 'Phone__c';
        }
        else if (strSortBy == 'Email')
        {
            strCol = 'Email__c';
        }
        else if (strSortBy == 'DayofTrial')
        {
            strCol = 'Day_of_Trial__c';
        } 
        else if (strSortBy == 'DaysRemaining')
        {
            strCol = 'Trial_Days_Remaining__c';
        }       
        else
        {
            strSortBy = 'Expiration';
            strCol = 'ExpirationDate__c';
        }
        
        ActiveTrials_SortedBy = strSortBy;
        ActiveTrials_SortDir = strDir;
        
        ActiveTrials_Load(strCol + ' ' + strDir);
    }
    //------------------------------------------------------------------------------------
    // Active Trials Properties and Methods - END
    //------------------------------------------------------------------------------------
    
    public class SubByMonth
    {
        public string MonthName {get; set;}
        public integer Count_Store {get; set;}
        public integer Count_Trial {get; set;}
        public integer MonthOrder {get; set;}
        
        public SubByMonth ()
        {
            Count_Store = 0;
            Count_Trial = 0;
        }
    }
    
    public class SubByProduct
    {
        public string ProdName {get; set;}
        public integer Count_Store {get; set;}
        public decimal MRR {get; set;}
        
        public SubByProduct ()
        {
            Count_Store = 0;
            MRR = 0;
        }
    }
}