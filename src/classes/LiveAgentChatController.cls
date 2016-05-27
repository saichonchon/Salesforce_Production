public class LiveAgentChatController {
    
    public Contact theContact {get; set;}
    public Subscription__c theSub {get; set;}
    public String endpoint {get; set;}
    public String csse {get; set;}
    public String jsSubmitForm {get; set;}
    public String liveChatBtnId{get; set;}    
    public String liveChatDepId{get; set;}
    public String formPIN{get; set;}
    public String formURL{get; set;}
    public String formURLqry{get; set;}
    public String formEmail{get; set;}
    public String formFname{get; set;}
    public String formLname{get; set;}
    public String tempURL { get; set; }
    public Boolean chatPanelOn{get; set;}
    public Id subId{get; set;}
    public Id AcctId{get; set;}
    public Id AcctOwn{get; set;}
        
    public LiveAgentChatController(){

        jsSubmitForm = '';
        theContact = new Contact();
        theSub = new Subscription__c();
        chatPanelOn = False;

        //get the querystring data passed in by the button.  This is the liveagent form action
        //EX: ?endpoint=https%3A%2F%2F1.la1a1.salesforceliveagent.com... etc..
        endpoint = '';
        csse = '';
        PageReference pageRef = ApexPages.currentPage();
        if (pageRef.getParameters() != null) {
            if (pageRef.getParameters().containsKey('endpoint')) {
                if (pageRef.getParameters().get('endpoint') != null) {
                    endpoint = pageRef.getParameters().get('endpoint');
                }
            }           
        }       

        if (pageRef.getParameters() != null) {
            if (pageRef.getParameters().containsKey('SupportSetting')) {
                if (pageRef.getParameters().get('SupportSetting') != null) {
                    csse = pageRef.getParameters().get('SupportSetting');
                }
            }
        }
        // Get the csse (Case Submission Setting entry from the VF page)
        system.debug('SupportSetting Parameter from VF page: '+csse);
        // TODO: API 29 supports pre-Chat API which will allow passing of parameters, until then hardcode Custom Setting
        CaseSubmissionSettings__c css = CaseSubmissionSettings__c.getValues('LiveAgent');
        system.debug('css Setting value: '+css);


        LiveChatButton lCBId = [SELECT Id FROM LiveChatButton WHERE DeveloperName =: css.LiveAgent_Button_Name__c];
        
        Datetime tempDate = datetime.newInstance(0000, 00, 0, 00, 00, 0);
        String latestId;
                
        List<LiveChatDeployment> lDIds = [SELECT Id, CreatedDate FROM LiveChatDeployment];
        
        for (LiveChatDeployment d : lDids){
            if (d.CreatedDate > tempDate){
                latestId = d.Id;
            }    
        }
        liveChatBtnId = String.valueOf(lCBId.id); 
        liveChatDepId = latestId;
        system.debug('***** Chat Button ID: '+liveChatBtnId);
        system.debug('***** Chat Deploy ID: '+liveChatDepId);

    }

    public pagereference clickChat() {      
        PageReference pr = null;        

        // Get the csse (Case Submission Setting entry from the VF page)
        //String csse = ApexPages.currentPage().getParameters().get('csse');
        system.debug('csse Parameter from VF page: '+csse);
        CaseSubmissionSettings__c css = CaseSubmissionSettings__c.getValues('LiveAgent');
        
        if ( AcctId == null ){
            Id AcctId = css.Default_Support_Account_ID__c; //ID for the Account to parent these Contacts
        }
        Id OwnId = css.Default_Support_Owner_ID__c; //ID for a default user to set as the owner of the Contact 

        system.debug('***** clickChat fields: ' + endpoint + ', ' + AcctId + ', ' + OwnId + ', ' + formPIN + ', ' + 
                                                formURL + ', ' + formEmail + ', ' + formFname + ', ' + formLname);

        //see if the email submitted exists as a contact
        List<Contact> contactList = new List<Contact>();
        if ( (formEmail != null) && (formEmail != '') ) {
            contactList = [SELECT Id FROM Contact WHERE email=:formEmail LIMIT 1];
            system.debug('***** Contact List: '+contactList);
            if (contactList.isEmpty()) {
                if(formLname == null){
                	formLname = formFname;
                }
                //create the contact
                Contact c = new Contact(
                    FirstName = formFname,
                    LastName = formLname,
                    Email = formEmail,
                    LeadSource = 'Chat',
                    AccountId = AcctId,
                    OwnerId = AcctOwn);
                insert c;
            }   
        }  

        jsSubmitForm = 'jQuery(\'#preChatFormSubmit\').submit();';
        
        return pr;      
    }

    public Id validatePIN(){
        List<Subscription__c> subList = new List<Subscription__c>();
        String PINArticleURL = '<a href=\"https://support.bigcommerce.com/questions/1207/What+is+my+support+PIN+and+where+do+I+find+it%3F\">What is my support PIN</a>';
        tempURL = '';
        
        // TODO: parse/trim Store URL to remove http:// or https://
        if(formURL.startsWith('http://')) {
            formURL = formURL.removeStart('http://');
        }
        
        if(formURL.startsWith('https://')) {
            formURL = formURL.removeStart('https://');
        }
        
        if(formURL.endsWith('/')){
        	formURL = formURL.removeEnd('/');
        }
        
        if(formURL.startsWith('www.')) {
        	formURL = formURL.removeStart('www.');
        }
        
        formURLqry = '%'+formURL+'%';
        
        try{
            subList = [SELECT Id, Account__r.Id, Account__r.OwnerId, Support_PIN__c, StoreURL__c FROM Subscription__c
                    WHERE Support_PIN__c =: formPIN AND StoreURL__c LIKE :formURLqry
                    AND Status__c = 'Active' LIMIT 1];
        } catch (ListException le){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Support URL/PIN combination provided cannot be verified. Please confirm with Account owner and try again. If you continue to experience difficulty please refer to this article - '+PINArticleURL);
            ApexPages.addMessage(msg);
        } catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Support URL/PIN combination provided cannot be verified. Please confirm with Account owner and try again. If you continue to experience difficulty please refer to this article - '+PINArticleURL);
            ApexPages.addMessage(msg);
        }
        
        if(subList.size() > 0){
            chatPanelOn = True;
            subId = subList[0].Id;
            AcctId = subList[0].Account__r.Id;
            AcctOwn = subList[0].Account__r.OwnerId;
            clickChat();
        } else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Support URL/PIN combination provided cannot be verified. Please confirm with Account owner and try again. If you continue to experience difficulty please refer to this article - '+PINArticleURL);
            ApexPages.addMessage(msg);
        }
        return null;
    }

}