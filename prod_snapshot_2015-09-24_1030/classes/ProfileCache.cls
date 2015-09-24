/***************************************
 * This class is used to create a profile cache via "lazy loading". If a given execution context doesn't request 
 * a profile, then the cache will never be loaded. If it is requested once, then it will be loaded and 
 * stored for the duration of that execution context making subsequent SOQL queries unnecessary.
 ***************************************/

public with sharing class ProfileCache {
	private static Map<String, Profile> profileMap = null;
	
	// Profile Name is unique, so use that as the key for the Map
	public static Profile getProfile(String profileName){
		if(profileMap == null){
			profileMap = new Map<String, Profile>();
			
			//Get all active Profiles
			List<Profile> profiles = [SELECT Id, Name
									  FROM Profile];
			
			// use Profile Name as the key for the Map
			for(Profile prof : profiles){
				profileMap.put(prof.Name, prof);
			}
		}
		
		// At this point it's loaded
		if (profileMap.containsKey(profileName)){
			return profileMap.get(profileName);
		}
		else{
			// not found, return null
			return null;
		}		
	}
	
}