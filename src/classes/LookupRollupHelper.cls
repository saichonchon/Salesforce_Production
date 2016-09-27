/*

History:   
                                                      
VERSION AUTHOR   DATE       DETAIL     
 
1.0 Maggie Frederick 2/25/2015  Added to bring setting by Name and added filter criteria.
 
***********************************************************************/

public without sharing class LookupRollupHelper 
{
    public String parentName;
    public String childName;
    public String configName;
    
    public String parentRelationshipKey;
    public String parentRelationshipValue;
    public Double RowCount = 0; 
    public RollupConfigs__c config;  
    public String additionalClause {get; set;} // by default the helper gets all children of parent; use this to add SOQL "AND" clauses to filter results
    
	private Set<String> fieldNames;
    private Map<String, RollupConfigs__c> configMap;
    private Map<String, String> childFieldMap;
    private Map<String, String> parentFieldMap;
    private Set<String> queryFields;
    private Map<String, String> childToParentMap;
    
    private final String QUERY_FIELD_PREFIX = 'queryfield';
    private final String PARENT_QUERY_FIELD_PREFIX = 'parentqueryfield';    
    private final Integer MAX_LENGTH_ALIAS = 22; //Actual max is 25, however leave 3 characters for numbers
    
    public static Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
          
    public LookupRollupHelper( String childName, String parentName)
    {
    	this.childName = childName;
        this.parentName = parentName;
        this.parentRelationshipKey = 'queryfield_parentrelationshipname__c'; 
        
        // If this is a rollup of Subscription__c records then reduce the scope of records
        if (childName == 'Subscription__c')
        {
        	additionalClause = ' AND RecordType.Name = \'MBA Subscription\'';
        }
        
        initConfiguration();                
    }
 // add criteria   
    public LookupRollupHelper( String childName, String parentName, string configName)
    {
    	this.childName = childName;
        this.parentName = parentName;
        this.configName = configName;
        this.parentRelationshipKey = 'queryfield_parentrelationshipname__c'; 
      
        initConfigByName();                
    }
    private void updateParentIdToChildAndParentIdSet(Id parentId, sObject child, Set<Id> parentIds, Map<Id,List<sObject>> parentIdToChild) {
    	//This will be used for error handling
		if( !parentIdToChild.containsKey(parentId) ) {
			List<sObject> tmpList = new List<sObject>();
			tmpList.add(child);
			parentIdToChild.put(parentId,tmpList);			
		} else {
			parentIdToChild.get(parentId).add(child);
		}
		
		if(parentId != null) {											
			parentIds.add(parentId);
		}		
    }
    
    
    public void rollupSummary(List<SObject> childObjectList, List<SObject> oldChildObjectList) 
    {
    	SObjectUtils.lookUpRollUpIsRunning = true;
    	
		System.debug('--------------> Starting rollupSummary');		
		System.debug('childObjectList: ' + childObjectList );
		
		try
		{
			if(childObjectList != null && childObjectList.size() > 0 && parentRelationshipValue != null && parentRelationshipValue.length() > 0) {				
				Set<Id> parentIds = new Set<Id>();
				
				//This will be used for error handling
				Map<Id,List<sObject>> parentIdToChild = new Map<Id,List<sObject>>(); 
				
				Integer i = 0;		
				for ( sObject child : childObjectList )
				{
					Id parentId = (Id)child.get(parentRelationshipValue);
					
					//If we have an old child list then compare parent Ids...
					if(oldChildObjectList != null && i < oldChildObjectList.size()) {
						Id oldParentId = (Id)(oldChildObjectList[i].get(parentRelationshipValue));
						if(oldParentId != parentId) {
							updateParentIdToChildAndParentIdSet(oldParentId, child, parentIds, parentIdToChild);
						}
					} 
					
					//Also do this for the new child
					updateParentIdToChildAndParentIdSet(parentId, child, parentIds, parentIdToChild);		
					i++;
				}
				
				/*
					Here's where you actually invoke the lookup code...
				*/
				// assign the rollups to the parent...
				if ( parentIds != null && parentIds.size() > 0 )
				{
					System.debug('updating parents to reflect new totals...');
							
				    /* 
				    	Use the "additionalClause" property to add filter clauses if you don't want to rollup all children
				    */
				    String query = 'SELECT Id FROM ' + this.parentName + ' WHERE ID IN (' + getFormattedIdList(parentIds) + ') FOR UPDATE';
				    List<SObject> parentObjectList = Database.query(query);	
				    System.debug('parentObjectList = ' + parentObjectList);	    
				    
				    sumChildren(parentObjectList);  
					
					/* 
				    	Update the parent to reflect the new rollup counts
				    */
					System.debug('saving parents!');
					Database.Saveresult[] results = Database.update(parentObjectList, false);	      
			  		//We don't want to fail every child, only those that have a matching parent that failed
			    	for(Database.Saveresult result : results) {
			    		System.debug('result : ' + result);
			            if(!result.isSuccess()) 
			            {					
					        String allErrorsForOneRecord = '';                 
					        for(Database.Error err : result.getErrors()) 
					        {
			  			  		System.debug('adding error: ' + err.getMessage() );              		
						        allErrorsForOneRecord += err.getMessage(); 
					      	}
						    System.debug('result is: ' + result);
						    System.debug('result.id is: ' + result.getId() );
						    
						    List<sObject> children = parentIdToChild.get(result.getId());
						    if(children != null) {
							    for(SObject child : children) {
							    	child.addError('Rollup Summary Error: ' + allErrorsForOneRecord);
							    }
						    } else {
						    	System.debug('UNKNOWN ERROR!');
						    }	                               
			            }                       
			      	}       	      		
				} //end if
			}
		}
		catch(Exception e)
		{
			ErrorEmailHelper.notifyOnError('LookupRollupHelper', 'rollupSummary', 'Error in rollupSummary', e.getMessage());
		}
		
		SObjectUtils.lookUpRollUpIsRunning = false;
	}
    
    public void initConfiguration() 
    {
    	try
    	{
	    	// get all the fields from the config
	        this.fieldNames = getFieldsFromRollupConfigs();
	        System.debug('fieldNames = ' + fieldNames);
	        
	        // get the config we are interested in
	        this.configMap = RollupConfigs__c.getAll();
	        config = getCurrentConfig( configMap, this.parentName, childName );
	        
	        // build a map of query fields/values
	        this.childFieldMap = getSpecifiedFieldMap( config, fieldNames, QUERY_FIELD_PREFIX );
	        System.debug('sumChildren:childFieldMap: ' + childFieldMap);
	        // build a map of parent fields/values
	        this.parentFieldMap = getSpecifiedFieldMap( config, fieldNames, PARENT_QUERY_FIELD_PREFIX );
	        
	        // build a set of the fields we're interested in to query
	        this.queryFields = new Set<String>();
	        queryFields.addAll( childFieldMap.values() );  
	        System.debug('sumChildren:queryFields: ' + queryFields);
	        
	        // build the map of child/parent fields
	        this.childToParentMap = getChildParentMap(childFieldMap, parentFieldMap);
	        
	        additionalClause = config.criteria__c;
    	}
    	catch (Exception e)
    	{
    		ErrorEmailHelper.notifyOnError('LookupRollupHelper', 'initConfiguration', 'Error in initConfiguration', e.getMessage());         
    	}            
    }
    public void initConfigByName() 
    {
    	try
    	{
	    	// get all the fields from the config
	        this.fieldNames = getFieldsFromRollupConfigs();
	        System.debug('fieldNames = ' + fieldNames);
	        
	        // get the config we are interested in
	        this.configMap = RollupConfigs__c.getAll();
	        config = getConfig( configMap, this.configName );
	        
	        // build a map of query fields/values
	        this.childFieldMap = getSpecifiedFieldMap( config, fieldNames, QUERY_FIELD_PREFIX );
	        System.debug('sumChildren:childFieldMap: ' + childFieldMap);
	        // build a map of parent fields/values
	        this.parentFieldMap = getSpecifiedFieldMap( config, fieldNames, PARENT_QUERY_FIELD_PREFIX );
	        
	        // build a set of the fields we're interested in to query
	        this.queryFields = new Set<String>();
	        queryFields.addAll( childFieldMap.values() );  
	        System.debug('sumChildren:queryFields: ' + queryFields);
	        
	        // build the map of child/parent fields
	        this.childToParentMap = getChildParentMap(childFieldMap, parentFieldMap);
	        
	        additionalClause = config.criteria__c;
    	}
    	catch (Exception e)
    	{
    		ErrorEmailHelper.notifyOnError('LookupRollupHelper', 'initConfiguration', 'Error in initConfiguration', e.getMessage());         
    	}            
    }
	public void sumChildren( List<sObject> parentList)
     {
        if ( parentList != null && parentList.size() > 0 )
        {                       
            // get the Ids
            Set<Id> parentIds = getIdsFromObjects(parentList);
                        
            // query for the children
            List<sObject> resultList = queryForChildren( parentIds, childFieldMap, this.parentName, childName, childToParentMap, queryFields, parentRelationshipValue );
            
            // assign rollups to parents
            assignRollupResults( resultList, parentList);
        } 
     }
     
    public Map<String, String> getSpecifiedFieldMap( RollupConfigs__c config, Set<String> fieldNames, String fieldType )
    {
        System.debug( 'Start getSpecifiedFieldMap');
        Map<String, String> fieldMap = new Map<String, String>();
        System.debug( 'getting fieldMap for type (' + fieldType + '); config, fieldNames: ' + config + ', ' + fieldNames );
        if ( config != null && fieldNames != null && fieldType != null)
        {
            for ( String key : fieldNames )
            {
                System.debug('specified field map: examining field: ' + key);
                // only work with query fields we're interested in...
                if ( key.toLowerCase().startsWith( fieldType )) 
                {
                    System.debug('adding queryField: ' + key );
                    String val = (String)config.get( key );
                    System.debug('adding key/val pair: ' + key + ', ' + val );
                    if ( val != null && key.toLowerCase() != parentRelationshipKey.toLowerCase())
                    {
                        System.debug( 'adding val to fieldmap: ' + val);
                        fieldMap.put( key, val );               
                    }
                    else if ( key.toLowerCase() == parentRelationshipKey.toLowerCase())
                    {
                        System.debug( 'adding parent relationship to fieldmap: ' + val);
                        parentRelationshipValue = val;
                    }                   
                }   
            }   
        }
        System.debug('returning fieldMap for '+ fieldType +': ' + fieldMap );
        return fieldMap;
    }
    
    public Map<String, String> getChildParentMap( Map<String, String> childFieldMap, Map<String, String> parentFieldMap )
    {
        System.debug( 'getting child/parent map for child: ' + childFieldMap );
        System.debug( 'getting child/parent map for parent: ' + parentFieldMap );
        Map<String, String> childToParentMap = new Map<String, String>();
        
        // first lets process the parent map to make it easier to match after we process the child field names below...
        Map<String, String> tmpParentMap = new Map<String, String>();
        for ( String p : parentFieldMap.keyset() )
        {
            String parentValue = parentFieldMap.get( p );
            // first, strip off "__c" and work with the word stem
            System.debug('--------------> parsing parent field ' + p + ' value is: ' + parentValue );
            List<String> splitted = p.split('__c');
            String theFieldName = splitted[0];
            System.debug('--------------> parent field split: ' + theFieldName );
            // strip off the parentfield prefix...  
            String fieldNumber = theFieldName.substring(PARENT_QUERY_FIELD_PREFIX.length());
            System.debug('--------------> parent field number: ' + fieldNumber );   
            
            String queryField = childFieldMap.get(QUERY_FIELD_PREFIX + fieldNumber + '__c');
            if ( queryField != null )
            {
                childToParentMap.put(queryField, parentFieldMap.get( p ) );
            }
        }
        
        System.debug('returning childToParentMap: ' + childToParentMap);
        return childToParentMap;
    }
    
    public List<sObject> queryForChildren( Set<ID> parentIds, Map<String, String> childFieldMap, String parentName, 
                                            String childName, Map<String, String> childToParentMap, Set<String> queryFields, String parentRelationshipValue )
    {
        if ( parentIds != null && childFieldMap != null && queryFields != null && childName != null && parentName != null )
        {
            String ids = getFormattedIdList( parentIds ); 
            System.debug('should be querying for queryFields: ' + queryFields);
            List<SObject> resultList = getSumsOfFullSObject(childName, parentName, childToParentMap, parentRelationshipValue, 'WHERE ' + parentRelationshipValue + ' IN (' + ids + ')');
            System.debug ('resultList: ' + resultList );
            return resultList;
        }
        else
        {
            return null;
        }
    } 
    
    public List<SObject> getSumsOfFullSObject(String objectName, String parentField, Map<String, String> childToParentMap, String parentRelationshipValue, String whereClause) 
    {
    	System.debug('getSumsOfFullSObject:FieldstoQuery: ' + childToParentMap.keySet());
    	System.debug('getSumsOfFullSObject:childToParentMap: ' + childToParentMap);
    	    	       
        List<SObject> fullObjects;
        
        try 
        {
            String allFields;
            
            // build up the query fields
            if(!childToParentMap.isEmpty()) 
            {
            	Integer counter = 0;
	            for (string fieldName : childToParentMap.keySet()) 
	            {
	                // create a field alias for assigning the values
	                String parentName = '';
	                if ( childToParentMap != null )
	                {
	                    parentName = childToParentMap.get( fieldName ); 
	                }
	                
	                System.debug('getSumsOfFullSObject:parentName: ' + parentName);
	                System.debug('getSumsOfFullSObject:counter: ' + counter);
	                System.debug('getSumsOfFullSObject:childToParentMap.size(): ' + childToParentMap.size());
	                
	                if ( fieldName != null )
	                {
	                	Integer trimUntil = MAX_LENGTH_ALIAS;
	                	trimUntil = Math.min(MAX_LENGTH_ALIAS, parentName.length());
	                    if(allFields == null) 
	                    {	                    	 
	                        allFields = 'sum(' + fieldName + ') ' + parentName.substring(0,trimUntil) + counter;
	                    } 	                        
	                    else 
	                    {	                    		                       
	                        allFields = allFields + ', ' + 'sum(' + fieldName + ') ' + parentName.substring(0,trimUntil) + counter;
	                    }   
	                }
	                counter++;   
	            }
            }
            
            System.debug('getSumsOfFullSObject:allFields: ' + allFields);
    	            
            if(allFields == null || allFields.length() == 0) {            	
            	allFields = 'count(Id) RowCount';            	
            } else {
	            // count the number of child objects
	            allFields = allFields + ', ' + 'count(Id) RowCount';
            }
            
            System.debug('getSumsOfFullSObject:parentField: ' + parentField);
    	                
            // add the parent field relationship to the select list
            if ( parentField != null )
            {
                allFields = allFields + ',' + parentRelationshipValue;  
            }
            
            System.debug('getSumsOfFullSObject:allFields: ' + allFields);
            
            String qry = 'SELECT ' + allFields + ' FROM ' + objectName;
            
            System.debug('getSumsOfFullSObject:whereClause: ' + whereClause);            
            
            if(whereClause != null) 
            {
                if(whereClause.contains('WHERE')) 
                {
                    if(whereClause.startsWith(' WHERE ')) 
                    {
                        qry = qry + whereClause;
                    } 
                    else 
                    {
                        qry = qry + ' ' +whereClause;
                    }
                } 
                else 
                {
                    qry = qry + ' WHERE ' + whereClause;
                }
                if (additionalClause != null )
                {
                    qry = qry + ' ' + additionalClause;
                }
            }
                                    
            // add the group by clause
            if ( parentField != null )
            {
                qry = qry + ' GROUP BY ' + parentRelationshipValue;
            }
            System.debug('The query = ' + qry);
            fullObjects = Database.query(qry);
        }
        catch ( Exception e )
        {
            system.debug('caught exception getting aggregate query: ' + e.getMessage() );        
			ErrorEmailHelper.notifyOnError('LookupRoolupHelper', 'getSumsOfFullSObject', 'Error in getSumsOfFullSObject', e.getMessage());			
        }       
        return fullObjects;
    }
     
    public void assignRollupResults( List<sObject> resultList, List<sObject> parentList)
    {
        System.debug('starting assignRollupResults. resultList is: ' + resultList );
        // initialize the parentlist to null in case rollups do not apply...
        Map<Id,sObject> parentObjectMap = new Map<Id, sObject>();
        if ( parentList != null && parentList.size() > 0 )
        {
            for ( sObject parent : parentList )
            {
                parentObjectMap.put( parent.Id, parent );   
            }
        }   
        
        // parse out the aggregate results...
        List<AggregateResult> rollups = new List<AggregateResult>();
        if ( resultList != null && resultList.size() > 0 )
        {
            rollups = (List<AggregateResult>)resultList;
            for ( AggregateResult ar : rollups )
            {
                System.debug( 'looking at rollup: ' + ar );
                System.debug( 'trying to get parent by parentRelationshipValue: ' + parentRelationshipValue);
                Id parentId = (Id)ar.get( parentRelationshipValue );
                SObject parentObject = parentObjectMap.get(parentId);
                RowCount = (Double)ar.get('RowCount');
                // put the total count intot he config; might not be a field on the parent object to hold, so put it into config if needed
                System.debug('rowCount is: ' + rowCount );
                if ( config.parentRowCount__c != null)
                {
                	try 
                	{
                    	parentObject.put(config.parentRowCount__c, RowCount );
                	} 
                	catch (Exception exp) 
                	{
                		if(exp.getMessage().contains('Illegal assignment from Double to Integer')) 
                		{
                			parentObject.put(config.parentRowCount__c, RowCount.intValue() );
                		}
                	}
                }
                
                if ( childToParentMap != null )
                {
                    try
                    {
                    	Integer counter = 0;
                        for ( String s : childToParentMap.keySet() ) 
                        {
                            System.debug( 'getting value for field: ' + s );
                            String parentField = childToParentMap.get( s );
                            
                            Integer trimUntil = MAX_LENGTH_ALIAS;
                        	trimUntil = Math.min(MAX_LENGTH_ALIAS, parentField.length());
                        	                            
                            String parentFieldALIAS = parentField.subString(0,trimUntil) + counter;
                            
                            System.debug( '-->filling parent field: ' + parentField );
                            System.debug( '-->parentField value: ' + ar.get( parentFieldALIAS ));
                            
                            Double parentFieldValue = (Double)ar.get( parentFieldALIAS );
                            if ( parentFieldValue == null ) parentFieldValue = 0;
                            parentObject.put( parentField, parentFieldValue );
                            counter++;    
                        }
                    }
                    catch (Exception e)
                    {
                        System.debug('caught exception: ' + e.getMessage() );                        
                        ErrorEmailHelper.notifyOnError('LookupRollupHelper', 'assignRollupResults', 'Error in assignRollupResults', e.getMessage());
                    }   
                }
            }
        }
        else
        {
            System.debug('no result list found -- zero-out the values');
            try
            {
                System.debug('parentList: ' + parentList );
                System.debug('parentObjectMap: ' + parentObjectMap );
                if ( parentList != null && parentList.size() > 0 )
                {
                    for ( SObject parent : parentList )
                    {
                        SObject parentObject = parentObjectMap.get(parent.Id);
                        for ( String s : childToParentMap.keySet() ) 
                        {
                                System.debug( 'getting value to zero-out field: ' + s );
                            String parentField = childToParentMap.get( s );
                                System.debug( '-->filling parent field: ' + parentField );
                                System.debug( '-->parentField value: 0' );
                            Double parentFieldValue = 0;                    
                            parentObject.put( parentField, parentFieldValue );                  
                        }   
                        // zero-out the count, if it exists
                        if ( config.parentRowCount__c != null)
                        {
                            Double tmpParentRowCount = 0;
                            try {
                            	parentObject.put(config.parentRowCount__c, tmpParentRowCount );
                            } catch(Exception exp) {
                            	if(exp.getMessage().contains('Illegal assignment from Double to Integer')) {                            		
                					parentObject.put(config.parentRowCount__c, tmpParentRowCount.intValue());
                				}
                            } //catch 
                        }
                    } // for                   
                }               
            }
            catch (Exception e)
            {
                System.debug('caught exception: ' + e.getMessage() );
                ErrorEmailHelper.notifyOnError('LookupRollupHelper', 'assignRollupResults', 'Error in assignRollupResults', e.getMessage());               	
            }   
        }
        
                
    }

/*
    simple helper methods...
*/
    public Set<Id> getIdsFromObjects( List<sObject> objList )
    {
        
        Set<Id> ids = new Set<Id>();
        if ( objList != null && objList.size() > 0 ) 
        {
            for ( sObject obj : objList )
            {
                ids.add( obj.Id );
            }
        }
        return ids;
    }
    
    public Set<String> getFieldsFromRollupConfigs( )
    {
        System.debug('starting getFieldsFromObject');
        Set<String> fieldNames = new Set<String>(); 
        
        Map<String, Schema.SObjectField> tmpFieldMap = Schema.SObjectType.RollupConfigs__c.fields.getMap();
        if ( tmpFieldMap != null ) fieldNames.addAll(tmpFieldMap.keySet());
        System.debug('fieldNames: ' + fieldNames);       
        return fieldNames;
    }
        
    public RollupConfigs__c getCurrentConfig( Map<String, RollupConfigs__c> configMap, String parentName, String childName )
    {       
        System.debug( 'getting current config; configMap: ' + configMap );
        if ( configMap != null && configMap.values().size() > 0 )
        {
            
            for ( RollupConfigs__c config : configMap.values() )
            {
                System.debug( '--> Parsing for object ' + config.name );
                if ( config.Parent_Object__c != null && config.Parent_Object__c == parentName && config.Child_Object_Name__c != null && config.Child_Object_Name__c == childName )
                {
                    return config;
                }   
            }   
        }
        return null;
    }
    public RollupConfigs__c getConfig(  Map<String, RollupConfigs__c> configMap, String configName )
    {       
        System.debug( 'getting current config; configMap: ' + configMap );
        if ( configMap != null && configMap.values().size() > 0 )
        {
            
            for ( RollupConfigs__c config : configMap.values() )
            {
                System.debug( '--> Parsing for name ' + config.name );
                if ( config.Name  == configName )
                {
                    return config;
                }   
            }   
        }
        return null;
    }
    public String getFormattedIdList( Set<Id> incomingIds )
    {   
    	String formattedStr = null;  
        if ( incomingIds != null )
        {        
	        formattedStr = '';
	        String sep = '';
	        for ( Id id : incomingIds )
	        {
	            formattedStr = formattedStr + sep + '\'' + id + '\'';
	            sep = ', ';
	        }
        }
        return formattedStr;
    } 
}