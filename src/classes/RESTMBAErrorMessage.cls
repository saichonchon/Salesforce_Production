public class RESTMBAErrorMessage
{
    public Boolean is_error;
    public String status;
    public String[] messages;

    public static RESTMBAErrorMessage parse(String json) 
    {
        return (RESTMBAErrorMessage) System.JSON.deserialize(json, RESTMBAErrorMessage.class);
    }
    
    static testMethod void testParse()
    {
        String json = '{\"is_error\":true,\"status\":400,\"messages\":[\"email: An account with this email already exists\"]}';
        RESTMBAErrorMessage obj = parse(json);
        system.debug('***RESTMBAErrorMessage:testParse - Object: ' + obj);
        system.debug('***RESTMBAErrorMessage:testParse - Object Messages: ' + obj.messages);
        System.assert(obj != null);
    } 
}