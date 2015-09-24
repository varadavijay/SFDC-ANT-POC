/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

// This class will test all of the testdata creation classes.
@isTest
private class TestData_Test {

    static testMethod void testAccounts() {
        List<Account> accts = TestData_Account.createAccounts('Smiths', 20);
        system.assertEquals(20, accts.size());
        system.assertEquals('Smiths15', accts[14].Name);
        
        // try the insert to make sure there are no required fields missing
        insert accts;
        
        List<Account> acctsNoName = TestData_Account.createAccounts(30);
        system.assertEquals(30, acctsNoName.size());
        system.assertEquals('TestAccount_15', acctsNoName[14].Name);
        
        // try the insert to make sure there are no required fields missing
        insert acctsNoName;
        
        Account acct = TestData_Account.CreateSingleAccount('Fred');
        system.assertEquals('Fred1', acct.Name);

        // try the insert to make sure there are no required fields missing
        insert acct;
        
    } //testAccounts()
    
    static testMethod void testOpportunities() {
    	// We need the constants loaded for the OppPusher trigger
    	Constants.loadData();
    	
        // <PWP> Rework needed on the Opp triggers. This test fails with more than 10 Opps
        List<Opportunity> opptys = TestData_Opportunity.createOpportunities('Best Buy', 5);
        system.assertEquals(5, opptys.size());
        system.assertEquals('Best Buy5', opptys[4].Name);
        
        
        List<Opportunity> opptysNoName = TestData_Opportunity.createOpportunities(5);
        system.assertEquals(5, opptysNoName.size());
        system.assertEquals('TestOpportunity_3', opptysNoName[2].Name);
        
        Test.startTest();
        // try the inserts to make sure there are no required fields missing
        insert opptys;
        insert opptysNoName;
        Test.stopTest();
        
        Opportunity oppty = TestData_Opportunity.CreateSingleOpportunity('Willma');
        system.assertEquals('Willma1', oppty.Name);

        // try the insert to make sure there are no required fields missing
        insert oppty;
        
    } //testOpportunities()
    
    static testMethod void testCases(){
    	List<Case> cases = TestData_Case.createCases(40);
    	system.assertEquals(40, cases.size());
    	insert cases;

		List<Case> selectedCases = [SELECT Id, CaseNumber FROM Case WHERE id = :cases[4].Id];    	
    	
        if(selectedCases.size() == 1){
        	system.assertNotEquals(null , selectedCases[0].CaseNumber);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Case to be selected', selectedCases.size() + ' Cases selected');
        }
    } // testCases()
    
	static testMethod void testContacts() {
        
        /**** Test the First and Last Name version ****/
        List<Contact> contacts = TestData_Contact.createContacts('Fred', 'Flintstone', 50);
        system.assertEquals(50, contacts.size());

		// We need to insert the contacts in order for calculated and default fields to be available
        insert contacts;
        
        //Save ID for 37th contact to select later
        ID savedId = contacts[36].Id;
        
        List<Contact> selectedContacts = [Select Id, Name, FirstName, LastName FROM Contact WHERE Id = :savedId];
        if(selectedContacts.size() == 1){
	        system.assertEquals('Fred37 Flintstone37', selectedContacts[0].Name);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Contact to be selected', selectedContacts.size() + ' Contacts selected');
        }
        
        /**** Test the number-only version ****/
        List<Contact> contactsNoName = TestData_Contact.createContacts(30);
        system.assertEquals(30, contactsNoName.size());
        insert contactsNoName;
        savedId = contactsNoName[27].Id;
        
        selectedContacts.clear();
        selectedContacts = [Select Id, Name, FirstName, LastName FROM Contact WHERE Id = :savedId];
        
        if(selectedContacts.size() == 1){
        	system.assertEquals('Test_28 Contact_28', selectedContacts[0].Name);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Contact to be selected', selectedContacts.size() + ' Contacts selected');
        }
        
        /**** Test the single Contact version ****/
        Contact con = TestData_Contact.CreateSingleContact('Barney', 'Rubble');
        insert con;
        
        selectedContacts.clear();
        selectedContacts = [Select Id, Name, FirstName, LastName FROM Contact WHERE Id = :con.Id];
        
        if(selectedContacts.size() == 1){
        	system.assertEquals('Barney1 Rubble1', selectedContacts[0].Name);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Contact to be selected', selectedContacts.size() + ' Contacts selected');
        }
        
    } // testContacts()

	static testMethod void testLeads() {
        
        /**** Test the First and Last Name version ****/
        List<Lead> leads = TestData_Lead.createLeads('George', 'Jetson', 'Spacely Sprokets', 50);
        system.assertEquals(50, leads.size());

		// We need to insert the leads in order for calculated and default fields to be available
        insert leads;
        
        //Save ID for 37th lead to select later
        ID savedId = leads[36].Id;
        
        List<Lead> selectedLeads = [Select Id, Name, FirstName, LastName, Company FROM Lead WHERE Id = :savedId];
        if(selectedLeads.size() == 1){
	        system.assertEquals('George37 Jetson37', selectedLeads[0].Name);
	        system.assertEquals('Spacely Sprokets37', selectedLeads[0].Company);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Lead to be selected', selectedLeads.size() + ' Leads selected');
        }
        
        /**** Test the number-only version ****/
        List<Lead> leadsNoName = TestData_Lead.createLeads(30);
        system.assertEquals(30, leadsNoName.size());
        insert leadsNoName;
        savedId = leadsNoName[27].Id;
        
        selectedLeads.clear();
        selectedLeads = [Select Id, Name, FirstName, LastName, Company FROM Lead WHERE Id = :savedId];
        
        if(selectedLeads.size() == 1){
        	system.assertEquals('Test_28 Lead_28', selectedLeads[0].Name);
	        system.assertEquals('TL_Company_28', selectedLeads[0].Company);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Lead to be selected', selectedLeads.size() + ' Leads selected');
        }
        
        /**** Test the single Lead version ****/
        Lead lead = TestData_Lead.CreateSingleLead('Barney', 'Rubble', 'Slate Quarry');
        insert lead;
        
        selectedLeads.clear();
        selectedLeads = [Select Id, Name, FirstName, LastName, Company FROM Lead WHERE Id = :lead.Id];
        
        if(selectedLeads.size() == 1){
        	system.assertEquals('Barney1 Rubble1', selectedLeads[0].Name);
        }
        else{
        	//This assertion will fail, as it should if we get here. So let's use it as a debug statement
        	system.assertEquals('One Lead to be selected', selectedLeads.size() + ' Leads selected');
        }
        
    } // testLeads()  
}