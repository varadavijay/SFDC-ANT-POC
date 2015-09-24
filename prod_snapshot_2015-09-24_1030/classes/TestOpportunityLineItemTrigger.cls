@isTest(seeAllData=true)

public class TestOpportunityLineItemTrigger {
	
	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	final static String OPP_STAGE_NAME_2 = 'Pitched';
	final static String OPP_STAGE_NAME_3 = 'Contract Sent';
	final static String OPP_STAGE_NAME_4 = 'Contract Won';
	final static String OPP_STAGE_NAME_5 = 'Contract Lost';
	final static String OLI_WAITING_STATUS_1 = 'Awaiting Onboard';
	final static String OLI_WAITING_STATUS_2 = 'In Fulfillment';
	final static String OLI_WAITING_STATUS_3 = 'Waiting On Client Approval';
	final static String OLI_WAITING_STATUS_4 = 'Waiting On Client Resource';
	final static String OLI_WAITING_STATUS_5 = 'Live';
	final static String OLI_WAITING_STATUS_6 = 'Canceled';
	final static String OLI_WAITING_STATUS_7 = 'Pending';
	final static String OLI_WAITING_STATUS_8 = 'Fulfilled Renewed';
	final static String OLI_WAITING_STATUS_9 = 'Fulfilled Non-Renewal';
	final static String OLI_WAITING_STATUS_10 = 'Fulfilled-Complete';
	final static String OLI_WAITING_STATUS_11 = '--Internal Use Only--';
	final static String OLI_WAITING_STATUS_12 = 'Paused:Billing';
	final static String OLI_WAITING_STATUS_13 = 'Paused:No Contact';
	
	public static List<Opportunity_Product_History__c> getOppProductHistories(Id oliId){
		List<Opportunity_Product_History__c> actualOppProductHistories = [Select Id, Time_Out__c, Time_In__c, OLI_Project__c,
																				Opportunity_Product__c,Opportunity__c,
																				Duration__c,OLI_Stage__c, Opportunity_Product_Type__c, 
																				Product_Days_To_Go_Live__c, Product_Live_Date__c
																		  		From Opportunity_Product_History__c Where Opportunity_Product__c = :oliId];
		return actualOppProductHistories;
	}
	
	public testmethod static void testOpportunityLineItemInsert(){
		// new OLI History object created with time_in as created date and no time_out
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 1;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, false);

		Test.startTest();
			insert testOLI;
		Test.stopTest();
		
