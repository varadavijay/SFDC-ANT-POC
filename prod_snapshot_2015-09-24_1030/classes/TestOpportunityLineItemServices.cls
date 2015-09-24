@isTest(seeAllData=true)
/* seeAllData=true for Standard Pricebook access */

public class TestOpportunityLineItemServices {
	
	final static String FAKE_OLI_ID_1 = '00kJ0000007BzAfIAK';
	final static String FAKE_OLI_ID_2 = '00kJ0000007BzAgIAK';
	final static String FAKE_OLI_ID_3 = '00kJ0000007BzAhIAK';
	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	final static String OLI_WAITING_STATUS_1 = 'Awaiting Onboard';
	final static String OLI_WAITING_STATUS_2 = 'In Fulfillment';
	final static String OLI_WAITING_STATUS_3 = 'Waiting On Client Approval';
	
    
	public testMethod static void testProcessNewOpportunityLineItem(){
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 2;
		final Datetime EXPECTED_OPP_PROD_HIST_TIME_OUT = null;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		Project__c testProject = TestingUtils.createProject('project1', true);
		Project__c testProject2 = TestingUtils.createProject('project2', true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, false); 
		OpportunityLineItem testOLI2 = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, false); 
		testOLI.Id = FAKE_OLI_ID_1;
		testOLI2.Id = FAKE_OLI_ID_2;
		testOLI.Project__c = testProject.Id;
		testOLI2.Project__c = testProject2.Id;
		testOLI2.Live_Date__c = Datetime.now();
		List<OpportunityLineItem> testOLIList = new List<OpportunityLineItem>{testOLI, testOLI2};
		Set<Id> testOLIs = new Set<Id>{testOLI.Id, testOLI2.Id};
		
