// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class Validator_CancelProjUpdate_class {
	private static boolean canAlreadyDone = false;
	public static boolean hasCANAlreadyDone(){
		
		return canAlreadyDone;
	}
	public static void setCANAlreadyDone() {
		system.debug('Setting Validator_CancelProjUpdate_class.blnAlreadyDone to true');
		canAlreadyDone = true;
	}
}