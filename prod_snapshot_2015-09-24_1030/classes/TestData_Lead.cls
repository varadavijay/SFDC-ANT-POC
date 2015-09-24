/***************************************
 * This Class is used to create test data for lead objects. The design priciple follwed
 * is that the main CreateLeads() method should be the method used to create a list of
 * Leads with only the default attributes filled in. The calling test class should then fill in 
 * the other data accordingly.
 ***************************************/

public with sharing class TestData_Lead {

	// Return a list of leads named based on a string and a number passed in
	// Set all required values - any new required values should be added to the loop
	// If numberToCreate < 1, the list will still be returned, but it will be empty
	public static List<Lead> createLeads(String baseFirstName, String baseLastName, String baseCompanyName, Integer numberToCreate){
		List<Lead> leads = new List<Lead>();
		for (Integer i=1; i <= numberToCreate; ++i ){
			Lead leadToAdd = new Lead();
			
			// Name is not writable, it's a concat of First and Last, but only Last Name is required.
			leadToAdd.FirstName = baseFirstName + String.valueOf(i);
			leadToAdd.LastName = baseLastName + String.valueOf(i);
			leadToAdd.Company = baseCompanyName + String.valueOf(i);
			
			//Add to List
			leads.add(leadToAdd);
		}
		return leads;
	}
	
	// Create a list using the method above, with "Test_ Lead_" as the baseName	and "TL_Company_" as the base Company
	public static List<Lead> createLeads(Integer numberToCreate){
		return createLeads('Test_', 'Lead_', 'TL_Company_', numberToCreate);
	}

	// Create a single Lead using the method above 
	// NOTE: This is NOT reccomended, it's better to always use list variables! But it will simplify the
	// refactoring of the current test classes to use it on occation.
	// NOTE2: this will append a "1" to the end of the Lead Name.
	public static Lead createSingleLead(String leadFirstName, String leadLastName, String leadCompany){
		List<Lead> leads = createLeads(leadFirstName, leadLastName, leadCompany, 1);
		return leads[0];
	}
	
} // class