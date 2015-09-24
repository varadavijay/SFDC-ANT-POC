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
private class beforeonTask_tstClass {

    static testMethod void TestTaskBlog() {
    	// <refactor> test data creation utility should be used to create test data 
        Lead testLead = new Lead(LastName = 'WingateTest', Company = 'WingateWorks', Status = 'Uncontacted - New');
        insert testLead;        
		
		// <refactor> test data creation utility should be used to create test data 
		Task testTask = new Task(Subject = 'Test', WhoId = testLead.Id, Description = 'Testing Blog');
		insert testTask;
		
		Task testTaskAfter = [SELECT Id, Blog__c from Task WHERE Id = :testTask.Id];
		
		// <refactor> need assertion message 
		System.assertEquals('Testing Blog', testTaskAfter.Blog__c);
    }
    static testMethod void TestTaskEmail() {
    	
    	// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account 1';
        a.OwnerId = Constants.GANNETT_LOCAL_USER.Id;
        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'SML_Company').Id;
        insert a;
        
        // <refactor> test data creation utility should be used to create test data 
        Opportunity o1 = new Opportunity();
        o1.AccountId = a.Id;
        o1.Name = 'Opp DC Test 1';
        o1.StageName = 'Needs Analysis';
        o1.CloseDate = date.today().addDays(2);
        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Digital_Fulfillment').Id;
        o1.OwnerId = Constants.GANNETT_LOCAL_USER.Id;
        insert o1;
        
        // The beforeonTask Trigger is going do do this query: 
        // SELECT Id from KPICalender__c WHERE Date__c = Date.today() limit 1
        // So lets put that KPICalrec into the test data so it sees it.
        
        // <refactor> test data creation utility should be used to create test data 
   		KPICalender__c kpiCal = new KPICalender__c();
   		Date today = Date.today();
		kpiCal.Name = String.valueOf(today.month()) + '/' + String.valueOf(today.day()) + '/' + String.valueOf(today.year());
		kpiCal.Date__c = Date.today();
		insert kpiCal;
        
		// <refactor> test data creation utility should be used to create test data 
		Task testTask = new Task(Subject = 'Email: DealChicken – Important Account Update!');
		testTask.WhatId = o1.Id;
		testTask.Description = 'Testing Tracking Insert';
		testTask.OwnerId = o1.ownerId;
		insert testTask; // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
		
		Integer SentCount = [SELECT count() FROM Opp_Tracking_Report__c WHERE Event__c = 'Sent' AND Opportunity__c = :o1.Id];
		
		// <refactor> need assertion message 
		system.assertequals(1, SentCount);
    }
}