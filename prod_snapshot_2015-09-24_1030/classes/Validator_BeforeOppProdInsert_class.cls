// CC Ph2 - Find where this is used, there's probably a better way.
// <CC> this controls the worlflow of the trigger
// <refactor> this refactor depends on the refactoring of the triggers
// <refactor> put this variable into a service class that all triggers can access the global variable 
// <refactor> bring this logic into service class 
// <CC> used to flag opportunity line item has been updated from an opportunity 

public with sharing class Validator_BeforeOppProdInsert_class {

	private static boolean blnAlreadyDone = false;
	
	public static boolean hasAlreadyDone(){
		return blnAlreadyDone;
	}
	public static void setAlreadyDone() {
		system.debug('Setting Validator_BeforeOppProdInsert_class.blnAlreadyDone to true');
		blnAlreadyDone = true;
	}
}