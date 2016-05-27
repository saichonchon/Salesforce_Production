public class SalesLiveAgentPreChatController {
 	
 	public String endpoint {get; set;}   
    public String jsSubmitForm {get; set;}   
    public ValueAndError formPIN{get; set;}
    public ValueAndError formURL{get; set;}  
    public ValueAndError formEmail{get; set;}
    public ValueAndError formFname{get; set;}
    //public ValueAndError formLname{get; set;}  
    protected FormErrorHelper formErrorHelper { get; set; }
    public List<String> formErrorsList { get; set; } 
    
        
    public SalesLiveAgentPreChatController(){

        jsSubmitForm = '';           
        //get the querystring data passed in by the button.  This is the liveagent form action
        //EX: ?endpoint=https%3A%2F%2F1.la1a1.salesforceliveagent.com... etc..
        endpoint = '';
        
        PageReference pageRef = ApexPages.currentPage();
        if (pageRef.getParameters() != null) {
            if (pageRef.getParameters().containsKey('endpoint')) {
                if (pageRef.getParameters().get('endpoint') != null) {
                    endpoint = pageRef.getParameters().get('endpoint');
                }
            }           
        }         

        formFname = new ValueAndError();
        //formLname = new ValueAndError();
        formEmail = new ValueAndError();        
        formErrorHelper = new FormErrorHelper();
        formErrorsList = new List<String>();
    }

    public pagereference clickChat(){ 

    	System.debug('clickChat : entry ');    

    	Boolean fieldsEmpty = this.hasEmptyFields();

        //fieldsEmpty = false;
        
        if(fieldsEmpty){        	
            return null;
        }else{

        	PageReference pr = null;     	        
	        jsSubmitForm = 'jQuery(\'#preChatFormSubmit\').submit();';	        
	        return pr;
        }               
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

    public Boolean hasEmptyFields()
    {

        formErrorHelper.clear();

        System.debug('hasEmptyFields : ' + formFname.value);
        //System.debug('hasEmptyFields : ' + formLname.value);
        System.debug('hasEmptyFields : ' + formEmail.value);        

        if(formFname.isEmpty()) {
            System.debug('hasEmptyFields: formFname is empty');
            formFname.error = 'Please enter your Full Name within the field below.';
            formErrorHelper.add(1, formFname.error);            
        }else{
            formFname.error = '';
        }
        //if(formLname.isEmpty()) {
        //    System.debug('hasEmptyFields: formLname is empty');
        //    formLname.error = 'Please enter your Last Name within the field below.';
        //    formErrorHelper.add(2, formLname.error);            
        //}else{
        //    formLname.error = '';
        //}
        if(formEmail.isEmpty()) {
            System.debug('hasEmptyFields: formEmail is empty');
 //           formEmail.error = 'Please enter your Email within the field below.';
 //           formErrorHelper.add(3, formEmail.error); 
              formEmail.error = '';
              formEmail.value = 'guestsaleschat.user@bigcommerce.com';           
        }else{
            formEmail.error = '';
            formEmail.value = formEmail.value.trim();
        }       
        //if(formFname.isEmpty() || formLname.isEmpty()|| formEmail.isEmpty()){
        if(formFname.isEmpty() || formEmail.isEmpty()){
            System.debug('hasEmptyFields: returning form for additional user input.');
            formErrorsList = formErrorHelper.allErrors();            
            if(formErrorsList.size()>2){   
            	formErrorsList.clear();
                formErrorsList.add('Please provide information within the fields below.');                   
            }
            return true;
        }
        return false;
    }
}