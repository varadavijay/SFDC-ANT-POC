@isTest(SeeAllData=True)

private class TestOpportunityServices {
	
	// these are the different picklist values and are subject to change
	final static String OPP_STAGE_NAME_CLOSED_WON =  'Closed Won';
	final static String OLI_STAGE_NAME_CLOSED_WON =  'Closed Won';
	final static String OPP_STAGE_NAME_1 = 'Book Appointment';
	
	private static Account testAccount;
		
	
	static {
		testAccount = TestingUtils.createAccounts(1, true)[0];
	}
	
	public static testMethod void testSetGOAssistEmail(){
		Integer TOTAL_NUMBER_OPPS = 4; 
	    User[] GOAssistUsers = [SELECT 	ID 
	    						FROM 	User 
	    						where isactive = true
	    						and (email!= null or email!='') 
	    						limit 4];
		List<Opportunity> allOpps = TestingUtils.createOpportunities(TOTAL_NUMBER_OPPS, 'test opp', testAccount.Id, false);
		//Test setGOAssistEmail on Insert
		allOpps[0].GL_Assisting_Rep__c = GOAssistUsers[0].ID;
		allOpps[0].GL_Assist_Rep_2__c = GOAssistUsers[1].ID;
		allOpps[1].GL_Assisting_Rep__c = GOAssistUsers[1].ID;
		allOpps[1].GL_Assist_Rep_2__c = GOAssistUsers[2].ID;
		
		for (Opportunity o : allOpps){
			o.StageName = 'Pitched';
			o.CloseDate = Date.today()+1;
		}
		Test.startTest();
		insert allOpps;
		//Test setGOAssistEmail on Update
		allOpps[1].GL_Assisting_Rep__c = null;
		allOpps[1].GL_Assist_Rep_2__c = null;
		allOpps[2].GL_Assisting_Rep__c = GOAssistUsers[2].ID;
		allOpps[2].GL_Assist_Rep_2__c = GOAssistUsers[3].ID;
   		update allOpps;
   		Test.stopTest();
   		
   		set<ID> oppIDs = new map<ID,Opportunity>(allOpps).keyset();
   		list<Opportunity> updatedInfo = [SELECT ID, 
   												GL_Assisting_Rep__c, 
   												GL_Assisting_Rep__r.Email, 
   												GL_Assisting_Rep_Email__c, 
   												GL_Assist_Rep_2__c, 
   												GL_Assist_Rep_2__r.Email,
   												GL_Assisting_Rep_2_Email__c 
   										from opportunity
										where id in :oppIDs];

		for (Opportunity opp: updatedInfo){
			if (opp.ID == allOpps[0].ID){
				system.assertEquals(opp.GL_Assisting_Rep__r.Email,opp.GL_Assisting_Rep_Email__c,'We expect GL Assist Rep Email to be populated on Insert if a Assist Rep is specified');
				system.assertEquals(opp.GL_Assist_Rep_2__r.Email,opp.GL_Assisting_Rep_2_Email__c,'We expect GL Assist  Rep 2 Email to be populated on Insert if a Assist Rep 2 is specified');
			}else if (opp.ID == allOpps[2].ID){
				system.assertEquals(opp.GL_Assisting_Rep__r.Email,opp.GL_Assisting_Rep_Email__c,'We expect GL Assist Rep Email to be populated on Insert if a Assist Rep is specified');
				system.assertEquals(opp.GL_Assist_Rep_2__r.Email,opp.GL_Assisting_Rep_2_Email__c,'We expect GL Assist  Rep 2 Email to be populated on Insert if a Assist Rep 2 is specified');
			}else{
				system.assertEquals(null,opp.GL_Assisting_Rep_Email__c,'We expect null emails when a Assist Rep is not specified and when it has been reset');
				system.assertEquals(null,opp.GL_Assisting_Rep_2_Email__c,'We expect null emails when a Assist Rep 2 is not specified and when it has been reset');
			}
		}
	}
	
