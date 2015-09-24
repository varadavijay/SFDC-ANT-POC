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
private class beforeonAccount_class {
	// <refactor> test class - not named to identify it as such

    static testMethod void insertTestSML() {
		
		// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'SML_Company').Id;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert a;
        
        Account UpdateTest1 = [SELECT Market_Originator__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an errror message to describe the problem
        System.assertEquals(Null, UpdateTest1.Market_Originator__c);
    }
    static testMethod void insertTestPartner() {
    	// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert a;
        
        Account UpdateTest1 = [SELECT Market_Originator__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an errror message to describe the problem
        System.assertEquals(Null, UpdateTest1.Market_Originator__c);
    }
    static testMethod void updateTestSML() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();
 		
 		// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account';
        a.Market_Originator__c = Constants.AZ_REPUBLIC_COMPANY.Id;
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'SML_Company').Id;
        insert a;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        a.Market_Originator__c = Null;
        update a;
        
        Account UpdateTest2 = [SELECT Market_Originator__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an errror message to describe the problem
        System.assertEquals(Null, UpdateTest2.Market_Originator__c);
    }
    static testMethod void updateTestPartner() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();
		
		// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account';
        a.Market_Originator__c = Constants.AZ_REPUBLIC_COMPANY.Id;
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        insert a;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        a.Market_Originator__c = Null;
        update a;
        
        Account UpdateTest2 = [SELECT Market_Originator__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an errror message to describe the problem
        System.assertEquals(Null, UpdateTest2.Market_Originator__c);
    }
    static testMethod void testAddressBreakUpdate() {//checking if line break in address on update
        
        // <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'LB Account Before';
        a.BillingStreet = '345 E Willow\nStreet';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        insert a;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        a.Name = 'LB Account After';
        try{
       		update a;
        }catch(exception e){
        	
        }
        
        Account UpdateTest2 = [SELECT CF_Line_Break__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an assertion 
        //System.assertEquals('Street Address', UpdateTest2.CF_Line_Break__c);
    }
    static testMethod void testAddressBreakInsert() {//checking if line break in address on insert
        
        // <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'LB Account Before';
        a.BillingStreet = '345 E Willow\nStreet';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert a;
        
        Account UpdateTest2 = [SELECT CF_Line_Break__c FROM Account WHERE Id = :a.Id];
         // <refactor> needs an assertion 
       // System.assertEquals('Street Address', UpdateTest2.CF_Line_Break__c);
    }
    static testMethod void testAddressBreakInsert2() {//checking if line break in address on insert
        
        // <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'LB Account Before';
        a.BillingStreet = '345 E Willow Street';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert a;
        
        Account UpdateTest2 = [SELECT CF_Line_Break__c FROM Account WHERE Id = :a.Id];
        // <refactor> needs an errror message to describe the problem
        System.assertEquals('No Line Break', UpdateTest2.CF_Line_Break__c);
    }
    static testMethod void testAddressBreakInsert3() {//checking if line break in address on insert
        
        // <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'LB Account Before';
        a.BillingStreet = '345 E Willow\nStreet';
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        insert a;
        
        Account UpdateTest2 = [SELECT BillingStreet, CF_Line_Break__c FROM Account WHERE Id = :a.Id];
        UpdateTest2.BillingStreet = '345 E Willow Street';
        UpdateTest2.CF_Line_Break__c = 'Null';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        update UpdateTest2;
        Account UpdateTest3 = [SELECT CF_Line_Break__c FROM Account WHERE Id = :a.Id];
        
        // <refactor> needs an errror message to describe the problem
        System.assertEquals('No Line Break', UpdateTest3.CF_Line_Break__c);
    }
}