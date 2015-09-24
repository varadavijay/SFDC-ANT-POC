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
private class afteronOpportunityProduct_class {
	// <refactor> test class not named to identify it as such, but actually has "Class" in it's name

    static testMethod void testOppProdTrigger1() {
    	
    	// <refactor> test data creation utility should be used to create test data
    	Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Opportunity o1 = new Opportunity();
        o1.AccountId = a.Id;
        o1.Name = 'Test Opp 1';
        o1.StageName = 'Booked Appointment';
        o1.CloseDate = date.today().addDays(2);
        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
        
        insert o1;
        
        // <refactor> test data creation utility should be used to create test data
        Product2 p1 = new product2(name='TestSocMed1', Family='Test', Social_Media_Notice__c=True);
        insert p1;
        Product2 p2 = new product2(name='TestSocMed2', Family='Test', Social_Media_Notice__c=False);
        insert p2;
        
        // <refactor> Isn't SeeAllData=true needed here ? 
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = p1.id, unitprice=1.0, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry(pricebook2id = stdPb.id, product2id = p2.id, unitprice=1.0, isActive=true);
        insert pbe2;
        
        // <refactor> test data creation utility should be used to create test data
        OpportunityLineItem oli1 = new OpportunityLineItem(opportunityid=o1.id, pricebookentryid=pbe1.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30));
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        insert oli1;
        
        Opportunity MyTest1 = [select Id, Social_Media_Notice__c from Opportunity where Id =: o1.Id];
		
		// <refactor> needs an errror message to describe the problem
        system.assertequals(True,MyTest1.Social_Media_Notice__c);
        
        delete oli1;
        
        Opportunity MyTest2 = [select Id, Social_Media_Notice__c from Opportunity where Id =: o1.Id];
		
		// <refactor> needs an errror message to describe the problem
        system.assertequals(False,MyTest2.Social_Media_Notice__c);
        
        
    }
    static testMethod void testOppProdTrigger2() {
    	
    	// <refactor> test data creation utility should be used to create test data
    	Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        // <refactor> test data creation utility should be used to create test data
        Opportunity o1 = new Opportunity();
        o1.AccountId = a.Id;
        o1.Name = 'test1';
        o1.StageName = 'New';
        o1.CloseDate = date.today();
        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
        insert o1;
        
        // <refactor> test data creation utility should be used to create test data
        List<Product2> P2ToAdd = new List<Product2>();
        Product2 p1 = new Product2(name='TestSocMed1', Family='Test', Social_Media_Notice__c=True, CanUseRevenueSchedule = True);
        Product2 p2 = new Product2(name='TestSocMed2', Family='Test', Social_Media_Notice__c=True, CanUseRevenueSchedule = True);
        P2ToAdd.add(P1);P2ToAdd.add(P2);
        insert P2ToAdd;
        
        // <refactor> Isn't SeeAllData=true needed here ? 
        Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        
        // <refactor> test data creation utility should be used to create test data
        List<PricebookEntry> PBToAdd = new List<PricebookEntry>();
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = stdPb.id, product2id = p1.id, unitprice=1.0, isActive=true);
        PricebookEntry pbe2 = new PricebookEntry(pricebook2id = stdPb.id, product2id = p2.id, unitprice=1.0, isActive=true);
        PBToAdd.add(pbe1);PBToAdd.add(pbe2);
        insert PBToAdd;
        
        // <refactor> test data creation utility should be used to create test data
        OpportunityLineItem oli1 = new OpportunityLineItem(opportunityid=o1.id, pricebookentryid=pbe1.id, unitprice=1.5, quantity=2,ServiceDate=date.today(),End_Date__c=date.today().adddays(30), Term__c = 'Test0');
        insert oli1;
        
        //Set<String> leadSet = new Set<String>(); <comment>
        // <refactor> test data creation utility should be used to create test data
        List<OpportunityLineItemSchedule> OLISToAdd = new List<OpportunityLineItemSchedule>();
        OpportunityLineItemSchedule olis1 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id, ScheduleDate=date.today().adddays(1), Revenue=100, Type = 'Revenue', Description = 'TestDescription');
        OpportunityLineItemSchedule olis2 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id, ScheduleDate=date.today().adddays(2), Revenue=100, Type = 'Revenue', Description = 'TestDescription');
        OpportunityLineItemSchedule olis3 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id, ScheduleDate=date.today().adddays(3), Revenue=100, Type = 'Revenue', Description = 'TestDescription');
        OLISToAdd.add(olis1);OLISToAdd.add(olis2);OLISToAdd.add(olis3);
        insert OLISToAdd;
        
        Integer CountCheck1 = [select count() from OpportunityLineItemSchedule where OpportunityLineItemId = :oli1.id];
        // <refactor> needs an errror message to describe the problem
        system.assertequals(3,CountCheck1);
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        oli1.Term__c = 'Test1';
        update oli1;
        
        Opportunity MyTest1 = [select Id, Last_Schedule_Bill_Date__c from Opportunity where Id =: o1.Id];
		
		// <refactor> needs an errror message to describe the problem
        //system.assertequals(date.today().adddays(3),Date.valueof(MyTest1.Last_Schedule_Bill_Date__c));  
        //system.assertequals(null,MyTest1.Last_Schedule_Bill_Date__c);
             
    }
}