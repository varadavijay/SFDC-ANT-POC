@isTest(seeAllData=true)

private class TestOpportunityLineItemExt { 

	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	final static String OLI_WAITING_STATUS_0 = 'Created';
	final static String OLI_WAITING_STATUS_1 = 'Awaiting Onboard';
	final static String OLI_WAITING_STATUS_2 = 'In Fulfillment';
	final static String OLI_WAITING_STATUS_3 = 'Waiting On Client Approval';
	final static String OLI_WAITING_STATUS_4 = 'Waiting On Client Resource';
	
	public static testMethod void testGetFieldNameForDifferentDepths()
	{
		List<Integer> depths = new List<Integer> {1,2,3,4,5,6,7,8,9};
		Set<String> fieldNamesEncountered = new Set<String>();
		
		Test.startTest();
			for(Integer i : depths)
			{
				fieldNamesEncountered.add(OpportunityLineItemChartServices.getFieldName(i));
			}
		Test.stopTest();
		
		System.assertEquals(depths.size(),fieldNamesEncountered.size(),'For each unique depth value, getFieldName must result in a unique string');
		for(String s : fieldNamesEncountered)
		{
			System.assert(s.contains(OpportunityLineItemChartServices.FIELD_NAME_PREFIX),'The field name must begin with a consistent prefix');
		}
	}
	
	public static testMethod void testGetFieldNameForIdenticalDepths()
	{
		List<Integer> depths = new List<Integer> {2,2,2,2,2,2,2,2,2,2};
		Set<String> fieldNamesEncountered = new Set<String>();
		
		Test.startTest();
			for(Integer i : depths)
			{
				fieldNamesEncountered.add(OpportunityLineItemChartServices.getFieldName(i));
			}
		Test.stopTest();
		
		System.assertEquals(1,fieldNamesEncountered.size(),'Every call of getFieldName for the same depth will result in the same field name');
		for(String s : fieldNamesEncountered)
		{
			System.assert(s.contains(OpportunityLineItemChartServices.FIELD_NAME_PREFIX),'The field name must begin with a consistent prefix');
		}
	}
	
	public static testMethod void testDataPointManipulation()
	{
		final Double sampleValue = 1.5;
		
		OpportunityLineItemChartServices.Data dataOne = new OpportunityLineItemChartServices.Data('Test One');
		dataOne.setDataPoint(1,sampleValue);
		dataOne.setDataPoint(2,0);
		dataOne.setDataPoint(3,null);
		
		Test.startTest();
			Double dataPoint1 = dataOne.getDataPoint(1);
			Double dataPoint2 = dataOne.getDataPoint(2);
			Double dataPoint3 = dataOne.getDataPoint(3);
			Double dataPoint45 = dataOne.getDataPoint(45);
		Test.stopTest();
		
		System.assertEquals(sampleValue,dataPoint1,'For every non-null value specified into a data point, when we access that data point, we will retrieve the same value');
		System.assertEquals(0,dataPoint2,'For every non-null value specified into a data point, when we access that data point, we will retrieve the same value');
		System.assertEquals(0,dataPoint3,'For every null value specified into a data point, when we access that data point, we will retrieve 0');
		System.assertEquals(0,dataPoint45,'When we try to access a data point that has not been specified, we will retrieve 0');
	}
	public static testMethod void testFindMaxDataPointDepth()
	{
		OpportunityLineItemChartServices.Data dataOne = new OpportunityLineItemChartServices.Data('Test One');
		dataOne.setDataPoint(1,Double.valueOf(1.5));
		dataOne.setDataPoint(2,Double.valueOf(2.5));
		dataOne.setDataPoint(3,0);
		dataOne.setDataPoint(4,Double.valueOf(9));
		dataOne.setDataPoint(5,null);
		dataOne.setDataPoint(6,0);
		dataOne.setDataPoint(7,null);
		
		OpportunityLineItemChartServices.Data dataTwo = new OpportunityLineItemChartServices.Data('Test Two');
		dataTwo.setDataPoint(1,Double.valueOf(55));
		dataTwo.setDataPoint(2,Double.valueOf(1.5));
		
		List<OpportunityLineItemChartServices.Data> dataElements = new List<OpportunityLineItemChartServices.Data> {dataOne, dataTwo};
		
		Test.startTest();
			Integer maxDataPointDepth = OpportunityLineItemChartServices.findMaxDataPointDepth(dataElements);
		Test.stopTest();
		
		System.assertEquals(6,maxDataPointDepth,'We expect to find the correct maximum data point depth of all of the data elements specified. Any trailing null data points are not counted as part of the data point depth');
	}
	