		List<Opportunity_Product_History__c> actualOppProdHistories = getOppProductHistories(testOLI.Id);
		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, actualOppProdHistories.size(), 'We expect to get back the correct number of Opportunity Product History objects for each New Opportunity Line Item');
		System.assertEquals(testOpp.Id, actualOppProdHistories[0].Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History');
		System.assertEquals(testOLI.Id, actualOppProdHistories[0].Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
		System.assertEquals(testOLI.Project__c, actualOppProdHistories[0].OLI_Project__c, 'We expect to get back the correct OLI Project for each Opportunity Product History');
		System.assertEquals(testOLI.Days_To_Go_Live__c , actualOppProdHistories[0].Product_Days_To_Go_Live__c, 'We expect to get back the correct days to live for the first Opportunity Product History record');
		System.assertEquals(testOLI.Live_Date__c , actualOppProdHistories[0].Product_Live_Date__c, 'We expect to get back the correct live date for the first Opportunity Product History record');
		System.assertEquals(OpportunityLineItemServices.CREATED_STAGE_NAME, actualOppProdHistories[0].OLI_Stage__c, 'We expect to get back the correct OLI Stage for each Opportunity Product History');
		
	}
	
	public testMethod static void testOpportunityLineItemInsertWithProductType(){
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 1;
		final String  EXPECTED_OPP_PROD_TYPE = 'Social';
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', false);
		testProd.Product_Type__c = EXPECTED_OPP_PROD_TYPE;
		insert testProd;
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, false);

		Test.startTest();
			insert testOLI;
		Test.stopTest();
		
		List<Opportunity_Product_History__c> actualOppProdHistories = getOppProductHistories(testOLI.Id);
		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, actualOppProdHistories.size(), 'We expect to get back the correct number of Opportunity Product History objects for each New Opportunity Line Item');
		System.assertEquals(testOpp.Id, actualOppProdHistories[0].Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History');
		System.assertEquals(testOLI.Id, actualOppProdHistories[0].Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
		//System.assertEquals(testOLI.Project__c, actualOppProdHistories[0].OLI_Project__c, 'We expect to get back the correct OLI Project for each Opportunity Product History');
		System.assertEquals(testOLI.Days_To_Go_Live__c , actualOppProdHistories[0].Product_Days_To_Go_Live__c, 'We expect to get back the correct days to live for the first Opportunity Product History record');
		System.assertEquals(testOLI.Live_Date__c , actualOppProdHistories[0].Product_Live_Date__c, 'We expect to get back the correct live date for the first Opportunity Product History record');
		//System.assertEquals(EXPECTED_OPP_PROD_TYPE, actualOppProdHistories[0].Opportunity_Product_Type__c, 'We expect to get back the correct Opportunity Product Type for each Opportunity Product History');
		System.assertEquals(OpportunityLineItemServices.CREATED_STAGE_NAME, actualOppProdHistories[0].OLI_Stage__c, 'We expect to get back the correct OLI Stage for each Opportunity Product History');
		
	}

	public testmethod static void testOpportunityLineItemUpdateNoStatusChange(){
		// no new OLI History objects
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 1;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); 
		
		Datetime OPP_PROD_1_TIME_IN = testOLI.LastModifiedDate.date();
		Datetime OPP_PROD_1_TIME_OUT = null; 
		
		testOLI.ServiceDate = Date.today().addDays(2); 
		
		Test.startTest();
			update testOLI;
		Test.stopTest();

		List<Opportunity_Product_History__c> actualOppProdHistories = getOppProductHistories(testOLI.Id); 
		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, actualOppProdHistories.size(), 'We expect to get back the correct number of Opportunity Product History objects for each New Opportunity Line Item');
		System.assertEquals(testOpp.Id, actualOppProdHistories[0].Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History');
		System.assertEquals(testOLI.Id, actualOppProdHistories[0].Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
		System.assertEquals(OPP_PROD_1_TIME_IN, actualOppProdHistories[0].Time_In__c.date(), 'We expect to get back the correct date/time of Time In for the first Opportunity Product History record');
		System.assertEquals(OPP_PROD_1_TIME_OUT, actualOppProdHistories[0].Time_Out__c, 'We expect to get back the correct date/time of Time Out for the first Opportunity Product History record');
		
		
	}
	
	public testmethod static void testOpportunityLineItemUpdateWithStatusChange(){
		// new OLI History objects created with latest record time_out updated
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 2;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); 
		Date OPP_PROD_1_TIME_IN = testOLI.CreatedDate.date();
		testOLI.ServiceDate = Date.today().addDays(2);
		testOLI.Waiting_Status__c = OLI_WAITING_STATUS_2;
		
		Test.startTest();
			OpportunityLineItemServices.processedOLIStatusChanges.remove(testOLI.ID);// trigger should process an ID only once per execution block
			// OpportunityLineItemServices.firstRun = true; // trigger should not run twice in same block of execution
			update testOLI;
		Test.stopTest();
		Map<Id, OpportunityLineItem> mapOppLineItems = new Map<Id, OpportunityLineItem>([Select Id, Project__c, LastModifiedDate
																		From OpportunityLineItem Where Id =: TestOLI.Id]);
		String OPP_PROD_PROJECT = mapOppLineItems.get(TestOLI.Id).Project__c;
		Date OPP_PROD_1_TIME_OUT = mapOppLineItems.get(TestOLI.Id).LastModifiedDate.date();
		Date OPP_PROD_2_TIME_IN = mapOppLineItems.get(TestOLI.Id).LastModifiedDate.date();

		List<Opportunity_Product_History__c> actualOppProdHistories = getOppProductHistories(testOLI.Id);

		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, actualOppProdHistories.size(), 'We expect to get back the correct number of Opportunity Product History objects for each New Opportunity Line Item');
		for (Opportunity_Product_History__c oppProdHist : actualOppProdHistories){
			System.assertEquals(testOpp.Id, oppProdHist.Opportunity__c, 'We expect to get back the correct Opportunity for each Opportunity Product History');
			System.assertEquals(testOLI.Id, oppProdHist.Opportunity_Product__c, 'We expect to get back the correct Opportunity Product for each Opportunity Product History');
			System.assertEquals(OPP_PROD_PROJECT, oppProdHist.OLI_Project__c, 'We expect to get back the correct OLI Project for each Opportunity Product History');
			System.assertEquals(testOLI.Days_To_Go_Live__c , oppProdHist.Product_Days_To_Go_Live__c, 'We expect to get back the correct days to live for the first Opportunity Product History record');
			System.assertEquals(testOLI.Live_Date__c , oppProdHist.Product_Live_Date__c, 'We expect to get back the correct live date for the first Opportunity Product History record');
		
		}
		System.assertEquals(OPP_PROD_1_TIME_IN, actualOppProdHistories[0].Time_In__c.date(), 'We expect to get back the created date of the opportunity product as the Time In of the first Opportunity Product History record');
		System.assertEquals(OPP_PROD_1_TIME_OUT, actualOppProdHistories[0].Time_Out__c.date(), 'We expect to get back the last modified date of the opportunity product as the Time Out of the first Opportunity Product History record');
		System.assertEquals(OPP_PROD_2_TIME_IN, actualOppProdHistories[1].Time_In__c.date(), 'We expect to get back the last modified date of the opportunity product as the Time In of the latest Opportunity Product History record');
		System.assertEquals(null, actualOppProdHistories[1].Time_Out__c, 'We expect to get back the last modified date of the opportunity product as the Time Out of the latest Opportunity Product History record');
		
	}
	
	public testmethod static void testOpportunityLineItemDelete(){
		// all related OLI History objects deleted
		
		final Integer NUM_EXPECTED_OPP_PROD_HISTORY = 0;
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLI(testPbe.Id, testOpp.Id, true);
		// assume OpportunityProductHistory record created : as tested in testOpportunityLineItemInsert()
		Test.startTest();
			OpportunityLineItemServices.processedOLIStatusChanges.remove(testOLI.ID);// trigger should process an ID only once per execution block
			//OpportunityLineItemServices.firstRun = true; // trigger should not run twice in same block of execution
			delete testOLI;
		Test.stopTest();
		
		List<Opportunity_Product_History__c> actualOppProdHistories = getOppProductHistories(testOLI.Id);
		System.assertEquals(NUM_EXPECTED_OPP_PROD_HISTORY, actualOppProdHistories.size(), 'We expect to get back no Opportunity Product History records for each deleted Opportunity Line Item');
	}
	
}