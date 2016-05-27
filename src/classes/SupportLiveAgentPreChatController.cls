public with sharing class SupportLiveAgentPreChatController {

    public Contact theContact {get; set;}
    public Subscription__c theSub {get; set;}
    public Opportunity theOpp {get; set;}
    public String endpoint {get; set;}
    public String csse {get; set;}
    public String jsSubmitForm {get; set;}
    public String liveChatBtnId{get; set;}    
    public String liveChatDepId{get; set;}
    public ValueAndError formPIN{get; set;}
    public ValueAndError formURL{get; set;}
    public String formURLqry{get; set;}
    public ValueAndError formEmail{get; set;}
    public ValueAndError formFname{get; set;}
    public ValueAndError formLname{get; set;}
    public ValueAndError formSubject { get; set; }
    public String tempURL { get; set; }
    public Boolean chatPanelOn{get; set;}
    public Id subId{get; set;}
    public Id AcctId{get; set;}
    public Id AcctOwn{get; set;}
    public Id oppId{get; set;}
    public Id conId{get; set;} 
 
    protected FormErrorHelper formErrorHelper { get; set; }
    public List<String> formErrorsList { get; set; }
        
    public SupportLiveAgentPreChatController(){

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

                    System.debug('LiveAgentChatController : endpoint ' + endpoint);
                }
            }           
        }       

        if (pageRef.getParameters() != null) {
            if (pageRef.getParameters().containsKey('SupportSetting')) {
                if (pageRef.getParameters().get('SupportSetting') != null) {
                    csse = pageRef.getParameters().get('SupportSetting');
                    System.debug('LiveAgentChatController : SupportSetting ' + csse);
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


        formFname = new ValueAndError();
        formLname = new ValueAndError();
        formEmail = new ValueAndError();
        formPIN = new ValueAndError();
        formURL = new ValueAndError();
        formSubject = new ValueAndError();
        formErrorHelper = new FormErrorHelper();
        formErrorsList = new List<String>();
        

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
                                                formURL + ', ' + formEmail + ', ' + formFname + ', ' + formLname + ', ' +formSubject);        

        jsSubmitForm = 'jQuery(\'#preChatFormSubmit\').submit();';
        
        return pr;      
    }

    public Id validatePIN(){
        List<Subscription__c> subList = new List<Subscription__c>();       
        
        Boolean fieldsEmpty = this.hasEmptyFields();

        System.debug('validatePIN : fieldsEmpty : ' + fieldsEmpty );

        if(fieldsEmpty){

            return null;
        }

        formURL.value = formURLFormatter(formURL.value);
        System.debug('validatePIN: formatted formURL: ' + formURL.value);
        String fullStoreUrl = 'http://' + formUrl.value;

        System.debug('here : formStoreUrl : ' + fullStoreUrl);
        System.debug('validatePIN : formURL.value ' + formURL.value);
        System.debug('validatePIN : formPIN.value ' + formPIN.value);
   
   // start change for Opportunity     
        Opportunity opp = new Opportunity();
        try{
             opp = DLUtility.getOppfromurlpin(formUrl.value,formPIN.value) ;
            } 
        catch (Exception e){
            formURL.error = 'There was a problem with the request...';
            formPIN.error = formURL.error;
            formErrorHelper.add(7, 'lets see 1 : ' +formURL.error);
            }        
        
        if(opp <> null){
            chatPanelOn = True;
            oppId = opp.Id;
            AcctId = opp.AccountId;
            subId = opp.Subscription__c;
            Contact newcon = new Contact();
            if (opp.Contact_Email__c == formEmail.Value) conId = opp.Contact__c;
            else 
            {
                newcon = DLUtility.findContactByEmailAcct(opp.AccountId, formEmail.value, formFname.Value, formLname.Value );
                if (newcon <> null && newcon.ID <> null ) conId = newcon.Id;
                else
                { 
                  newcon  = DLUtility.findPrimaryContactFromAcct(AcctId);
                    if (newcon <> null) conId = newcon.Id; 
                }
            }
            system.debug('*** AcctId '+AcctId);
//            AcctOwn = oppList[0].Account__r.OwnerId;
            clickChat();
        } else 
        
        {
            Subscription__c sub = new Subscription__c();
            try{
                 sub = DLUtility.getSubfromurlpin(formUrl.value,formPIN.value) ;
                            
                }  catch (Exception e){
                    formURL.error = 'There was a problem with the request...';
                    formPIN.error = formURL.error;
                    formErrorHelper.add(7, 'lets see 1 : ' +formURL.error);
                    
                    }
        
                if(sub.Id <> null){
                    chatPanelOn = True;
                    subId = sub.Id;
                    AcctId = sub.Account__c;
                    system.debug('*** AcctId '+AcctId);
//                  AcctOwn = sub.Account__r.OwnerId;
                    if (sub.Contact__r.Email == formEmail.Value) conId = sub.Contact__c;
                    else 
                    {
                        Contact newcon = DLUtility.findContactByEmailAcct(sub.Account__c, formEmail.value, formFname.Value, formLname.Value );
                        if (newcon <> null) conId = newcon.Id;
                    }
                    clickChat();
                } else {
                        formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
                        formPIN.error = formURL.error;
                        formErrorHelper.add(0, formURL.error);           
                        }
        }
        formErrorsList = formErrorHelper.allErrors();
        System.debug('validatePIN: formErrorsList:' + formErrorsList);
        return null;
    }

    /**
     * Formatter for the store url supplied by the user.
     */
    public String formURLFormatter(String url) 
    {
        url = url.trim();  //removes leading and trailing spaces as well as control and newline characters

        if(url.startsWith('http://')) {
            url = url.removeStart('http://');
        }

        if(url.startsWith('https://')) {
            url = url.removeStart('https://');
        }

        if(url.startsWith('www.')) {
            url = url.removeStart('www.');
        }

        if(url.contains('#')){
            url = url.substringBefore('#');  //removes any non-URL paths added to the Store URL string
        }

        if(url.contains('?')){
            url = url.substringBefore('?');  //removes any non-URL paths added to the Store URL string
        }

        if(url.contains('/')){
            url = url.substringBefore('/');  //removes any non-URL paths added to the Store URL string
        }

        return url;
    }

    /**
     * Check for empty fields 
     */

    public Boolean hasEmptyFields(){

        formErrorHelper.clear();

        System.debug('hasEmptyFields : ' + formFname.value);
        System.debug('hasEmptyFields : ' + formLname.value);
        System.debug('hasEmptyFields : ' + formEmail.value);
        System.debug('hasEmptyFields : ' + formSubject.value);
        System.debug('hasEmptyFields : ' + formURL.value);
        System.debug('hasEmptyFields : ' + formPIN.value);

        if(formFname.isEmpty()) {
            System.debug('hasEmptyFields: formFname is empty');
            formFname.error = 'Please enter your First Name within the field below.';
            formErrorHelper.add(5, formFname.error);            
        }else{
            formFname.error = '';
        }

        if(formLname.isEmpty()) {
            System.debug('hasEmptyFields: formLname is empty');
            formLname.error = 'Please enter your Last Name within the field below.';
            formErrorHelper.add(4, formLname.error);            
        }else{
            formLname.error = '';
        }

        if(formEmail.isEmpty()) {
            System.debug('hasEmptyFields: formEmail is empty');
            formEmail.error = 'Please enter your Email within the field below.';
            formErrorHelper.add(3, formEmail.error);            
        }else{
            formEmail.error = '';
        }

        if(formURL.isEmpty()) {
            System.debug('hasEmptyFields: formURL is empty');
            formURL.error = 'Please enter your Store URL within the field below.';
            formErrorHelper.add(2, formURL.error);            
        }else{
            formURL.error = '';
        }

        if(formPIN.isEmpty()) {
            System.debug('validatePIN: formPIN is empty');
            formPIN.error = 'Please enter your Support PIN within the field below.';
            formErrorHelper.add(1, formPIN.error);            
        }else{
            formPIN.error = '';
            formPIN.value = formPIN.value.trim();
        }
       
       if(formSubject.isEmpty()) {
            System.debug('hasEmptyFields: formSubject is empty');
            formPIN.error = 'Please enter Subject within the field below.';
            formErrorHelper.add(1, formSubject.error);            
        }else{
            formSubject.error = '';
            formSubject.value = formSubject.value.trim();
        }
        if(formFname.isEmpty() || formLname.isEmpty()|| formEmail.isEmpty()|| formURL.isEmpty() || formPIN.isEmpty() || formSubject.isEmpty()){
            System.debug('hasEmptyFields: url or pin empty, returning form for additional user input.');
            formErrorsList = formErrorHelper.allErrors();
            if(formErrorsList.size()>2){

                formErrorsList.clear();
                formErrorsList.add('Please provide information within the fields below.');
            }
            return true;
        }
        return false;
    }

    /**
     * Implements a data structure that allows a field/variable to hold a value and an error message.
     */
    public class ValueAndError
    {
        public String value {get; set;}

        public String error {get; set;}

        public Boolean getHasError()
        {
            return (!String.IsBlank(error));
        }

        public Boolean isEmpty()
        {
            return (String.IsEmpty(value));
        }
    }

    /**
     * Helper to manage adding/sorting error messages.
     */
    public class FormErrorHelper
    {
        public Map<Decimal, String> errorsMap { get; set; }
        public List<String> errorsList { get; set; }

        // We need to have unique error messages and the order of the error messages are important.
        // Without a LinkedHashSet in Apex, falling back to a map of key(position)/value(error message).
        // Call allErrors() to get a list of error messages ordered by its position; useful for sending to VF page
        // for rendering.

        // Use position 0 for a global message or when there might be other messages but there should be a
        // combined message displayed first. Otherwise, the position of the message should be the order of the input
        // on the front-end.
        public FormErrorHelper()
        {
            errorsMap = new Map<Decimal, String>();
            errorsList = new List<String>();
        }

        public void add(Decimal position, String message)
        {
            errorsMap.put(position, message);
        }
        
        public List<String> allErrors()
        {
            errorsList.clear();

            List<Decimal> keySetList = new List<Decimal>();
            keySetList.addAll(errorsMap.keySet());
            keySetList.sort();

            for(Decimal key : keySetList) {
                errorsList.add(errorsMap.get(key));
            }

            return errorsList;
        }

        public void clear()
        {
            errorsMap.clear();
            errorsList.clear();
        }
    }
}