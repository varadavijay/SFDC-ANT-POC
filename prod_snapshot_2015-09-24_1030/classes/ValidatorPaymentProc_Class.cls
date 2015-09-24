// CC Ph2 - Find where this is used, there's probably a better way.


public with sharing class ValidatorPaymentProc_Class {
	private static boolean blnAlreadyDonePP = false;
	
	public static boolean hasAlreadyDonePP(){
		return blnAlreadyDonePP;
	}
	public static void setAlreadyDone() {
		system.debug('Setting ValidatorPaymentProc_Class.blnAlreadyDone to true');
		blnAlreadyDonePP = true;
	}
}