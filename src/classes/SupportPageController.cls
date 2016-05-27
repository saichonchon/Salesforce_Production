public class SupportPageController {
	
	public String dcsname;
	
	public void setdcsname (String s)
	{
		dcsname = s;
	}
	public String getdcsname ()
	{
		return dcsname;
	}
	public List <University__kav> univArtList {get;set;}
	public Map <String, List <University__kav>> mapunivArtList {get;set;}
	
	public  supportPageController()
	{
		
    	mapunivArtList = DLUtility.getUnivArticles();
	}
	
	public List <University__kav> univArtListByName{ 
		get { univArtList = mapunivArtList.get(dcsname);
			
			 return univArtList;}
	}
    
  	
/*    
public void getunivArtList () {
  		
  	}
  	public List <University__kav> getunivArtList() {
    
    	return univArtList;
  } 
*/  
  	
}