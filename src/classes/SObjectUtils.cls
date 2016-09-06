global without sharing class SObjectUtils 
{
    /*-----------------------------------
    * PRIVATE CONSTANTS
    *-----------------------------------*/
    private static final list<Schema.DisplayType> STRING_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.base64,
        Schema.DisplayType.Email,
        Schema.DisplayType.MultiPicklist,
        Schema.DisplayType.Phone,
        Schema.DisplayType.Picklist,
        Schema.DisplayType.String,
        Schema.DisplayType.TextArea,
        Schema.DisplayType.URL
    };
    
    private static final list<Schema.DisplayType> INTEGER_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.Integer
    };
    
    private static final list<Schema.DisplayType> ID_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.ID,
        Schema.DisplayType.Reference
    };
    
    private static final list<Schema.DisplayType> DOUBLE_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.Currency,
        Schema.DisplayType.Double,
        Schema.DisplayType.Percent
    };
    
    private static final list<Schema.DisplayType> DATETIME_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.DateTime
    };
    
    private static final list<Schema.DisplayType> DATE_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.Date
    };
    
    private static final list<Schema.DisplayType> BOOLEAN_TYPES = new list<Schema.DisplayType>
    {
        Schema.DisplayType.Boolean,
        Schema.DisplayType.Combobox
    };
    
    /*-----------------------------------
    * PRIVATE methods
    *-----------------------------------*/ 
    private static boolean isBlank(string str) 
    {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }
     
    private static Boolean isEqualType(Schema.DisplayType typeToCheckA, Schema.DisplayType typeToCheckB) 
    {
        String typeA = getGenericType(typeToCheckA);
        String typeB = getGenericType(typeToCheckB);
        if(typeA != null && typeB != null && typeA == typeB) 
        {
            return true;
        } 
        else 
        {
            return false;
        }
    }
    
    private static Boolean contains(list<Schema.DisplayType> aListActingAsSet, Schema.DisplayType typeToCheck)
    {
        if(aListActingAsSet != null && aListActingAsSet.size() > 0)
        {
            for(Schema.DisplayType aType : aListActingAsSet)
            {
                if(aType == typeToCheck)
                {
                    return true;
                }
            }
        }
        return false;
    }
    
    private static String getGenericType(Schema.DisplayType typeToCheck) 
    {
        if(contains(STRING_TYPES,typeToCheck)) 
        {
            return 'STRING';
        }
        if(contains(INTEGER_TYPES,typeToCheck)) 
        {
            return 'INTEGER';
        }
        if(contains(ID_TYPES,typeToCheck)) 
        {
            return 'ID';
        }
        if(contains(DOUBLE_TYPES,typeToCheck)) 
        {
            return 'DOUBLE';
        }
        if(contains(DATETIME_TYPES,typeToCheck)) 
        {
            return 'DATETIME';
        }
        if(contains(DATE_TYPES,typeToCheck)) 
        {
            return 'DATE';
        }
        if(contains(BOOLEAN_TYPES,typeToCheck)) 
        {
            return 'BOOLEAN';
        }
        return null;
    }
    
    /*-----------------------------------
    * Public methods
    *-----------------------------------*/
    global static boolean runSync = true;
    global static boolean SubscriptionLogicRunning = false;
    global static boolean ResetSubOwnersForLeadOwnerChanges = true;
    global static boolean ManualLeadConvert = false;
    global static boolean RoundRobinLogicRunning = false;
    //global static boolean SentToRoundRobinFuture = false;
    global static boolean lookUpRollUpIsRunning = false;
    global static boolean SubscriptionLogicComplete = false;
    
    public static string LeadConvertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1].MasterLabel;
    
    global static map<string, User> mpUserRecordsByName (set<String> stNameofUsers)
    {
        map<string, User> mpRet = new map<string, User>();
        
        // Ensure NameofUsers is not null
        if (stNameofUsers == null || stNameofUsers.isEmpty())
        {
            return mpRet;
        }
        else
        {
            for (User u : [SELECT Id, Name, Username, Email, FirstName, LastName, UserType, UserRoleId, ProfileId, IsActive, ContactId 
                            FROM User 
                            WHERE Name IN :stNameofUsers])
            {
                mpRet.put(u.Name, u);
            }
            
            return mpRet;
        }
    }
    
    global static list<QueueSobject> lstQueues4Object (string objType)
    {
        // Query for the queues to create the map of Ids to Names
        return [SELECT SobjectType, Queue.Name, QueueId, Id 
                FROM QueueSobject
                WHERE SobjectType = :objType];
    }
    
    //-------------------------------------------------------------------------------------------------------------------------------
    // Static properties
    //-------------------------------------------------------------------------------------------------------------------------------
    private static string BuildSelectFromStagingToTableMapping (string sObjectName, boolean isStagingObject, list<string> lstReqFlds)
    {
        string retVal = '';
        // Always ensure the Id field is part of the select
        string soqlFlds = 'Id';
        string curFld = '';
        
        set<string> stStr = new set<string>();
        
        for (StagingToTableMapping__c s : StagingToTableMapping__c.getall().values())
        {
            curFld = '';
                    
            if (s.Active__c)
            {           
                if (isStagingObject && s.Staging_Object_Name_API__c == sObjectName)
                {
                    if (stStr.add(s.Staging_Object_Field_Name_API__c) && s.Staging_Object_Field_Name_API__c.trim().toUpperCase() != 'ID')
                    {   
                        curFld = s.Staging_Object_Field_Name_API__c.trim();
                        soqlFlds += (soqlFlds.length() == 0 ? '' : ', ') + curFld;
                    }
                }
                else if (!isStagingObject && s.Object_Name_API__c == sObjectName)
                {
                    if (stStr.add(s.Object_Field_Name_API__c) && s.Object_Field_Name_API__c.trim().toUpperCase() != 'ID')
                    {
                        curFld = s.Object_Field_Name_API__c.trim();
                        soqlFlds += (soqlFlds.length() == 0 ? '' : ', ') + curFld;                      
                    }
                }
                                
                // Loop through the required fields to see if this field is in the list
                if (lstReqFlds != null && lstReqFlds.size() > 0)
                {
                    for (integer x = lstReqFlds.size() - 1; x >= 0; x--)
                    {
                        if (lstReqFlds[x].trim().toUpperCase() == curFld.trim().toUpperCase())
                        {
                            lstReqFlds.remove(x);
                        }                   
                    }
                }               
            }
        }
        
        // Make sure specific fields exist in each select statement
        if (lstReqFlds != null && lstReqFlds.size() > 0)
        {
            for (string s : lstReqFlds)
            {
                system.debug('*** Required Field to Add: ' + s);
                system.debug('*** Current Fields to Query: ' + soqlFlds);
    
                soqlFlds += (soqlFlds.length() > 0 ? ', ' : '') + s.trim();
            }
        }
                
        retVal = 'SELECT ' + soqlFlds + ' FROM ' + sObjectName;
        system.debug(' soql '+retval);
        return retVal;      
    }
    
    public static string SubscriptionSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('Subscription__c', false, new string[]{'MBAAccountID__c', 'Account__c', 'Lead__c', 'MBASubscriptionID__c', 'MBAPartnerID__c', 'OwnerId'});
        }
    }
    
    public static string OpportunitySelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('Opportunity', false, new string[]{'MBAAccountID__c', 'AccountId', 'MBASubscriptionID__c', 'OwnerId','RecordTypeId','RecordType.Name'});
        }
    }
    public static string SubscriptionStagingSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('MBA_Staging_Subscription__c', true, new string[]{'MBAAccountID__c', 'MBASubscriptionID__c', 'MBAPartnerID__c', 'OwnerId'});
        }
    }
                                                
    public static string LeadSelect
    {
        get
        {
			return BuildSelectFromStagingToTableMapping ('Lead', false, new string[]{'MBAAccountID__c', 'MBAClientID__c', 'Email', 'OwnerId', 'SBD_Store_ID_EXT__c', 'Phone'});
        }
    }
    
    public static string AccountSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('Account', false, new string[]{'MBAAccountID__c', 'OwnerId', 'iDev_Partner_ID__c'});           
        }
    }
    
    public static string AccountStagingSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('MBA_Staging_Account__c', true, new string[]{'MBAAccountID__c', 'OwnerId'});
        }
    }
                                                
    public static string ContactSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('Contact', false, new string[]{'MBAAccountID__c', 'MBAClientID__c', 'AccountId', 'Email', 'OwnerId', 'Account.Type', 'Account.OwnerId', 'Account.MBAAccountID__c'});
        }
    }   
    
    public static string ContactStagingSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('MBA_Staging_Contact__c', true, new string[]{'MBAAccountID__c', 'MBAClientID__c', 'Email__c', 'OwnerId'});
        }
    }
    
    public static string RVContactStagingSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('rvpe__RVMember__c', true, new string[]{'rvpe__ExtMemberId__c'  , 'OwnerId'});
        }
    }
    public static string ContactRVStagingSelect
    {
        get
        {
            return BuildSelectFromStagingToTableMapping ('Contact', true, new string[]{'RV_Member__c', 'RV_Account__c', 'OwnerId'});
        }
    }
    public static string MonthNameFromVal (integer val)
    {
        string retVal = '';
        if (val == 1)
        {
            retVal = 'January';
        }
        else if (val == 2)
        {
            retVal = 'February';
        }
        else if (val == 3)
        {
            retVal = 'March';
        }
        else if (val == 4)
        {
            retVal = 'April';
        }
        else if (val == 5)
        {
            retVal = 'May';
        }
        else if (val == 6)
        {
            retVal = 'June';
        }
        else if (val == 7)
        {
            retVal = 'July';
        }
        else if (val == 8)
        {
            retVal = 'August';
        }
        else if (val == 9)
        {
            retVal = 'September';
        }
        else if (val == 10)
        {
            retVal = 'October';
        }
        else if (val == 11)
        {
            retVal = 'November';
        }
        else if (val == 12)
        {
            retVal = 'December';
        }
        
        return retVal;
    }                                           
       
    public static SObject copyFields(SObject source, SObject destination, map<String, String> sourceFieldToDestinationField, map<String, Schema.DisplayType> fieldNameToType)
    {
        system.debug('*** BEGIN: copyFields');
        system.debug('*** source ' + source);
        system.debug('*** destination ' + destination);
        system.debug('*** sourceFieldToDestinationField ' + sourceFieldToDestinationField);
        system.debug('*** fieldNameToType ' + fieldNameToType);     
        
        if(source == null || destination == null)
        {
            system.debug('*** source == null || destination == null');
            return destination;
        }
                
        for(String fieldName : sourceFieldToDestinationField.keySet())
        {
            //system.debug('*** fieldName to copy ' + fieldName);
            //system.debug('***              type ' + fieldNameToType.get(fieldName));
            
            if(contains(STRING_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** STRING_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (String)source.get(fieldName));
            } 
            else if(contains(INTEGER_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** INTEGER_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (Integer)source.get(fieldName));
            } 
            else if(contains(ID_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** ID_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (ID)source.get(fieldName));
            } 
            else if(contains(DOUBLE_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** DOUBLE_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (Double)source.get(fieldName));
            } 
            else if(contains(DATETIME_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** DATETIME_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (DateTime)source.get(fieldName));
            } 
            else if(contains(DATE_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** DATE_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (Date)source.get(fieldName));
            } 
            else if(contains(BOOLEAN_TYPES, fieldNameToType.get(fieldName)))
            {
                //system.debug('*** BOOLEAN_TYPES');
                destination.put(sourceFieldToDestinationField.get(fieldName), (Boolean)source.get(fieldName));
            } 
            else 
            {
                system.debug('*** NO MATCH for TYPE ' + getGenericType(fieldNameToType.get(fieldName)));
            }
        }
        
        //system.debug('*** destination ' + destination);
        return destination;
    }
    
    public static map<String, Schema.DisplayType> getFieldMappingsAndTypes(SObject source, SObject destination, map<string, string> sourceToDestFieldMapping)
    {
        //system.debug('*** BEGIN: getFieldMappingsAndTypes(SObject source, SObject destination, map<string, string> sourceToDestFieldMapping)');
        system.debug('*** source ' + source);
        system.debug('*** destination ' + destination);
        system.debug('*** sourceToDestFieldMapping ' + sourceToDestFieldMapping);
        
        map<String, Schema.DisplayType> fieldNameToType = new map<String, Schema.DisplayType>();
        
        if(source == null || destination == null || sourceToDestFieldMapping == null || sourceToDestFieldMapping.size() == 0)
        {
            system.debug('*** return NULL: first');
            return fieldNameToType;
        }
        
        map<String, Schema.SObjectField> sourceFields = source.getSObjectType().getDescribe().fields.getMap();
        map<String, Schema.SObjectField> destinationFields = destination.getSObjectType().getDescribe().fields.getMap();
        list<Schema.DescribeFieldResult> commonFieldsToCopy = new list<Schema.DescribeFieldResult>();
       
        //system.debug('*** sourceFields.keySet()      ' + sourceFields.keySet());
        //system.debug('*** destinationFields.keySet() ' + destinationFields.keySet());
        
        map<string, string> sourceFieldToDestinationField = new map<string, string>();
        
        Schema.DescribeFieldResult sourceField = null;
        Schema.DescribeFieldResult destinationField = null;
        
        set<string> fieldNamesToMap = new set<string>();
        fieldNamesToMap.addAll(sourceToDestFieldMapping.keySet());
        
        //system.debug('*** fieldNamesToMap (Source) ' + fieldNamesToMap);
                        
        if(fieldNamesToMap == null || fieldNamesToMap.size() == 0) 
        {
            system.debug('*** return NULL: second');
            return fieldNameToType;
        }
        
        for(string fieldName : fieldNamesToMap)
        {
            system.debug('*** fieldName ' + fieldName);
            //Source Field Defined
            if(!sourceFields.containsKey(fieldName)) 
            {
                //user defined field doesn't exist in Source so skip
                system.debug('*** ' + sourceField.getName() + ': NO FIELD IN SOURCE' );
                continue; 
            } 
            sourceField = sourceFields.get(fieldName).getDescribe();
            
            //Destination Field Defined
            
            //Check the user defined mappings 
            if(sourceToDestFieldMapping != null && sourceToDestFieldMapping.containsKey(fieldName)) 
            {
                //field is in the fields to map
                string destinationFieldName = sourceToDestFieldMapping.get(fieldName);
                if(destinationFields.containsKey(destinationFieldName)) 
                {
                    destinationField = destinationFields.get(destinationFieldName).getDescribe();                    
                }                 
            }
            else 
            {
                //it's not in the custom map                              
                system.debug('*** ' + sourceField.getName() + ': NO MATCH)');
                continue;                      
            }
                        
            //source and destination are defined now determine elligability
            //system.debug('*** sourceField (' + sourceField.getName() + ') = [' + sourceField + ']');
            //system.debug('*** destinationField (' + destinationField.getName() + ') = [' + destinationField + ']');            
            
            // Removed the "isAccessible, Createable, Updateable since the destination object may not have these even though they can be updated, created or accessed.
            if( !sourceField.isAccessible()
                //|| !destinationField.isAccessible()
                || destinationField.isAutoNumber()
                || destinationField.isCalculated()
                //|| (isBlank((string)destination.get('id')) && !destinationField.isCreateable())
                //|| (!isBlank((string)destination.get('id')) && !destinationField.isUpdateable())
               )
            {
                //source or destination field either can't or shouldn't be read or written to   
                system.debug('*** ' + sourceField.getName() + ': SOURCE OR DESTINATION NOT ACCESSIBLE' );
                continue;
            }
            
            //system.debug('*** sourceField.getType() ' + sourceField.getType());
            //system.debug('*** destinationField.getType() ' + destinationField.getType());
            
            if(!isEqualType(sourceField.getType(), destinationField.getType()))
            {
                //source or destination field either can't or shouldn't be read or written to   
                system.debug('*** ' + sourceField.getName() + ': TYPE MIS-MATCH' );
                continue;
            }
            
            //fields exist and are eligable
            //system.debug('*** ' + sourceField.getName() + ': MATCH' );
            sourceFieldToDestinationField.put(sourceField.getName(), destinationField.getName());
            
            //We've already confirmed that the fields are the same type
            //system.debug('*** fieldName ' + fieldName);
            //system.debug('*** sourceField.getType() ' + sourceField.getType());
                        
            fieldNameToType.put(sourceField.getName(), sourceField.getType());
        }
        
        //ensure Map is empty
        if(sourceToDestFieldMapping != null) 
        {
            sourceToDestFieldMapping.clear();
        } 
        else 
        {
            sourceToDestFieldMapping = new map<string, string>();
        }
        
        //now reset Map
        //This is a side effect, the SourceToDestFieldMapping will get updated with all of the mappings
        if(sourceFieldToDestinationField != null && sourceFieldToDestinationField.size() > 0) 
        {
            sourceToDestFieldMapping.putAll(sourceFieldToDestinationField);
        }
        system.debug('*** return fieldNameToType ' + fieldNameToType);
        return fieldNameToType;
    }
        
    //Used to sync two objects together.  Must be called for one and ONLY ONE sync, can be for multiple records but not different types
    public static void SyncObjects (string strStagingObjName, string strObjName, map<SObject, SObject> mpSourceObjToDestObj, database.Dmloptions dml)
    {       
        // Maps to hold the source to destination mapping as well as the destination field to field types
        map<string, string> mpSourceToDestFldMap = new map<string, string>();
        map<string, Schema.DisplayType> mpFieldNameToType = new map<string, Schema.DisplayType>();
        
        // List to hold all destination records for insert and for update
        list<SObject> lstDestRcrds_Ins = new list<SObject>();
        list<SObject> lstDestRcrds_Upd = new list<SObject>();       
        
        // Loop through all the field mappings available and pull out the ones needed for these objects
        for (StagingToTableMapping__c o : StagingToTableMapping__c.getall().values())
        {
            if (o.Active__c && o.Staging_Object_Name_API__c == strStagingObjName && o.Object_Name_API__c == strObjName)
            {
                // Update the map holding the Source to Destination field names 
                mpSourceToDestFldMap.put(o.Staging_Object_Field_Name_API__c, o.Object_Field_Name_API__c);
            }
        }
        
        // Find all the field types
        for (SObject obj : mpSourceObjToDestObj.keySet())
        {
            mpFieldNameToType = getFieldMappingsAndTypes(obj, mpSourceObjToDestObj.get(obj), mpSourceToDestFldMap);
            break;
        }
        
        system.debug('*** SyncObjects just called getFieldMappingsAndTypes: mpFieldNameToType ' + mpFieldNameToType);
        if(mpFieldNameToType == null || mpFieldNameToType.size() == 0) 
        {
            system.debug('****Unable to determine Field Types*****');
            return;
        }
        
        for (SObject obj : mpSourceObjToDestObj.keySet())
        {
            SObject objDest = mpSourceObjToDestObj.get(obj);
            
            // Now copy all the fields
            objDest = copyFields(obj, objDest, mpSourceToDestFldMap, mpFieldNameToType);
            
            if (objDest.Id == null)
                lstDestRcrds_Ins.add(objDest);
            else
                lstDestRcrds_Upd.add(objDest);
        }
        
        // Update the destination records if needed
        if (lstDestRcrds_Upd != null && !lstDestRcrds_Upd.IsEmpty())
        {
            system.debug('@@@ Sync Objects Update');
            system.debug('*** Update Destination Records - Beginning: ' + lstDestRcrds_Upd);
            database.update(lstDestRcrds_Upd, dml);
            system.debug('*** Update Destination Records - Completed: ' + lstDestRcrds_Upd);
        }
        
        // Insert the destination records if needed
        if (lstDestRcrds_Ins != null && !lstDestRcrds_Ins.IsEmpty())
        {
            system.debug('@@@ Sync Objects Insert');
            system.debug('*** Insert Destination Records - Beginning: ' + lstDestRcrds_Ins);
            database.insert(lstDestRcrds_Ins, dml);
            system.debug('*** Insert Destination Records - Completed: ' + lstDestRcrds_Ins);
        }
    }
    //Used to sync two objects together.  Must be called for one and ONLY ONE sync, can be for multiple records but not different types
    // New version using custom metadata type
    public static void SyncObjectsNew (string strStagingObjName, string strObjName, map<SObject, SObject> mpSourceObjToDestObj, database.Dmloptions dml)
    {       
        // Maps to hold the source to destination mapping as well as the destination field to field types
        map<string, string> mpSourceToDestFldMap = new map<string, string>();
        map<string, Schema.DisplayType> mpFieldNameToType = new map<string, Schema.DisplayType>();
        
        // List to hold all destination records for insert and for update
        list<SObject> lstDestRcrds_Ins = new list<SObject>();
        list<SObject> lstDestRcrds_Upd = new list<SObject>();       
        
        // Loop through all the field mappings available and pull out the ones needed for these objects
        for (StagingTableMapping__mdt o : [SELECT Active__c,DeveloperName,Id,Object_Field_Name_API__c,Object_Name_API__c,QualifiedApiName,Staging_Object_Field_Name_API__c,Staging_Object_Name_API__c FROM StagingTableMapping__mdt ])
        {
            if (o.Active__c && o.Staging_Object_Name_API__c == strStagingObjName && o.Object_Name_API__c == strObjName)
            {
                // Update the map holding the Source to Destination field names 
                mpSourceToDestFldMap.put(o.Staging_Object_Field_Name_API__c, o.Object_Field_Name_API__c);
  				
            }
        }
 
        // Find all the field types
        for (SObject obj : mpSourceObjToDestObj.keySet())
        {
            mpFieldNameToType = getFieldMappingsAndTypes(obj, mpSourceObjToDestObj.get(obj), mpSourceToDestFldMap);
            break;
        }
        
        system.debug('*** SyncObjects just called getFieldMappingsAndTypes: mpFieldNameToType ' + mpFieldNameToType);
        if(mpFieldNameToType == null || mpFieldNameToType.size() == 0) 
        {
            system.debug('****Unable to determine Field Types*****');
            return;
        }
        
        for (SObject obj : mpSourceObjToDestObj.keySet())
        {
            SObject objDest = mpSourceObjToDestObj.get(obj);
            
            // Now copy all the fields
            objDest = copyFields(obj, objDest, mpSourceToDestFldMap, mpFieldNameToType);
            
            if (objDest.Id == null)
                lstDestRcrds_Ins.add(objDest);
            else
                lstDestRcrds_Upd.add(objDest);
        }
        
        // Update the destination records if needed
        if (lstDestRcrds_Upd != null && !lstDestRcrds_Upd.IsEmpty())
        {
            system.debug('@@@ Sync Objects Update');
            system.debug('*** Update Destination Records - Beginning: ' + lstDestRcrds_Upd);
            database.update(lstDestRcrds_Upd, dml);
            system.debug('*** Update Destination Records - Completed: ' + lstDestRcrds_Upd);
        }
        
        // Insert the destination records if needed
        if (lstDestRcrds_Ins != null && !lstDestRcrds_Ins.IsEmpty())
        {
            system.debug('@@@ Sync Objects Insert');
            system.debug('*** Insert Destination Records - Beginning: ' + lstDestRcrds_Ins);
            database.insert(lstDestRcrds_Ins, dml);
            system.debug('*** Insert Destination Records - Completed: ' + lstDestRcrds_Ins);
        }
    }
}