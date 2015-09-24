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

@isTest(SeeAllData=true) // <CC> shouldn't need access to actual data here 
private class afteronTBProposal_class {
	// <refactor> Test Class - not only not named to identify it as such, but actually has "Class" in it's name

    static testMethod void testTBProposalTrigger() {
        
        //<PWP> the 2 lines below were commented - but maybe we need to do the Runas with those parameters at some point...
        
        //User u = [SELECT Id FROM User WHERE Profile.Name = 'DC Account Executive' AND IsActive = True LIMIT 1];
        //system.runAs(u)
        
        // The trigger (afteronTBProposal_trigger) depends on the running user, which must also have a KPIRep record.
        // For testing, we'll run as GL system, so the trigger will have it's data.
	    system.runAs(Constants.GANNETT_LOCAL_USER){ // <CC> What is GANNETT_LOCAL_USER for ? 
	    	
	    	// <refactor> make need to create KPIRep here
	    	
	    	// <refactor> test data creation utility should be used to create test data 
	        Account a = new Account();
	        a.Name = 'Test Account 1';
	        a.OwnerId = Userinfo.getUserId();  // <CC> Is this the same User Id as the System.RunAs(Gannett_local_user), is this needed ? 
	        a.RecordTypeId = RecordTypeCache.getRecordType('Account', 'SML_Company').Id;
	        insert a;
	        
	        system.debug('after insert a'); // <CC> are debug statements needed ?
	        
	        // <refactor> test data creation utility should be used to create test data 
	        Opportunity o1 = new Opportunity();
	        o1.AccountId = a.Id;
	        o1.Name = 'Opp DC Test 1';
	        o1.StageName = 'Needs Analysis';
	        o1.CloseDate = date.today().addDays(2);
	        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id;
	        o1.OwnerId = Userinfo.getUserId();
	        o1.Sales_Rep_II__c = o1.OwnerId;
	        insert o1;
	        system.debug('after insert o1: o1.OwnerId = ' + o1.OwnerId + '::'); // <CC> are debug statements needed ?
	        
	        // <refactor> test data creation utility should be used to create test data 
	        tinderbox__Proposal__c t1 = new tinderbox__Proposal__c();
	        t1.Name = 'Test Class Proposal 1';
	        t1.tinderbox__Opportunity__c = o1.Id;
	        t1.tinderbox__description__c = 'Test Description';
	        t1.tinderbox__Status__c = 'Open';
	        t1.tinderbox__TBAccount__c = a.Name;
	        t1.tinderbox__tinderboxid__c = '99999';
	        insert t1;
	        
	        system.debug('after insert t1'); // <CC> are debug statements needed ?
	        
	        // <refactor> test data creation utility should be used to create test data 
	        List<tinderbox__Proposal__c> getnewprop = new List<tinderbox__Proposal__c>();
	        
	        getnewprop = [SELECT Id, tinderbox__tinderboxid__c, tinderbox__Status__c
	        			  FROM tinderbox__Proposal__c
	        			  WHERE Name = 'Test Class Proposal 1'];
	        
	        Integer getnewpropsize = getnewprop.size();
	        system.assertequals(1,getnewpropsize); // <refactor> need assertion message
	        
	        for(tinderbox__Proposal__c tempnewprop : getnewprop){
	            tempnewprop.tinderbox__Status__c = 'Accepted';
	        }
	        
	        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
	        system.debug('before update getnewprop'); // <CC> are debug statements needed ?
	        update getnewprop;
	        system.debug('after update getnewprop'); // <CC> are debug statements needed ?
	        
	        Integer MyTest1 = [select count() from Opp_Tracking_Report__c where Event__c = 'Signed' and Opportunity__c = :o1.Id];
	
	        system.assertequals(1,MyTest1); // <refactor> need assertion message
		}
    }
}