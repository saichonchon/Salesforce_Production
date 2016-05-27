public without sharing class NoSharingUtils {
	public static void insertObject(sObject obj){
		insert obj;
	}
	
	public static void updateObject(sObject obj){
		update obj;
	}
	
	public static List<sObject> queryObject(String sql){
		return database.query(sql);
	}
	
	public static sObject queryObject1 (String sql){
		return database.query(sql);
	}
}