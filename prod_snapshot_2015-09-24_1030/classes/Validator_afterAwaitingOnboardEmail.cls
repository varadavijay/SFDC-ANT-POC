// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class Validator_afterAwaitingOnboardEmail {

	private static boolean blnAlreadyDone_ao = false;
	
	public static boolean hasAlreadyDone(){
		return blnAlreadyDone_ao;
	}
	public static void setAlreadyDone() {
		system.debug('Setting Validator_afterAwaitingOnboardEmail.blnAlreadyDone to true');
		blnAlreadyDone_ao = true;
	}
}