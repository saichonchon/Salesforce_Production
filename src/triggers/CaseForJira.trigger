/**********************************************************************
 
Name:  CaseForJira
  
======================================================
 Purpose:                                                           
 
Before trigger to populate fields for Jira.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 9/1/2013  Initial development
 
***********************************************************************/
trigger CaseForJira on Case (before insert, before update) {

    date startDate = Date.Today();
      
    Id migRecordType =  Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Migration').getRecordTypeId();
    
    If (Trigger.isInsert && Trigger.isBefore)
    {
      for (Case newCase :Trigger.New)
     {
        if (newCase.RecordTypeId == migRecordType)
        {
        //  set default SF Target Completion Date 
      
             if (newCase.of_Products__c == '<500'|| newCase.of_Products__c == '501-10k' || newCase.of_Products__c ==  '10k - 30k')
              {
                newCase.Target_Completion_Date__c = DataUtility.AddBusinessDays(startDate,4);
              }
             else 
                if (newCase.of_Products__c == '30k - 50k' || newCase.of_Products__c ==  '50k - 75k')
                  {
                    newCase.Target_Completion_Date__c = DataUtility.AddBusinessDays(startDate,10);
                  }
             else 
                if (newCase.of_Products__c == '75k - 100k' || newCase.of_Products__c ==  '>100k')
                  {
                    newCase.Target_Completion_Date__c = DataUtility.AddBusinessDays(startDate,15);
                  }
                  
         }
      }
    }

    if (Trigger.isbefore)
    {
        String stringforJira = '';
       
        for (Case newCase :Trigger.New)
        {
    
         if (newCase.RecordTypeId == migRecordType)
         {
            /**
            * 12/23/2013: Kelly requested to only add http:// when is not added to the field
            *   this can be easily achieved with a validation rule but we need to first consult with our admin team
            *
            **/
            String currentStoreUrl = newCase.Current_Store_URL__c;            
            String currentAdminUrl = newCase.Current_Store_Admin_Panel_URL__c;

            if(currentStoreUrl != null && currentStoreUrl.contains('http://')){
                currentStoreUrl = currentStoreUrl;
            }else{
                currentStoreUrl = 'http://' + currentStoreUrl;
            }           
            if(currentAdminUrl != null && currentAdminUrl.contains('http://')){
                currentAdminUrl = currentAdminUrl;
            }else{
                currentAdminUrl = 'http://' + currentAdminUrl;
            }

         // concatenate the description field for Migration Cases 
             stringforJira = 'Subject: ' + newCase.Subject +'\n' + 'Case Number: ' + newCase.CaseNumber + '\n' + 'SFDC URL: ' + System.URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ newCase.Id + '\n' ;
             stringforJira = stringforJira + 'Migration Platform: ' + newCase.Migration_Platform__c  +'\n' + 'Sales team: ' + newCase.Sales_Team__c +'\n';
             stringforJira = stringforJira + 'Store Plan: ' + newCase.Bigcommerce_Plan__c +'\n' + 'Target Completion Date: ' + newCase.Target_Completion_Date__c.format() + '\n';
             stringforJira = stringforJira + '\n' + 'NOTES: '  +'\n' +'\n';
             stringforJira = stringforJira + newCase.Description +'\n' +'\n' ;
             stringforJira = stringforJira + '# of Products  : ' +newCase.of_Products__c +'\n' ;
             stringforJira = stringforJira + '# of Customers : ' +newCase.of_Customers__c +'\n' ;
             stringforJira = stringforJira + 'Use of Product Options : '+newCase.Use_of_Product_Options__c +'\n' ;
             stringforJira = stringforJira + 'Current Platform Customizations : ' +newCase.Current_Platform_Customizations__c +'\n' ;
             stringforJira = stringforJira + 'Crtitcal Needs :' +newCase.Dealbreakers__c +'\n' +'\n' ; 
             stringforJira = stringforJira + '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' +'\n';
             if (newCase.Migration_Partner__c == 'EIG' )stringforJira = stringforJira + 'EIG ID :' +newCase.EIG_ID__c +'\n';
             
             stringforJira = stringforJira + 'Current Store URL: ' + currentStoreUrl + '\n' + 'Current Store Admin URL: ' + currentAdminUrl +  '\n' + 'Current Store Admin ID: ' + newCase.Current_Store_Admin_ID__c  +'\n';
             stringforJira = stringforJira + 'Current Store Admin Pwd: ' + newCase.Current_Store_Admin_Password__c + '\n' + 'Current Store API / Security Key: ' + newCase.Current_Store_API_Key__c + '/' + newCase.Current_Store_API_Password__c  +'\n' +'\n';           
             stringforJira = stringforJira + 'FTP Host Name: ' + newCase.FTP_Host_Name__c +  '\n' + 'FTP Admin ID: ' + newCase.FTP_User_Name__c +  '\n' + + 'FTP Password: ' + newCase.FTP_Password__c +  '\n' +'\n';            
             stringforJira = stringforJira + 'BigCommerce Store URL: http://'+ newCase.Bigcommerce_Store_URL__c +'\n' + 'BigCommerce Temporary Store URL: http://' + newCase.Temporary_Store_URL__c + '\n' + 'BigCommerce Store User Name: ' + newCase.Bigcommerce_Store_User_Name__c  +'\n'  + 'BigCommerce Store User Password: ' + newCase.Bigcommerce_Store_Password__c +'\n' ;         
             stringforJira.replaceAll('null', '');
             
             if (newCase.Jira_Description__c == null || newCase.Jira_Description__c <> stringforJira) newCase.Jira_Description__c = stringforJira;        
        
        // set Completion Date to Verification Date only the first time.
        
             if (newCase.Status == 'Verification' && newCase.Status <> Trigger.oldMap.get(newCase.ID).Status)
                {
                    if (newCase.Verification_Date__c == null || newCase.Verification_Date__c == Date.Today())
                    newCase.Completion_Date__c = Date.Today();
                }
        //  If Status changes from Verification to In Progress, need to update Target completion Date status change date + 4 business days
           
               if (newCase.Status == 'In Progress' && Trigger.oldMap.get(newCase.ID).Status == 'Verification' )
                {
                    if (newCase.Verification_Date__c == null || newCase.Verification_Date__c == Date.Today())
                    newCase.Target_Completion_Date__c = DataUtility.AddBusinessDays(startDate,4);
                }
            }        
        } // end for loop
    }  
}