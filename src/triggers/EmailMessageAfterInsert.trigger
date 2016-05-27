/**********************************************************************
Name:  EmailMessageAfterInsert 
======================================================
 Purpose:  Email into Case Comment.
======================================================
 
History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 12/5/2015  Initial development
 
***********************************************************************/

trigger EmailMessageAfterInsert  on EmailMessage(after insert) 
{
  List <CaseComment> commentsToInsert = new List <CaseComment>();
  Map <Id, Case> caseEmails = new Map<Id, Case>();
  Set<Id> caseIds = new Set<Id>();
 
  Id idCSCaseRecordType 	= Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Client Success').getRecordTypeId();
  Id idBillRecordType		= Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Billing').getRecordTypeId();
  Id idCancelRecordType 	= Case.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Cancellations').getRecordTypeId();

 	Set<Id> eligibleRecIds = new Set<Id>();
    eligibleRecIds.add(idCSCaseRecordType);
    eligibleRecIds.add(idBillRecordType);
    eligibleRecIds.add(idCancelRecordType);
 
  for (EmailMessage em : Trigger.new)
  {
  	if (em.Incoming == false)
    {
        caseIds.add(em.ParentId);
    }
  }
    
  for(Case c : [Select Id from Case where id in :caseIds and RecordTypeId in :eligibleRecIds])
  {
    caseEmails.put(c.id, c);
  }
  
  
  for (EmailMessage em : Trigger.new)
  {
	If (caseEmails.get(em.ParentId) <> null)
	{
	      CaseComment cc = new CaseComment();
	      String emailBody;
	      
	      if (em.TextBody <> null)
	      { if (em.TextBody.length() > 3999)
	        {
	          emailBody = em.TextBody.substring(1,3950);
	           emailBody =  cc.CommentBody  +'-------Remainder of response truncated-------';
	        }
	      	else
	      	{
	          emailBody = em.TextBody;
	 		}
	      	  integer startString = emailBody.indexOf(Label.Email_Strip_Text_2);
	      	  integer sLength = Label.Email_Strip_Text_2.Length();
	      	  startString = startString + sLength;
		 	  integer cutString = emailBody.indexOf(Label.Email_Strip_Text);
		 	  if (startstring <> null && startstring >0
		 	      && cutstring <> null && cutstring >0
		 	      && cutstring > startstring && cutstring < em.TextBody.length())
		 	  {
		 	  	Try{
		 	  			cc.CommentBody = emailBody.substring(startString,cutString);
		 	  	}
		 	  	Catch (Exception e)
		 	  	{
		 	  		cc.CommentBody = emailBody;
		 	  	}
		 	  }
		 	  else
		 	  {	
		 	  	cc.CommentBody = emailBody;
		 	  }
		 	  
		 	  if (cc.CommentBody.length() < 3900)
		 	  {
		 	  	string toadd = em.ToAddress.substring(0,em.ToAddress.length());
		 	  	cc.CommentBody += '\n Email Sent to:' + toadd;
		 	  }
			  cc.IsPublished = true;
			  cc.ParentId = em.parentId;
			  commentsToInsert.add(cc);
	      }
	} 
  }
  
  insert commentsToInsert;
  
}