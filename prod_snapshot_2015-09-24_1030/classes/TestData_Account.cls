/***************************************
 * This Class is used to create test data for account objects. The design priciple follwed
 * is that the main CreateAccounts() method should be the method used to create a list of
 * Accounts with only the default attributes filled in. The calling test class should then fill in 
 * the other data accordingly.
 ***************************************/

public with sharing class TestData_Account {

	// Return a list of accounts named based on a string and a number passed in
	// Set all required values - any new required values should be added to the loop
	// If numberToCreate < 1, the list will still be returned, but it will be empty
	public static List<Account> createAccounts(String baseName, Integer numberToCreate){
		List<Account> accounts = new List<Account>();
		for (Integer i=1; i <= numberToCreate; ++i ){
			Account acct = new Account();
			
			// Assign all Required Fields here
			acct.Name = baseName + String.valueOf(i);
			
			//Add to List
			accounts.add(acct);
		}
		return accounts;
	}
	
	// Create a list using the method above, with "TestAccount_" as the baseName	
	public static List<Account> createAccounts(Integer numberToCreate){
		return createAccounts('TestAccount_', numberToCreate);
	}

	// Create a single Account using the method above 
	// NOTE: This is NOT reccomended, it's better to always use list variables! But it will simplify the
	// refactoring of the current test classes to use it on occation.
	// NOTE2: this will append a "1" to the end of the Account Name.
	public static Account createSingleAccount(string accountName){
		List<Account> accounts = createAccounts(accountName, 1);
		return accounts[0];
	}
	
} // class