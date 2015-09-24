// CC Ph2 - "myUnitTest" and "myUnitTest2" aren't descriptive

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
private class beforeUpdateOnLead_tstclass {
	
	// <refactor> use more clear testMethod names
    static testMethod void testLeadUpdateTrigger1() {
        // <refactor> test data creation should be done using a data creation class
        Lead testLead = new Lead(LastName = 'WingateTest', Company = 'WingateWorks', Status = 'Uncontacted - New');
        insert testLead;        
		
		Lead testLeadAfter = [SELECT Id, Connected_Count__c, Call_Count__c, Lead_Owner__c
							  FROM Lead
							  WHERE Id = :testLead.Id];
		// <refactor> nothing being asserted or tested 
		
		//System.assertEquals('005A0000001WlbjIAC', testLeadAfter.Lead_Owner__c);
		        
    }
    // <refactor> use more clear testMethod names
    static testMethod void testLeadUpdateTrigger2() {
        // <comment> is this comment helpful ? 
        
        // <PWP> 003F000000on3GD = Shane Morris - A sales rep for the Des Moines Register, i.e. an affiliate.
        // The Before Update Lead trigger depends on this contact record, but I refuse to make a constant out of
        // a real person - as real people are rarely constant. I'll create a Test Contact with the same 
        // attributes as Shane, instead, Then recreate the lead below
        // </PWP>
        //Lead testLead2 = new Lead(SalesRep__c = '003F000000on3GD',
        //						  Company = 'TestDigitialFulf',
        //						  Status = 'Awaiting Assignment',
        //						  RecordTypeId = RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id,
        //						  LastName = 'TestFirstName TestLastName');
        //insert testLead2;  
        
        // Create a Partner Market Account for the Affiliate SalesRep
        List<Account> affiliateAccount = TestData_Account.createAccounts(1);
        affiliateAccount[0].RecordTypeId = RecordTypeCache.getRecordType('Account', 'PartnerMarket').Id;
        affiliateAccount[0].Partner_Type__c = 'USCP';
        insert affiliateAccount[0];
        
        Market__c testMarket = new Market__c(Name = 'IA, Des Moines', Active_DC__c = true, Active_CP__c = true);
        insert testMarket;
        
        List<Contact> affiliateSalesReps = TestData_Contact.createContacts('Chuck', 'Norris', 1);
        affiliateSalesReps[0].RecordTypeId = RecordTypeCache.getRecordType('Contact', 'Affiliated').Id;
        affiliateSalesReps[0].Market__c = testMarket.Id;
        affiliateSalesReps[0].OwnerId = Constants.GANNETT_LOCAL_USER.id;
        affiliateSalesReps[0].AccountId = affiliateAccount[0].Id;
        insert affiliateSalesReps[0];
        
        List<Lead> affiliateLeads = TestData_Lead.createLeads('TestFirstName', 'TestLastName', 'TestDigitialFulf', 1);
        affiliateLeads[0].SalesRep__c = affiliateSalesReps[0].Id;
        affiliateLeads[0].Status = 'Awaiting Assignment';
        affiliateLeads[0].RecordTypeId = RecordTypeCache.getRecordType('Lead', 'Digital_Fulfillment').Id;
        insert affiliateLeads[0];  
  
		Lead testLeadAfter = [SELECT Id, Related_Company__c, Gannett_Market__c, Marketing_Source__c
							  FROM Lead
							  WHERE Id = :affiliateLeads[0].Id];
		// <refactor> use Test.startTest(); Test.stopTest(); to reset limits 
		// <refactor> needs an errror message to describe the problem
		System.assertEquals(affiliateAccount[0].Id, testLeadAfter.Related_Company__c);
		System.assertEquals(testMarket.Id, testLeadAfter.Gannett_Market__c);  
		System.assertEquals('USCP Channel', testLeadAfter.Marketing_Source__c);     
    }
}