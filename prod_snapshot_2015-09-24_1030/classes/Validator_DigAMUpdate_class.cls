// CC Ph2 - Find where this is used, there's probably a better way.
// <CC> this controls the worlflow of the trigger
// <refactor> this refactor depends on the refactoring of the triggers
// <refactor> put this variable into a service class that all triggers can access the global variable 
// <refactor> bring this logic into service class 
// <CC> used to flag opportunity line item has been updated from an opportunity 

public with sharing class Validator_DigAMUpdate_class {
	private static boolean damAlreadyDone = false;

	public static boolean hasDAMAlreadyDone(){
		
		return damAlreadyDone;
	}
	public static void setDAMAlreadyDone() {
		system.debug('Setting Validator_DigAMUpdate_class.blnAlreadyDone to true');
		damAlreadyDone = true;
	}
	public static void resetDAMAlreadyDone() {damAlreadyDone = false;}
}