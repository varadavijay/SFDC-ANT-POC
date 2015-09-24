/***************************************
 * This Class is used to create test data for opportunity objects. The design priciple follwed
 * is that the main createOpportunities() method should be the method used to create a list of
 * opportunities with only the default attributes filled in. The calling test class should then fill in 
 * the other data accordingly.
 ***************************************/

public with sharing class TestData_Opportunity {

	// Return a list of opportunities named based on a string and a number passed in
	// Set all required values - any new required values should be added to the loop
	// If numberToCreate < 1, the list will still be returned, but it will be empty
	public static List<Opportunity> createOpportunities(String baseName, Integer numberToCreate){
		
		List<Opportunity> opportunities = new List<Opportunity>();
		for (Integer i=1; i <= numberToCreate; ++i ){
			Opportunity oppty = new Opportunity();
			
			// Assign all Required Fields here
			oppty.Name = baseName + String.valueOf(i);
			oppty.CloseDate = Date.today();
			oppty.StageName = 'Prospecting';
			
			//Add to List
			opportunities.add(oppty);
		}
		return opportunities;
	}
	
	// Create a list using the method above, with "TestOpportunity_" as the baseName	
	public static List<Opportunity> createOpportunities(Integer numberToCreate){
		return createOpportunities('TestOpportunity_', numberToCreate);
	}

	// Create a single Opportunity using the method above 
	// NOTE: This is NOT reccomended, it's better to always use list variables! But it will simplify the
	// refactoring of the current test classes to use it on occation.
	// NOTE2: this will append a "1" to the end of the Opportunity Name.
	public static Opportunity createSingleOpportunity(string opportunityName){
		List<Opportunity> opportunities = createOpportunities(opportunityName, 1);
		return opportunities[0];
	}
	
} // class