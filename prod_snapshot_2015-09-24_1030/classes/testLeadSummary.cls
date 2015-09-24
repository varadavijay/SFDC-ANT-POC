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
private class testLeadSummary {
	
	// <comment>
	// <deletefile>
	// <CC> the only calling code is LeadSummaryUpdate.trigger which is also entire commented out. 
	//  no *active* calls to this commented out code 
	//  appears to update lead call log information </CC>
	
	/****************  BEGIN FULL CLASS COMMENT ************************
	
    static testMethod void myUnitTest() {
    
    	// <refactor> possibly use TestingUtils class for standardized data creation, 
    	// 		i.e. Lead testLead = TestingUtils.createLead(...); 
    	 
        //create Lead
        // <refactor> Set<Id> LeadIds ? 
        Set<String> leadSets = new Set<String>();
        
        Lead testLead = new Lead(LastName = 'ZappaTest', Company = 'ZappaWorks', Status = 'Uncontacted - New');
        insert testLead;
        leadSets.add(testLead.Id);
        
        Lead testLeadTwo = new Lead(LastName = 'ZappaTest', Company = 'ZappaWorks', Status = 'Uncontacted - New');
        insert testLeadTwo;
        leadSets.add(testLeadTwo.Id);
        
        
        
        //create task to trigger update
		Task testTask = new Task(WhoId = testLead.Id, Subject = 'Call Dialer Initiative', CallDurationInSeconds = 0);
		insert testTask;
		
		List<Task> testTaskBatch = new List<Task>();
		// <Iterator>
		for(Integer i = 0; i < 100; i++){
			
			Task tempTask = new Task(WhoId = testLead.Id, Subject = 'Call Dialer Initiative', CallDurationInSeconds = 60);
			
			testTaskBatch.add(tempTask);
			
		}
		// <Iterator>
		for(Integer i = 0; i < 100; i++){
			
			Task tempTask = new Task(WhoId = testLeadTwo.Id, Subject = 'Call Dialer Initiative', CallDurationInSeconds = 60);
			
			testTaskBatch.add(tempTask);
			
		}
		
		insert testTaskBatch;
		// <logic> <refactor> Why insert then immediate update ? 
		update testTaskBatch;
		
		Lead testLeadAfter = [SELECT Id, Connected_Count__c, Call_Count__c from Lead WHERE Id = :testLead.Id];
		// <refactor> no assertions 
		//System.assertEquals(101, testLeadAfter.Call_Count__c);
		//System.assertEquals(100, testLeadAfter.Connected_Count__c);
		
		Lead testLeadAfterTwo = [SELECT Id, Connected_Count__c, Call_Count__c from Lead WHERE Id = :testLeadTwo.Id];
		// <refactor> no assertions 
		//System.assertEquals(100, testLeadAfterTwo.Call_Count__c);
		//System.assertEquals(100, testLeadAfterTwo.Connected_Count__c);
		
		// <refactor> use Test.startTest(); Test.stopTest(); to reset Limits
		FutureLeadSummaryUpdate.updateLeadSummary(leadSets);
        
    }
    
    **************  END FULL CLASS COMMENT *******************/
}