	public static testMethod void testFindMaxDataPointDepthWhenNoData()
	{
		OpportunityLineItemChartServices.Data dataOne = new OpportunityLineItemChartServices.Data('Test One');
		
		List<OpportunityLineItemChartServices.Data> dataElements = new List<OpportunityLineItemChartServices.Data> {dataOne};
		
		Test.startTest();
			Integer maxDataPointDepth = OpportunityLineItemChartServices.findMaxDataPointDepth(dataElements);
		Test.stopTest();
		
		System.assertEquals(1,maxDataPointDepth, 'If no data is specified for all the data elements specified, we expect a maximum data point depth of 1');
	}
	
	public static testMethod void testPrintDataFieldDepth1() {
		Test.startTest();
			String result = OpportunityLineItemChartServices.printDataFieldDepth(1);
		Test.stopTest();
		
		String expectedResult = OpportunityLineItemChartServices.getFieldName(1);
		
		System.assertEquals(expectedResult,result, 'When the specified depth is one, we only expect to get back the field name that corresponds to the depth of 1');
	}
	
	public static testMethod void testPrintDataFieldDepthGreaterThan1() {
		Integer maxDepth = 5;
		Set<String> expectedDataFields = new Set<String>();
		for(Integer i = 1; i <= maxDepth; i++)
		{
			expectedDataFields.add(OpportunityLineItemChartServices.getFieldName(i));
		}
		
		Test.startTest();
			String result = OpportunityLineItemChartServices.printDataFieldDepth(maxDepth);
		Test.stopTest();
		
		Set<String> dataFields = new Set<String>(result.split(','));
		System.assert(expectedDataFields == dataFields,'We expect to get back the same number of data fields as the depth, seperated by a comma');
	}
	
	public static testMethod void toJSON()
	{
		OpportunityLineItemChartServices.Data stageOneData = new OpportunityLineItemChartServices.Data('Stage-One');
		stageOneData.setDataPoint(1,Double.valueOf(2.3));
		stageOneData.setDataPoint(2,Double.valueOf(5));
		stageOneData.setDataPoint(3,Double.valueOf(7));
		OpportunityLineItemChartServices.Data stageTwoData = new OpportunityLineItemChartServices.Data('Stage-Two');
		stageTwoData.setDataPoint(1,Double.valueOf(2.3));
		stageTwoData.setDataPoint(2,Double.valueOf(5));
		stageTwoData.setDataPoint(3,Double.valueOf(7));
		stageTwoData.setDataPoint(4,Double.valueOf(0));
		stageTwoData.setDataPoint(5,Double.valueOf(6));
		
		Map<String, OpportunityLineItemChartServices.Data> nameToData = new Map<String, OpportunityLineItemChartServices.Data>();
		nameToData.put(stageOneData.name,stageOneData);
		nameToData.put(stageTwoData.name,stageTwoData);
		
		final Integer maxDepth = 2;
		
		Test.startTest();
			String jsonString = OpportunityLineItemChartServices.toJSON(nameToData.values(),maxDepth);
		Test.stopTest();
		
		JSONParser parser = JSON.createParser(jsonString);
		System.assertEquals(JSONToken.START_ARRAY,parser.nextToken(), 'The first token in the JSON string must indicate the start of the array of data elements');
		
		Set<String> allNamesEncountered = new Set<String>();
		while(parser.nextToken()!=null)
		{
			if(parser.getCurrentToken()==JSONToken.END_ARRAY)
			{
				System.assert(allNamesEncountered==nameToData.keySet(),'We must produce a JSON object for each data element');
				System.assertEquals(null,parser.nextToken(), 'If we encounter the token that indicates that the array of data elements is ended, then we do not expect to find any more JSON elements');
			}
			else if(parser.getCurrentToken()==JSONToken.START_OBJECT)
			{
				Boolean endObjectEncountered = false;
				Map<String, Double> actualDatapointValues = new Map<String, Double>();
				String nameEncountered = '';
				while(parser.nextToken()!=null)
				{
					if(parser.getCurrentToken()==JSONToken.END_OBJECT)
					{
						System.assert(nameToData.containsKey(nameEncountered),'The name that we encounter for our data element must be valid');
						for(Integer depth = 1; depth <= maxDepth; depth++)
						{
							Double actualValue = actualDatapointValues.get(OpportunityLineItemChartServices.getFieldName(depth));
							Double expectedValue = nameToData.get(nameEncountered).getDataPoint(depth);
							System.assertNotEquals(null,actualValue,'There must be a data point value discovered for each possible depth');
							System.assertEquals(expectedValue, actualValue, 'We expect to get back the right data point value for each possible depth');
						}
						allNamesEncountered.add(nameEncountered);
						endObjectEncountered = true;
					}
					else if(parser.getCurrentToken()==JSONToken.FIELD_NAME)
					{
						String fieldName = parser.getCurrentName();
						if(fieldName!='name')
						{
							if(parser.nextToken()==JSONToken.VALUE_NUMBER_FLOAT)
							{
								actualDatapointValues.put(fieldName,parser.getDoubleValue());
							}
							else
							{
								System.assert(false,'Every data point field must have a double value');
							}
						}
						else
						{
							if(parser.nextToken()==JSONToken.VALUE_STRING)
							{
								nameEncountered = parser.getText();
							}
							else
							{
								System.assert(false,'The name field must be followed with a string value');
							}
						}
					}
				}
				System.assert(endObjectEncountered,'Every time we encounter the JSON token that indicates the start of the object, we expect it to be ultimately closed by the JSON token that indicates end of object');
			}
			else
			{
				System.assert(false,'The JSON string is not correctly constructed.');
			}
		}
		
		
	}
	
