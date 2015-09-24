// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class Validator_afteronProject_cls {

	private static boolean blnAlreadyDone_pj = false;
	
	public static boolean hasAlreadyDone(){
		return blnAlreadyDone_pj;
	}
	public static void setAlreadyDone() {
		system.debug('Setting Validator_afteronProject_cls.blnAlreadyDone to true');
		blnAlreadyDone_pj = true;
	}
}