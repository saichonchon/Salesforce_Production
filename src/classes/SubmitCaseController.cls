/*
    TODO: Error messages should be constants, or at least defined outside the validate methods.
    TODO: Validate/update method/variable scopes (public/private/virtual, etc)

    Requirements needed to:
    TODO: Name validation
    TODO: Phone validation (?) Do we validate optional fields

	Change Log
	2/12/15 Maggie Frederick Add Web to Cancel Case submit.
	4/15/15 Maggie Frederick Add Subject to Case
*/
public class SubmitCaseController { 

    public static final long MAX_FILE_SIZE = 5242880;
    public static Set<String> allowedFileUploadTypes = new Set<String> {'csv','doc','txt','pdf','png','jpg','jpeg','gif','zip','xls','xlsx','docx','js','html','htm','css','crt','cer', 'xml'};
    public String allowedFileUploadTypesList { get; set; }
    public Case c { get; set; }
    public Contact ct { get; set; }
    public Lead ld { get; set; } 
    public Transient String fileName { get; set; }
    public Transient Blob fileAtt { get; set; }
    public String sPIN { get; set; }
    public String csse { get; set; }
    public String sURL { get; set; }
    public String tempURL { get; set; }
    public ValueAndError formPIN { get; set; }
    public ValueAndError formURL { get; set; }
    public String formURLqry { get; set; }
    public ValueAndError formEmail { get; set; }
    public ValueAndError formPhone { get; set; }
    public ValueAndError formFname { get; set; }
    public ValueAndError formLname { get; set; }
    public ValueAndError formDescription { get; set; }
    public ValueAndError formSubject { get; set; }
    public IdValueAndError formDeptId { get; set; }
    public String deptName {get; set; }
    public String caseNum { get; set; }
    public Id subId { get; set; }
    public Id AcctId { get; set; }
    public Id AcctOwn { get; set; }
    public Id ContId { get; set; }
    public Id subContId { get; set; }
    public Id LeadId { get; set; }
    public Id oppId { get; set; }
    public String ProductId { get; set; }
    public Boolean webFormOn { get; set; }
    protected FormErrorHelper formErrorHelper { get; set; }
    public List<String> formErrorsList { get; set; }
    public CaseSubmissionSettings__c css { get; set; }
    public transient Attachment  caseAtt {get;set;}
    public Boolean fileUploadHasErrors {get;set;}
    public Boolean fileUploadSizeError {get;set;}
    public Boolean fileUploadExtesionError {get;set;}
    public Boolean fileUploadValidation {get;set;}
    public String caseDescription {get; set; }
    public String caseSubject {get; set; }
    public Transient Integer fileSize {get;set;}

    public SubmitCaseController() 
    {
        // Build a list of the file types accepted via file upload. This is done dynamically because there are error messages that 
        // give this information back to the user.
       
        //caseAtt = new Attachment();         
        webFormOn = False;
        String csse = ApexPages.currentPage().getParameters().get('SupportSetting');

        // Form Step 1 Fields. Expose query string parameters that will validate users if they are provided.
        formURL = new ValueAndError();
        String requestedStoreUrl = ApexPages.currentPage().getParameters().get('storeUrl');
        Boolean prepopulatedFormUrl = prefillInput(formURL, requestedStoreUrl);

        formPIN = new ValueAndError();
        String requestedSupporPin = ApexPages.currentPage().getParameters().get('supportPin');
        Boolean prepopulatedFormPin = prefillInput(formPIN, requestedSupporPin);

        // If the store url/pin was provided, debug the values.
        if(!String.isEmpty(requestedStoreUrl) || !String.isEmpty(requestedSupporPin)) {
            System.debug('Prepopulated Form Url: ' + prepopulatedFormUrl + ', value: ' + requestedStoreUrl);
            System.debug('Prepopulated Form Pin: ' + prepopulatedFormPin + ', value: ' + requestedSupporPin);
        }
        if(!String.isEmpty(requestedStoreUrl) && !String.isEmpty(requestedSupporPin)) {
            FormUrl.value = requestedStoreUrl;
            FormPin.value = requestedSupporPin;
            
            }
        // Form Step 2 Fields
        formDescription = new ValueAndError();
        formSubject = new ValueAndError();
        formDeptId = new IdValueAndError();
        formFname = new ValueAndError();
        formLname = new ValueAndError();
        formPhone = new ValueAndError();
        formEmail = new ValueAndError();

        // formErrorHelper is used to ensure unique, ordered error messages. 
        // formErrorsList is the publicly available list of current error messages.
        formErrorHelper = new FormErrorHelper();
        formErrorsList = new List<String>();
        System.debug('Controller: SupportSetting: ' + csse);

        // If the store url and support pin are supplied as query string params,
        // validate the form before initial load. Show the authenication form with 
        // errors if they exist or step 2 if valid info provided.
        if(!formURL.isEmpty() && !formPIN.isEmpty()) {
            this.validatePIN();
        }
    }