		Test.startTest();
			List<Opportunity_Product_History__c> newOppProdHistories = OpportunityLineItemServices.processNewOpportunityLineItem(testOLIList);
		Test.stopTest();
		
		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, newOppProdHistories.size(), 'We expect to get back the correct number of Opportunity Product History objects for each New Opportunity Line Item');
		for (Opportunity_Product_History__c oppProdHist : newOppProdHistories){
			system.assert(testOLIs.contains(oppProdHist.Opportunity_Product__c), 'We expect to get back the correct Opportunity Products for each Opportunity Product History record');
			system.assertEquals(testOpp.Id, oppProdHist.Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History');
			if (oppProdHist.Opportunity_Product__c == testOLI.Id){
				system.assertEquals(OpportunityLineItemServices.CREATED_STAGE_NAME, oppProdHist.OLI_Stage__c, 'We expect to get back the correct OLI Stage for the Opportunity Product History records');
				system.assertEquals(testOLI.LastModifiedDate, oppProdHist.Time_In__c, 'We expect to get back the correct date/time of Time In for the first Opportunity Product History record');
				system.assertEquals(EXPECTED_OPP_PROD_HIST_TIME_OUT, oppProdHist.Time_Out__c, 'We expect to get back the correct date/time of Time In for the first Opportunity Product History record');
				system.assertEquals(testOLI.Project__c, oppProdHist.OLI_Project__c, 'We expect to get back the correct project for the first Opportunity Product History record');
				system.assertEquals(testOLI.Days_To_Go_Live__c , oppProdHist.Product_Days_To_Go_Live__c, 'We expect to get back the correct days to live for the first Opportunity Product History record');
				system.assertEquals(testOLI.Live_Date__c , oppProdHist.Product_Live_Date__c, 'We expect to get back the correct live date for the first Opportunity Product History record');
				
			} else if (oppProdHist.Opportunity_Product__c == testOLI2.Id){
				system.assertEquals(OpportunityLineItemServices.CREATED_STAGE_NAME, oppProdHist.OLI_Stage__c, 'We expect to get back the correct OLI Stage for the Opportunity Product History records');
				system.assertEquals(testOLI2.LastModifiedDate, oppProdHist.Time_In__c, 'We expect to get back the correct date/time of Time Out for the first Opportunity Product History record');
				system.assertEquals(EXPECTED_OPP_PROD_HIST_TIME_OUT, oppProdHist.Time_Out__c, 'We expect to get back the correct date/time of Time In for the first Opportunity Product History record');
				system.assertEquals(testOLI2.Project__c, oppProdHist.OLI_Project__c, 'We expect to get back the correct project for the second Opportunity Product History record');
				system.assertEquals(testOLI2.Days_To_Go_Live__c , oppProdHist.Product_Days_To_Go_Live__c, 'We expect to get back the correct days to live for the first Opportunity Product History record');
				system.assertEquals(testOLI2.Live_Date__c , oppProdHist.Product_Live_Date__c, 'We expect to get back the correct live date for the first Opportunity Product History record');
				
			} else {
				System.assert(false, 'We do not expect to an invalid Opportunity Product from the Opportunity Product History records');
			}
		}
	}
	
	public testMethod static void testProcessOpportunityLineItemStatusChanges(){
		// validate the created Opp Prod History records created from processing 
		
		final Integer NUM_EXPECTED_PROCESSED_OPP_PROD_HIST = 5;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		Project__c testProject = TestingUtils.createProject('project1', true);
		Project__c testProject2 = TestingUtils.createProject('project2', true);
		Project__c testProject3 = TestingUtils.createProject('project3', true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false); 
		OpportunityLineItem testOLI2 = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false); 
		OpportunityLineItem testOLI3 = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false); 
		testOLI.Id = FAKE_OLI_ID_1;
		testOLI2.Id = FAKE_OLI_ID_2;
		testOLI3.Id = FAKE_OLI_ID_3;
		testOLI.Project__c = testProject.Id;
		testOLI2.Project__c = testProject2.Id;
		testOLI3.Project__c = testProject3.Id;
		testOLI.Waiting_Status__c = OpportunityLineItemServices.CREATED_STAGE_NAME;
		testOLI2.Waiting_Status__c = OpportunityLineItemServices.CREATED_STAGE_NAME;
		testOLI3.Waiting_Status__c = OLI_WAITING_STATUS_2;
		List<OpportunityLineItem> testOLIList = new List<OpportunityLineItem>{testOLI, testOLI2, testOLI3};
		
		List<Opportunity_Product_History__c> testOliHistories = TestingUtils.createOliHistory(2, false);
		testOliHistories[0].OLI_Stage__c = testOLI.Waiting_Status__c;
		testOliHistories[0].Opportunity__c = testOLI.OpportunityId;
		testOliHistories[0].Opportunity_Product__c = testOLI.Id;
		testOliHistories[0].OLI_Project__c = testOLI.Project__c;
		
		testOliHistories[1].OLI_Stage__c = testOLI2.Waiting_Status__c;
		testOliHistories[1].Opportunity__c = testOLI2.OpportunityId;
		testOliHistories[1].Opportunity_Product__c = testOLI2.Id;
		testOliHistories[1].OLI_Project__c = testOLI2.Project__c;
		insert testOliHistories;

		Test.startTest();
			List<Opportunity_Product_History__c> processedOppProdHistory = OpportunityLineItemServices.processOpportunityLineItemStatusChanges(testOLIList);
		Test.stopTest();
		System.assertEquals(NUM_EXPECTED_PROCESSED_OPP_PROD_HIST, processedOppProdHistory.size(), 'We expect to get back the correct number of Opportunity Product History records for each Opportunity Line Item');
		for (Opportunity_Product_History__c oppProdHist : processedOppProdHistory){
			System.assertEquals(testOpp.Id, oppProdHist.Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History: ');
			if (testOLI.Id == oppProdHist.Opportunity_Product__c){
				System.assertEquals(testOLI.Id, oppProdHist.Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');				
				System.assertEquals(testOLI.Waiting_Status__c, oppProdHist.OLI_Stage__c, 'We expect to get back the correct OLI Stage for each Opportunity Product History');
				System.assertEquals(testOLI.Project__c, oppProdHist.OLI_Project__c, 'We expect to get back the correct project for the first Opportunity Product History record');
			} else if (testOLI2.Id == oppProdHist.Opportunity_Product__c) {
				System.assertEquals(testOLI2.Id, oppProdHist.Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
				System.assertEquals(testOLI2.Waiting_Status__c, oppProdHist.OLI_Stage__c, 'We expect to get back the correct OLI Stage for each Opportunity Product History');
				System.assertEquals(testOLI2.Project__c, oppProdHist.OLI_Project__c, 'We expect to get back the correct project for the second Opportunity Product History record');
			} else if (testOLI3.Id == oppProdHist.Opportunity_Product__c) {
				System.assertEquals(testOLI3.Id, oppProdHist.Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
				System.assertEquals(testOLI3.Waiting_Status__c, oppProdHist.OLI_Stage__c, 'We expect to get back the correct OLI Stage for each Opportunity Product History');
				System.assertEquals(testOLI3.Project__c, oppProdHist.OLI_Project__c, 'We expect to get back the correct project for the second Opportunity Product History record');
			} else {
				System.assert(false, 'We do not expect to an invalid Opportunity Product from the Opportunity Product History records');
			}
		}
	}
    
	public testMethod static void testFilterOpportunityLineItemStatusChanges(){
		// filter list with status changes and without changes 
				
		final Integer NUM_EXPECTED_OLI_CHANGED = 1;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); 
		OpportunityLineItem testOLINoStatusChange = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); 
		testOLI.Id = FAKE_OLI_ID_1;
		testOLINoStatusChange.Id = FAKE_OLI_ID_2;
		List<OpportunityLineItem> testOLIList = new List<OpportunityLineItem>{testOLI, testOLINoStatusChange};
		Map<Id, OpportunityLineItem> oldMap = new Map<Id, OpportunityLineItem>();
		oldMap.put(testOLI.Id, testOLI.clone(true,true));
		oldMap.put(testOLINoStatusChange.Id, testOLINoStatusChange.clone(true,true));
		
		testOLI.Waiting_Status__c = OLI_WAITING_STATUS_2; 
		
		Test.startTest();
			List<OpportunityLineItem> filteredOLI = OpportunityLineItemServices.getStatusChange(new List<OpportunityLineItem>{testOLI, testOLINoStatusChange}, oldMap);
		Test.stopTest();
		
		System.assertEquals(NUM_EXPECTED_OLI_CHANGED, filteredOLI.size(), 'We expect to get back the correct number of filtered Opportunity Line Items');		
		System.assertEquals(testOLI.Id, filteredOLI[0].Id, 'We expect to get back  only the Opportunity Line Items with Waiting Status changes');
	}

	public testMethod static void testProcessDeletedOpportunityLineItem(){
		// validate the Opp Prod History records deleted 
	
		final Integer NUM_EXPECTED_DELETED_OPP_PROD_HISTORIES = 1;		
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false);
		testOli.Id = FAKE_OLI_ID_1;

		Opportunity_Product_History__c testOliHistory = TestingUtils.createOliHistory(1, false)[0];
		testOliHistory.Opportunity__c = testOpp.Id;
		testOliHistory.Opportunity_Product__c = FAKE_OLI_ID_1;
		insert testOliHistory;
		
		Test.startTest();
			List<Opportunity_Product_History__c> oliHistoryToDelete = OpportunityLineItemServices.processDeletedOpportunityLineItem(new List<OpportunityLineItem>{testOLI});
		Test.stopTest();
		
		System.assertEquals(NUM_EXPECTED_DELETED_OPP_PROD_HISTORIES, oliHistoryToDelete.size(), 'We expect to get back the correct number of OLI History Records to be deleted ');
		System.assertEquals(testOpp.Id, oliHistoryToDelete[0].Opportunity__c, 'We expect to get back the correct Opportunity of Opportunity Product History Record to be deleted ');
		System.assertEquals(testOLI.Id, oliHistoryToDelete[0].Opportunity_Product__c, 'We expect to get back the correct Opportunity Product Id of Opportunity Product History Record to be deleted ');
		
	}
	
	
	public testMethod static void testGetBusinessHoursDifference() {
		
		Integer expectedBusinessHoursDifference = 1;
		Datetime time1 = Datetime.now();
		Datetime time2 = BusinessHours.add(OpportunityLineItemServices.bh.Id, time1, expectedBusinessHoursDifference * ((Long) OpportunityLineItemServices.MILLISECONDS_IN_HOURS) );
		
		Test.startTest();
			Double timeDifference = OpportunityLineItemServices.getBusinessHoursDifference(time1, time2);
			Boolean acceptableTimeDifference = OpportunityLineItemServices.acceptableBusinessHoursDifference(timeDifference, expectedBusinessHoursDifference);
		Test.stopTest();
		
		System.assert(acceptableTimeDifference, 'We expect to get back about one hour difference in business hours');
		
	}
}