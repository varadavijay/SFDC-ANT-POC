// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class Validator_MarketUpdate_class {
	private static boolean blnAlreadyDone = false;
	
	public static boolean hasAlreadyDone(){
		return blnAlreadyDone;
	}
	public static void setAlreadyDone() {
		system.debug('Setting Validator_MarketUpdate_class.blnAlreadyDone to true');
		blnAlreadyDone = true;
	}
}