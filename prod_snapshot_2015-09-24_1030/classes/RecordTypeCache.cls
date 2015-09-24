/***************************************
 * This class is used to create a recordType cache via "lazy loading". If a given execution context doesn't request 
 * a recordType, then the cache will never be loaded. If it is requested once, then it will be loaded and 
 * stored for the duration of that execution context making subsequent SOQL queries unnecessary.
 ***************************************/

public with sharing class RecordTypeCache {
	private static Map<String, RecordType> recordTypeMap = null;
	
	// The combination of developerName and SObject type is unique, so use that as the key for the Map
	public static RecordType getRecordType(String sObjectType, String developerName){
		if(recordTypeMap == null){
			recordTypeMap = new Map<String, RecordType>();
			
			//Get all active RecordTypes
			List<RecordType> recordTypes = [SELECT Id, SobjectType, Name, DeveloperName
											FROM RecordType
											WHERE IsActive = true];
			
			// use sObjectType + ':' + DeveloperName as the key for the Map
			for(RecordType rt : recordTypes){
				recordTypeMap.put(rt.SobjectType + ':' + rt.DeveloperName, rt);
			}
		}
		
		// At this point it's loaded
		if (recordTypeMap.containsKey(sObjectType + ':' + developerName)){
			return recordTypeMap.get(sObjectType + ':' + developerName);
		}
		else{
			// not found, return null
			return null;
		}		
	}
	
}