	public static testMethod void testFilterOpportunitiesWithClosedWon() {
		
		Integer NUM_EXPECTED_CLOSED_WON = 2; 
		Integer TOTAL_NUMBER_OPPS = 4; 
	   
		List<Opportunity> allOpps = TestingUtils.createOpportunities(TOTAL_NUMBER_OPPS, 'test opp', testAccount.Id, false);
		for (Opportunity o : allOpps){
			o.StageName = 'Pitched';
			o.CloseDate = Date.today()+1;
		}
		insert allOpps;
		
		Map<Id, Opportunity> allOppOldMap = new Map<Id, Opportunity>(allOpps.deepClone(true));
		Set<Opportunity> validOpps = new Set<Opportunity>();
		for (Integer i=0; i<TOTAL_NUMBER_OPPS; i++){
			if (i < NUM_EXPECTED_CLOSED_WON){
				allOpps[i].StageName = OPP_STAGE_NAME_CLOSED_WON;
				allOpps[i].Signature_Override__c = true;
				validOpps.add(allOpps[i]);
			}
		}
		
   		update allOpps;
   		
       	Test.startTest();
       		List<Opportunity> filteredOpps = OpportunityServices.filterOpportunitiesWithClosedWon(allOpps, allOppOldMap);
   		Test.stopTest();

   		System.assertEquals(NUM_EXPECTED_CLOSED_WON, filteredOpps.size(), 'We expect to get back only the opportunity that have stage in Closed Won');
		System.assert(validOpps.containsAll(filteredOpps), 'We expect to get back all the valid Closed Won opportunities');
    }
    
    
    
    public static List<OpportunityLineItem> setupOLIs(Opportunity testOppClosedWon, Opportunity testOpp){

		Pricebook2 testStandardPriceBook = [select id from Pricebook2 where IsStandard = true];
		Product2 testProd = TestingUtils.createProduct('test prod', true);
		Product2 testProd2 = TestingUtils.createProduct('test prod2', true);
		PriceBookEntry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, testStandardPriceBook.Id, true);
		PriceBookEntry testPbe2 = TestingUtils.createPriceBookEntry(testProd2.Id, testStandardPriceBook.Id, true);
		
		OpportunityLineItem testOLI = TestingUtils.createOLI(testPbe.Id, testOppClosedWon.Id, false); 
		OpportunityLineItem testOLI2 = TestingUtils.createOLI(testPbe2.Id, testOppClosedWon.Id, false); 
		OpportunityLineItem testOLI3 = TestingUtils.createOLI(testPbe2.Id, testOpp.Id, false); 
		OpportunityLineItem testOLI4 = TestingUtils.createOLI(testPbe.Id, testOpp.Id, false); 
		testOLI.ServiceDate = Date.today().addDays(2);
		testOLI2.ServiceDate = Date.today().addDays(2);
		testOLI3.ServiceDate = Date.today().addDays(2);
		testOLI4.ServiceDate = Date.today().addDays(2);
		
