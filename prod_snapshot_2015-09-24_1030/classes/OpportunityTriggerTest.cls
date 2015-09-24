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
private class OpportunityTriggerTest {

    static testMethod void testOpportunityInsertandUpdate() {
    	// We need the constants loaded for the OppPusher trigger
    	Constants.loadData();
    	
		system.AssertEquals(false, Validator_BeforeOppProdUpdate_class.hasAlreadyDone());
		
		List<Opportunity> opps = TestData_Opportunity.createOpportunities(5);
        system.assertEquals(5, opps.size());
        system.assertEquals('TestOpportunity_3', opps[2].Name);
        
        integer x = 1;
        for(Opportunity opp : opps){
        	opp.Amount = 10*x;
        	++x;
        }
		insert opps;
		
		opps[3].Amount = 500;
		
		system.AssertEquals(false, Validator_BeforeOppProdUpdate_class.hasAlreadyDone());
		update opps[3];
		system.AssertEquals(false, Validator_BeforeOppProdUpdate_class.hasAlreadyDone());
		

    }
    
    @isTest(seeAllData = true)
    static void testOpportunityUpdate() {
    	List<Opportunity> opps = [SELECT id, Name, Amount from Opportunity Where Name = 'TestData Opp'];
    	if(opps != null && opps.size() > 0){
    		opps[0].Amount = 1234;
    		update opps[0];
    	}
    }
    
    //DEV-627 Test method for insert
    static testMethod void testOpportunityInsertWithDigitalAccountManager(){
    	// We need the constants loaded for the OppPusher trigger
    	Constants.loadData();
    	
    	Test.startTest();
    	Account newAccount = TestData_Account.createSingleAccount('Test Digital Account Manager updates');
    	insert newAccount;
    	
    	Opportunity newOpportunity = TestData_Opportunity.createSingleOpportunity('TEST OPPORTUNITY');
    	User anyUser = [SELECT Id FROM User WHERE Profile.Name != 'System Administrator' AND IsActive = True LIMIT 1];
    	
    	newOpportunity.AccountId = newAccount.Id;
    	newOpportunity.Dig_Account_Manager__c = anyUser.Id;
    	newOpportunity.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id;
    	insert newOpportunity;
    	Test.stopTest();
    	
    	newAccount = [Select Account_Manager__c from Account Where Id =: newAccount.Id Limit 1];
    	System.assertEquals(newOpportunity.Dig_Account_Manager__c , newAccount.Account_Manager__c);
    }
    
    //DEV-627 Test method for update
    static testMethod void testOpportunityUpdateWithDigitalAccountManager(){
    	// We need the constants loaded for the OppPusher trigger 
    	Constants.loadData();
    	
    	Test.startTest();
    	User anyUser1 = [SELECT Id FROM User WHERE Profile.Name != 'System Administrator' AND IsActive = True LIMIT 1];
    	Account newAccount = TestData_Account.createSingleAccount('Test Digital Account Manager updates');
    	newAccount.Account_Manager__c = anyUser1.Id;
    	newAccount.RecordTypeId = RecordTypeCache.getRecordType('Account', 'SML_Company').Id;
    	insert newAccount;
    	
    	//Affiliated Contact
    	Contact newContact = TestData_Contact.createSingleContact('TEST FIRST', 'TEST LAST');
    	newContact.Email = 'testuser@testuser.com';
    	newContact.RecordTypeId = RecordTypeCache.getRecordType('Contact', 'Affiliated').Id;
    	insert newContact;
    	
    	Opportunity newOpportunity = TestData_Opportunity.createSingleOpportunity('TEST OPPORTUNITY');
    	User anyUser2 = [SELECT Id FROM User WHERE Profile.Name != 'System Administrator' AND IsActive = True AND Id !=: anyUser1.Id LIMIT 1];
    	newOpportunity.AccountId = newAccount.Id;
    	newOpportunity.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id;
    	newOpportunity.Sales_Rep__c = newContact.Id;
    	insert newOpportunity;
    	
    	newOpportunity.Dig_Account_Manager__c = anyUser2.Id;
    	update newOpportunity;
    	Test.stopTest();
    	
    	newAccount = [Select Account_Manager__c from Account Where Id =: newAccount.Id Limit 1];
    	System.assertEquals(newOpportunity.Dig_Account_Manager__c , newAccount.Account_Manager__c);
    }
}