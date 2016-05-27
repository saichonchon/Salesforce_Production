/**
 * This class contains all the settings for the Apex code under Bigcommerce.
 * It doesn't seem to be a common pattern in Apex-land, but we need to be able
 * to refer to specific account types, record types etc. and this seems to be 
 * the best way to centralise that information.
 * 
 * All properties are read only.
 */
 public class BCSettings {
	
	// Users
	public static User apiUser { get { return new User(Id='00530000004W020AAC'); } set {} }
	
	// Profile IDs
	public static Id conversionRepProfileId { get { return '00e30000001UPDKAA4'; } set {} }
	public static Id acquisitionRepProfileId { get { return '00e3000000248EZ'; } set {} }
	public static Id partnerManagerProfileId { get { return '00e30000001UrWqAAK'; } set {} }

	// Record type IDs
	public static Id partnerRecordTypeId { get { return '012a0000001NOe1AAG'; } set {} }
	public static Id clientRecordTypeId { get { return '012a0000001NOe6AAG'; } set {} }

}