		return new List<OpportunityLineItem>{testOLI,testOLI2,testOLI3,testOLI4};
		
		
	}
	
	
    public static testMethod void testProcessOppProductOnClosedWonOpportunity(){
    	
    	final Integer NUM_EXPECTED_OLI_WITH_CLOSED_WON = 2;

		List<Opportunity> testOppList = TestingUtils.createOpportunities(2, 'test opp', testAccount.Id, false);
		Opportunity testOppClosedWon = testOppList[0];
		Opportunity testOpp = testOppList[1];
		testOppClosedWon.StageName = OPP_STAGE_NAME_CLOSED_WON;
		testOppClosedWon.Signature_Override__c = true;
		testOppClosedWon.CloseDate = Date.today().addDays(1);
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOppList;
		
		List<OpportunityLineItem> testOLIList = setupOLIs(testOppClosedWon, testOpp);
		insert testOLIList;

		Test.startTest();
			List<OpportunityLineItem> closedWonOLIS = OpportunityServices.processOpportunitiesWithClosedWon(new List<Opportunity>{testOppClosedWon});
		Test.stopTest();

		System.assertEquals(NUM_EXPECTED_OLI_WITH_CLOSED_WON, closedWonOLIS.size(), 'We expect to get back the correct number of Opportunity Products for each Opportunity that is Closed Won');
		for (OpportunityLineItem oli : closedWonOLIS){
			System.assertEquals(testOppClosedWon.Id, oli.OpportunityId, 'We expect to get back the opportunity line items for the closed won opportunity');
			System.assertEquals(OLI_STAGE_NAME_CLOSED_WON, oli.Waiting_Status__c, 'We expect to get back the closed won picklist value on each opportunity product');
		}
		
    }
    
    public static testMethod void testUpdateOppProductOnClosedWonOpportunity(){
    	
    	final Integer NUM_EXPECTED_OLI_WITH_CLOSED_WON = 2;

		List<Opportunity> testOppList = TestingUtils.createOpportunities(2, 'test opp', testAccount.Id, false);
		Opportunity testOppClosedWon = testOppList[0];
		Opportunity testOpp = testOppList[1];
		testOppClosedWon.StageName = OPP_STAGE_NAME_CLOSED_WON;
		testOppClosedWon.Signature_Override__c = true;
		testOppClosedWon.CloseDate = Date.today().addDays(1);
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOppList;
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(testOppList);
		List<OpportunityLineItem> testOLIList = setupOLIs(testOppClosedWon, testOpp);
		insert testOLIList;
		
		List<OpportunityLineItem> closedWonOLIS = OpportunityServices.processOpportunitiesWithClosedWon(new List<Opportunity>{testOppClosedWon});
		
		Test.startTest();
			List<OpportunityLineItem> updatedClosedWonOLIS = OpportunityServices.updateOpportunityProductsWithClosedWon(closedWonOLIS, oppMap);
		Test.stopTest();

		System.assertEquals(NUM_EXPECTED_OLI_WITH_CLOSED_WON, updatedClosedWonOLIS.size(), 'We expect to get back the correct number of Opportunity Products for each Opportunity that is Closed Won');
		for (OpportunityLineItem oli : updatedClosedWonOLIS){
			System.assertEquals(testOppClosedWon.Id, oli.OpportunityId, 'We expect to get back the opportunity line items for the closed won opportunity');
			System.assertEquals(OLI_STAGE_NAME_CLOSED_WON, oli.Waiting_Status__c, 'We expect to get back the closed won picklist value on each opportunity product');
		}
		
    }
    
    public static testMethod void testUpdateOppProductOnClosedWonOpportunityErrorHandling(){
    	
    	final Integer NUM_EXPECTED_OLI_WITH_CLOSED_WON = 2;

		List<Opportunity> testOppList = TestingUtils.createOpportunities(2, 'test opp', testAccount.Id, false);
		Opportunity testOppClosedWon = testOppList[0];
		Opportunity testOpp = testOppList[1];
		testOppClosedWon.StageName = OPP_STAGE_NAME_CLOSED_WON;
		testOppClosedWon.Signature_Override__c = true;
		testOppClosedWon.CloseDate = Date.today().addDays(1);
		testOpp.StageName = OPP_STAGE_NAME_1;
		testOpp.CloseDate = Date.today().addDays(1);
		insert testOppList;
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(testOppList);
		List<OpportunityLineItem> testOLIList = setupOLIs(testOppClosedWon, testOpp);
		insert testOLIList;
		
		List<OpportunityLineItem> closedWonOLIS = OpportunityServices.processOpportunitiesWithClosedWon(new List<Opportunity>{testOppClosedWon});

		closedWonOLIS[0].Id = null;
		
		Test.startTest();
			List<OpportunityLineItem> updatedClosedWonOLIS = OpportunityServices.updateOpportunityProductsWithClosedWon(closedWonOLIS, oppMap);
		Test.stopTest();

		System.assertEquals(NUM_EXPECTED_OLI_WITH_CLOSED_WON, updatedClosedWonOLIS.size(), 'We expect to get back the correct number of Opportunity Products for each Opportunity that is Closed Won');
		System.assert(ApexPages.hasMessages(), 'We expect an error to be thrown when trying to update an Opportunity Line Item with no id.');
		
    }
    
}