    public pageReference initFromChat()
    {
        String requestedStoreUrl = ApexPages.currentPage().getParameters().get('storeUrl');
        String requestedSupporPin = ApexPages.currentPage().getParameters().get('supportPin');
      
        // If the store url/pin was provided, debug the values.
        if(!String.isEmpty(requestedStoreUrl) || !String.isEmpty(requestedSupporPin)) {
            System.debug('Prepopulated Form Url:  value: ' + requestedStoreUrl);
            System.debug('Prepopulated Form Pin:  value: ' + requestedSupporPin);
            }
        if(!String.isEmpty(requestedStoreUrl) && !String.isEmpty(requestedSupporPin)) {
            FormUrl.value = requestedStoreUrl;
            FormPin.value = requestedSupporPin;
            validatePin();
            }
        return null; 
    }

    /**
     * A formated list of supported file types that will be used as the "accept" attribute on the file input.
     */
    public String formatAcceptedFileUploadTypeList()
    {
        System.debug('formatAcceptedFileUploadTypeList : entry');
        allowedFileUploadTypesList = '';
		
        for(String fileType : allowedFileUploadTypes) {
            if(!String.isEmpty(allowedFileUploadTypesList)) {
                allowedFileUploadTypesList += ', ';
            }
            allowedFileUploadTypesList += fileType;
        }
        System.debug('allowedFileUploadTypesList: ' + allowedFileUploadTypesList);

        return allowedFileUploadTypesList;
    }
    /**
     * Set the initial value of a ValueAndError field and return a boolean if it was set.
     */
    public Boolean prefillInput(ValueAndError input, String fieldValue)
    {
        if(!String.IsBlank(fieldValue)) {
            input.value = fieldValue;
            return True;
        }
        return False;
    }
    /**
     * Form Step 1 Submit Handler.
     */
    public Id validatePIN()
    {
        formErrorHelper.clear();
        System.debug('validatePIN: Begin input values');
        System.debug('formURL: ' + formURL.value);
        System.debug('formPIN: ' + formPIN.value);
        System.debug('validatePIN: End input values');

        // Form field validation
        formURL.value = formURLFormatter(formURL.value);
        System.debug('validatePIN: formatted formURL: ' + formURL.value);

        if(formURL.isEmpty()) {
            System.debug('validatePIN: formURL is empty');
            formURL.error = 'Please enter a Store URL within the field below.';
            formErrorHelper.add(1, formURL.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter a Store URL within the field below.');
            // ApexPages.addMessage(msg);
        }

        if(formPIN.isEmpty()) {
            System.debug('validatePIN: formPIN is empty');
            formPIN.error = 'Please enter a Support Pin within the field below.';
            formErrorHelper.add(2, formPIN.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter a Support Pin within the field below.');
            // ApexPages.addMessage(msg);
        } else {
            formPIN.value = formPIN.value.trim();
        }

        if(formURL.isEmpty() || formPIN.isEmpty()) {
            System.debug('validatePIN: url or pin empty, returning form for additional user input.');
            formErrorsList = formErrorHelper.allErrors();
            return null;
        }

		Boolean errorO = getValuesFromOpp();
		 
		if (errorO) 
		   { 
		   	Boolean errorS = getValuesFromSub();  
		
			if (errorS) {
	            formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
	            formPIN.error = formURL.error;
	            formErrorHelper.add(0, formURL.error);
	            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.');
	            // ApexPages.addMessage(msg);
	           
	            formErrorsList = formErrorHelper.allErrors();
	            System.debug('validatePIN: formErrorsList:' + formErrorsList);
	            
	            return null;
        		}
		   }
 /*
        List<Subscription__c> subList = new List<Subscription__c>();

        String fullStoreUrl = 'http://' + formUrl.value;
        try{
            subList = [SELECT Id, Account__c, Account__r.OwnerId, Contact__c, Lead__c, Support_PIN__c, StoreURL__c, Email__c, ProductID__c FROM Subscription__c
                    WHERE Support_PIN__c = :formPIN.value AND (StoreURL__c = :formUrl.value OR StoreURL__c = :fullStoreUrl)
                    AND Status__c = 'Active' LIMIT 1];

            System.debug('subList: ' + subList);
        } catch (ListException le){
            formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
            formPIN.error = formURL.error;
            formErrorHelper.add(0, formURL.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.');
            // ApexPages.addMessage(msg);
        } catch (Exception e){
            formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
            formPIN.error = formURL.error;
            formErrorHelper.add(0, formURL.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.');
            // ApexPages.addMessage(msg);
        }

        if(!subList.isEmpty()){
            webFormOn = True;
            subId = subList[0].Id;
            formEmail.value = subList[0].Email__c;
            AcctId = subList[0].Account__c;
            AcctOwn = subList[0].Account__r.OwnerId;
            ContId = subList[0].Contact__c;
            LeadId = subList[0].Lead__c;
            ProductId = subList[0].ProductID__c;
  */          
            try {
                // Try to prefill user's name/phone on step 2
                Contact masterContact = [SELECT FirstName, LastName, Phone FROM Contact WHERE Id = :ContId LIMIT 1];
                System.debug('validatePIN: masterContact: ' + masterContact);
                
                prefillInput(formFname, masterContact.FirstName);
                prefillInput(formLname, masterContact.LastName);
                prefillInput(formPhone, masterContact.Phone);
            } catch(Exception e) {
                System.debug('validatePIN: exception getting master contact\'s contact information');
            }
 
        formErrorsList = formErrorHelper.allErrors();
        System.debug('validatePIN: formErrorsList:' + formErrorsList);

        return null;
    }
 
 // start change for Opportunity     
    public Boolean getValuesFromOpp()
	{
		Boolean errorOpp = false;
		
		String fullStoreUrl = 'http://' + formUrl.value;
 
     
        Opportunity opp = new Opportunity();
        try{
             opp = DLUtility.getOppfromurlpin(formUrl.value,formPIN.value) ;
        	} 
        catch (Exception e){
            	errorOpp = true;
			}    
		
		if(opp <> null){
            webFormOn = True;
            subId = opp.Subscription__c;
            formEmail.value = opp.Contact_Email__c;
            AcctId = opp.AccountId;
 //           AcctOwn = subList[0].Account__r.OwnerId;
            ContId = opp.Contact__c;
 //           LeadId = subList[0].Lead__c;
            ProductId = opp.ProductID__c;
            oppId = opp.Id;
		}	
		else
		{  errorOpp = true; }
		
		return errorOpp;
	}
	public Boolean getValuesFromSub()
	{
		
		Boolean errorS = false;
		List<Subscription__c> subList = new List<Subscription__c>();

        String fullStoreUrl = 'http://' + formUrl.value;
        
        try{
            subList = [SELECT Id, Account__c, Account__r.OwnerId, Contact__c, Lead__c, Support_PIN__c, StoreURL__c, Email__c, ProductID__c FROM Subscription__c
                    WHERE Support_PIN__c = :formPIN.value AND (StoreURL__c = :formUrl.value OR StoreURL__c = :fullStoreUrl)
                    AND Status__c = 'Active' LIMIT 1];

            System.debug('subList: ' + subList);
        } catch (ListException le){
            formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
            formPIN.error = formURL.error;
            formErrorHelper.add(0, formURL.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.');
            // ApexPages.addMessage(msg);
            errorS = true;
        } catch (Exception e){
            formURL.error = 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.';
            formPIN.error = formURL.error;
            formErrorHelper.add(0, formURL.error);
            // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The Store URL and Support Pin provided do not match our records.  Please ensure the information is entered correctly and try again.');
            // ApexPages.addMessage(msg);
             errorS = true;
        }
		
		if (errorS) return errorS;
		
        if(!subList.isEmpty()){
            webFormOn = True;
            subId = subList[0].Id;
            formEmail.value = subList[0].Email__c;
            AcctId = subList[0].Account__c;
            AcctOwn = subList[0].Account__r.OwnerId;
            ContId = subList[0].Contact__c;
            LeadId = subList[0].Lead__c;
            ProductId = subList[0].ProductID__c;
        }
        else 
        {  errorS = true; }
        return  errorS; 
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
     * Get's the case submission settings
     */
    public CaseSubmissionSettings__c getCaseSubmissionSettings() 
    {
        if(css == null) {
            css = CaseSubmissionSettings__c.getValues(csse);
        }
        return css;
    }
    /** 
     * Form Step 2 Submit Handler
     */
    public PageReference submitCase() 
    {  
        System.debug('submitCase : entry');        
        System.debug('File Name  :' + fileName);

        allowedFileUploadTypesList = this.formatAcceptedFileUploadTypeList();
        // Clear any existing error messages
        formErrorHelper.clear();

        // Get the csse (Case Submission Setting entry from the VF page)
        css = getCaseSubmissionSettings();   
        
        //ID for a default user to set as the owner of the Case 
        Id OwnId = css.Default_Support_Owner_ID__c; 
        
        // Form Description
        formDescription.value = caseDescription;
        formSubject.value = caseSubject;
        Boolean descriptionHasErrors = this.validateDescription();
        Boolean subjectHasErrors = this.validateSubject();
		 System.debug('form phone' +formPhone.value);
        fileUploadValidation = false;
        System.debug('submitCase first : ' + fileUploadValidation);
        fileUploadValidation = this.validateFileUpload();
        System.debug('submitCase second : ' + fileUploadValidation);

        System.debug('submitCase : descriptionHasErrors: ' + descriptionHasErrors);
        System.debug('submitCase : fileUploadValidation: ' + fileUploadValidation);

        // If there are any errors, let the user correct them
        if(descriptionHasErrors || fileUploadValidation || (css.Name != 'Web2Cancel' && subjectHasErrors)) {
         //if(descriptionHasErrors){
            System.debug('descriptionHasErrors: ' + descriptionHasErrors);
            System.debug('fileUploadValidation: ' + fileUploadValidation);           

            formErrorsList = formErrorHelper.allErrors();
            return null;
        }
        deptName = this.getTargetDepartment();
        
        System.debug('submitCase : css : ' + css);
        System.debug('submitcase : calling attachToCase ');
      
        PageReference nextAction = this.caseBuilder(css);

        return nextAction;
    }
    /**
     * Saves the case and adds the attachment, if necessary. Returns the next action (Thanks or Error).
     */
    public PageReference attachToCase(Case caseRecord)
    {
        System.debug('attachToCase : entry ');
        System.debug('attachToCase : entry : CaseId' + caseRecord.Id);
           

        caseRecord = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseRecord.Id];
        caseNum = caseRecord.CaseNumber;
        System.debug('attachToCase : entry : caseNum ' + caseRecord.CaseNumber);
        System.debug('attachToCase : entry : formEmail.value ' + formEmail.value);
        System.debug('attachToCase : entry : formURL.value ' + formURL.value);
    
        System.debug('attachToCase : entry : fileName ' + fileName);
        System.debug('attachToCase : entry : fileName ' + fileAtt);
        if(fileName != null || fileAtt !=null){
            caseAtt = new Attachment();
            try{
            System.debug('attachToCase : entry : fileName ' + fileName);
            System.debug('attachToCase : entry : caseRecord.Id ' + caseRecord.Id);

            caseAtt.Name = fileName;
            System.debug('attachToCase : entry : caseAtt ' + caseAtt.Name);
            caseAtt.Body = fileAtt;
            caseAtt.ParentId = caseRecord.Id;
            insert caseAtt;
            }         
            catch (Exception e) {
                formErrorHelper.add(0, e.getMessage());           
                formErrorsList = formErrorHelper.allErrors();
                return null;
            }
        }
        
        // Redirect to completion page
        return new PageReference(css.Redirect_URL__c + '?caseNum=' + EncodingUtil.urlEncode(caseNum, 'UTF-8') +
                                    '&contactEmail=' + EncodingUtil.urlEncode(formEmail.value, 'UTF-8') + '&storeUrl=' 
                                    + EncodingUtil.urlEncode(formURL.value, 'UTF-8'));           
    }
    /**
     * Validates the ticket description. Returns bolean for has errors.
     */
    public Boolean validateDescription() 
    {
        if(formDescription.isEmpty()){
            formDescription.error = 'Please enter a description within the field below.';
            formErrorHelper.add(1, formDescription.error);
            return true;
        } else {
            return false;
        }
    }
    public Boolean validateSubject() 
    {
        if(formSubject.isEmpty()){
            formSubject.error = 'Please enter a Subject within the field below.';
            formErrorHelper.add(1, formSubject.error);
            return true;
        } else {
            return false;
        }
    }
    
    /**
    * Creates the case record when the attachment is validated
    */
    public PageReference caseBuilder(CaseSubmissionSettings__c css)
    {
        System.debug('caseBuilder: entry');
        
        if (!validateAPIRequest())
        {
            return new PageReference(css.Invalid_API_Request_URL__c);  
            
        }
        c = new Case();
        try {

            c.AccountId = AcctId;
            if(ContId != null){
                c.ContactId = ContId;
            }
            if(LeadId != null && ContId == null){
                c.Lead__c = LeadId;
            }

            String suppliedName = formFname.value + ' ' + formLname.value;
            if(!String.isBlank(suppliedName)) {
                c.SuppliedName = suppliedName;
            }

            c.Description = formDescription.value;
            System.debug('caseBuilder : contactId : ' + c.ContactId);
             System.debug('form phone' +formPhone.value);
            c.SuppliedPhone = formPhone.value;
            c.RecordTypeId = css.Case_Record_Type__c;
            c.Subscription__c = subId;
            c.Origin = css.Case_Origin__c;
//            c.Subject = c.Description.left(255);
			c.Subject = formSubject.value;
			c.Opportunity__c = oppId;
			
            if (css.Name == 'Web2Cancel')
            {
	            c.OwnerId = css.Default_Support_Owner_ID__c;
	            c.Department__c = 'Cancellation';
	            c.Subject = 'Cancellation Request for '+ formURL.value;
            }
            else 
            {
	            c.OwnerId = formDeptId.value;
	            c.Department__c = deptName;
            }
           
           
    
            // Insert the case
            System.debug('caseBuilder: case values: ' + c);
            //System.debug('caseBuilder: caseId: ' + c.Id);
            INSERT c;  
            System.debug('caseBuilder: caseId: ' + c);
            PageReference caseRecord = this.attachToCase(c);

            return caseRecord;
            
        } catch (Exception e) {
            formErrorHelper.add(0, 'caseBuilder error: ' + e.getMessage() );          
            formErrorsList = formErrorHelper.allErrors();
            return null;
        }
    }
    /**
     * Validates the file upload extension. Returns bolean for has errors.
     */
    public Boolean validateFileUpload()
    {

        System.debug('validateFileUpload : validating upload entry ' );  
        System.debug('validateFileUpload : validating upload entry :'  + fileSize);  
        System.debug('validateFileUpload : validating upload entry :'  + fileName); 

        if(ApexPages.hasMessages(ApexPages.severity.ERROR)) {

            System.debug('Exceeds File Size limit, abort processing. ApexPages.getMessages() :' + ApexPages.getMessages());
            List<Apexpages.Message> msgs = ApexPages.getMessages();
           
            for(Apexpages.Message msg:msgs){

                System.debug('validateFileUpload : msg ' + msg);
                System.debug('validateFileUpload : msg.getSummary() ' + msg.getSummary());

                if (msg.getSummary().contains('This file exceeds the maximum size limit of 10MB.')){

                    System.debug('you got it :');
                    formErrorHelper.add(2,'Please ensure your attachment is less than 5MB');
                    //fileName = null;
                    //fileAtt = null;
                    return true;
                }
            }         
        }else{
            if(fileSize > 0){
                String[] fileExt = fileName.split('\\.');
                System.debug(' validateFileUpload : fileExt : ' + fileExt);
                String extension = fileExt[1];
                
                System.debug(' validateFileUpload : extesion : ' + extension);
                System.debug(' validateFileUpload : valid File Extension : ' + allowedFileUploadTypes.contains(extension)); 
                System.debug(' validateFileUpload : fileSize : ' + fileSize);  
                System.debug(' validateFileUpload : MAX_FILE_SIZE : ' + MAX_FILE_SIZE);          
                
                if(allowedFileUploadTypes.contains(extension.toLowerCase())){ 
                    System.debug(' validateFileUpload : Good extension');
                       
                    if(fileSize < MAX_FILE_SIZE){
                        System.debug(' validateFileUpload : Good size');
                        return false;
                    }else{
                        System.debug(' validateFileUpload : Good extesion oversize file');
                        //fileName = null;
                        //fileAtt = null;
                        return true;
                    }                                                
                }else{
                    if(fileSize > MAX_FILE_SIZE){
                        formErrorHelper.add(2, 'Please ensure your attachment is less than 5MB and is one of the following types: "' + allowedFileUploadTypesList + '".');                     
                    } else{
                        formErrorHelper.add(2, 'Please ensure your attachment is one of the following types: "' + allowedFileUploadTypesList + '".');                     
                    } 
                    //fileName = null;
                    //fileAtt = null;
                    return true;
                }
            }
        }            
        return false; 
    }  

    public String getTargetDepartment() 
    {
        String deptResult = null;

        String department = 'Support';

        System.debug('getTargetDepartment: formDeptId.value: ' + formDeptId.value);

        try{
            deptResult = (String) [SELECT Queue_Name__c FROM CaseQueueRouting__c WHERE Queue_ID__c =: formDeptId.value LIMIT 1][0].get('Queue_Name__c');
        } catch (Exception e) {
            System.debug('submitCase: Submitted department ID (' + formDeptId.value + ') can\'t be found in CaseQueueRouting__c');
        }

        if(deptResult != null) {
            department = deptResult;
        }
        system.debug('***' +department);
        return department;
    }
    /**
     * Builds the select dropdown list for the Issue Types field.
     */
    public List<SelectOption> getDepts() 
    {
        List<SelectOption> options = new List<SelectOption>();
        Map<String, CaseQueueRouting__c> queues = CaseQueueRouting__c.getAll();
        List<String> queueSorted = new List<String>();
        queueSorted.addAll(queues.keySet());
        queueSorted.sort();

        for(String queueName : queueSorted){
            CaseQueueRouting__c queue = queues.get(queueName);
            options.add(new SelectOption(queue.Queue_ID__c,queue.Queue_Name__c));
        }

        return options;
    }
    public Boolean validateAPIRequest()
    {
        Boolean validRequest = true;
        system.debug('***' +deptName);
        if (deptName == 'API' && ProductId <> null && Label.API_Plan_Ids.contains(ProductId))
        {
            validRequest = false;
        }
        return validRequest;
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
     * Implements a data structure that allows an ID field/variable to hold a value and an error message.
     */
    public class IDValueAndError
    {
        public ID value {get; set;}

        public String error {get; set;}

        public Boolean getHasError()
        {
            return (!String.IsBlank(error));
        }

        public Boolean isEmpty()
        {
            return (String.IsEmpty(String.valueOf(value)));
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