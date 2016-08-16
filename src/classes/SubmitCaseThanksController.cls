public class SubmitCaseThanksController{

    public String caseNum {get; set;}
    public String contactEmail {get; set;}
    public String storeUrl {get; set;}

    public SubmitCaseThanksController(){
      if (ApexPages.currentPage().getParameters().get('caseNum') != null)
      {
        caseNum = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('caseNum'), 'UTF-8');

        try
        {
          Case lclCase = [Select Id, CaseNumber, Contact.Email, Bigcommerce_Store_URL__c from Case where CaseNumber =:caseNum];
          contactEmail = lclCase.Contact.Email;
          storeUrl = lclCase.Bigcommerce_Store_URL__c;
        }
        catch (Exception e)
        {
          System.debug(e);
          contactEmail = '';
          storeUrl = '';
        }

        System.debug('SubmitCaseThanksController: caseNum: ' + caseNum + ', contactEmail: ' + contactEmail + ', storeUrl: ' + storeUrl);
      }
    }
}