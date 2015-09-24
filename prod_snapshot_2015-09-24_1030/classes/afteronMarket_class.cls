// CC Ph2 - This is a test class, but the name doesn't make that clear

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
private class afteronMarket_class {

    static testMethod void testAfterMarketTrigger() {
    	
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	Constants.loadData();

        User dcApprover = [Select id, name, username FROM User where username like 'dealchickentraining@hotmail.com%' limit 1];

        if(dcApprover == null){
        	// use as debug - will fail
        	system.assertEquals('dcApprover not null', 'null');
        }

        Market__c m = new Market__c();
        m.Name = 'TX, Dallas';
        m.State__c = 'TX';
        m.City_Area__c = 'Dallas';
        m.Region__c = 'South & West';
        m.DealChicken_Approver__c = dcApprover.Id;
        insert m;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTestOfOpp';
        o.AccountId = Constants.GO_DIGITAL_COMPANY.Id;
        o.DealChicken_Market__c = m.Id;
        o.StageName = 'Needs Analysis';
        o.CloseDate = date.today()+ 14;
        o.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'Deal_Chicken').Id;
        insert o;
        
        m.DealChicken_Approver__c = Constants.GANNETT_LOCAL_USER.Id;
        update m;
        
        Opportunity DCOppTest = [select Id, Market_Area_Manager__c from Opportunity where Id = :o.Id];
        System.assertEquals(Constants.GANNETT_LOCAL_USER.Id, DCOppTest.Market_Area_Manager__c);
        
    }
}