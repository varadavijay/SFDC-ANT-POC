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
@isTest
private class beforeonContact_cls {
	// <refactor> Test Class - not only not named to identify it as such, but actually has "Class" in it's name
	
    static testMethod void testBeforeContactTrigger() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();

        Account azRepAcct = Constants.AZ_REPUBLIC_COMPANY;
        
        List<Contact> contacts = TestData_Contact.CreateContacts('Bob', 'Barker', 2);
        // <refactor> both contacts are the same, can assign values in for loop 
        contacts[0].recordTypeId = RecordTypeCache.getRecordType('Contact', 'Affiliated').id;
        contacts[0].AccountId = azRepAcct.id;
        contacts[0].KPI_Refresh__c = False;
        
        contacts[1].recordTypeId = RecordTypeCache.getRecordType('Contact', 'Affiliated').id;
        contacts[1].AccountId = azRepAcct.id;
        contacts[1].KPI_Refresh__c = False;
        insert contacts;
        
        List<Lead> leads = TestData_Lead.createLeads('FirstName', 'KPITest', 'Barker Test', 1);
        leads[0].RecordTypeId = RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id;
        leads[0].SalesRep__c = contacts[1].Id;
        insert leads;
        
        // <refactor> test data creation utility should be used to create test data 
        Account a2 = new Account();
        a2.Name = 'Barker Test';
        insert a2;
        
        List<Opportunity> opptys = TestData_Opportunity.createOpportunities('Barker Opp', 1);
        opptys[0].AccountId = a2.Id;
        opptys[0].StageName = 'Closed Won';
        opptys[0].CloseDate = date.today().addDays(2);
        opptys[0].RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id;
        opptys[0].Sales_Rep__c = contacts[1].Id;
        opptys[0].Amount = 500;
        insert opptys;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        contacts[1].KPI_Refresh__c = True;
        update contacts[1];
        
        Contact KPI_AfflTest = [SELECT Id,
        							   KPI_Dig_Audit_Closed__c,
        							   KPI_Dig_Audit_Converts__c,
        							   KPI_Dig_Audit_Requests__c,
        							   KPI_Dig_Audit_Won_Value__c
        						FROM Contact
        						WHERE Id = :contacts[1].Id];

        if(KPI_AfflTest != null){ // <logic> use asssertion here 
	        System.assertEquals(1, KPI_AfflTest.KPI_Dig_Audit_Closed__c); // <refactor> need assertion message 
	        System.assertEquals(0, KPI_AfflTest.KPI_Dig_Audit_Converts__c); // <refactor> need assertion message 
	        System.assertEquals(1, KPI_AfflTest.KPI_Dig_Audit_Requests__c); // <refactor> need assertion message 
	        System.assertEquals(500, KPI_AfflTest.KPI_Dig_Audit_Won_Value__c); // <refactor> need assertion message 
        }
        else{
        	// <logic> simplify logic here to get rid of empty else block 
        	//Using assert as debug - we know it'll fail if we get here
        	system.assertEquals('KPI_AfflTest to not be null', 'It\'s Null');
        }
    }
}