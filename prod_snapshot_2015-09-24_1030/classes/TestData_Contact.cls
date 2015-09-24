/***************************************
 * This Class is used to create test data for contact objects. The design priciple follwed
 * is that the main CreateContacts() method should be the method used to create a list of
 * Contacts with only the default attributes filled in. The calling test class should then fill in 
 * the other data accordingly.
 ***************************************/

public with sharing class TestData_Contact {

	// Return a list of contacts named based on a string and a number passed in
	// Set all required values - any new required values should be added to the loop
	// If numberToCreate < 1, the list will still be returned, but it will be empty
	public static List<Contact> createContacts(String baseFirstName, String baseLastName, Integer numberToCreate){
		List<Contact> contacts = new List<Contact>();
		for (Integer i=1; i <= numberToCreate; ++i ){
			Contact con = new Contact();
			
			// Name is not writable, it's a concat of First and Last, but only Last Name is required.
			con.FirstName = baseFirstName + String.valueOf(i);
			con.LastName = baseLastName + String.valueOf(i);
			
			//Add to List
			contacts.add(con);
		}
		return contacts;
	}
	
	// Create a list using the method above, with "Test_ Contact_" as the baseName	
	public static List<Contact> createContacts(Integer numberToCreate){
		return createContacts('Test_', 'Contact_', numberToCreate);
	}

	// Create a single Contact using the method above 
	// NOTE: This is NOT reccomended, it's better to always use list variables! But it will simplify the
	// refactoring of the current test classes to use it on occation.
	// NOTE2: this will append a "1" to the end of the Contact Name.
	public static Contact createSingleContact(string contactFirstName, string contactLastName){
		List<Contact> contacts = createContacts(contactFirstName, contactLastName, 1);
		return contacts[0];
	}
	
} // class