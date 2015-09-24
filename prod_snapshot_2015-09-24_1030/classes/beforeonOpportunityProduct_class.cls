//CC Ph2 - Class name

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

// <comment> great explanation 
// Currently, Pricebook data is not visible when seeAllData=false, even though it 
// comes over with a refresh, like Profile, User and RecordType, all of which can be
// seen from testMethods without seeAllData=true. And you CANNOT create the "Standard Price Book" 
// programatically. This is an known issue in SF and when they fix it, this will need to be removed. 
// Until then any test method which uses pricebook must have seeAllData=true
// 
// for more info: https://success.salesforce.com/ideaView?id=08730000000j9TpAAI


@isTest(seeAllData=true)
private class beforeonOpportunityProduct_class {
	// <refactor>  Class name implies it's a class, not a test

    static testMethod void TestOppProd() {
    	// For seeAllData=False (API 24+), need to load the constants data in the test DB
    	// Due to Pricebook note above, however, this class needs to seedata for now.
    	// once SF resolves that issue, we can set back to false, and uncomment next line 
    	// Constants.loadData();
    	
    	// <refactor> test data creation utility should be used to create test data 
        Account a = new Account();
        a.Name = 'Test Account 1';
        insert a;
        system.debug('After insert a');
        
        // <refactor> test data creation utility should be used to create test data 
        Opportunity o1 = new Opportunity();
        o1.AccountId = a.Id;
        o1.Name = 'Opp Test 1';
        o1.StageName = 'Booked Appointment';
        o1.CloseDate = date.today().addDays(2);
        o1.RecordTypeId = RecordTypeCache.getRecordType('Opportunity', 'SML_Opportunity').Id;
        o1.OwnerId = Constants.GANNETT_LOCAL_USER.Id;
        insert o1;
        system.debug('After insert o1: RecordType = ' + o1.RecordTypeId); // <CC> debug statement not needed 
        
        // <refactor> test data creation utility should be used to create test data 
        Product2 p1 = new Product2(Name='TestSocMed1',
        						   Family='Test',
        						   Social_Media_Notice__c=True,
        						   CanUseRevenueSchedule = True);
        insert p1;
        system.debug('After insert p1'); // <CC> debug statement not needed 
		
		// <refactor> test data creation utility should be used to create test data 
        Product2 p2 = new Product2(Name='TestSocMed2',
        						   Family='Test',
        						   Social_Media_Notice__c=False,
        						   CanUseRevenueSchedule = True);
        insert p2;
        system.debug('After insert p2'); // <CC> debug statement not needed 
        
        // <PWP> This doesn't appear to do anything
        // Pricebook2 stdPb = new Pricebook2(Name='NewPriceBook',IsActive=True,Description='Description1');
        // insert stdPb;
        // </PWP>
        
        //Pricebook2 stdPb = [select Id from Pricebook2 limit 1];
        
        // <refactor> test data creation utility should be used to create test data 
        PricebookEntry pbe1 = new PricebookEntry(pricebook2id = Constants.STANDARD_PRICEBOOK.Id,
        										 product2id = p1.id,
        										 unitprice=1.0,
        										 isActive=true,
        										 usestandardprice=false);
        system.debug('After insert pbe1:  pricebook2id.isStandard = ' + Constants.STANDARD_PRICEBOOK.IsStandard); 
        insert pbe1;
       	
       	// <refactor> test data creation utility should be used to create test data 
        PricebookEntry pbe2 = new PricebookEntry(pricebook2id = Constants.STANDARD_PRICEBOOK.Id,
        										 product2id = p2.id,
        										 unitprice=1.0,
        										 isActive=true,
        										 usestandardprice=false);
        insert pbe2;
        system.debug('After insert pbe2'); // <CC> debug statement not needed 
        
        // <refactor> test data creation utility should be used to create test data 
        OpportunityLineItem oli1 = new OpportunityLineItem(opportunityid=o1.id,
        												   pricebookentryid=pbe1.id,
        												   unitprice=1.5,
        												   quantity=2,
        												   ServiceDate=date.today(),
        												   End_Date__c=date.today().adddays(30),
        												   Term__c = 'Test0',
        												   Waiting_Status__c = 'Awaiting Onboard');
        insert oli1;
        system.debug('After insert oli1');
		
		// <refactor> test data creation utility should be used to create test data 
		// <CC> appears to contains sensitive information, is security in place to allow/deny access to these records 
        Payment_Processing__c payproc = new Payment_Processing__c(Account__c=a.id,
        														  Opportunity__c=o1.id,
        														  Processing_Status__c='Captured',
        														  Billing_Options__c='Bill Monthly',
        														  RecordTypeId = RecordTypeCache.getRecordType('Payment_Processing__c','Credit_Card_Processing').Id,
        														  Credit_Card_Type__c='Visa',
        														  Credit_Card_Number__c = '1234567891234567',
        														  Exp_Month__c = '1',
        														  Exp_Year__c='2015',
        														  Security_Code__c='123');
        insert payproc;
        system.debug('After insert payproc'); // <CC> debug statement not needed 
        
        // <comment>
        /**OpportunityLineItem MyTest2 = [select Id, OpportunityId, Term__c from OpportunityLineItem where Id = '00kF000000D4gef'];
        
        MyTest2.Term__c = 'testterm';
        update MyTest2;
        
        Opportunity MyTest3 = [select Id, Last_Schedule_Bill_Date__c from Opportunity where Id = :MyTest2.OpportunityId];
        
        string year = '2013';
		string month = '2';
		string day = '28';
		string hour = '12';
		string minute = '20';
		string second = '20';
		string stringDate = year + '-' + month
		+ '-' + day + ' ' + hour + ':' +
		minute + ':' + second;
		Date myDate = date.valueOf(stringDate);


        system.assertequals(myDate,MyTest3.Last_Schedule_Bill_Date__c); 
        **/
        //Set<String> leadSet = new Set<String>();
        
        // <refactor> test data creation utility should be used to create test data 
        List<OpportunityLineItemSchedule> OLISToAdd = new List<OpportunityLineItemSchedule>();
        OpportunityLineItemSchedule olis1 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id,
        																	ScheduleDate=date.today().adddays(1),
        																	Revenue=100,
        																	Type = 'Revenue',
        																	Description = 'TestDescription');
        																	
