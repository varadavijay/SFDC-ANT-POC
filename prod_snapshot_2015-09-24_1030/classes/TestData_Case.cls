/***************************************
 * This Class is used to create test data for Case objects. The design priciple follwed
 * is that the main CreateCases() method should be the method used to create a list of
 * cases with only the default attributes filled in. The calling test class should then fill in 
 * the other data accordingly.
 ***************************************/

public with sharing class TestData_Case {

	// Return a list of cases named based on a string and a number passed in
	// Set all required values - any new required values should be added to the loop
	// If numberToCreate < 1, the list will still be returned, but it will be empty
	public static List<Case> createCases(Integer numberToCreate){
		List<Case> cases = new List<Case>();
		for (Integer i=1; i <= numberToCreate; ++i ){
			Case newCase = new Case();
			
			// Assign all Required Fields here
			
			//Add to List
			cases.add(newCase);
		}
		return cases;
	}
	
} // class