	public static testMethod void testOpportunityLineItemExt(){
		
		Account testAccount = TestingUtils.createAccounts(1, true)[0];
		Opportunity testOpp = TestingUtils.createOpportunities(1, 'test opp', testAccount.Id, false)[0];
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOpp;
		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		
		final Integer NUM_STATUS_CHANGES = 3; 
		Datetime initTimeIn = Datetime.now(); 
		List<Datetime> timeTransitions = new List<Datetime>{initTimeIn.addHours(2), initTimeIn.addHours(5), initTimeIn.addDays(1)};
		
		OpportunityLineItem testOLI = TestingUtils.createOLIandGetRecordInfo(testPbe.Id, testOpp.Id, true); // creates initial history record
		List<Opportunity_Product_History__c> testOLIHistories = new List<Opportunity_Product_History__c>();
		
		testOLIHistories.addAll([Select Id, Time_In__c, Time_Out__c From Opportunity_Product_History__c Where Opportunity_Product__c = :testOLI.Id And Time_Out__c = null]);
		
		System.assertEquals(1, testOLIHistories.size(), 'We expect the trigger to create an initial opp product history record per Opportunity Product.');
		
		testOLIHistories.addAll(TestingUtils.createOliHistory(NUM_STATUS_CHANGES, false));
		
		testOLIHistories[0].Opportunity_Product__c = testOLI.Id;
		testOLIHistories[0].OLI_Stage__c = OLI_WAITING_STATUS_1;
		testOLIHistories[0].Time_In__c = initTimeIn;
		testOLIHistories[0].Time_Out__c = timeTransitions[0];
		testOLIHistories[0].Duration__c = 2;
		
		testOLIHistories[1].Opportunity_Product__c = testOLI.Id;
		testOLIHistories[1].OLI_Stage__c = OLI_WAITING_STATUS_2;
		testOLIHistories[1].Time_In__c = timeTransitions[0];
		testOLIHistories[1].Time_Out__c = timeTransitions[1];
		testOLIHistories[1].Duration__c = 3;
		
		testOLIHistories[2].Opportunity_Product__c = testOLI.Id;
		testOLIHistories[2].OLI_Stage__c = OLI_WAITING_STATUS_3;
		testOLIHistories[2].Time_In__c = timeTransitions[1];
		testOLIHistories[2].Time_Out__c = timeTransitions[2];
		testOLIHistories[2].Duration__c = 24;
		
		testOLIHistories[3].Opportunity_Product__c = testOLI.Id;
		testOLIHistories[3].OLI_Stage__c = OLI_WAITING_STATUS_2;
		testOLIHistories[3].Time_In__c = timeTransitions[2];
		testOLIHistories[3].Time_Out__c = null;
		testOLIHistories[3].Duration__c = 5;
		upsert testOLIHistories;
		
		final String EXPECTED_FIELD_LEVEL_DEPTH = OpportunityLineItemChartServices.printDataFieldDepth(2);
		Set<String> expectedStages = new Set<String>{OLI_WAITING_STATUS_0, OLI_WAITING_STATUS_1, OLI_WAITING_STATUS_2, OLI_WAITING_STATUS_3};
		Set<Id> expectedOLIs = new Set<Id>{testOLIHistories[0].Id,testOLIHistories[1].Id,testOLIHistories[2].Id,testOLIHistories[3].Id};
		
		Test.startTest();
			ApexPages.StandardController stdController = new ApexPages.StandardController(testOLI);
		    OpportunityLineItemExt controllerExt = new OpportunityLineItemExt (stdController);
		Test.stopTest();
		
		
		System.assertEquals(testOLIHistories.size(), controllerExt.HistoryTrack.size(), 'We expect to receive the correct number of raw History Records in the controller extention');
		System.assertEquals(testOLIHistories.size(), controllerExt.HistoryTrackRecords.size(), 'We expect to receive the correct number of Wrapper History Records in the controller extention');
		for (OpportunityLineItemChartServices.OppProductHistoryRecord historyRecord : controllerExt.HistoryTrackRecords){
			System.assert(expectedOLIs.contains(historyRecord.record.Id), 'We only expect to retrieve Opportunity Product History records that are associated with the current Opportunity Line Item');
			System.assertEquals(historyRecord.backtrack ? OpportunityLineItemChartServices.BACKGROUND_ROW_STYLE : OpportunityLineItemChartServices.BACKGROUND_ROW_STYLE_DEFAULT, historyRecord.styleClass, 'We expect to get back the right CSS style on History records based on the backtrack status');
			System.assertEquals(historyRecord.isCurrent ? historyRecord.runningTime : historyRecord.record.Duration__c, historyRecord.getDuration, 'We expect to get back the right duration on History records based on the current status');
		}
		System.assertEquals(EXPECTED_FIELD_LEVEL_DEPTH, controllerExt.dataFieldDepth, 'We expect to receive the correct field level depth from the Data objects');
		for (OpportunityLineItemChartServices.Data dataRecord : controllerExt.oliChartServices.chartDataOrder){
			if (!dataRecord.dataPoints.values().isEmpty()){
				System.assert(expectedStages.contains(dataRecord.name), 'We only expect to get back data records for the expected stages');
				
				if (dataRecord.name == testOLIHistories[0].OLI_Stage__c){
					System.assert(dataRecord.dataPoints.values().size() == 1, 'We only expect to get back one data point for the stage 1');
					System.assertEquals(testOLIHistories[0].Duration__c, dataRecord.getDataPoint(1), 'We expect to get back to get back the correct duration for stage 1 field index 1');
				}
				else if (dataRecord.name == testOLIHistories[1].OLI_Stage__c){
					System.assert(dataRecord.dataPoints.values().size() == 2, 'We only expect to get back two data points for the stage 2');
					System.assertEquals(testOLIHistories[1].Duration__c, dataRecord.getDataPoint(1), 'We expect to get back to get back the correct duration for stage 2 field index 1');
					System.assertEquals(testOLIHistories[3].Duration__c, dataRecord.getDataPoint(2), 'We expect to get back to get back the correct duration for stage 2 field index 2');
				} 
				else if (dataRecord.name == testOLIHistories[2].OLI_Stage__c){
					System.assert(dataRecord.dataPoints.values().size() == 1, 'We only expect to get back one data point for the stage 3');
					System.assertEquals(testOLIHistories[2].Duration__c, dataRecord.getDataPoint(1), 'We expect to get back to get back the correct duration for stage 3 field index 1');
				} 
			}
		}
	}
	
}