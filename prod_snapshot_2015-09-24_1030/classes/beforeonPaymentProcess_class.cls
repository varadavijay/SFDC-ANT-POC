// <PWP> Class name implies it's a class, not a test

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
private class beforeonPaymentProcess_class {
	// <refactor>  Class name implies it's a class, not a test

    static testMethod void testPaymentProcessing1() {
    	
    	// <refactor> test data creation utility should be used to create test data 
        Opportunity Test1Opp = new Opportunity(RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').id,
        									   AccountId = Constants.GO_DIGITAL_COMPANY.Id,
        									   Name = 'TestOppForPPEntries',
        									   Type = 'New Business',
        									   Include_Address_in_Ads__c = 'Yes',
        									   StageName = 'Needs Analysis',
        									   CloseDate = date.today(),
        									   Amount = 100);
        // <refactor> unnecessary debug statements 
        system.debug('Before inserting Opp');
        insert Test1Opp;  	
        system.debug('After inserting Opp');
        
        // <refactor> test data creation utility should be used to create test data 
        Payment_Processing__c Test1PP = new Payment_Processing__c(Opportunity__c = Test1Opp.Id,
        														  Credit_Card_Type__c = 'Mastercard',
        														  Credit_Card_Number__c = '4444555566667777',
        														  Exp_Month__c = '8',
        														  Exp_Year__c = '2011',
        														  Security_Code__c = '666',
        														  Billing_Options__c = 'Bill Monthly',
        														  Entry_Processor__c = Constants.GANNETT_LOCAL_USER.Id);
        // <refactor> unnecessary debug statements 
        system.debug('Before inserting PP');
        insert Test1PP;
        system.debug('After inserting PP');
        
        // <refactor> test data creation utility should be used to create test data 
        Payment_Processing__c  testPPAfter = [SELECT Id, First_Charge_Day__c, Entry_Cycle__c, Cycles__c, Reset_Entries__c
        									  FROM Payment_Processing__c
        									  WHERE Id = :Test1PP.Id];
         
		testPPAfter.First_Charge_Day__c = date.today() - 3;
		testPPAfter.Entry_Cycle__c = 'Monthly';
		testPPAfter.Cycles__c = '1';
		testPPAfter.Reset_Entries__c = True;
		
		// <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
		update testPPAfter;
		
		Integer testPEAfter = [SELECT count() from Payment_Entries__c WHERE CC__c = :testPPAfter.Id];
		
		// <refactor> needs an errror message to describe the problem
		System.assertEquals(1, testPEAfter);
    }
    static testMethod void testPaymentProcessing2() {
    	
    	// <refactor> test data creation utility should be used to create test data 
        Opportunity Test2Opp = new Opportunity(RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').id,
        									   AccountId = Constants.GO_DIGITAL_COMPANY.id,
        									   Name = 'TestOppForPPEntries',
        									   Type = 'New Business',
        									   Include_Address_in_Ads__c = 'Yes',
        									   StageName = 'Needs Analysis',
        									   CloseDate = date.today(),
        									   Amount = 100);
        insert Test2Opp;  	
        
        // <refactor> test data creation utility should be used to create test data 
        Payment_Processing__c Test2PP = new Payment_Processing__c(Opportunity__c = Test2Opp.Id,
        														  Credit_Card_Type__c = 'Mastercard',
        														  Credit_Card_Number__c = '4444555566667777',
        														  Exp_Month__c = '8',
        														  Exp_Year__c = '2011',
        														  Security_Code__c = '666',
        														  Billing_Options__c = 'Bill Monthly',
        														  Entry_Processor__c = Constants.GANNETT_LOCAL_USER.Id);
        insert Test2PP;
        
        // <refactor> test data creation utility should be used to create test data 
        Payment_Processing__c  test2PPAfter = [SELECT Id,
        											  First_Charge_Day__c,
        											  End_Date__c,
        											  Entry_Cycle__c,
        											  Cycles__c,
        											  Reset_Entries__c
        									   FROM Payment_Processing__c
        									   WHERE Id = :Test2PP.Id];
        
        Date endDay = date.today();
        endDay = endDay.addDays(70);
		test2PPAfter.First_Charge_Day__c = date.today();
		test2PPAfter.End_Date__c = endDay;
		test2PPAfter.Entry_Cycle__c = 'Monthly';
		test2PPAfter.Reset_Entries__c = True;
		
		// <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
		update test2PPAfter;
		
		Integer test2PEAfter = [SELECT count() from Payment_Entries__c WHERE CC__c = :test2PPAfter.Id];
		
		// <refactor> needs an errror message to describe the problem
		System.assertEquals(3, test2PEAfter);
    }
}