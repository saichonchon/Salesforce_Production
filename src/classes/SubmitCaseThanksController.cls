public class SubmitCaseThanksController{

    public String caseNum {get; set;}
    public String contactEmail {get; set;}
    public String storeUrl {get; set;}

    public SubmitCaseThanksController(){
      if (ApexPages.currentPage().getParameters().get('caseNum') != null)
      {
        caseNum = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('caseNum'), 'UTF-8');
        contactEmail = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('contactEmail'), 'UTF-8');
        storeUrl = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('storeUrl'), 'UTF-8');

        System.debug('SubmitCaseThanksController: caseNum: ' + caseNum + ', contactEmail: ' + contactEmail + ', storeUrl: ' + storeUrl);
      }
    }
}