        OpportunityLineItemSchedule olis2 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id,
        																	ScheduleDate=date.today().adddays(2),
        																	Revenue=100,
        																	Type = 'Revenue',
        																	Description = 'TestDescription');
        																	
        OpportunityLineItemSchedule olis3 = new OpportunityLineItemSchedule(OpportunityLineItemId=oli1.id,
        																	ScheduleDate=date.today().adddays(3),
        																	Revenue=100,
        																	Type = 'Revenue',
        																	Description = 'TestDescription');
        OLISToAdd.add(olis1);
        OLISToAdd.add(olis2);
        OLISToAdd.add(olis3);
        
		system.assertequals(3,OLISToAdd.size()); // <refactor> why is this asserted ? 
        insert OLISToAdd;
        system.debug('After insert OLISToAdd'); // <CC> debug statement not needed 
        
        // <comment>
        //Integer CountCheck1 = [select count() from OpportunityLineItemSchedule where OpportunityLineItemId = :payproc.id];
        //system.assertequals(3,CountCheck1);
        
        //oli1.Term__c = 'Test1';
        //oli1.Waiting_Status__c = 'Awaiting Onboard';
        
        // <refactor> use Test.startTest; test.stopTest to reset limits on specific blocks of code
        //update oli1;
        //system.debug('After update oli1'); // <CC> debug statement not needed
        
        //New Paymentries creation service class
        Test.startTest();
        OpportunityPaymentEntries.createPaymentEntries(oli1.Id); 
        Test.stopTest();
        
        Integer MyTest1 = [select count() from Payment_Entries__c where CC__c =:payproc.Id];
		
		// <refactor> needs an errror message to describe the problem
        system.assertequals(3,MyTest1);
        //system.assertequals(null,MyTest1.Last_Schedule_Bill_Date__c);
    }
}