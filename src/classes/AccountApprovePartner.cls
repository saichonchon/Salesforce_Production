public with sharing class AccountApprovePartner {
    public Account account { get; set; }
    public Boolean hasContact {get; set;}
    public Contact partnerContact {get; set;}
    public Boolean partnerApproved { get; set; }
    public Boolean isPartner { get; set; }
    public integer page { get; set; }
    
    public AccountApprovePartner(ApexPages.StandardController controller) {
        // TODO: Not this
        Account controllerAccount = (Account) controller.getRecord();
        account = [SELECT Id, Name, Type, iDev_Partner_ID__c, Partner_iDevID__c, RecordTypeId, Website, Phone, Fax, OwnerID, Status__c,
            BillingStreet, BillingState, BillingPostalCode, BillingCity, BillingCountry
            FROM Account WHERE Id = :controllerAccount.Id LIMIT 1];
            
        list<Contact> contacts = [SELECT Email, FirstName, LastName FROM Contact WHERE AccountId = :account.Id LIMIT 1];
        if (contacts.size() != 1) {
            hasContact = false;
        }
        else {
            hasContact = true;
            partnerContact = contacts.get(0);
        }
        
        partnerApproved = !(account.iDev_Partner_ID__c == NULL || account.iDev_Partner_ID__c == 0);
        isPartner = (account.RecordTypeId == BCSettings.partnerRecordTypeId);
        page = 1;
            
        // Default the iDev account to the name with spaces removed.
        // TODO: Check in the iDev side as to whether there's a way to check this without submitting.
        if (!partnerApproved) {
            account.Partner_iDevID__c = account.Name.replaceAll('[\\W]', '');

            if (account.Partner_iDevID__c.length() > 12) {
                account.Partner_iDevID__c = account.Partner_iDevID__c.substring(0, 11);
            }
        }
    }
    
    public pageReference ApprovePartner() {

        String URL = 'https://techpartners.bigcommerce.com/API/scripts/newAffiliate.php';       
        
        // Get everything together and formulate the request to iDev
        String body = 'secret=' + Label.iDev_Parameter + '&approved=1&payout_type=1&payout_level=5&use_paypal=1';
        
        if (account.Partner_iDevID__c != NULL)
            body += '&username='+EncodingUtil.urlEncode(account.Partner_iDevID__c, 'UTF-8');
        if (partnerContact.Email != NULL)
            body += '&email='+EncodingUtil.urlEncode(partnerContact.Email, 'UTF-8');
        if (partnerContact.FirstName != NULL)
            body += '&first_name='+EncodingUtil.urlEncode(partnerContact.FirstName, 'UTF-8');
        if (partnerContact.LastName != NULL)
            body += '&last_name='+EncodingUtil.urlEncode(partnerContact.LastName, 'UTF-8');
        if (account.Name != NULL)
            body += '&company='+EncodingUtil.urlEncode(account.Name, 'UTF-8');
        if (account.Website != NULL)
            body += '&website='+EncodingUtil.urlEncode(account.Website, 'UTF-8');
        if (account.Phone != NULL)
            body += '&phone='+EncodingUtil.urlEncode(account.Phone, 'UTF-8');
        if (account.Fax != NULL)
            body += '&fax='+EncodingUtil.urlEncode(account.Fax, 'UTF-8');
        if (account.BillingStreet != NULL)
            body += '&address_1='+EncodingUtil.urlEncode(account.BillingStreet, 'UTF-8');
        if (account.BillingCity != NULL)
            body += '&city='+EncodingUtil.urlEncode(account.BillingCity, 'UTF-8');
        if (account.BillingState != NULL)
            body += '&state='+EncodingUtil.urlEncode(account.BillingState, 'UTF-8');
        if (account.BillingPostalCode != NULL)
            body += '&zip='+EncodingUtil.urlEncode(account.BillingPostalCode, 'UTF-8');
        if (account.BillingCountry != NULL)
            body += '&country='+EncodingUtil.urlEncode(account.BillingCountry, 'UTF-8');
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        try {
            req.setMethod('POST');
            req.setEndPoint(URL);
            req.setBody(body);
            
            try {
                
                // tests can't call external services... 
                if (Test.isRunningTest()) {
                    res = fakeResponse(account.Partner_iDevID__c);
                }
                else {
                    res = http.send(req);
                }
            } catch(System.CalloutException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Ummmm... Something went very wrong. Raise a ticket for the Internal Development team they\'ll fix it for you because they\'re nice.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Tell them this: line '+ e.getLineNumber() + ' - ' + e.getMessage()));
            }
            
            // Check the response
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode response = doc.getRootElement();
            String status = response.getChildElement('status', null).getText();
            
            // - Did everything work
            if (status == 'error') {
                // Check what the errors are and show them.
                String message = response.getChildElement('message', null).getText();
                account.addError(message);
            }
            else if (status == 'success') {
                // SAVE!!
                String affiliateId = response.getChildElement('id', null).getText();
                String username = response.getChildElement('username', null).getText();
                String message = response.getChildElement('message', null).getText();
                
                // Note: iDev_Partner_ID__c is the iDev ID, Partner_iDevID__c is the
                // iDev Username...
                account.iDev_Partner_ID__c = integer.ValueOf(affiliateId);
                account.Partner_iDevID__c = username;
                account.Status__c = 'Onboarding';
                account.Partner_Approved_Date__c = Date.today();
                partnerApproved = true;
                update account;
                
                if (message != 'The affiliate account was created successfully') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message));
                }
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'An iDev account has been created for this partner. Their username is "' + username + '"'));
            }
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Ummmm... Something went very wrong. Raise a ticket for the Internal Development team they\'ll fix it for you because they\'re nice.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Tell them this: line '+ e.getLineNumber() + ' - ' + e.getMessage()));
        }
        return ApexPages.currentPage();
    }
    
    public pageReference openApprovalWindow() {
        return ApexPages.currentPage();
    }
    
    public static HttpResponse fakeResponse(String username) {
        HttpResponse res = new HttpResponse();
        if (username == 'mitch') {
            res.setBody('<?xml version="1.0"?><response><status>error</status><message>- Username is taken.</message></response>');
        }
        else {
            res.setBody('<?xml version="1.0"?><response><status>success</status><id>999999999</id><username>ToBeApproved</username><message>The affiliate account was created successfully</message></response>');
        }
        return res;
    }
    
}