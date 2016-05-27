public class GetAttachment {

private final  LiveChatTranscript att;
public  Id Doc_ID {get;set;}

   
    
	public String getBody()
	{
		if (DOC_ID == null) return null;
 	    LiveChatTranscript att = [SELECT Body FROM LiveChatTranscript WHERE CaseId = :Doc_ID LIMIT 1 ];
	
	        System.debug('##PDF Attach -att: ' + att.body);
    
		   return att.body;
	}
}