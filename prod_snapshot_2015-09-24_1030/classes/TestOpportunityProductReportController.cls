@isTest(SeeAllData=true)


public class TestOpportunityProductReportController {
	
	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	final static String OLI_WAITING_STATUS_0 = 'Created';
	final static String OLI_WAITING_STATUS_1 = 'Awaiting Onboard';
	final static String OLI_WAITING_STATUS_2 = 'In Fulfillment';
	final static String OLI_WAITING_STATUS_3 = 'Waiting On Client Approval';
	final static String OLI_WAITING_STATUS_4 = 'Waiting On Client Resource';
	
	public static Integer NUM_OLI = 2;
	public static OpportunityLineItem testOLI; 
	public static OpportunityLineItem testOLI2; 
	public static List<String> testOLIs; 
	
	static {
		
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp rpt controller', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		
		testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); // creates initial history record
		OpportunityLineItemServices.firstRun = true;
		testOLI2 = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); // creates initial history record
		
		testOLIs = new List<String>{testOLI.Id,testOLI2.Id};
		
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c From Opportunity_Product_History__c 
								Where Opportunity_Product__c in :testOLIs And Time_Out__c = null]);
		System.assertEquals(NUM_OLI, testOLIHistories.size(), 'We expect the trigger to create an initial opp product history record per Opportunity Product.');
	}
	
	private static Opportunity_Product_History__c  generateOppProdHistory(Id oliID, String waitingStatus, Datetime timeIn, Datetime timeOut, Double duration, String productType){
		
		
		Opportunity_Product_History__c testOLIHistory = TestingUtils.createOliHistory(1, false)[0];
		
		testOLIHistory.Opportunity_Product__c = oliID; 
		testOLIHistory.Opportunity_Product_Type__c = productType;
		testOLIHistory.OLI_Stage__c = waitingStatus; 
		testOLIHistory.Time_In__c = timeIn;
		testOLIHistory.Time_Out__c = timeOut;
		testOLIHistory.Duration__c = duration;

		insert testOLIHistory;
		
		return testOLIHistory;
		
	}
	
	private static Opportunity_Product_History__c  generateOppProdHistory(Id oliID, String waitingStatus, Datetime timeIn, Datetime timeOut, Double duration){
		return generateOppProdHistory(oliID, waitingStatus, timeIn, timeOut, duration, '');
	}

	
	private static List<Opportunity_Product_History__c> setupDataFilterBySelectedProducts( )
	{
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c, OLI_Stage__c From Opportunity_Product_History__c 
								Where Opportunity_Product__c in :testOLIs And Time_Out__c = null]);
	
		Datetime initTimeIn = Datetime.now(); 
		List<Datetime> timeTransitions = new List<Datetime>{initTimeIn.addHours(2), initTimeIn.addHours(5), initTimeIn.addDays(1)};
		
		testOLIHistories.addAll(new List<Opportunity_Product_History__c>{
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_0, initTimeIn, timeTransitions[0], 2),	//miss
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, initTimeIn, timeTransitions[0], 2), 	//hit
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_2, initTimeIn, timeTransitions[0], 2),	//miss
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, initTimeIn, timeTransitions[0], 2)	//hit
		});
		
		return testOLIHistories;
	}

	
	private static List<Opportunity_Product_History__c> setupDataFilterByStartDate( Datetime initStartDate )
	{
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c,OLI_Stage__c From Opportunity_Product_History__c 
								Where Opportunity_Product__c in :testOLIs And Time_Out__c = null]);
	
		List<Datetime> timeTransitions = new List<Datetime>{initStartDate.addDays(1), initStartDate.addDays(2), initStartDate.addDays(3)};
		
		testOLIHistories.addAll(new List<Opportunity_Product_History__c>{
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_0, initStartDate, timeTransitions[0], 2), 		// miss
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[0], timeTransitions[1], 2), 	// miss
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_2, timeTransitions[1], timeTransitions[2], 2), 	// hit 
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[1], timeTransitions[2], 2) 	// hit
		});
		
		return testOLIHistories;
	}
	
	
	private static List<Opportunity_Product_History__c> setupDataFilterByEndDate( Datetime initStartDate )
	{
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c,OLI_Stage__c From Opportunity_Product_History__c 
								Where Opportunity_Product__c in :testOLIs And Time_Out__c = null]);
	
		List<Datetime> timeTransitions = new List<Datetime>{initStartDate.addDays(1), initStartDate.addDays(2), initStartDate.addDays(3)};
		
		testOLIHistories.addAll(new List<Opportunity_Product_History__c>{
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_0, initStartDate, timeTransitions[0], 2), 		// hit
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[0], timeTransitions[1], 2), 	// hit
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_2, timeTransitions[1], timeTransitions[2], 2), 	// miss 
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[1], timeTransitions[2], 2) 	// miss
		});
		
		return testOLIHistories;
	}
	
	
	private static List<Opportunity_Product_History__c> setupDataFilterBySelectedProductType( )
	{
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c,OLI_Stage__c, Opportunity_Product_Type__c From Opportunity_Product_History__c 
								Where Opportunity_Product__c in :testOLIs And Time_Out__c = null]);
	
		Datetime initStartDate = Datetime.now(); 
		List<Datetime> timeTransitions = new List<Datetime>{initStartDate.addDays(1), initStartDate.addDays(2), initStartDate.addDays(3)};
		
		testOLIHistories.addAll(new List<Opportunity_Product_History__c>{
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_0, initStartDate, timeTransitions[0], 2, 'Social'), 		// hit
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[0], timeTransitions[1], 2), 	// miss
			generateOppProdHistory(testOLI.Id, OLI_WAITING_STATUS_2, timeTransitions[1], timeTransitions[2], 2, 'Social'), 	// hit 
			generateOppProdHistory(testOLI2.Id, OLI_WAITING_STATUS_1, timeTransitions[1], timeTransitions[2], 2) 	// miss
		});
		
		return testOLIHistories;
	}


	public static testMethod void testOpportunityProductReportController (){

		List<SelectOption> expectedProdOptions = new List<SelectOption>{OpportunityProductReportController.ALL_PRODUCT_STATUSES};
		Schema.DescribeFieldResult F2 = OpportunityLineItem.Waiting_Status__c.getDescribe();
		List<Schema.PicklistEntry> stageNamesPickList = F2.getPicklistValues();
		for (Schema.PicklistEntry stageEntry : stageNamesPickList){
			if (stageEntry.getLabel().contains('Internal Use Only')) break;
			expectedProdOptions.add(new SelectOption(stageEntry.getValue(), stageEntry.getLabel()));
		}	

		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
		Test.stopTest();
		
		System.assertEquals(OpportunityProductReportController.ALL_PRODUCT_STATUSES.getValue(), oliRptCont.selectedProductStatus, 'We expect to default to the all selected account types');
		System.assertEquals(expectedProdOptions, OpportunityProductReportController.getProductStatuses, 'We expect to have a list of all field picklist values for Product Statuses');
		System.assertEquals(0, oliRptCont.getOppProdHistResults.size(), 'We do not expect to have any data in the chart when no products are selected and no filter is applied.');


	}
	
	public static testMethod void testRunReportWithNoFilterNoSelected () {

		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.runReport();
		Test.stopTest();
		
		System.assertEquals(0, oliRptCont.getOppProdHistResults.size(), 'We do not expect to have any data in the chart when no products are selected and no filter is applied.');
	}
	

	public static testMethod void testRunReportWithOneSelected () {

		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.add(new SelectOption(testOLI.Id, testOLI.Id));
			oliRptCont.runReport();
		Test.stopTest();
		
		System.assertEquals(1, oliRptCont.getOppProdHistResults.size(), 'We expect to have one Opp History Record in the chart when one product is selected and no filter is applied.');
		
	}
	

	public static void testRunReportWithAllSelected () {

		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.addAll(oliRptCont.allProducts);
			oliRptCont.runReport();
		Test.stopTest();
		
		System.assertEquals(NUM_OLI, oliRptCont.getOppProdHistResults.size(), 'We expect to have all Opp History Record in the chart when all products are selected and no filter is applied.');
		
	}
	
	public static testMethod void testRunReportWithAllSelectedAndFilterStatus () {
		
		final String expectedProductStatus = OLI_WAITING_STATUS_1;
		final Integer NUM_EXPECTED_PROD_STATUS_1 = 2;
		
		List<Opportunity_Product_History__c> allOppProdHist = setupDataFilterBySelectedProducts();
		Set<Id> expectedOppProdHist = new Set<Id>();
		for (Opportunity_Product_History__c oppHist : allOppProdHist){
			if (oppHist.OLI_Stage__c == expectedProductStatus)
				expectedOppProdHist.add(oppHist.Id);
		}
		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.addAll(new List<SelectOption>{new SelectOption(testOLI.Id, testOLI.Id), new SelectOption(testOLI2.Id, testOLI2.Id)});
			oliRptCont.selectedProductStatus = expectedProductStatus;
			oliRptCont.runReport();
		Test.stopTest();
		System.assertEquals(NUM_EXPECTED_PROD_STATUS_1, oliRptCont.getOppProdHistResults.size(), 'We expect to have all Opp History Record in the chart when all products are selected and no filter is applied.');
		for (Opportunity_Product_History__c oppProdHist : oliRptCont.getOppProdHistResults){
			System.assertEquals(expectedProductStatus, oppProdHist.OLI_Stage__c, 'We expect to filter only the Opp Prod History records with the selected Product Status');
			System.assert(expectedOppProdHist.contains(oppProdHist.Id), 'We expect to get back the expected Opp Prod History record');
		}
	
	
	}
	
	
	public static testMethod void testRunReportWithAllSelectedAndFilterProductType () {
		
		final String expectedProductType = 'Social';
		final Integer NUM_EXPECTED_PROD_TYPE = 2;
		
		List<Opportunity_Product_History__c> allOppProdHist = setupDataFilterBySelectedProductType();
		Set<Id> expectedOppProdHist = new Set<Id>();
		for (Opportunity_Product_History__c oppHist : allOppProdHist){
			if (oppHist.Opportunity_Product_Type__c == expectedProductType)
				expectedOppProdHist.add(oppHist.Id);
		}
		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.addAll(new List<SelectOption>{new SelectOption(testOLI.Id, testOLI.Id), new SelectOption(testOLI2.Id, testOLI2.Id)});
			oliRptCont.selectedProductType = expectedProductType;
			oliRptCont.runReport();
		Test.stopTest();
		System.assertEquals(NUM_EXPECTED_PROD_TYPE, oliRptCont.getOppProdHistResults.size(), 'We expect to have all Opp History Record in the chart when all products are selected and no filter is applied.');
		for (Opportunity_Product_History__c oppProdHist : oliRptCont.getOppProdHistResults){
			System.assertEquals(expectedProductType, oppProdHist.Opportunity_Product_Type__c, 'We expect to filter only the Opp Prod History records with the selected Product Type');
			System.assert(expectedOppProdHist.contains(oppProdHist.Id), 'We expect to get back the expected Opp Prod History record');
		}
	
	
	}
	
	
	
	
	public static testMethod void testRunReportWithAllSelectedAndFilterStartDate () {
		
		final Integer NUM_EXPECTED_WITH_START_DATE = 2;
		Date initialCreationDate = Date.today();
		Date expectedStartDate = initialCreationDate.addDays(2);
		
		List<Opportunity_Product_History__c> allOppProdHist = setupDataFilterByStartDate(initialCreationDate);

		Set<Id> expectedOppProdHist = new Set<Id>();
		for (Opportunity_Product_History__c oppHist : allOppProdHist){
			if (oppHist.Time_In__c >= expectedStartDate)
				expectedOppProdHist.add(oppHist.Id);
		}
		
		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.addAll(new List<SelectOption>{new SelectOption(testOLI.Id, testOLI.Id), new SelectOption(testOLI2.Id, testOLI2.Id)});
			oliRptCont.selectedStartDate = expectedStartDate;
			oliRptCont.runReport();
		Test.stopTest();
		
		System.assertEquals(NUM_EXPECTED_WITH_START_DATE, oliRptCont.getOppProdHistResults.size(), 'We expect to have two Opp History Records in the chart when start date filter is applied.');
		for (Opportunity_Product_History__c oppProdHist : oliRptCont.getOppProdHistResults){
			System.assert(oppProdHist.Time_In__c >= expectedStartDate, 'We expect to filter only the Opp Prod History records with a time in entry greater than or equal to the selected start date.');
			System.assert(expectedOppProdHist.contains(oppProdHist.Id), 'We expect to get back the expected Opp Prod History record');
		}
	
	
	}
	
	public static testMethod void testRunReportWithAllSelectedAndFilterEndDate () {
		
		final Integer NUM_EXPECTED_WITH_END_DATE = 2;
		Date initialCreationDate = Date.today();
		Date expectedEndDate = initialCreationDate.addDays(2);
		
		List<Opportunity_Product_History__c> allOppProdHist = setupDataFilterByEndDate(initialCreationDate);

		Set<Id> expectedOppProdHist = new Set<Id>();
		for (Opportunity_Product_History__c oppHist : allOppProdHist){
			if (oppHist.Time_Out__c <= expectedEndDate)
				expectedOppProdHist.add(oppHist.Id);
		}
		
		Test.startTest();
			OpportunityProductReportController oliRptCont = new OpportunityProductReportController();
			oliRptCont.selectedProducts.addAll(new List<SelectOption>{new SelectOption(testOLI.Id, testOLI.Id), new SelectOption(testOLI2.Id, testOLI2.Id)});
			oliRptCont.selectedEndDate = expectedEndDate;
			oliRptCont.runReport();
		Test.stopTest();
		
		System.assertEquals(NUM_EXPECTED_WITH_END_DATE, oliRptCont.getOppProdHistResults.size(), 'We expect to have two Opp History Records in the chart when end date filter is applied.');
		for (Opportunity_Product_History__c oppProdHist : oliRptCont.getOppProdHistResults){
			System.assert(oppProdHist.Time_Out__c <= expectedEndDate, 'We expect to filter only the Opp Prod History records with a time out entry less than or equal to the selected end date.');
			System.assert(expectedOppProdHist.contains(oppProdHist.Id), 'We expect to get back the expected Opp Prod History record');
		}
	
	
	}
	
	
	
	
	
	
}