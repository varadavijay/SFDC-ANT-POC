// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class Validator_beforeonContact_class {
	private static boolean blnAlreadyDone_bc = false;
	
	public static boolean hasAlreadyDone(){
		return blnAlreadyDone_bc;
	}
	public static void setAlreadyDone() {
		system.debug('Setting Validator_beforeonContact_class.blnAlreadyDone to true');
		blnAlreadyDone_bc = true;
	}
}